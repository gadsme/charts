{{- define "cube.env.database.mysql" }}
{{- if (.mysql).useNamedTimezones }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_MYSQL_USE_NAMED_TIMEZONES" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.mysql).useNamedTimezones | quote }}
{{- end }}
{{- end }}
