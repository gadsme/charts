{{- define "cube.env.database.databricks" }}
{{- if (.databricks).url }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DATABRICKS_URL" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .databricks.url | quote }}
{{- end }}
{{- if (.databricks).acceptPolicy }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DATABRICKS_ACCEPT_POLICY" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .databricks.acceptPolicy | quote }}
{{- end }}
{{- if (.databricks).token }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DATABRICKS_TOKEN" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .databricks.token | quote }}
{{- end }}
{{- if (.databricks).catalog }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DATABRICKS_CATALOG" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .databricks.catalog | quote }}
{{- end }}
{{- if (.databricks).oauthClientId }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DATABRICKS_OAUTH_CLIENT_ID" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.databricks).oauthClientId | quote }}
{{- end }}
{{- if (.databricks).oauthClientSecret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DATABRICKS_OAUTH_CLIENT_SECRET" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.databricks).oauthClientSecret | quote }}
{{- else if (.databricks).oauthClientSecretFromSecret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DATABRICKS_OAUTH_CLIENT_SECRET" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  valueFrom:
    secretKeyRef:
      name: {{ .databricks.oauthClientSecretFromSecret.name | required "datasources.<name>.databricks.oauthClientSecretFromSecret.name is required" }}
      key: {{ .databricks.oauthClientSecretFromSecret.key | required "datasources.<name>.databricks.oauthClientSecretFromSecret.key is required" }}
{{- end }}
{{- end }}
