{{- define "cube.env.database.common" }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_TYPE" "datasource" .datasource) }}
  value: {{ .type | quote | required "database.type is required" }}
{{- if .url }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_URL" "datasource" .datasource) }}
  value: {{ .url | quote }}
{{- end }}
{{- if .host }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_HOST" "datasource" .datasource) }}
  value: {{ .host | quote }}
{{- end }}
{{- if .port }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_PORT" "datasource" .datasource) }}
  value: {{ .port | quote }}
{{- end }}
{{- if .schema }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SCHEMA" "datasource" .datasource) }}
  value: {{ .schema | quote }}
{{- end }}
{{- if .name }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_NAME" "datasource" .datasource) }}
  value: {{ .name | quote }}
{{- end }}
{{- if .user }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_USER" "datasource" .datasource) }}
  value: {{ .user | quote }}
{{- end }}
{{- if .pass }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_PASS" "datasource" .datasource) }}
  value: {{ .pass | quote }}
{{- else if .passFromSecret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_PASS" "datasource" .datasource) }}
  valueFrom:
    secretKeyRef:
      name: {{ .passFromSecret.name | required "database.passFromSecret.name is required" }}
      key: {{ .passFromSecret.key | required "database.passFromSecret.key is required" }}
{{- end }}
{{- if .domain }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DOMAIN" "datasource" .datasource) }}
  value: {{ .domain | quote }}
{{- end }}
{{- if .socketPath }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SOCKET_PATH" "datasource" .datasource) }}
  value: {{ .socketPath | quote }}
{{- end }}
{{- if .catalog }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_CATALOG" "datasource" .datasource) }}
  value: {{ .catalog | quote }}
{{- end }}
{{- if .maxPool }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_MAX_POOL" "datasource" .datasource) }}
  value: {{ .maxPool | quote }}
{{- end }}
{{- if .queryTimeout }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_QUERY_TIMEOUT" "datasource" .datasource) }}
  value: {{ .queryTimeout | quote }}
{{- end }}
{{- if (.export).name }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_BUCKET" "datasource" .datasource) }}
  value: {{ .export.name | quote }}
{{- end }}
{{- if (.export).type }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_BUCKET_TYPE" "datasource" .datasource) }}
  value: {{ .export.type | quote }}
{{- end }}
{{- if (.export).integration }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_INTEGRATION" "datasource" .datasource) }}
  value: {{ .export.integration | quote }}
{{- end }}
{{- if ((.export).gcs).credentials }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_GCS_CREDENTIALS" "datasource" .datasource) }}
  value: {{ .export.gcs.credentials | quote }}
{{- else if ((.export).gcs).credentialsFromSecret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_GCS_CREDENTIALS" "datasource" .datasource) }}
  valueFrom:
    secretKeyRef:
      name: {{ .export.gcs.credentialsFromSecret.name | required "export.gcs.credentialsFromSecret.name is required" }}
      key: {{ .export.gcs.credentialsFromSecret.key | required "export.gcs.credentialsFromSecret.key is required" }}
{{- end }}
{{- if ((.export).aws).key }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_BUCKET_AWS_KEY" "datasource" .datasource) }}
  value: {{ .export.aws.key | quote }}
{{- end }}
{{- if ((.export).aws).secret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_BUCKET_AWS_SECRET" "datasource" .datasource) }}
  value: {{ .export.aws.secret | quote }}
{{- else if ((.export).aws).secretFromSecret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_BUCKET_AWS_SECRET" "datasource" .datasource) }}
  valueFrom:
    secretKeyRef:
      name: {{ .export.aws.secretFromSecret.name | required "export.aws.secretFromSecret.name is required" }}
      key: {{ .export.aws.secretFromSecret.key | required "export.aws.secretFromSecret.key is required" }}
{{- end }}
{{- if ((.export).aws).region }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_BUCKET_AWS_REGION" "datasource" .datasource) }}
  value: {{ .export.aws.region | quote }}
{{- end }}
{{- if ((.export).redshift).arn }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_BUCKET_REDSHIFT_ARN" "datasource" .datasource) }}
  value: {{ .export.redshift.arn | quote }}
{{- end }}
{{- if (.ssl).enabled }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SSL" "datasource" .datasource) }}
  value: "true"
{{- if (.ssl).rejectUnAuthorized }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SSL_REJECT_UNAUTHORIZED" "datasource" .datasource) }}
  value: {{ .ssl.rejectUnAuthorized | quote }}
{{- end }}
{{- if (.ssl).ca }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SSL_CA" "datasource" .datasource) }}
  value: {{ .ssl.ca | quote }}
{{- end }}
{{- if (.ssl).cert }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SSL_CERT" "datasource" .datasource) }}
  value: {{ .ssl.cert | quote }}
{{- end }}
{{- if (.ssl).key }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SSL_KEY" "datasource" .datasource) }}
  value: {{ .ssl.key | quote }}
{{- end }}
{{- if (.ssl).ciphers }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SSL_CIPHERS" "datasource" .datasource) }}
  value: {{ .ssl.ciphers | quote }}
{{- end }}
{{- if (.ssl).serverName }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SSL_SERVERNAME" "datasource" .datasource) }}
  value: {{ .ssl.serverName | quote }}
{{- end }}
{{- if (.ssl).passPhrase }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SSL_PASSPHRASE" "datasource" .datasource) }}
  value: {{ .ssl.passPhrase | quote }}
{{- end }}
{{- end }}

{{- end }}