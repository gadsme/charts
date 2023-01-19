{{- define "cube.env.database.bigquery" }}
{{- if (.bigquery).projectId }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_BQ_PROJECT_ID" "datasource" .datasource) }}
  value: {{ .bigquery.projectId | quote }}
{{- end }}
{{- if (.bigquery).location }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_BQ_LOCATION" "datasource" .datasource) }}
  value: {{ .bigquery.location | quote }}
{{- end }}
{{- if (.bigquery).credentials }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_BQ_CREDENTIALS" "datasource" .datasource) }}
  value: {{ .bigquery.credentials | quote }}
{{- else if (.bigquery).credentialsFromSecret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_BQ_CREDENTIALS" "datasource" .datasource) }}
  valueFrom:
    secretKeyRef:
      name: {{ .bigquery.credentialsFromSecret.name | required "bigquery.credentialsFromSecret.name is required" }}
      key: {{ .bigquery.credentialsFromSecret.key | required "bigquery.credentialsFromSecret.key is required" }}
{{- end }}
{{- if (.bigquery).keyFile }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_BQ_KEY_FILE" "datasource" .datasource) }}
  value: {{ .bigquery.keyFile }}
{{- end }}
{{- end }}