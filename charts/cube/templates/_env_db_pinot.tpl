{{- define "cube.env.database.pinot" }}
{{- if (.pinot).authToken }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_PINOT_AUTH_TOKEN" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.pinot).authToken | quote }}
{{- else if (.pinot).authTokenFromSecret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_PINOT_AUTH_TOKEN" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  valueFrom:
    secretKeyRef:
      name: {{ .pinot.authTokenFromSecret.name | required "datasources.<name>.pinot.authTokenFromSecret.name is required" }}
      key: {{ .pinot.authTokenFromSecret.key | required "datasources.<name>.pinot.authTokenFromSecret.key is required" }}
{{- end }}
{{- if (.pinot).nullHandling }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_PINOT_NULL_HANDLING" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.pinot).nullHandling | quote }}
{{- end }}
{{- end }}
