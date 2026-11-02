{{- define "cubestore.common-env" -}}
{{- if .Values.config.logLevel }}
- name: CUBESTORE_LOG_LEVEL
  value: {{ .Values.config.logLevel | quote }}
{{- end }}
{{- if .Values.config.noUpload }}
- name: CUBESTORE_NO_UPLOAD
  value: {{ .Values.config.noUpload | quote }}
{{- end }}
- name: CUBESTORE_TELEMETRY
  value: {{ .Values.config.telemetry | quote }}
{{- if .Values.config.jobRunners }}
- name: CUBESTORE_JOB_RUNNERS
  value: {{ .Values.config.jobRunners | quote }}
{{- end }}
{{- if .Values.config.queryTimeout }}
- name: CUBESTORE_QUERY_TIMEOUT
  value: {{ .Values.config.queryTimeout | quote }}
{{- end }}
{{- if .Values.config.walSplitThreshold }}
- name: CUBESTORE_WAL_SPLIT_THRESHOLD
  value: {{ .Values.config.walSplitThreshold | quote }}
{{- end }}
{{- if .Values.cloudStorage.gcp.bucket }}
- name: CUBESTORE_GCS_BUCKET
  value: {{ .Values.cloudStorage.gcp.bucket | quote }}
{{- end }}
{{- if .Values.cloudStorage.gcp.subPath }}
- name: CUBESTORE_GCS_SUB_PATH
  value: {{ .Values.cloudStorage.gcp.subPath | quote }}
{{- end }}
{{- if .Values.cloudStorage.gcp.credentials }}
- name: CUBESTORE_GCP_CREDENTIALS
  value: {{ .Values.cloudStorage.gcp.credentials | quote }}
{{- else if .Values.cloudStorage.gcp.credentialsFromSecret }}
- name: CUBESTORE_GCP_CREDENTIALS
  valueFrom:
    secretKeyRef:
      name: {{ .Values.cloudStorage.gcp.credentialsFromSecret.name | required "cloudStorage.gcp.credentialsFromSecret.name is required" }}
      key: {{ .Values.cloudStorage.gcp.credentialsFromSecret.key | required "cloudStorage.gcp.credentialsFromSecret.key is required" }}
{{- end }}
{{- if .Values.cloudStorage.aws.accessKeyID }}
- name: CUBESTORE_AWS_ACCESS_KEY_ID
  value: {{ .Values.cloudStorage.aws.accessKeyID | quote }}
{{- else if .Values.cloudStorage.aws.accessKeyIDFromSecret }}
- name: CUBESTORE_AWS_ACCESS_KEY_ID
  valueFrom:
    secretKeyRef:
      name: {{ .Values.cloudStorage.aws.accessKeyIDFromSecret.name | required "cloudStorage.aws.accessKeyIDFromSecret.name is required" }}
      key: {{ .Values.cloudStorage.aws.accessKeyIDFromSecret.key | required "cloudStorage.aws.accessKeyIDFromSecret.key is required" }}
{{- end }}
{{- if .Values.cloudStorage.aws.secretKey }}
- name: CUBESTORE_AWS_SECRET_ACCESS_KEY
  value: {{ .Values.cloudStorage.aws.secretKey | quote }}
{{- else if .Values.cloudStorage.aws.secretKeyFromSecret }}
- name: CUBESTORE_AWS_SECRET_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      name: {{ .Values.cloudStorage.aws.secretKeyFromSecret.name | required "cloudStorage.aws.secretKeyFromSecret.name is required" }}
      key: {{ .Values.cloudStorage.aws.secretKeyFromSecret.key | required "cloudStorage.aws.secretKeyFromSecret.key is required" }}
{{- end }}
{{- if .Values.cloudStorage.aws.bucket }}
- name: CUBESTORE_S3_BUCKET
  value: {{ .Values.cloudStorage.aws.bucket | quote }}
{{- end }}
{{- if .Values.cloudStorage.aws.region }}
- name: CUBESTORE_S3_REGION
  value: {{ .Values.cloudStorage.aws.region | quote }}
{{- end }}
{{- if .Values.cloudStorage.aws.subPath }}
- name: CUBESTORE_S3_SUB_PATH
  value: {{ .Values.cloudStorage.aws.subPath | quote }}
{{- end }}
{{- if .Values.cloudStorage.aws.refreshCredsEveryMinutes }}
- name: CUBESTORE_AWS_CREDS_REFRESH_EVERY_MINS
  value: {{ .Values.cloudStorage.aws.refreshCredsEveryMinutes | quote }}
{{- end }}
{{- if .Values.cloudStorage.minio.accessKeyID }}
- name: CUBESTORE_MINIO_ACCESS_KEY_ID
  value: {{ .Values.cloudStorage.minio.accessKeyID | quote }}
{{- end }}
{{- if .Values.cloudStorage.minio.secretKey }}
- name: CUBESTORE_MINIO_SECRET_ACCESS_KEY
  value: {{ .Values.cloudStorage.minio.secretKey | quote }}
{{- else if .Values.cloudStorage.minio.secretKeyFromSecret }}
- name: CUBESTORE_MINIO_SECRET_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      name: {{ .Values.cloudStorage.minio.secretKeyFromSecret.name | required "cloudStorage.minio.secretKeyFromSecret.name is required" }}
      key: {{ .Values.cloudStorage.minio.secretKeyFromSecret.key | required "cloudStorage.minio.secretKeyFromSecret.key is required" }}
{{- end }}
{{- if .Values.cloudStorage.minio.bucket }}
- name: CUBESTORE_MINIO_BUCKET
  value: {{ .Values.cloudStorage.minio.bucket | quote }}
{{- end }}
{{- if .Values.cloudStorage.minio.region }}
- name: CUBESTORE_MINIO_REGION
  value: {{ .Values.cloudStorage.minio.region | quote }}
{{- end }}
{{- if .Values.cloudStorage.minio.subPath }}
- name: CUBESTORE_MINIO_SUB_PATH
  value: {{ .Values.cloudStorage.minio.subPath | quote }}
{{- end }}
{{- if .Values.cloudStorage.minio.endpoint }}
- name: CUBESTORE_MINIO_SERVER_ENDPOINT
  value: {{ .Values.cloudStorage.minio.endpoint | quote }}
{{- end }}
{{- if .Values.cloudStorage.minio.credentialsRefreshEveryMinutes }}
- name: CUBESTORE_MINIO_CREDS_REFRESH_EVERY_MINS
  value: {{ .Values.cloudStorage.minio.credentialsRefreshEveryMinutes | quote }}
{{- end }}
{{- if .Values.metrics.format }}
- name: CUBESTORE_METRICS_FORMAT
  value: {{ .Values.metrics.format | quote }}
{{- end }}
{{- if .Values.metrics.address }}
- name: CUBESTORE_METRICS_ADDRESS
  value: {{ .Values.metrics.address | quote }}
{{- end }}
{{- if .Values.metrics.port }}
- name: CUBESTORE_METRICS_PORT
  value: {{ .Values.metrics.port | quote }}
{{- end }}
{{- if .Values.config.selectWorkers }}
- name: CUBESTORE_SELECT_WORKERS
  value: {{ .Values.config.selectWorkers | quote }}
{{- end }}
{{- if .Values.config.selectWorkerStackSize }}
- name: CUBESTORE_SELECT_WORKER_STACK_SIZE
  value: {{ .Values.config.selectWorkerStackSize | quote }}
{{- end }}
{{- if .Values.config.mainStackSize }}
- name: CUBESTORE_MAIN_STACK_SIZE
  value: {{ .Values.config.mainStackSize | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.csvImportJobRunners) }}
