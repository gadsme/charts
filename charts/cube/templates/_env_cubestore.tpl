{{- define "cube.env.cubestore" -}}
{{- if .Values.cubestore.host }}
- name: CUBEJS_CUBESTORE_HOST
  value: {{ .Values.cubestore.host | quote }}
{{- end }}
{{- if .Values.cubestore.port }}
- name: CUBEJS_CUBESTORE_PORT
  value: {{ .Values.cubestore.port | quote }}
{{- end }}
{{- if .Values.cubestore.maxMessageSize }}
- name: CUBEJS_CUBESTORE_MAX_MESSAGE_SIZE
  value: {{ .Values.cubestore.maxMessageSize | quote }}
{{- end }}
{{- end }}
