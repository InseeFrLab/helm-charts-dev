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
{{- if (.Values.s3).enabled }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "library-chart.secretNameMc" . }}
  labels:
    {{- include "library-chart.labels" . | nindent 4 }}
stringData: 
{{- if (.Values.s3).profiles }}
{{- range $name, $profile := .Values.s3.profiles }}
  {{- if $profile.sessionToken }}
  MC_HOST_{{ $profile.name }}: "https://{{ $profile.accessKeyId }}:{{ $profile.secretAccessKey }}:{{ $profile.sessionToken }}@{{ $profile.endpoint_url }}"
  {{- else }}
  MC_HOST_{{ $profile.name }}: "https://{{ $profile.accessKeyId }}:{{ $profile.secretAccessKey }}@{{ $profile.endpoint_url }}"
  {{- end }}
{{- else }}
  {{- if .Values.s3.sessionToken  }}
  MC_HOST_s3: "https://{{  .Values.s3.accessKeyId }}:{{ .Values.s3.secretAccessKey }}:{{ .Values.s3.sessionToken }}@{{ .Values.s3.endpoint }}"
  {{- else }}
  MC_HOST_s3: "https://{{  .Values.s3.accessKeyId }}:{{ .Values.s3.secretAccessKey }}@{{ .Values.s3.endpoint }}"
  {{- end }}
{{- end }}
{{- end }}
{{- end -}}


{{/* Template to generate a ConfigMap for s3 */}}
{{- define "library-chart.configMapS3" -}}
{{- if and (.Values.s3).enabled (.Values.s3).profiles }}
{{- $defaultProfile := index .Values.s3.profiles 0 }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ printf "%s-configmaps3" (include "library-chart.fullname" .) }}
  labels:
    {{- include "library-chart.labels" . | nindent 4 }}
data:
  config: |
    {{- range $name, $profile := .Values.s3.profiles }}
    [{{ $profile.name }}]
    {{- if  $profile.region }}
    region = {{ $profile.region }}
    {{- end }}
    {{- if $profile.endpoint_url }}
    endpoint_url = {{ printf "https://%s" $defaultProfile.endpoint_url }}
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




{{/* Create the name of the secret S3 to use */}}
{{- define "library-chart.secretNameS3" -}}
{{- if (.Values.s3).enabled }}
{{- $name := printf "%s-secrets3" (include "library-chart.fullname" .) }}
{{- default $name .Values.s3.secretName }}
{{- else }}
{{- default "default" .Values.s3.secretName }}
{{- end }}
{{- end }}

{{/* Template to generate a secret for S3 */}}
{{- define "library-chart.secretS3" -}}
{{- if and (.Values.s3).enabled   -}}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "library-chart.secretNameS3" . }}
  labels:
    {{- include "library-chart.labels" . | nindent 4 }}
type: Opaque
stringData:
{{- if empty (.Values.s3).profiles }}
  AWS_ACCESS_KEY_ID: {{ .Values.s3.accessKeyId | quote }}
  AWS_S3_ENDPOINT: {{ .Values.s3.endpoint | quote }}
  AWS_ENDPOINT_URL: {{ printf "https://%s/" .Values.s3.endpoint | quote }}
  S3_ENDPOINT: {{ printf "https://%s/" .Values.s3.endpoint | quote }}
  AWS_DEFAULT_REGION: {{ .Values.s3.defaultRegion | quote }}
  AWS_SECRET_ACCESS_KEY: {{ .Values.s3.secretAccessKey | quote }}
  AWS_SESSION_TOKEN: {{ .Values.s3.sessionToken | quote }}
  AWS_PATH_STYLE_ACCESS: "{{ .Values.s3.pathStyleAccess }}"
  AWS_WORKING_DIRECTORY_PATH: "{{ .Values.s3.workingDirectoryPath }}"
{{- else }}
{{- $defaultProfile := index .Values.s3.profiles 0 }}
  credentials: | 
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
{{- end }}




