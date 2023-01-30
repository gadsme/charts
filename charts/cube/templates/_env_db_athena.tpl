{{- define "cube.env.database.athena" }}
{{- if (.athena).key }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_AWS_KEY" "datasource" .datasource) }}
  value: {{ .athena.key | quote }}
{{- end }}
{{- if (.athena).secret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_AWS_SECRET" "datasource" .datasource) }}
  value: {{ .athena.secret | quote }}
{{- end }}
{{- if (.athena).region }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_AWS_REGION" "datasource" .datasource) }}
  value: {{ .athena.region | quote }}
{{- end }}
{{- if (.athena).s3OutputLocation }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_AWS_S3_OUTPUT_LOCATION" "datasource" .datasource) }}
  value: {{ .athena.s3OutputLocation | quote }}
{{- end }}
{{- if (.athena).workgroup }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_AWS_ATHENA_WORKGROUP" "datasource" .datasource) }}
  value: {{ .athena.workgroup | quote }}
{{- end }}
{{- if (.athena).catalog }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_AWS_ATHENA_CATALOG" "datasource" .datasource) }}
  value: {{ .athena.catalog | quote }}
{{- end }}
{{- end }}