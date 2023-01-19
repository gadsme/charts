{{- define "cube.env.database.presto" }}
{{- if (.presto).catalog }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_PRESTO_CATALOG" "datasource" .datasource) }}
  value: {{ .presto.catalog | quote }}
{{- end }}
{{- end }}