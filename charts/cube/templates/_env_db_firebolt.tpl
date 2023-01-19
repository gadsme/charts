{{- define "cube.env.database.firebolt" }}
{{- if (.firebolt).account }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_FIREBOLT_ACCOUNT" "datasource" .datasource) }}
  value: {{ .firebolt.account | quote }}
{{- end }}
{{- if (.firebolt).engineName }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_FIREBOLT_ENGINE_NAME" "datasource" .datasource) }}
  value: {{ .firebolt.engineName | quote }}
{{- end }}
{{- if (.firebolt).apiEndpoint }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_FIREBOLT_API_ENDPOINT" "datasource" .datasource) }}
  value: {{ .firebolt.apiEndpoint | quote }}
{{- end }}
{{- end }}