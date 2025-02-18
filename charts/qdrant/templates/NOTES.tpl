{{- if eq .Values.userPreferences.language "fr" }}

{{- if .Values.qdrant.apikey }}
- Votre token: {{- .Values.qdrant.apikey }}
Aller regarder la valeur du secret --> utiliser juste ls secret du compte ???
{{- end }}

{{- if .Values.qdrant.ingress.enabled }}
- Vous pouvez vous connecter à qdrant avec votre navigateur à ce [lien](http{{ if $.Values.qdrant.ingress.tls }}s{{ end }}://{{ .Values.qdrant.ingress.hostname }})
{{- end }}
- Vous pouvez vous connectez à qdrant depuis l'intérieur du datalab à cette URL : **https://{{ .Release.Name }}-qdrant:{{ .Values.qdrant.ingress.enabled }}**
{{/*  TODO : récupérer le nom du service  */}}

- Un seul chart de {{ .Chart.Name }} peut être démarré dans un namespace

**NOTES sur la suppression :**

- **Vous pouvez supprimer ce chart en toute sécurité et en recréer un plus tard**
- Les volumes de données ne seront pas supprimés
- Si vous démarrez un nouveau {{ .Chart.Name }}, il réutilisera ces volumes en silence.
- Si vous souhaitez supprimer définitivement ces volumes : `kubectl delete pvc data-qdrant-0`
{{- else }}

{{- if .Values.qdrant.apikey }}
- Your token is **TODO** 
{{- end }}

{{- if .Values.qdrant.ingress.enabled }}
- You can connect to qdrant with your browser on this [link](http{{ if $.Values.ingress.tls }}s{{ end }}://{{ .Values.qdrant.ingress.hostname }})
{{- end }}

- You can connect to elastic from inside the datalab at this url : **https://{{ .Release.Name }}-qdrant:{{ .Values.elasticsearch.service.ports.restAPI }}**

- Only one chart of {{ .Chart.Name }} can be started in a namespace

*NOTES about deletion :*

- **You can safely delete this chart and recreate one later**
- Data volumes will not be deleted
- If you start a new {{ .Chart.Name }}, it will reuse those volumes silently.
- If you want to delete those volumes definitely : `kubectl delete pvc data-qdrant-0`


{{- end }}
