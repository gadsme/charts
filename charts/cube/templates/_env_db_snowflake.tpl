{{- define "cube.env.database.snowflake" }}
{{- if (.snowFlake).account }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SNOWFLAKE_ACCOUNT" "datasource" .datasource) }}
  value: {{ .snowFlake.account | quote }}
{{- end }}
{{- if (.snowFlake).region }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SNOWFLAKE_REGION" "datasource" .datasource) }}
  value: {{ .snowFlake.region | quote }}
{{- end }}
{{- if (.snowFlake).role }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SNOWFLAKE_ROLE" "datasource" .datasource) }}
  value: {{ .snowFlake.role | quote }}
{{- end }}
{{- if (.snowFlake).warehouse }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SNOWFLAKE_WAREHOUSE" "datasource" .datasource) }}
  value: {{ .snowFlake.warehouse | quote }}
{{- end }}
{{- if (.snowFlake).clientSessionKeepAlive }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SNOWFLAKE_CLIENT_SESSION_KEEP_ALIVE" "datasource" .datasource) }}
  value: {{ .snowFlake.clientSessionKeepAlive | quote }}
{{- end }}
{{- if (.snowFlake).authenticator }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SNOWFLAKE_AUTHENTICATOR" "datasource" .datasource) }}
  value: {{ .snowFlake.authenticator | quote }}
{{- end }}
{{- if (.snowFlake).privateKeyPath }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SNOWFLAKE_PRIVATE_KEY_PATH" "datasource" .datasource) }}
  value: {{ .snowFlake.privateKeyPath | quote }}
{{- end }}
{{- if (.snowFlake).urprivateKeyPassl }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_SNOWFLAKE_PRIVATE_KEY_PASS" "datasource" .datasource) }}
  value: {{ .snowFlake.privateKeyPass | quote }}
{{- end }}
{{- end }}