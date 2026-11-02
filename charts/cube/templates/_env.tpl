{{- define "cube.env.database" -}}
{{- include "cube.env.database.common" . }}
{{- if eq .type "athena" }}
{{- include "cube.env.database.athena" . }}
{{- end }}
{{- if eq .type "bigquery" }}
{{- include "cube.env.database.bigquery" . }}
{{- end }}
{{- if eq .type "clickhouse" }}
{{- include "cube.env.database.clickhouse" . }}
{{- end }}
{{- if eq .type "databricks-jdbc" }}
{{- include "cube.env.database.databricks" . }}
{{- end }}
{{- if eq .type "duckdb" }}
{{- include "cube.env.database.duckdb" . }}
{{- end }}
{{- if eq .type "firebolt" }}
{{- include "cube.env.database.firebolt" . }}
{{- end }}
{{- if eq .type "hive" }}
{{- include "cube.env.database.hive" . }}
{{- end }}
{{- if eq .type "ksql" }}
{{- include "cube.env.database.ksql" . }}
{{- end }}
{{- if eq .type "materialize" }}
{{- include "cube.env.database.materialize" . }}
{{- end }}
{{- if eq .type "mssql" }}
{{- include "cube.env.database.mssql" . }}
{{- end }}
{{- if eq .type "mysql" }}
{{- include "cube.env.database.mysql" . }}
{{- end }}
{{- if eq .type "pinot" }}
{{- include "cube.env.database.pinot" . }}
{{- end }}
{{- if eq .type "prestodb" }}
{{- include "cube.env.database.presto" . }}
{{- end }}
{{- if eq .type "redshift" }}
{{- include "cube.env.database.redshift" . }}
{{- end }}
{{- if eq .type "snowflake" }}
{{- include "cube.env.database.snowflake" . }}
{{- end }}
{{- if eq .type "trino" }}
{{- include "cube.env.database.trino" . }}
{{- end }}
{{- end }}

{{- define "cube.env" -}}
{{- include "cube.env.config" . }}
{{- include "cube.env.jwt" . }}
{{- include "cube.env.cubestore" . }}

{{- $datasources := list }}
{{- range $e, $i := $.Values.datasources }}
{{- $datasources = append $datasources $e }}
{{- if not $i.type }}
{{- fail (printf "database.%s.type is required" $e) }}
{{- end }}
{{- include "cube.env.database" (set $i "datasource" $e) }}
{{- if $i.preAggregations }}
{{- include "cube.env.database" (merge (dict "datasource" $e "type" $i.type "forPreAggregations" true) (deepCopy $i.preAggregations)) }}
{{- end }}
{{- end }}
{{- if gt (len $datasources) 1 }}
- name: CUBEJS_DATASOURCES
  value: {{ join "," $datasources | quote }}
{{- end }}
{{- end }}
