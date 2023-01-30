{{- define "cube.env.database.trino" }}
{{- if (.trino).catalog }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_PRESTO_CATALOG" "datasource" .datasource) }}
  value: {{ .trino.catalog | quote }}
{{- end }}
{{- end }}