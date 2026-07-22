{{/* Template to generate a ConfigMap for s3 */}}
{{- define "library-chart.configMapS3" -}}
{{- if and (.Values.s3).enabled (not (empty .Values.s3.profiles)) }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ printf "%s-configmaps3" (include "library-chart.fullname" .) }}
  labels:
    {{- include "library-chart.labels" . | nindent 4 }}
data:
  config: |
    {{- range $name, $profile := .Values.s3.profiles }}
    [{{ $profile.profileName }}]
    {{- if  $profile.region }}
    region = {{ $profile.region }}
    {{- end }}
    {{- if $profile.endpoint }}
    endpoint_url = {{ printf "https://%s" $profile.endpoint }}
    {{- end }}
    {{- if $profile.pathStyleAccess }}
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
{{- if (.Values.s3).enabled -}}
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
  credentials: | 
    {{- range $name, $profile := .Values.s3.profiles }}
    [{{ $profile.profileName }}]
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