- name: CUBESTORE_CSV_IMPORT_JOB_RUNNERS
  value: {{ .Values.config.csvImportJobRunners | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.loadAwareImportPlacement) }}
- name: CUBESTORE_LOAD_AWARE_IMPORT_PLACEMENT
  value: {{ .Values.config.loadAwareImportPlacement | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.maxConcurrentQueryPlans) }}
- name: CUBESTORE_MAX_CONCURRENT_QUERY_PLANS
  value: {{ .Values.config.maxConcurrentQueryPlans | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.maxQueuedQueryPlans) }}
- name: CUBESTORE_MAX_QUEUED_QUERY_PLANS
  value: {{ .Values.config.maxQueuedQueryPlans | quote }}
{{- end }}
{{- if .Values.config.maxQueryPlanDepth }}
- name: CUBESTORE_MAX_QUERY_PLAN_DEPTH
  value: {{ .Values.config.maxQueryPlanDepth | quote }}
{{- end }}
{{- if .Values.config.sqlParserRecursionLimit }}
- name: CUBESTORE_SQL_PARSER_RECURSION_LIMIT
  value: {{ .Values.config.sqlParserRecursionLimit | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.groupByLimitFactor) }}
- name: CUBESTORE_GROUP_BY_LIMIT_FACTOR
  value: {{ .Values.config.groupByLimitFactor | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.groupByLimitPerPartition) }}
