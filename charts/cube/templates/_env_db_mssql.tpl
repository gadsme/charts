{{- define "cube.env.database.mssql" }}
{{- if (.mssql).useNamedTimezones }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_MSSQL_USE_NAMED_TIMEZONES" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.mssql).useNamedTimezones | quote }}
{{- end }}
{{- end }}
