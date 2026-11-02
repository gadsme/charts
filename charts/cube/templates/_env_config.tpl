{{- define "cube.env.config" -}}
- name: PORT
  value: {{ .Values.config.apiPort | quote }}
{{- if .Values.config.debug }}
- name: DEBUG_LOG
  value: {{ .Values.config.debug | quote }}
{{- end }}
{{- if .Values.config.pgSqlPort }}
- name: CUBEJS_PG_SQL_PORT
  value: {{ .Values.config.pgSqlPort | quote }}
{{- end }}
{{- if .Values.config.sqlSuperUser }}
- name: CUBEJS_SQL_SUPER_USER
  value: {{ .Values.config.sqlSuperUser | quote }}
{{- end }}
{{- if .Values.config.sqlUser }}
- name: CUBEJS_SQL_USER
  value: {{ .Values.config.sqlUser | quote }}
{{- end }}
{{- if .Values.config.sqlPassword }}
- name: CUBEJS_SQL_PASSWORD
  value: {{ .Values.config.sqlPassword | quote }}
{{- else if .Values.config.sqlPasswordFromSecret }}
- name: CUBEJS_SQL_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.config.sqlPasswordFromSecret.name | required "config.sqlPasswordFromSecret.name is required" }}
      key: {{ .Values.config.sqlPasswordFromSecret.key | required "config.sqlPasswordFromSecret.key is required" }}
{{- end }}
{{- if .Values.config.devMode }}
- name: CUBEJS_DEV_MODE
  value: {{ .Values.config.devMode | quote }}
{{- end }}
{{- if .Values.config.logLevel }}
- name: CUBEJS_LOG_LEVEL
  value: {{ .Values.config.logLevel | quote }}
{{- end }}
{{- if .Values.config.app }}
- name: CUBEJS_APP
  value: {{ .Values.config.app | quote }}
{{- end }}
{{- if .Values.config.cacheAndQueueDriver }}
- name: CUBEJS_CACHE_AND_QUEUE_DRIVER
  value: {{ .Values.config.cacheAndQueueDriver | quote }}
{{- end }}
{{- if .Values.config.concurrency }}
- name: CUBEJS_CONCURRENCY
  value: {{ .Values.config.concurrency | quote }}
{{- end }}
{{- if .Values.config.queryDefaultLimit }}
- name: CUBEJS_DB_QUERY_DEFAULT_LIMIT
  value: {{ .Values.config.queryDefaultLimit | quote }}
{{- end }}
{{- if .Values.config.queryLimit }}
- name: CUBEJS_DB_QUERY_LIMIT
  value: {{ .Values.config.queryLimit | quote }}
{{- end }}
{{- if .Values.config.rollupOnly }}
- name: CUBEJS_ROLLUP_ONLY
  value: {{ .Values.config.rollupOnly | quote }}
{{- end }}
{{- if .Values.config.scheduledRefreshTimezones }}
- name: CUBEJS_SCHEDULED_REFRESH_TIMEZONES
  value: {{ .Values.config.scheduledRefreshTimezones | quote }}
{{- end }}
{{- if .Values.config.scheduledRefreshQueriesPerAppId }}
- name: CUBEJS_SCHEDULED_REFRESH_QUERIES_PER_APP_ID
  value: {{ .Values.config.scheduledRefreshQueriesPerAppId | quote }}
{{- end }}
{{- if .Values.config.preAggregationsSchema }}
- name: CUBEJS_PRE_AGGREGATIONS_SCHEMA
  value: {{ .Values.config.preAggregationsSchema | quote }}
{{- end }}
{{- if .Values.config.webSockets }}
- name: CUBEJS_WEB_SOCKETS
  value: {{ .Values.config.webSockets | quote }}
{{- end }}
- name: CUBEJS_TELEMETRY
  value: {{ .Values.config.telemetry | quote }}
{{- if .Values.config.apiSecret }}
- name: CUBEJS_API_SECRET
  value: {{ .Values.config.apiSecret | quote }}
{{- else if .Values.config.apiSecretFromSecret }}
- name: CUBEJS_API_SECRET
  valueFrom:
    secretKeyRef:
      name: {{ .Values.config.apiSecretFromSecret.name | required "config.apiSecretFromSecret.name is required" }}
      key: {{ .Values.config.apiSecretFromSecret.key | required "config.apiSecretFromSecret.key is required" }}
{{- end }}
{{- if .Values.config.defaultApiScopes }}
- name: CUBEJS_DEFAULT_API_SCOPES
  value: {{ .Values.config.defaultApiScopes | quote }}
{{- end }}
{{- if .Values.config.playgroundAuthSecret }}
- name: CUBEJS_PLAYGROUND_AUTH_SECRET
  value: {{ .Values.config.playgroundAuthSecret | quote }}
{{- else if .Values.config.playgroundAuthSecretFromSecret }}
- name: CUBEJS_PLAYGROUND_AUTH_SECRET
  valueFrom:
    secretKeyRef:
      name: {{ .Values.config.playgroundAuthSecretFromSecret.name | required "config.playgroundAuthSecretFromSecret.name is required" }}
      key: {{ .Values.config.playgroundAuthSecretFromSecret.key | required "config.playgroundAuthSecretFromSecret.key is required" }}
{{- end }}
{{- if .Values.config.schemaPath }}
- name: CUBEJS_SCHEMA_PATH
  value: {{ .Values.config.schemaPath | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.dropPreAggWithoutTouch) }}