- name: CUBESTORE_GROUP_BY_LIMIT_PER_PARTITION
  value: {{ .Values.config.groupByLimitPerPartition | quote }}
{{- end }}
{{- if .Values.config.topkStrategy }}
- name: CUBESTORE_TOPK_STRATEGY
  value: {{ .Values.config.topkStrategy | quote }}
{{- end }}
{{- if .Values.config.coalesceUnderHashAggregate }}
- name: CUBESTORE_COALESCE_UNDER_HASH_AGGREGATE
  value: {{ .Values.config.coalesceUnderHashAggregate | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.cacheEvictionSizeClasses) }}
- name: CUBESTORE_CACHE_EVICTION_SIZE_CLASSES
  value: {{ .Values.config.cacheEvictionSizeClasses | quote }}
{{- end }}
{{- if .Values.config.cacheMaxEntrySize }}
- name: CUBESTORE_CACHE_MAX_ENTRY_SIZE
  value: {{ .Values.config.cacheMaxEntrySize | quote }}
{{- end }}
{{- if .Values.config.queryCacheStaleWhileRevalidate }}
- name: CUBESTORE_QUERY_CACHE_STALE_WHILE_REVALIDATE
  value: {{ .Values.config.queryCacheStaleWhileRevalidate | quote }}
{{- end }}
{{- if .Values.config.chunksCountThreshold }}
- name: CUBESTORE_CHUNKS_COUNT_THRESHOLD
  value: {{ .Values.config.chunksCountThreshold | quote }}
{{- end }}
{{- if .Values.config.compactionReadinessChunksThreshold }}
- name: CUBESTORE_COMPACTION_READINESS_CHUNKS_THRESHOLD
  value: {{ .Values.config.compactionReadinessChunksThreshold | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.repartitionConcurrentDownload) }}
- name: CUBESTORE_REPARTITION_CONCURRENT_DOWNLOAD
  value: {{ .Values.config.repartitionConcurrentDownload | quote }}
{{- end }}
{{- if .Values.config.repartitionMergeMaxRows }}
- name: CUBESTORE_REPARTITION_MERGE_MAX_ROWS
  value: {{ .Values.config.repartitionMergeMaxRows | quote }}
{{- end }}
{{- if .Values.config.repartitionStrategy }}
- name: CUBESTORE_REPARTITION_STRATEGY
  value: {{ .Values.config.repartitionStrategy | quote }}
{{- end }}
{{- if .Values.config.transportMaxFrameSize }}
- name: CUBESTORE_TRANSPORT_MAX_FRAME_SIZE
  value: {{ .Values.config.transportMaxFrameSize | quote }}
{{- end }}
{{- if .Values.config.transportMaxMessageSize }}
- name: CUBESTORE_TRANSPORT_MAX_MESSAGE_SIZE
  value: {{ .Values.config.transportMaxMessageSize | quote }}
{{- end }}
{{- if .Values.config.maxWsConnectionsPerUser }}
- name: CUBESTORE_MAX_WS_CONNECTIONS_PER_USER
  value: {{ .Values.config.maxWsConnectionsPerUser | quote }}
{{- end }}
{{- if not (kindIs "invalid" .Values.config.metastoreBatchRpc) }}
- name: CUBESTORE_METASTORE_BATCH_RPC
  value: {{ .Values.config.metastoreBatchRpc | quote }}
{{- end }}
{{- if .Values.config.streamingLagTimeoutMs }}
- name: CUBESTORE_STREAMING_LAG_TIMEOUT_MS
  value: {{ .Values.config.streamingLagTimeoutMs | quote }}
{{- end }}
{{- if .Values.cloudStorage.gcp.keyFile }}
- name: CUBESTORE_GCP_KEY_FILE
  value: {{ .Values.cloudStorage.gcp.keyFile | quote }}
{{- end }}
{{- if .Values.cloudStorage.aws.roleArn }}
- name: CUBESTORE_AWS_ROLE_ARN
  value: {{ .Values.cloudStorage.aws.roleArn | quote }}
{{- end }}
{{- if .Values.cloudStorage.aws.webIdentityTokenFile }}
- name: CUBESTORE_AWS_WEB_IDENTITY_TOKEN_FILE
  value: {{ .Values.cloudStorage.aws.webIdentityTokenFile | quote }}
{{- end }}
{{- if .Values.cloudStorage.aws.sse }}
- name: CUBESTORE_S3_SSE
  value: {{ .Values.cloudStorage.aws.sse | quote }}
{{- end }}
{{- end }}
