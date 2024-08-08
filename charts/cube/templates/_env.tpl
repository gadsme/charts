{{- define "cube.env" -}}
{{- include "cube.env.config" . }}
{{- include "cube.env.jwt" . }}
{{- include "cube.env.redis" . }}
{{- include "cube.env.cubestore" . }}

{{- $datasources := list }}
{{- range $e, $i := $.Values.datasources }}
{{- $datasources = append $datasources $e }}
{{- if not $i.type }}
{{- fail (printf "database.%s.type is required" $e) }}
{{- end }}
{{- include "cube.env.database.common" (set $i "datasource" $e) }}
{{- if eq $i.type "athena" }}
{{- include "cube.env.database.athena" (set $i "datasource" $e) }}
{{- end }}
{{- if eq $i.type "bigquery" }}
{{- include "cube.env.database.bigquery" (set $i "datasource" $e) }}
{{- end }}
{{- if eq $i.type "clickhouse" }}
{{- include "cube.env.database.clickhouse" (set $i "datasource" $e) }}
{{- end }}
{{- if eq $i.type "databricks-jdbc" }}
{{- include "cube.env.database.databricks" (set $i "datasource" $e) }}
{{- end }}
{{- if eq $i.type "elasticsearch" }}
{{- include "cube.env.database.elasticsearch" (set $i "datasource" $e) }}
{{- end }}
{{- if eq $i.type "firebolt" }}
{{- include "cube.env.database.firebolt" (set $i "datasource" $e) }}
{{- end }}
{{- if eq $i.type "hive" }}
{{- include "cube.env.database.hive" (set $i "datasource" $e) }}
{{- end }}
{{- if eq $i.type "materialize" }}
{{- include "cube.env.database.materialize" (set $i "datasource" $e) }}
{{- end }}
{{- if eq $i.type "presto" }}
{{- include "cube.env.database.presto" (set $i "datasource" $e) }}
{{- end }}
{{- if eq $i.type "snowflake" }}
{{- include "cube.env.database.snowflake" (set $i "datasource" $e) }}
{{- end }}
{{- if eq $i.type "trino" }}
{{- include "cube.env.database.trino" (set $i "datasource" $e) }}
{{- end }}
{{- end }}
{{- if gt (len $datasources) 1 }}
- name: CUBEJS_DATASOURCES
  value: {{ join "," $datasources | quote }}
{{- end }}
{{- end }}