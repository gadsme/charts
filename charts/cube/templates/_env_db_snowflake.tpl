{{- define "cube.env.database.snowflake" }}
{{- if (.snowFlake).account }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SNOWFLAKE_ACCOUNT" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .snowFlake.account | quote }}
{{- end }}
{{- if (.snowFlake).region }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SNOWFLAKE_REGION" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .snowFlake.region | quote }}
{{- end }}
{{- if (.snowFlake).role }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SNOWFLAKE_ROLE" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .snowFlake.role | quote }}
{{- end }}
{{- if (.snowFlake).warehouse }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SNOWFLAKE_WAREHOUSE" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .snowFlake.warehouse | quote }}
{{- end }}
{{- if not (kindIs "invalid" (.snowFlake).clientSessionKeepAlive) }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SNOWFLAKE_CLIENT_SESSION_KEEP_ALIVE" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .snowFlake.clientSessionKeepAlive | quote }}
{{- end }}
{{- if (.snowFlake).authenticator }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SNOWFLAKE_AUTHENTICATOR" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .snowFlake.authenticator | quote }}
{{- end }}
{{- if (.snowFlake).privateKeyPath }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SNOWFLAKE_PRIVATE_KEY_PATH" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .snowFlake.privateKeyPath | quote }}
{{- end }}
{{- if (.snowFlake).privateKeyPass }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SNOWFLAKE_PRIVATE_KEY_PASS" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .snowFlake.privateKeyPass | quote }}
{{- end }}
{{- if (.snowFlake).host }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SNOWFLAKE_HOST" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.snowFlake).host | quote }}
{{- end }}
{{- if (.snowFlake).privateKey }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SNOWFLAKE_PRIVATE_KEY" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.snowFlake).privateKey | quote }}
{{- else if (.snowFlake).privateKeyFromSecret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SNOWFLAKE_PRIVATE_KEY" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  valueFrom:
    secretKeyRef:
      name: {{ .snowFlake.privateKeyFromSecret.name | required "datasources.<name>.snowFlake.privateKeyFromSecret.name is required" }}
      key: {{ .snowFlake.privateKeyFromSecret.key | required "datasources.<name>.snowFlake.privateKeyFromSecret.key is required" }}
{{- end }}
{{- if (.snowFlake).oauthToken }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SNOWFLAKE_OAUTH_TOKEN" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.snowFlake).oauthToken | quote }}
{{- else if (.snowFlake).oauthTokenFromSecret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SNOWFLAKE_OAUTH_TOKEN" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  valueFrom:
    secretKeyRef:
      name: {{ .snowFlake.oauthTokenFromSecret.name | required "datasources.<name>.snowFlake.oauthTokenFromSecret.name is required" }}
      key: {{ .snowFlake.oauthTokenFromSecret.key | required "datasources.<name>.snowFlake.oauthTokenFromSecret.key is required" }}
{{- end }}
{{- if (.snowFlake).oauthTokenPath }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SNOWFLAKE_OAUTH_TOKEN_PATH" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.snowFlake).oauthTokenPath | quote }}
{{- end }}
{{- if (.snowFlake).quotedIdentifiersIgnoreCase }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SNOWFLAKE_QUOTED_IDENTIFIERS_IGNORE_CASE" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.snowFlake).quotedIdentifiersIgnoreCase | quote }}
{{- end }}
{{- end }}
