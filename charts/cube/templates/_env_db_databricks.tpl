{{- define "cube.env.database.databricks" }}
{{- if (.databricks).url }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DATABRICKS_URL" "datasource" .datasource) }}
  value: {{ .databricks.url | quote }}
{{- end }}
{{- if (.databricks).acceptPolicy }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DATABRICKS_ACCEPT_POLICY" "datasource" .datasource) }}
  value: {{ .databricks.acceptPolicy | quote }}
{{- end }}
{{- if (.databricks).token }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DATABRICKS_TOKEN" "datasource" .datasource) }}
  value: {{ .databricks.token | quote }}
{{- end }}
{{- if (.databricks).catalog }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_DATABRICKS_CATALOG" "datasource" .datasource) }}
  value: {{ .databricks.catalog | quote }}
{{- end }}
{{- end }}