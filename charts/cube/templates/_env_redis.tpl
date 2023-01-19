{{- define "cube.env.redis" -}}
{{- if or (eq .Values.config.cacheAndQueueDriver "redis") (and (not .Values.config.cacheAndQueueDriver) (not .Values.config.devMode)) }}
- name: CUBEJS_REDIS_URL
  value: {{ .Values.redis.url | quote | required "redis.url is required" }}
{{- if .Values.redis.password }}
- name: CUBEJS_REDIS_PASSWORD
  value: {{ .Values.redis.password | quote }}
{{- else if .Values.redis.passwordFromSecret }}
- name: CUBEJS_REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.redis.passwordFromSecret.name | required "redis.passwordFromSecret.name is required" }}
      key: {{ .Values.redis.passwordFromSecret.key | required "redis.passwordFromSecret.key is required" }}
{{- end }}
{{- if .Values.redis.tls }}
- name: CUBEJS_REDIS_TLS
  value: {{ .Values.redis.tls | quote }}
{{- end }}
{{- if .Values.redis.poolMin }}
- name: CUBEJS_REDIS_POOL_MIN
  value: {{ .Values.redis.poolMin | quote }}
{{- end }}
{{- if .Values.redis.poolMax }}
- name: CUBEJS_REDIS_POOL_MAX
  value: {{ .Values.redis.poolMax | quote }}
{{- end }}
{{- if .Values.redis.useIoRedis }}
- name: CUBEJS_REDIS_USE_IOREDIS
  value: {{ .Values.redis.useIoRedis | quote }}
{{- end }}
{{- end }}
{{- end }}