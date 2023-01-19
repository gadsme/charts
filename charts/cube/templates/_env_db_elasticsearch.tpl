{{- define "cube.env.database.elasticsearch" }}
{{- if (.elasticsearch).queryFormat }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_ELASTIC_QUERY_FORMAT" "datasource" .datasource) }}
  value: {{ .elasticsearch.queryFormat | quote }}
{{- end }}
{{- if (.elasticsearch).openDistro }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_ELASTIC_OPENDISTRO" "datasource" .datasource) }}
  value: {{ .elasticsearch.openDistro | quote }}
{{- end }}
{{- if (.elasticsearch).apiKeyId }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_ELASTIC_APIKEY_ID" "datasource" .datasource) }}
  value: {{ .elasticsearch.apiKeyId | quote }}
{{- end }}
{{- if (.elasticsearch).apiKeyKey }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_ELASTIC_APIKEY_KEY" "datasource" .datasource) }}
  value: {{ .elasticsearch.apiKeyKey | quote }}
{{- end }}
{{- end }}