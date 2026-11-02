{{- define "cube.env.database.athena" }}
{{- if (.athena).key }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_AWS_KEY" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .athena.key | quote }}
{{- end }}
{{- if (.athena).secret }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_AWS_SECRET" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .athena.secret | quote }}
{{- end }}
{{- if (.athena).region }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_AWS_REGION" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .athena.region | quote }}
{{- end }}
{{- if (.athena).s3OutputLocation }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_AWS_S3_OUTPUT_LOCATION" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .athena.s3OutputLocation | quote }}
{{- end }}
{{- if (.athena).workgroup }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_AWS_ATHENA_WORKGROUP" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .athena.workgroup | quote }}
{{- end }}
{{- if (.athena).catalog }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_AWS_ATHENA_CATALOG" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ .athena.catalog | quote }}
{{- end }}
{{- if (.athena).assumeRoleArn }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_AWS_ATHENA_ASSUME_ROLE_ARN" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.athena).assumeRoleArn | quote }}
{{- end }}
{{- if (.athena).assumeRoleExternalId }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_AWS_ATHENA_ASSUME_ROLE_EXTERNAL_ID" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.athena).assumeRoleExternalId | quote }}
{{- end }}
{{- end }}
