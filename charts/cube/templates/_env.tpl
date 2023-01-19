{{- define "cube.env" -}}
{{- include "cube.env.config" . }}
{{- include "cube.env.jwt" . }}
{{- include "cube.env.redis" . }}

{{- $datasources := list }}
{{- range $e, $i := $.Values.datasources }}
{{- $datasources = append $datasources $e }}
{{- include "cube.env.database.common" (set $i "datasource" $e) }}
{{- include "cube.env.database.bigquery" (set $i "datasource" $e) }}
{{- include "cube.env.database.clickhouse" (set $i "datasource" $e) }}
{{- include "cube.env.database.databricks" (set $i "datasource" $e) }}
{{- include "cube.env.database.elasticsearch" (set $i "datasource" $e) }}
{{- include "cube.env.database.firebolt" (set $i "datasource" $e) }}
{{- include "cube.env.database.hive" (set $i "datasource" $e) }}
{{- include "cube.env.database.presto" (set $i "datasource" $e) }}
{{- include "cube.env.database.snowflake" (set $i "datasource" $e) }}
{{- end }}
{{- if gt (len $datasources) 1 }}
- name: CUBEJS_DATASOURCES
  value: {{ join "," $datasources | quote }}
{{- end }}
{{- end }}