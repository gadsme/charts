{{- define "cube.env.database.presto" }}
{{- if (.presto).catalog }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_PRESTO_CATALOG" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .presto.catalog | quote }}
{{- end }}
{{- if (.presto).authToken }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_PRESTO_AUTH_TOKEN" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.presto).authToken | quote }}
{{- else if (.presto).authTokenFromSecret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_PRESTO_AUTH_TOKEN" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  valueFrom:
    secretKeyRef:
      name: {{ .presto.authTokenFromSecret.name | required "datasources.<name>.presto.authTokenFromSecret.name is required" }}
      key: {{ .presto.authTokenFromSecret.key | required "datasources.<name>.presto.authTokenFromSecret.key is required" }}
{{- end }}
{{- end }}