- name: CUBEJS_DROP_PRE_AGG_WITHOUT_TOUCH
  value: {{ .Values.config.dropPreAggWithoutTouch | quote }}
{{- end }}
{{- if .Values.config.touchPreAggTimeout }}
- name: CUBEJS_TOUCH_PRE_AGG_TIMEOUT
  value: {{ .Values.config.touchPreAggTimeout | quote }}
{{- end }}
{{- if .Values.config.apiSecrets }}
- name: CUBEJS_API_SECRETS
  value: {{ .Values.config.apiSecrets | quote }}
{{- else if .Values.config.apiSecretsFromSecret }}
- name: CUBEJS_API_SECRETS
  valueFrom:
    secretKeyRef:
      name: {{ .Values.config.apiSecretsFromSecret.name | required "config.apiSecretsFromSecret.name is required" }}
      key: {{ .Values.config.apiSecretsFromSecret.key | required "config.apiSecretsFromSecret.key is required" }}
{{- end }}
{{- if .Values.config.maxRequestSize }}
- name: CUBEJS_MAX_REQUEST_SIZE
  value: {{ .Values.config.maxRequestSize | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.serverHeadersTimeout) }}
- name: CUBEJS_SERVER_HEADERS_TIMEOUT
  value: {{ .Values.config.serverHeadersTimeout | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.serverKeepAliveTimeout) }}
- name: CUBEJS_SERVER_KEEP_ALIVE_TIMEOUT
  value: {{ .Values.config.serverKeepAliveTimeout | quote }}
{{- end }}
{{- if .Values.config.defaultTimezone }}
- name: CUBEJS_DEFAULT_TIMEZONE
  value: {{ .Values.config.defaultTimezone | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.autoRunMode) }}
- name: CUBEJS_AUTO_RUN_MODE
  value: {{ .Values.config.autoRunMode | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.logRedaction) }}
