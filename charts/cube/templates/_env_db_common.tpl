{{- define "cube.env.database.common" }}
{{- if not .forPreAggregations }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_TYPE" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .type | quote | required "database.type is required" }}
{{- end }}
{{- if .url }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_URL" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .url | quote }}
{{- end }}
{{- if .host }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_HOST" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .host | quote }}
{{- else if .hostFromSecret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_HOST" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  valueFrom:
    secretKeyRef:
      name: {{ .hostFromSecret.name | required "datasources.<name>.hostFromSecret.name is required" }}
      key: {{ .hostFromSecret.key | required "datasources.<name>.hostFromSecret.key is required" }}
{{- end }}
{{- if .port }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_PORT" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .port | quote }}
{{- end }}
{{- if .schema }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SCHEMA" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .schema | quote }}
{{- end }}
{{- if .name }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_NAME" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .name | quote }}
{{- end }}
{{- if .user }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_USER" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .user | quote }}
{{- else if .userFromSecret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_USER" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  valueFrom:
    secretKeyRef:
      name: {{ .userFromSecret.name | required "datasources.<name>.userFromSecret.name is required" }}
      key: {{ .userFromSecret.key | required "datasources.<name>.userFromSecret.key is required" }}
{{- end }}
{{- if .pass }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_PASS" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .pass | quote }}
{{- else if .passFromSecret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_PASS" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  valueFrom:
    secretKeyRef:
      name: {{ .passFromSecret.name | required "database.passFromSecret.name is required" }}
      key: {{ .passFromSecret.key | required "database.passFromSecret.key is required" }}
{{- end }}
{{- if .domain }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DOMAIN" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .domain | quote }}
{{- end }}
{{- if .socketPath }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SOCKET_PATH" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .socketPath | quote }}
{{- end }}
{{- if .maxPool }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_MAX_POOL" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .maxPool | quote }}
{{- end }}
{{- if .queryTimeout }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_QUERY_TIMEOUT" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .queryTimeout | quote }}
{{- end }}
{{- if not (kindIs "invalid" .fetchColumnsByOrdinalPosition) }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_FETCH_COLUMNS_BY_ORDINAL_POSITION" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .fetchColumnsByOrdinalPosition | quote }}
{{- end }}
{{- if (.export).name }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_BUCKET" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .export.name | quote }}
{{- end }}
{{- if (.export).type }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_BUCKET_TYPE" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .export.type | quote }}
{{- end }}
{{- if (.export).integration }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_INTEGRATION" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .export.integration | quote }}
{{- end }}
{{- if ((.export).gcs).credentials }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_GCS_CREDENTIALS" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .export.gcs.credentials | quote }}
{{- else if ((.export).gcs).credentialsFromSecret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_GCS_CREDENTIALS" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  valueFrom:
    secretKeyRef:
      name: {{ .export.gcs.credentialsFromSecret.name | required "export.gcs.credentialsFromSecret.name is required" }}
      key: {{ .export.gcs.credentialsFromSecret.key | required "export.gcs.credentialsFromSecret.key is required" }}
{{- end }}
{{- if ((.export).aws).key }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_BUCKET_AWS_KEY" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .export.aws.key | quote }}
{{- else if ((.export).aws).keyFromSecret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_BUCKET_AWS_KEY" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  valueFrom:
    secretKeyRef:
      name: {{ .export.aws.keyFromSecret.name | required "export.aws.keyFromSecret.name is required" }}
      key: {{ .export.aws.keyFromSecret.key | required "export.aws.keyFromSecret.key is required" }}
{{- end }}
{{- if ((.export).aws).secret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_BUCKET_AWS_SECRET" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .export.aws.secret | quote }}
{{- else if ((.export).aws).secretFromSecret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_BUCKET_AWS_SECRET" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  valueFrom:
    secretKeyRef:
      name: {{ .export.aws.secretFromSecret.name | required "export.aws.secretFromSecret.name is required" }}
      key: {{ .export.aws.secretFromSecret.key | required "export.aws.secretFromSecret.key is required" }}
{{- end }}
{{- if ((.export).aws).region }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_BUCKET_AWS_REGION" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .export.aws.region | quote }}
{{- end }}
{{- if ((.export).redshift).arn }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_BUCKET_REDSHIFT_ARN" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .export.redshift.arn | quote }}
{{- end }}
{{- if (.ssl).enabled }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SSL" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: "true"
{{- if (.ssl).rejectUnAuthorized }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SSL_REJECT_UNAUTHORIZED" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .ssl.rejectUnAuthorized | quote }}
{{- end }}
{{- if and (not .forPreAggregations) (.ssl).ca }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SSL_CA" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .ssl.ca | quote }}
{{- end }}
{{- if and (not .forPreAggregations) (.ssl).cert }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SSL_CERT" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .ssl.cert | quote }}
{{- end }}
{{- if and (not .forPreAggregations) (.ssl).key }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SSL_KEY" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .ssl.key | quote }}
{{- end }}
{{- if and (not .forPreAggregations) (.ssl).ciphers }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SSL_CIPHERS" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .ssl.ciphers | quote }}
{{- end }}
{{- if and (not .forPreAggregations) (.ssl).serverName }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SSL_SERVERNAME" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .ssl.serverName | quote }}
{{- end }}
{{- if and (not .forPreAggregations) (.ssl).passPhrase }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SSL_PASSPHRASE" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .ssl.passPhrase | quote }}
{{- end }}
{{- end }}

{{- if .preciseDecimalInCubestore }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_PRECISE_DECIMAL_IN_CUBESTORE" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .preciseDecimalInCubestore | quote }}
{{- end }}
{{- if (.export).mountDir }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_BUCKET_MOUNT_DIR" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.export).mountDir | quote }}
{{- end }}
{{- if ((.export).azure).key }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_BUCKET_AZURE_KEY" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ ((.export).azure).key | quote }}
{{- else if ((.export).azure).keyFromSecret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_BUCKET_AZURE_KEY" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  valueFrom:
    secretKeyRef:
      name: {{ .export.azure.keyFromSecret.name | required "datasources.<name>.export.azure.keyFromSecret.name is required" }}
      key: {{ .export.azure.keyFromSecret.key | required "datasources.<name>.export.azure.keyFromSecret.key is required" }}
{{- end }}
{{- if ((.export).azure).tenantId }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_BUCKET_AZURE_TENANT_ID" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ ((.export).azure).tenantId | quote }}
{{- end }}
{{- if ((.export).azure).clientId }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_BUCKET_AZURE_CLIENT_ID" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ ((.export).azure).clientId | quote }}
{{- end }}
{{- if ((.export).azure).clientSecret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_BUCKET_AZURE_CLIENT_SECRET" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ ((.export).azure).clientSecret | quote }}
{{- else if ((.export).azure).clientSecretFromSecret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_EXPORT_BUCKET_AZURE_CLIENT_SECRET" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  valueFrom:
    secretKeyRef:
      name: {{ .export.azure.clientSecretFromSecret.name | required "datasources.<name>.export.azure.clientSecretFromSecret.name is required" }}
      key: {{ .export.azure.clientSecretFromSecret.key | required "datasources.<name>.export.azure.clientSecretFromSecret.key is required" }}
{{- end }}
{{- end }}
