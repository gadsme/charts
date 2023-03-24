{{- define "cube.env.config" -}}
- name: PORT
  value: {{ .Values.config.apiPort | quote }}
{{- if .Values.config.debug }}
- name: DEBUG_LOG
  value: {{ .Values.config.debug | quote }}
{{- end }}
{{- if .Values.config.sqlPort }}
- name: CUBEJS_SQL_PORT
  value: {{ .Values.config.sqlPort | quote }}
{{- end }}
{{- if .Values.config.pgSqlPort }}
- name: CUBEJS_PG_SQL_PORT
  value: {{ .Values.config.pgSqlPort | quote }}
{{- end }}
{{- if .Values.config.sqlUser }}
- name: CUBEJS_SQL_USER
  value: {{ .Values.config.sqlUser | quote }}
{{- end }}
{{- if .Values.config.sqlPassword }}
- name: CUBEJS_SQL_PASSWORD
  value: {{ .Values.config.sqlPassword | quote }}
{{- else if .Values.config.sqlPasswordFromSecret }}
- name: CUBEJS_SQL_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.config.sqlPasswordFromSecret.name | required "config.sqlPasswordFromSecret.name is required" }}
      key: {{ .Values.config.sqlPasswordFromSecret.key | required "config.sqlPasswordFromSecret.key is required" }}
{{- end }}
{{- if .Values.config.devMode }}
- name: CUBEJS_DEV_MODE
  value: {{ .Values.config.devMode | quote }}
{{- end }}
{{- if .Values.config.logLevel }}
- name: CUBEJS_LOG_LEVEL
  value: {{ .Values.config.logLevel | quote }}
{{- end }}
{{- if .Values.config.app }}
- name: CUBEJS_APP
  value: {{ .Values.config.app | quote }}
{{- end }}
{{- if .Values.config.cacheAndQueueDriver }}
- name: CUBEJS_CACHE_AND_QUEUE_DRIVER
  value: {{ .Values.config.cacheAndQueueDriver | quote }}
{{- end }}
{{- if .Values.config.concurrency }}
- name: CUBEJS_CONCURRENCY
  value: {{ .Values.config.concurrency | quote }}
{{- end }}
{{- if .Values.config.rollupOnly }}
- name: CUBEJS_ROLLUP_ONLY
  value: {{ .Values.config.rollupOnly | quote }}
{{- end }}
{{- if .Values.config.scheduledRefreshTimezones }}
- name: CUBEJS_SCHEDULED_REFRESH_TIMEZONES
  value: {{ .Values.config.scheduledRefreshTimezones | quote }}
{{- end }}
{{- if .Values.config.scheduledRefreshConcurrency }}
- name: CUBEJS_SCHEDULED_REFRESH_CONCURRENCY
  value: {{ .Values.config.scheduledRefreshConcurrency | quote }}
{{- end }}
{{- if .Values.config.preAggregationsSchema }}
- name: CUBEJS_PRE_AGGREGATIONS_SCHEMA
  value: {{ .Values.config.preAggregationsSchema | quote }}
{{- end }}
{{- if .Values.config.webSockets }}
- name: CUBEJS_WEB_SOCKETS
  value: {{ .Values.config.webSockets | quote }}
{{- end }}
- name: CUBEJS_TELEMETRY
  value: {{ .Values.config.telemetry | quote }}
{{- if .Values.config.apiSecret }}
- name: CUBEJS_API_SECRET
  value: {{ .Values.config.apiSecret | quote }}
{{- else if .Values.config.apiSecretFromSecret }}
- name: CUBEJS_API_SECRET
  valueFrom:
    secretKeyRef:
      name: {{ .Values.config.apiSecretFromSecret.name | required "config.apiSecretFromSecret.name is required" }}
      key: {{ .Values.config.apiSecretFromSecret.key | required "config.apiSecretFromSecret.key is required" }}
{{- end }}
{{- if .Values.config.playgroundAuthSecret }}
- name: CUBEJS_PLAYGROUND_AUTH_SECRET
  value: {{ .Values.config.playgroundAuthSecret | quote }}
{{- else if .Values.config.playgroundAuthSecretFromSecret }}
- name: CUBEJS_PLAYGROUND_AUTH_SECRET
  valueFrom:
    secretKeyRef:
      name: {{ .Values.config.playgroundAuthSecretFromSecret.name | required "config.playgroundAuthSecretFromSecret.name is required" }}
      key: {{ .Values.config.playgroundAuthSecretFromSecret.key | required "config.playgroundAuthSecretFromSecret.key is required" }}
{{- end }}
{{- if .Values.config.schemaPath }}
- name: CUBEJS_SCHEMA_PATH
  value: {{ .Values.config.schemaPath | quote }}
{{- end }}
{{- if .Values.config.topicName }}
- name: CUBEJS_TOPIC_NAME
  value: {{ .Values.config.topicName | quote }}
{{- end }}
{{- end }}