- name: CUBEJS_LOG_REDACTION
  value: {{ .Values.config.logRedaction | quote }}
{{- end }}
{{- if .Values.config.allowUngroupedWithoutPrimaryKey }}
- name: CUBEJS_ALLOW_UNGROUPED_WITHOUT_PRIMARY_KEY
  value: {{ .Values.config.allowUngroupedWithoutPrimaryKey | quote }}
{{- end }}
{{- if .Values.config.nestedFoldersDelimiter }}
- name: CUBEJS_NESTED_FOLDERS_DELIMITER
  value: {{ .Values.config.nestedFoldersDelimiter | quote }}
{{- end }}
{{- if .Values.config.nodeExtraCaCerts }}
- name: NODE_EXTRA_CA_CERTS
  value: {{ .Values.config.nodeExtraCaCerts | quote }}
{{- end }}
{{- if .Values.config.compilerCacheSize }}
- name: CUBEJS_COMPILER_CACHE_SIZE
  value: {{ .Values.config.compilerCacheSize | quote }}
{{- end }}
{{- if .Values.config.compilerMultiTenantSharing }}
- name: CUBEJS_COMPILER_MULTI_TENANT_SHARING
  value: {{ .Values.config.compilerMultiTenantSharing | quote }}
{{- end }}
{{- if .Values.config.maxCompiledMembers }}
- name: CUBEJS_MAX_COMPILED_MEMBERS
  value: {{ .Values.config.maxCompiledMembers | quote }}
{{- end }}
{{- if .Values.config.maxMemberResolutionDepth }}
- name: CUBEJS_MAX_MEMBER_RESOLUTION_DEPTH
  value: {{ .Values.config.maxMemberResolutionDepth | quote }}
{{- end }}
{{- if .Values.config.maxMultiStageDepth }}
- name: CUBEJS_MAX_MULTI_STAGE_DEPTH
  value: {{ .Values.config.maxMultiStageDepth | quote }}
{{- end }}
{{- if .Values.config.maxMultiStageStages }}
- name: CUBEJS_MAX_MULTI_STAGE_STAGES
  value: {{ .Values.config.maxMultiStageStages | quote }}
{{- end }}
{{- if .Values.config.maxPartitionsPerCube }}
- name: CUBEJS_MAX_PARTITIONS_PER_CUBE
  value: {{ .Values.config.maxPartitionsPerCube | quote }}
{{- end }}
{{- if .Values.config.maxSourceRowLimit }}
- name: CUBEJS_MAX_SOURCE_ROW_LIMIT
  value: {{ .Values.config.maxSourceRowLimit | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.tesseractSqlPlanner) }}
- name: CUBEJS_TESSERACT_SQL_PLANNER
  value: {{ .Values.config.tesseractSqlPlanner | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.tesseractCubestoreUnionFullKeyAggregate) }}
- name: CUBEJS_TESSERACT_CUBESTORE_UNION_FULL_KEY_AGGREGATE
  value: {{ .Values.config.tesseractCubestoreUnionFullKeyAggregate | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.tesseractTrinoUnionFullKeyAggregate) }}
- name: CUBEJS_TESSERACT_TRINO_UNION_FULL_KEY_AGGREGATE
  value: {{ .Values.config.tesseractTrinoUnionFullKeyAggregate | quote }}
{{- end }}
{{- if .Values.config.refreshWorkerConcurrency }}
- name: CUBEJS_REFRESH_WORKER_CONCURRENCY
  value: {{ .Values.config.refreshWorkerConcurrency | quote }}
{{- end }}
{{- if .Values.config.scheduledRefreshTimerIntervalOnly }}
- name: CUBEJS_SCHEDULED_REFRESH_TIMER_INTERVAL_ONLY
  value: {{ .Values.config.scheduledRefreshTimerIntervalOnly | quote }}
{{- end }}
{{- if .Values.config.refreshKeyLocalTime }}
- name: CUBEJS_REFRESH_KEY_LOCAL_TIME
  value: {{ .Values.config.refreshKeyLocalTime | quote }}
{{- end }}
{{- if .Values.config.queueFastTrack }}
- name: CUBEJS_QUEUE_FAST_TRACK
  value: {{ .Values.config.queueFastTrack | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.preAggregationsBuilder) }}
- name: CUBEJS_PRE_AGGREGATIONS_BUILDER
  value: {{ .Values.config.preAggregationsBuilder | quote }}
{{- end }}
{{- if .Values.config.preAggregationsBackoffMaxTime }}
- name: CUBEJS_PRE_AGGREGATIONS_BACKOFF_MAX_TIME
  value: {{ .Values.config.preAggregationsBackoffMaxTime | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.preAggregationsAllowNonStrictDateRangeMatch) }}
