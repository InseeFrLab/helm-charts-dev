{{/* Create the name of the secret MLFlow to use */}}
{{- define "library-chart.secretNameMLFlow" -}}
{{- if (.Values.discovery).mlflow }}
{{- $name := printf "%s-secretmlflow" (include "library-chart.fullname" .) }}
{{- default $name (.Values.mlflow).secretName }}
{{- else }}
{{- default "default" (.Values.mlflow).secretName }}
{{- end }}
{{- end }}

{{/* Secret for MLFlow */}}
{{- define "library-chart.secretMLFlow" }}
{{- $context := . }}
{{- if (.Values.discovery).mlflow }}
{{- with $secretData := first (include "library-chart.getOnyxiaDiscoverySecrets" (list .Release.Namespace "mlflow") | fromJsonArray) -}}
{{- $uri                      := $secretData.uri                      | default "" | b64dec }}
{{- $mlflow_tracking_username := $secretData.MLFLOW_TRACKING_USERNAME | default "" | b64dec }}
{{- $mlflow_tracking_password := $secretData.MLFLOW_TRACKING_PASSWORD | default "" | b64dec }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "library-chart.secretNameMLFlow" $context }}
  labels:
    {{- include "library-chart.labels" $context | nindent 4 }}
stringData:
{{- if $uri }}
  MLFLOW_TRACKING_URI: {{ $uri | quote }}
{{- end }}
{{- if and $mlflow_tracking_username $mlflow_tracking_password }}
  MLFLOW_TRACKING_USERNAME: {{ $mlflow_tracking_username | quote }}
  MLFLOW_TRACKING_PASSWORD: {{ $mlflow_tracking_password | quote }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}


{{- define "library-chart.mlflow-discovery-help" -}}
{{- if .Values.discovery.mlflow }}
{{- with $secretData := first (include "library-chart.getOnyxiaDiscoverySecrets" (list .Release.Namespace "mlflow") | fromJsonArray) }}
{{- $uri                      := $secretData.uri                      | default "" | b64dec }}
{{- $mlflow_tracking_username := $secretData.MLFLOW_TRACKING_USERNAME | default "" | b64dec }}
{{- $mlflow_tracking_password := $secretData.MLFLOW_TRACKING_PASSWORD | default "" | b64dec }}
The following environment variables are available in your service:
```sh
{{- with $uri }}
MLFLOW_TRACKING_URI={{ quote . }}
{{- end }}
{{- if and $mlflow_tracking_username $mlflow_tracking_password }}
MLFLOW_TRACKING_USERNAME={{ $mlflow_tracking_username | quote }}
MLFLOW_TRACKING_PASSWORD={{ $mlflow_tracking_password | quote }}
{{- end }}
```
{{- end }}
{{- end }}
{{- end -}}
