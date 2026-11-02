# Change Log

The release numbering uses [semantic versioning](http://semver.org).

## 4.0.0

- update to cube 1.8.16
- BREAKING: remove `redis.*` values (Redis support was removed in Cube v0.36)
- BREAKING: remove `datasources.<name>.elasticsearch.*` values (Elasticsearch driver was removed in Cube v1.7)
- BREAKING: remove `config.scheduledRefreshConcurrency` (removed in Cube v1.7), use `config.scheduledRefreshQueriesPerAppId`
- BREAKING: remove `config.topicName` (`CUBEJS_TOPIC_NAME` is no longer used)
- BREAKING: remove `datasources.<name>.catalog`, use `datasources.<name>.presto.catalog` or `datasources.<name>.trino.catalog`
- add all missing environment variables from the Cube documentation (API, compiler, Tesseract, refresh, SQL API, DAX/MDX, drivers, export bucket)
- add ksqlDB, MySQL, MSSQL, Pinot and Redshift datasource parameters
- add `datasources.<name>.preAggregations` to configure a dedicated pre-aggregations connection (`CUBEJS_PRE_AGGREGATIONS_*`)
- add `datasources.<name>.hostFromSecret`, `datasources.<name>.userFromSecret` and `config.sqlSuperUser`
- add `startupProbe` / `customStartupProbe` support for api and worker
- fix `false` values being ignored for `dropPreAggWithoutTouch`, `fetchColumnsByOrdinalPosition`, `snowFlake.clientSessionKeepAlive` and `duckdb.s3.useSSL`
- fix `snowFlake.privateKeyPass`, `clickhouse.readonly` and `duckdb.s3.urlStyle` not being applied
- fix `CUBEJS_DB_QUERY_DEFAULT_LIMIT` being gated on `config.queryLimit`

## 3.2.0

- add scheduledRefreshQueriesPerAppId to replace scheduledRefreshConcurrency

## 3.0.1

- add sidecar support

## 3.0.0

- update to cube 1.2.0

## 2.3.1

- update to cube 0.35.76
- fix CUBEJS_DB_TYPE for presto

## 2.3.0

- update to cube 0.35.67
- add materialize config
- add duckdb config
- remove old mysql sql api

## 2.2.0

- update to cube 0.34.56
- add aws accessKeyID from secret

## 2.1.0

- update to cube 0.34.23
- add support for init containers

## 2.0.2

- update to cube 0.33.48
- run containers as non root

## 2.0.1

- fix databrics database type

## 2.0.0

- remove logic to detect redis as default cacheAndQueueDriver
- add metrics environment variables
- add `config.touchPreAggTimeout`and `config.dropPreAggWithoutTouch`
- fix spreadConstraints condition on router

Breaking changes:

- rename `workers.*` config to `worker.*`

## 1.4.0

- Update to cube 0.32.14
- add `config.concurrency`

## 1.3.1

- Fix chart version

## 1.3.0

- Update to cube 0.32.7

## 1.2.0

- Upgrade to cube 0.31.58
- add ability to extend envVars

## 1.1.2

- Fix add missing `cubestore` env vars

## 1.1.1

- Fix `athena` env var generation when used in multiple datasource context
- Add safe checks to only generate current database related env var

## 1.1.0

- Upgrade to cube 0.31.55
- Rename `aws` database config to `athena`

## 1.0.0

- Add multiple datasources support.
- Upgrade to cube 0.31.47

Breaking changes:

- move `database` to `datasources.default`
- move `exportsBucket` to `datasources.<name>.export`
- rename `jwt.url` to `jwt.jwkUrl`
