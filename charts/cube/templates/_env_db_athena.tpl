{{- define "cube.env.database.athena" }}
{{- if (.aws).key }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_AWS_KEY" "datasource" .datasource) }}
  value: {{ .aws.key | quote }}
{{- end }}
{{- if (.aws).secret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_AWS_SECRET" "datasource" .datasource) }}
  value: {{ .aws.secret | quote }}
{{- end }}
{{- if (.aws).region }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_AWS_REGION" "datasource" .datasource) }}
  value: {{ .aws.region | quote }}
{{- end }}
{{- if (.aws).s3OutputLocation }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_AWS_S3_OUTPUT_LOCATION" "datasource" .datasource) }}
  value: {{ .aws.s3OutputLocation | quote }}
{{- end }}
{{- if (.aws).athenaWorkgroup }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_AWS_ATHENA_WORKGROUP" "datasource" .datasource) }}
  value: {{ .aws.athenaWorkgroup | quote }}
{{- end }}
{{- if (.aws).athenaCatalog }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_AWS_ATHENA_CATALOG" "datasource" .datasource) }}
  value: {{ .aws.athenaCatalog | quote }}
{{- end }}
{{- end }}