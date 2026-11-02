{{- define "cube.env.database.duckdb" }}
{{- if (.duckdb).memoryLimit }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DUCKDB_MEMORY_LIMIT" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .duckdb.memoryLimit | quote }}
{{- end }}
{{- if (.duckdb).schema }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DUCKDB_SCHEMA" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .duckdb.schema | quote }}
{{- end }}
{{- if (.duckdb).motherduckToken }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DUCKDB_MOTHERDUCK_TOKEN" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .duckdb.motherduckToken | quote }}
{{- end }}
{{- if (.duckdb).databasePath }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DUCKDB_DATABASE_PATH" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .duckdb.databasePath | quote }}
{{- end }}
{{- if (.duckdb).s3.accessKeyId }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DUCKDB_S3_ACCESS_KEY_ID" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .duckdb.s3.accessKeyId | quote }}
{{- end }}
{{- if (.duckdb).s3.secretAccessKey }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DUCKDB_S3_SECRET_ACCESS_KEY" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .duckdb.s3.secretAccessKey | quote }}
{{- else if (.duckdb).s3.secretAccessKeyFromSecret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DUCKDB_S3_SECRET_ACCESS_KEY" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  valueFrom:
    secretKeyRef:
      name: {{ .bigquery.s3.secretAccessKeyFromSecret.name | required "duckdb.s3.secretAccessKeyFromSecret.name is required" }}
      key: {{ .bigquery.s3.secretAccessKeyFromSecret.key | required "bigqduckdbuery.s3.secretAccessKeyFromSecret.key is required" }}
{{- end }}
{{- if (.duckdb).s3.endpoint }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DUCKDB_S3_ENDPOINT" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .duckdb.s3.endpoint | quote }}
{{- end }}
{{- if (.duckdb).s3.region }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DUCKDB_S3_REGION" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .duckdb.s3.region | quote }}
{{- end }}
{{- if not (kindIs "invalid" ((.duckdb).s3).useSSL) }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DUCKDB_S3_USE_SSL" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .duckdb.s3.useSSL | quote }}
{{- end }}
{{- if or ((.duckdb).s3).urlStyle ((.duckdb).s3).URLStyle }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DUCKDB_S3_URL_STYLE" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ or .duckdb.s3.urlStyle .duckdb.s3.URLStyle | quote }}
{{- end }}
{{- if (.duckdb).s3.sessionToken }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DUCKDB_S3_SESSION_TOKEN" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .duckdb.s3.sessionToken | quote }}
{{- end }}
{{- if (.duckdb).extensions }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DUCKDB_EXTENSIONS" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.duckdb).extensions | quote }}
{{- end }}
{{- if (.duckdb).communityExtensions }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DUCKDB_COMMUNITY_EXTENSIONS" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.duckdb).communityExtensions | quote }}
{{- end }}
{{- if ((.duckdb).s3).useCredentialChain }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DUCKDB_S3_USE_CREDENTIAL_CHAIN" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ ((.duckdb).s3).useCredentialChain | quote }}
{{- end }}
{{- end }}
