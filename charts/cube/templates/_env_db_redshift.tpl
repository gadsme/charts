{{- define "cube.env.database.redshift" }}
{{- if (.redshift).clusterIdentifier }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_REDSHIFT_CLUSTER_IDENTIFIER" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.redshift).clusterIdentifier | quote }}
{{- end }}
{{- if (.redshift).awsRegion }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_REDSHIFT_AWS_REGION" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.redshift).awsRegion | quote }}
{{- end }}
{{- if (.redshift).assumeRoleArn }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_REDSHIFT_ASSUME_ROLE_ARN" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.redshift).assumeRoleArn | quote }}
{{- end }}
{{- if (.redshift).assumeRoleExternalId }}
- name: {{ include "cube.env.decorated" (dict "key" "CUBEJS_DB_REDSHIFT_ASSUME_ROLE_EXTERNAL_ID" "datasource" .datasource "forPreAggregations" .forPreAggregations) }}
  value: {{ (.redshift).assumeRoleExternalId | quote }}
{{- end }}
{{- end }}
