{{- define "cube.env.database.ksql" }}
{{- if (.kafka).host }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_KAFKA_HOST" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.kafka).host | quote }}
{{- end }}
{{- if (.kafka).user }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_KAFKA_USER" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.kafka).user | quote }}
{{- end }}
{{- if (.kafka).pass }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_KAFKA_PASS" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.kafka).pass | quote }}
{{- else if (.kafka).passFromSecret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_KAFKA_PASS" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  valueFrom:
    secretKeyRef:
      name: {{ .kafka.passFromSecret.name | required "datasources.<name>.kafka.passFromSecret.name is required" }}
      key: {{ .kafka.passFromSecret.key | required "datasources.<name>.kafka.passFromSecret.key is required" }}
{{- end }}
{{- if (.kafka).useSsl }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_KAFKA_USE_SSL" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.kafka).useSsl | quote }}
{{- end }}
{{- end }}
