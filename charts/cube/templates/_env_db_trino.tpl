{{- define "cube.env.database.trino" }}
{{- if (.trino).catalog }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_PRESTO_CATALOG" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .trino.catalog | quote }}
{{- end }}
{{- if (.trino).authToken }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_PRESTO_AUTH_TOKEN" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.trino).authToken | quote }}
{{- else if (.trino).authTokenFromSecret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_PRESTO_AUTH_TOKEN" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  valueFrom:
    secretKeyRef:
      name: {{ .trino.authTokenFromSecret.name | required "datasources.<name>.trino.authTokenFromSecret.name is required" }}
      key: {{ .trino.authTokenFromSecret.key | required "datasources.<name>.trino.authTokenFromSecret.key is required" }}
{{- end }}
{{- end }}
