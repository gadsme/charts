{{- define "cube.env.database.clickhouse" }}
{{- if (.clickhouse).readOnly }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_CLICKHOUSE_READONLY" "datasource" .datasource) }}
  value: {{ .clickhouse.readOnly | quote }}
{{- end }}
{{- end }}