{{- define "cube.env.database.hive" }}
{{- if (.hive).type }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_HIVE_TYPE" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .hive.type | quote }}
{{- end }}
{{- if (.hive).version }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_HIVE_VER" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .hive.version | quote }}
{{- end }}
{{- if (.hive).thriftVersion }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_HIVE_THRIFT_VER" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .hive.thriftVersion | quote }}
{{- end }}
{{- if (.hive).cdhVersion }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_HIVE_CDH_VER" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .hive.cdhVersion | quote }}
{{- end }}
{{- end }}