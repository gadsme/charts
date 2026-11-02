{{- define "cube.env.database.clickhouse" }}
{{- if or (.clickhouse).readonly (.clickhouse).readOnly }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_CLICKHOUSE_READONLY" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ or .clickhouse.readonly .clickhouse.readOnly | quote }}
{{- end }}
{{- if (.clickhouse).compression }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_CLICKHOUSE_COMPRESSION" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.clickhouse).compression | quote }}
{{- end }}
{{- end }}