- name: CUBEJS_PRE_AGGREGATIONS_ALLOW_NON_STRICT_DATE_RANGE_MATCH
  value: {{ .Values.config.preAggregationsAllowNonStrictDateRangeMatch | quote }}
{{- end }}
{{- if .Values.config.sqlIncludeTraceId }}
- name: CUBEJS_SQL_INCLUDE_TRACE_ID
  value: {{ .Values.config.sqlIncludeTraceId | quote }}
{{- end }}
{{- if .Values.config.maxSessions }}
- name: CUBEJS_MAX_SESSIONS
  value: {{ .Values.config.maxSessions | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.sqlPushDown) }}
- name: CUBESQL_SQL_PUSH_DOWN
  value: {{ .Values.config.sqlPushDown | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.sqlPushDownPreAggregations) }}
- name: CUBESQL_SQL_PUSH_DOWN_PRE_AGGREGATIONS
  value: {{ .Values.config.sqlPushDownPreAggregations | quote }}
{{- end }}
{{- if .Values.config.sqlStreamMode }}
- name: CUBESQL_STREAM_MODE
  value: {{ .Values.config.sqlStreamMode | quote }}
{{- end }}
{{- if .Values.config.sqlFailOnLimitlessPostProcessing }}
- name: CUBESQL_FAIL_ON_LIMITLESS_POST_PROCESSING
  value: {{ .Values.config.sqlFailOnLimitlessPostProcessing | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.sqlCubeScanMaxBatchRows) }}
- name: CUBESQL_CUBE_SCAN_MAX_BATCH_ROWS
  value: {{ .Values.config.sqlCubeScanMaxBatchRows | quote }}
{{- end }}
{{- if .Values.config.sqlNonStreamingQueryMaxRowLimit }}
- name: CUBESQL_NON_STREAMING_QUERY_MAX_ROW_LIMIT
  value: {{ .Values.config.sqlNonStreamingQueryMaxRowLimit | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.sqlNoImplicitOrder) }}
- name: CUBESQL_SQL_NO_IMPLICIT_ORDER
  value: {{ .Values.config.sqlNoImplicitOrder | quote }}
{{- end }}
{{- if .Values.config.sqlRewriteMaxNodes }}
- name: CUBESQL_REWRITE_MAX_NODES
  value: {{ .Values.config.sqlRewriteMaxNodes | quote }}
{{- end }}
{{- if .Values.config.sqlRewriteMaxIterations }}
- name: CUBESQL_REWRITE_MAX_ITERATIONS
  value: {{ .Values.config.sqlRewriteMaxIterations | quote }}
{{- end }}
{{- if .Values.config.sqlRewriteTimeout }}
- name: CUBESQL_REWRITE_TIMEOUT
  value: {{ .Values.config.sqlRewriteTimeout | quote }}
{{- end }}
{{- if .Values.config.sqlAuthExpireSecs }}
- name: CUBESQL_AUTH_EXPIRE_SECS
  value: {{ .Values.config.sqlAuthExpireSecs | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.daxCreateDateHierarchies) }}
- name: CUBEJS_DAX_CREATE_DATE_HIERARCHIES
  value: {{ .Values.config.daxCreateDateHierarchies | quote }}
{{- end }}
{{- if .Values.config.daxShareVars }}
- name: CUBEJS_DAX_SHARE_VARS
  value: {{ .Values.config.daxShareVars | quote }}
{{- end }}
{{- if .Values.config.daxSinglePerspective }}
- name: CUBEJS_DAX_SINGLE_PERSPECTIVE
  value: {{ .Values.config.daxSinglePerspective | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.mdxCreateDateHierarchies) }}
- name: CUBE_MDX_CREATE_DATE_HIERARCHIES
  value: {{ .Values.config.mdxCreateDateHierarchies | quote }}
{{- end }}
{{- if .Values.config.xmlaLanguage }}
- name: CUBE_XMLA_LANGUAGE
  value: {{ .Values.config.xmlaLanguage | quote }}
{{- end }}
{{- end }}
