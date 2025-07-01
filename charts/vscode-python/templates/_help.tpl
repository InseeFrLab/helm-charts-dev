

{{/* Create the name of the secret mc to use */}}
{{- define "library-chart.secretNameMc" -}}
{{- if (.Values.s3).enabled }}
{{- $name := printf "%s-secretmc" (include "library-chart.fullname" .) }}
{{- default $name .Values.s3.secretNameMc }}
{{- else }}
{{- default "default" .Values.s3.secretNameMc }}
{{- end }}
{{- end }}

{{- define "library-chart.secretMc" -}}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "library-chart.secretNameMc" . }}
  labels:
    {{- include "library-chart.labels" . | nindent 4 }}
stringData: 
{{- range $name, $profile := .Values.s3.profiles }}
  {{- if $profile.sessionToken }}
  MC_HOST_{{ $profile.name }}: "https://{{ $profile.accessKeyId }}:{{ $profile.secretAccessKey }}:{{ $profile.sessionToken }}@{{ $profile.endpoint_url }}"
  {{- else }}
  MC_HOST_{{ $profile.name }}: "https://{{ $profile.accessKeyId }}:{{ $profile.secretAccessKey }}@{{ $profile.endpoint_url }}"
  {{- end }}
{{- end }}
{{- end -}}



{{/* Template to generate a ConfigMap for s3 */}}
{{- define "library-chart.configMapS3" -}}
{{- if (.Values.s3).enabled }}
{{- $defaultProfile := index .Values.s3.profiles 0 }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ printf "%s-configmaps3" (include "library-chart.fullname" .) }}
  labels:
    {{- include "library-chart.labels" . | nindent 4 }}
data:
  config: |
    [default]
    {{- if $defaultProfile.region }}
    region = {{ $defaultProfile.region }}
    {{- end }}
    {{- if $defaultProfile.endpoint_url }}
    endpoint_url = {{ $defaultProfile.endpoint_url }}
    {{- end }}
    {{- if $defaultProfile.pathStyleAccess }}
        s3 = 
      addressing_style = path
    {{- else }}
        s3 = 
      addressing_style = virtual
    {{- end }}    
    {{- range $name, $profile := .Values.s3.profiles }}
    [{{ $profile.name }}]
    {{- if  $profile.region }}
    region = {{ $profile.region }}
    {{- end }}
    {{- if $profile.endpoint_url }}
    endpoint_url = {{ $profile.endpoint_url }}
    {{- end }}
    {{- if $defaultProfile.pathStyleAccess }}
        s3 = 
      addressing_style = path
    {{- else }}
        s3 = 
      addressing_style = virtual
    {{- end }}
    {{- end }}
{{- end }}
{{- end -}}


{{/* Template to generate a secret for S3 */}}
{{- define "library-chart.secretS3" -}}
{{- if (.Values.s3).enabled -}}
{{- $defaultProfile := index .Values.s3.profiles 0 }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "library-chart.secretNameS3" . }}
  labels:
    {{- include "library-chart.labels" . | nindent 4 }}
type: Opaque
stringData: 
  credentials: |
    [default]
    {{- if $defaultProfile.accessKeyId }}
    aws_access_key_id = {{ $defaultProfile.accessKeyId }}
    {{- end }}
    {{- if $defaultProfile.secretAccessKey }}
    aws_secret_access_key = {{ $defaultProfile.secretAccessKey }}
    {{- end }}
    {{- if $defaultProfile.sessionToken }}
    aws_session_token = {{ $defaultProfile.sessionToken }}
    {{- end }}
    
    {{- range $name, $profile := .Values.s3.profiles }}
    [{{ $profile.name }}]
    {{- if $profile.accessKeyId }}
    aws_access_key_id = {{ $profile.accessKeyId }}
    {{- end }}
    {{- if  $profile.secretAccessKey }}
    aws_secret_access_key = {{ $profile.secretAccessKey }}
    {{- end }}
    {{- if $profile.sessionToken }}
    aws_session_token = {{ $profile.sessionToken }}
    {{- end }}
    {{- end }}

{{- end }}
{{- end }}


