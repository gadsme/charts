{{- define "cube.env.database.materialize" }}
{{- if (.materialize).cluster }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_MATERIALIZE_CLUSTER" "datasource" .datasource) }}
  value: {{ .materialize.cluster | quote }}
{{- end }}
{{- end }}