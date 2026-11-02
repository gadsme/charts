# Cube Chart

## Table of Contents

- [Get Started](#get-started)
  - [Install Chart](#install-chart)
  - [Uninstall Chart](#uninstall-chart)
  - [Upgrading Chart](#upgrading-chart)
- [Configuration](#configuration)
  - [Injecting schema](#injecting-schema)
  - [Injecting javascript config](#injecting-javascript-config)
  - [Fix duplicate schemas issue](#fix-duplicate-schemas-issue)
  - [Examples](#examples)
- [Reference](#reference)
  - [Global parameters](#global-parameters)
  - [Image parameters](#image-parameters)
  - [Config parameters](#config-parameters)
  - [JWT parameters](#jwt-parameters)
  - [Datasources configuration](#datasources-configuration)
    - [Common parameters](#common-datasource-parameters)
    - [Athena parameters](#athena-datasource-parameters)
    - [Bigquery parameters](#bigquery-datasource-parameters)
    - [Databricks parameters](#databricks-datasource-parameters)
    - [DuckDB parameters](#duckdb-datasource-parameters)
    - [ClickHouse parameters](#clickhouse-datasource-parameters)
    - [Firebolt parameters](#firebolt-datasource-parameters)
    - [Hive parameters](#hive-datasource-parameters)
    - [Materialize parameters](#materialize-datasource-parameters)
    - [Presto parameters](#presto-datasource-parameters)
    - [Snowflake parameters](#snowflake-datasource-parameters)
    - [Trino parameters](#trino-datasource-parameters)
    - [ksqlDB parameters](#ksqldb-datasource-parameters)
    - [MSSQL parameters](#mssql-datasource-parameters)
    - [MySQL parameters](#mysql-datasource-parameters)
    - [Pinot parameters](#pinot-datasource-parameters)
    - [Redshift parameters](#redshift-datasource-parameters)
  - [Api instance parameters](#api-instance-parameters)
  - [Refresh worker parameters](#worker-parameters)
  - [Ingress parameters](#ingress-parameters)

## Get Started

```console
helm repo add gadsme https://gadsme.github.io/charts
helm repo update
```

_See [`helm repo`](https://helm.sh/docs/helm/helm_repo/) for command documentation._

### Install Chart

```console
helm install [RELEASE_NAME] gadsme/cube --set [CONFIGURATION]
```

The command deploys Cube on the Kubernetes cluster using the default configuration.

_See [configuration](#configuration) below._

_See [`helm install`](https://helm.sh/docs/helm/helm_install/) for command documentation._

### Uninstall Chart

```console
helm uninstall [RELEASE_NAME]
```

This removes all the Kubernetes components associated with the chart and deletes the release.

_See [`helm uninstall`](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

### Upgrading Chart

```console
helm upgrade [RELEASE_NAME] gadsme/cube --install
```

## Configuration

By default an api instance and one worker will be deployed. You can customize the deployment using helm values.

Refer to the official documentation for more information:
https://cube.dev/docs/reference/environment-variables

### Injecting schema

To inject your schema files in the deployment you have to use `config.volumes` and `config.volumeMounts` values.

Mount path is `/cube/conf/schema` by default and can be customized with the `config.schemaPath` value.

A good practice is to use a ConfigMap to store your all the cube definition files:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: cube-schema
data:
  Cube1.js: |
    cube(`Cube1`, {
      sql: `SELECT * FROM cube1_data`,

      measures: {
        count: {
          type: `count`,
        },
      },
    });
  Cube2.js: |
    cube(`Cube2`, {
      sql: `SELECT * FROM cube2_data`,

      measures: {
        count: {
          type: `count`,
        },
      },
    });
```

or using a template:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: cube-schema
data:
{{ (.Files.Glob "schema/**.js").AsConfig | indent 2 }}
```

### Injecting javascript config

To inject a javascript config in the deployment you can use `config.volumes` and `config.volumeMounts` values.

Mount path is `/cube/conf/`

### Fix duplicate schemas issue

When you mount a secret or configmap as volume, the path at which Kubernetes will mount it will contain the root level items symlinking the same names into a `..data` directory, which is symlink to real mountpoint.

As cube will recursively browse the schema folder, it will found duplicate schemas.

To fix this issue you can mount each schema files using a `subPath` or change the default behavior using your own `repositoryFactory`:

```javascript
const path = require("path");
const fs = require("fs");

module.exports = {
  repositoryFactory: () => ({
    dataSchemaFiles: async () => {
      const files = await fs.promises.readdir(
        path.join(process.cwd(), "schema")
      );
      return await Promise.all(
        files
          .filter((file) => file.endsWith(".js") || file.endsWith(".yaml"))
          .map(async (file) => ({
            fileName: file,
            content: await fs.promises.readFile(
              path.join(process.cwd(), "schema", file),
              "utf-8"
            ),
          }))
      );
    },
  }),
};
```

### Examples

Deployment with:

- BigQuery db with export Bucket on GCS
- Schema located in a `cube-schema` ConfigMap
- Cubestore

```bash
$ helm install my-release -f values.yaml gadsme/cube
```

```yaml
# values.yaml
config:
  volumes:
    - name: schema
      configMap:
        name: cube-schema
  volumeMounts:
    - name: schema
      readOnly: true
      mountPath: /cube/conf/schema

datasources:
  default:
    type: bigquery
    export:
      type: gcp
      name: <bucket-name>
      gcsCredentialsFromSecret:
    name: <service-account-secret-name>
    key: <service-account-secret-key>
    bigquery:
      projectId: <project-id>
      credentialsFromSecret:
        name: <service-account-secret-name>
        key: <service-account-secret-key>

cubestore:
  host: <cubestore-host>
```

Multiple datasources sample:

```yaml
# values.yaml
config:
  volumes:
    - name: schema
      configMap:
        name: cube-schema
  volumeMounts:
    - name: schema
      readOnly: true
      mountPath: /cube/conf/schema

datasources:
  default:
    type: bigquery
    export:
      type: gcp
      name: <bucket-name>
      gcsCredentialsFromSecret:
    name: <service-account-secret-name>
    key: <service-account-secret-key>
    bigquery:
      projectId: <project-id>
      credentialsFromSecret:
        name: <service-account-secret-name>
        key: <service-account-secret-key>
  postgres:
    type: postgres
    host: <postgres-host>
    name: <postgres-database>
    user: <postgres-user>
    passFromSecret:
      name: <postgres-password-secret-name>
      key: <postgres-password-secret-key>

cubestore:
  host: <cubestore-host>
```

## Reference

### Global parameters

| Name                        | Description                                                                              | Value |
| --------------------------- | ---------------------------------------------------------------------------------------- | ----- |
| `nameOverride`              | Override the name                                                                        | `""`  |
| `fullnameOverride`          | Provide a name to substitute for the full names of resources                             | `""`  |
| `commonLabels`              | Labels to add to all deployed objects                                                    | `{}`  |
| `commonAnnotations`         | Annotations to add to all deployed objects                                               | `{}`  |
| `extraEnvVars`              | Extra environment variables to pass on to all pods. The value is evaluated as a template | `[]`  |
| `extraEnvVarsFromConfigMap` | Name of a Config Map containing extra environment variables to pass on to all pods       |       |
| `extraEnvVarsFromSecret`    | Name of a Secret containing extra environment variables to pass on to all pods           |       |

### Image parameters

| Name                | Description                                                                             | Value          |
| ------------------- | --------------------------------------------------------------------------------------- | -------------- |
| `image.repository`  | Cube image repository                                                                   | `cubejs/cube`  |
| `image.tag`         | Cube image tag (immutable tags are recommended)                                         | `1.2.0`        |
| `image.pullPolicy`  | Cube image pull policy                                                                  | `IfNotPresent` |
| `image.pullSecrets` | If defined, uses a Secret to pull an image from a private Docker registry or repository | `[]`           |

### Config parameters

| Name                                                       | Description                                                                                                                                  | Value   |
| ---------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `config.apiPort`                                           | The port for a Cube deployment to listen to API connections on                                                                               | `4000`  |
| `config.pgSqlPort`                                         | The port to listen to Postgres-compatible connections on                                                                                     |         |
| `config.sqlSuperUser`                                      | The superuser name to access the SQL api                                                                                                     |         |
| `config.sqlUser`                                           | The username to access the SQL api                                                                                                           |         |
| `config.sqlPassword`                                       | The password to access the SQL api                                                                                                           |         |
| `config.sqlPasswordFromSecret.name`                        | The password to access the SQL api (using secret)                                                                                            |         |
| `config.sqlPasswordFromSecret.key`                         | The password to access the SQL api (using secret)                                                                                            |         |
| `config.devMode`                                           | If true, enables development mode                                                                                                            | `false` |
| `config.debug`                                             | If true, enables debug logging                                                                                                               | `false` |
| `config.logLevel`                                          | The logging level for Cube                                                                                                                   | `warn`  |
| `config.telemetry`                                         | If true, then send telemetry to Cube                                                                                                         | `false` |
| `config.apiSecret`                                         | The secret key used to sign and verify JWTs. Generated on project scaffold                                                                   |         |
| `config.apiSecretFromSecret.name`                          | The secret key used to sign and verify JWTs. Generated on project scaffold (using secret)                                                    |         |
| `config.apiSecretFromSecret.key`                           | The secret key used to sign and verify JWTs. Generated on project scaffold (using secret)                                                    |         |
| `config.defaultApiScopes`                                  | API scopes used to allow or disallow access to REST API endpoints.                                                                           |         |
| `config.Values.config.playgroundAuthSecret`                | The secret key used to enable system APIs                                                                                                    |         |
| `config.Values.config.playgroundAuthSecretFromSecret.name` | The secret key used to enable system APIs (using secret)                                                                                     |         |
| `config.Values.config.playgroundAuthSecretFromSecret.key`  | The secret key used to enable system APIs (using secret)                                                                                     |         |
| `config.schemaPath`                                        | The path where Cube loads schemas from. Defaults to schema                                                                                   |         |
| `config.app`                                               | An application ID used to uniquely identify the Cube deployment. Can be different for multitenant setups. Defaults to cubejs                 |         |
| `config.rollupOnly`                                        | If true, this instance of Cube will only query rollup pre-aggregations. Defaults to false                                                    |         |
| `config.scheduledRefreshTimezones`                         | A comma-separated list of timezones to schedule refreshes for                                                                                |         |
| `config.scheduledRefreshQueriesPerAppId`                   | How many queries will be run concurrently per app (tenant)                                                                                   |         |
| `config.webSockets`                                        | If true, then use WebSocket for data fetching. Defaults to false                                                                             |         |
| `config.preAggregationsSchema`                             | The schema name to use for storing pre-aggregations true                                                                                     |         |
| `config.cacheAndQueueDriver`                               | The cache and queue driver to use for the Cube deployment. Defaults to cubestore                                                             |         |
| `config.concurrency`                                       | The number of concurrent connections each query queue has to the database                                                                    |         |
| `config.queryDefaultLimit`                                 | The default row limit in the result set if it's not explicitly specified in an API query.                                                    |         |
| `config.queryLimit`                                        | The maximum row limit in the result set                                                                                                      |         |
| `config.touchPreAggTimeout`                                | The number of seconds without a touch before pre-aggregation is considered orphaned and marked for removal                                   |         |
| `config.dropPreAggWithoutTouch`                            | If true, it enables dropping pre-aggregations that Refresh Worker doesn't touch within touchPreAggTimeout                                    |         |
| `config.apiSecrets`                                        | A comma-separated list of secret keys accepted when verifying JWTs, used to rotate apiSecret. Takes precedence over apiSecret                |         |
| `config.apiSecretsFromSecret.name`                         | A comma-separated list of secret keys accepted when verifying JWTs, used to rotate apiSecret. Takes precedence over apiSecret (using secret) |         |
| `config.apiSecretsFromSecret.key`                          | A comma-separated list of secret keys accepted when verifying JWTs, used to rotate apiSecret. Takes precedence over apiSecret (using secret) |         |
| `config.maxRequestSize`                                    | The maximum allowed size for incoming requests, between 100kb and 64mb. Defaults to 50mb                                                     |         |
| `config.serverHeadersTimeout`                              | The number of milliseconds the server waits to receive the complete HTTP headers. Defaults to the Node.js default                            |         |
| `config.serverKeepAliveTimeout`                            | The number of milliseconds of inactivity the server waits for more data before closing a socket. Defaults to the Node.js default             |         |
| `config.defaultTimezone`                                   | The default time zone for queries. Defaults to UTC                                                                                           |         |
| `config.autoRunMode`                                       | If false, Explore and Workbooks wait for an explicit Run query instead of running queries automatically. Defaults to true                    |         |
| `config.logRedaction`                                      | If true, values in SQL API statements are replaced with `redacted` in logs. Defaults to true in production                                   |         |
| `config.allowUngroupedWithoutPrimaryKey`                   | If true, disables the primary key inclusion check for ungrouped queries. Defaults to false                                                   |         |
| `config.nestedFoldersDelimiter`                            | The delimiter used to flatten nested folder names in views for tools that do not support nested folders                                      |         |
| `config.nodeExtraCaCerts`                                  | A path to a PEM file with extra CA certificates for Node.js to trust (mount it with config.volumes)                                          |         |
| `config.compilerCacheSize`                                 | The maximum number of compiled data models to keep in the compiler cache. Defaults to 250                                                    |         |
| `config.compilerMultiTenantSharing`                        | If true, data models of different tenants in one process share compiled files and caches. Defaults to false                                  |         |
| `config.maxCompiledMembers`                                | The maximum number of compiled members to keep in the compiler cache. No limit by default                                                    |         |
| `config.maxMemberResolutionDepth`                          | The maximum depth of a chain of members referencing other members (Tesseract only). Defaults to 160                                          |         |
| `config.maxMultiStageDepth`                                | The maximum number of multi-stage members one query may chain (Tesseract only). Defaults to 150                                              |         |
| `config.maxMultiStageStages`                               | The maximum number of multi-stage stages one query may plan in total (Tesseract only). Defaults to 1000                                      |         |
| `config.maxPartitionsPerCube`                              | The maximum number of partitions each pre-aggregation in a cube can use. Defaults to 10000                                                   |         |
| `config.maxSourceRowLimit`                                 | The maximum number of source rows read for a rollup_lambda pre-aggregation with union_with_source_data. Defaults to 200000                   |         |
| `config.tesseractSqlPlanner`                               | If true, enables Tesseract, the next-generation SQL planner. Enabled by default since Cube v1.7.0                                            |         |
| `config.tesseractCubestoreUnionFullKeyAggregate`           | If true, Tesseract combines multi-stage subqueries with UNION ALL and GROUP BY for Cube Store queries. Defaults to true                      |         |
| `config.tesseractTrinoUnionFullKeyAggregate`               | Same as tesseractCubestoreUnionFullKeyAggregate, for Trino data sources. Defaults to true                                                    |         |
| `config.refreshWorkerConcurrency`                          | The number of pre-aggregation queries the refresh worker executes concurrently. Defaults to concurrency                                      |         |
| `config.scheduledRefreshTimerIntervalOnly`                 | If true, a numeric scheduled_refresh_timer only sets the refresh worker heartbeat interval. Defaults to false                                |         |
| `config.refreshKeyLocalTime`                               | If true, every-based refresh keys use Cube's own clock instead of querying the database. Defaults to false                                   |         |
| `config.queueFastTrack`                                    | If true, enables the experimental fast-track path for Cube Store query queues. Defaults to false                                             |         |
| `config.preAggregationsBuilder`                            | If true, this instance builds pre-aggregations even if it is an API instance. Defaults to false in production                                |         |
| `config.preAggregationsBackoffMaxTime`                     | The maximum time, in seconds, of the exponential backoff between failed pre-aggregation builds. Defaults to 600                              |         |
| `config.preAggregationsAllowNonStrictDateRangeMatch`       | If true, allows non-strict date range matching for pre-aggregations by default. Defaults to true                                             |         |
| `config.sqlIncludeTraceId`                                 | If true, attaches a trace_id SQL comment with the API request ID to queries sent to data sources. Defaults to false                          |         |
| `config.maxSessions`                                       | The maximum number of concurrent SQL API sessions. Defaults to 1024                                                                          |         |
| `config.sqlPushDown`                                       | If true, enables query pushdown in the SQL API. Defaults to true                                                                             |         |
| `config.sqlPushDownPreAggregations`                        | If true, queries pushed down by the SQL API can be served from pre-aggregations. Defaults to true                                            |         |
| `config.sqlStreamMode`                                     | If true, enables the streaming mode in the SQL API. Defaults to false                                                                        |         |
| `config.sqlFailOnLimitlessPostProcessing`                  | If true, the SQL API rejects queries needing post-processing over a Cube query without a LIMIT. Defaults to false                            |         |
| `config.sqlCubeScanMaxBatchRows`                           | The maximum number of rows in one record batch when the SQL API reads data from a cube. Defaults to 65536                                    |         |
| `config.sqlNonStreamingQueryMaxRowLimit`                   | The maximum row limit for SQL API queries that are not streamed. Defaults to queryLimit                                                      |         |
| `config.sqlNoImplicitOrder`                                | If true, prevents adding an implicit default ORDER BY to SQL API queries. Defaults to true                                                   |         |
| `config.sqlRewriteMaxNodes`                                | The maximum number of e-graph nodes allocated while planning a SQL API query. Defaults to 10000                                              |         |
| `config.sqlRewriteMaxIterations`                           | The maximum number of e-graph rewriting iterations while planning a SQL API query. Defaults to 300                                           |         |
| `config.sqlRewriteTimeout`                                 | The maximum time, in seconds, to plan a SQL API query. Defaults to 30                                                                        |         |
| `config.sqlAuthExpireSecs`                                 | The number of seconds before a SQL API session security context is invalidated. Defaults to 300                                              |         |
| `config.daxCreateDateHierarchies`                          | If true, the DAX API exposes time dimensions as calendar hierarchies. Defaults to true                                                       |         |
| `config.daxShareVars`                                      | If true, the DAX API evaluates a SUMMARIZECOLUMNS variable once per request. Defaults to false                                               |         |
| `config.daxSinglePerspective`                              | If true, the DAX API exposes all views as a single perspective, enabling cross-view filtering. Defaults to false                             |         |
| `config.mdxCreateDateHierarchies`                          | If true, the MDX API creates calendar hierarchies for all time dimensions. Defaults to true                                                  |         |
| `config.xmlaLanguage`                                      | The locale for the MDX API, as an LCID or a language tag. Defaults to 1033 (English - United States)                                         |         |
| `config.volumes`                                           | The config volumes. Will be used to both api and worker                                                                                      | `[]`    |
| `config.volumeMounts`                                      | The config volumeMounts. Will be used to both api and worker                                                                                 | `[]`    |
| `config.initContainers`                                    | Add init containers to load models using volume mounts ( an alternative to using configs, example in values)                                 | `[]`    |
| `config.sidecarContainers`                                 | Add sidecar containers to load models using volume mounts ( an alternative to using configs, example in values)                              | `[]`    |

### JWT parameters

| Name                      | Description                                                                               | Value |
| ------------------------- | ----------------------------------------------------------------------------------------- | ----- |
| `jwt.jwkUrl`              | A valid URL to a JSON Web Key Sets (JWKS)                                                 |       |
| `jwt.key`                 | The secret key used to sign and verify JWTs. Generated on project scaffold                |       |
| `jwt.keyFromSecret.name`  | The secret key used to sign and verify JWTs. Generated on project scaffold (using secret) |       |
| `jwt.keyFromSecret.value` | The secret key used to sign and verify JWTs. Generated on project scaffold (using secret) |       |
| `jwt.audience`            | An audience value which will be used to enforce the aud claim from inbound JWTs           |       |
| `jwt.issuer`              | An issuer value which will be used to enforce the iss claim from inbound JWTs             |       |
| `jwt.subject`             | A subject value which will be used to enforce the sub claim from inbound JWTs             |       |
| `jwt.algs`                | Any supported algorithm for decoding JWTs                                                 |       |
| `jwt.claimsNamespace`     | A namespace within the decoded JWT under which any custom claims can be found             |       |

### Datasources configuration

| Name          | Description                                                              | Value          |
| ------------- | ------------------------------------------------------------------------ | -------------- |
| `datasources` | map of named datasources. The first datasource has to be named "default" | { default: {}} |

### Common datasource parameters

| Name                                                          | Description                                                                                                                                                                                                                                                                                                                                              | Value   |
| ------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| `datasources.<name>.type`                                     | A database type supported by Cube.js                                                                                                                                                                                                                                                                                                                     |         |
| `datasources.<name>.url`                                      | The URL for a database                                                                                                                                                                                                                                                                                                                                   |         |
| `datasources.<name>.host`                                     | The host URL for a database                                                                                                                                                                                                                                                                                                                              |         |
| `datasources.<name>.hostFromSecret.name`                      | The host URL for a database (using secret)                                                                                                                                                                                                                                                                                                               |         |
| `datasources.<name>.hostFromSecret.key`                       | The host URL for a database (using secret)                                                                                                                                                                                                                                                                                                               |         |
| `datasources.<name>.port`                                     | The port for the database connection                                                                                                                                                                                                                                                                                                                     |         |
| `datasources.<name>.schema`                                   | The schema within the database to connect to                                                                                                                                                                                                                                                                                                             |         |
| `datasources.<name>.name`                                     | The name of the database to connect to                                                                                                                                                                                                                                                                                                                   |         |
| `datasources.<name>.user`                                     | The username used to connect to the database                                                                                                                                                                                                                                                                                                             |         |
| `datasources.<name>.userFromSecret.name`                      | The username used to connect to the database (using secret)                                                                                                                                                                                                                                                                                              |         |
| `datasources.<name>.userFromSecret.key`                       | The username used to connect to the database (using secret)                                                                                                                                                                                                                                                                                              |         |
| `datasources.<name>.pass`                                     | The password used to connect to the database                                                                                                                                                                                                                                                                                                             |         |
| `datasources.<name>.passFromSecret.name`                      | The password used to connect to the database (using secret)                                                                                                                                                                                                                                                                                              |         |
| `datasources.<name>.passFromSecret.key`                       | The password used to connect to the database (using secret)                                                                                                                                                                                                                                                                                              |         |
| `datasources.<name>.domain`                                   | A domain name within the database to connect to                                                                                                                                                                                                                                                                                                          |         |
| `datasources.<name>.socketPath`                               | The path to a Unix socket for a MySQL database                                                                                                                                                                                                                                                                                                           |         |
| `datasources.<name>.maxPool`                                  | The maximum number of connections to keep active in the database connection pool                                                                                                                                                                                                                                                                         |         |
| `datasources.<name>.queryTimeout`                             | The timeout value for any queries made to the database by Cube                                                                                                                                                                                                                                                                                           |         |
| `datasources.<name>.fetchColumnsByOrdinalPosition`            | Force fetching of columns by ordinal positions. Certain data-providers (e.g., Redshift) do not guarantee columns in the same order on each request (e.g., SELECT * FROM foo). This flag ensures that columns will be fetched in proper order for pre-aggregation generation.                                                                             |         |
| `datasources.<name>.preciseDecimalInCubestore`                | If true, decimal columns keep their precision and scale when exported to Cube Store. Defaults to false                                                                                                                                                                                                                                                   |         |
| `datasources.<name>.export.name`                              | The name of a bucket in cloud storage                                                                                                                                                                                                                                                                                                                    |         |
| `datasources.<name>.export.type`                              | The cloud provider where the bucket is hosted (gcs, s3)                                                                                                                                                                                                                                                                                                  |         |
| `datasources.<name>.export.gcs.credentials`                   | Base64 encoded JSON key file for connecting to Google Cloud                                                                                                                                                                                                                                                                                              |         |
| `datasources.<name>.export.gcs.credentialsFromSecret.name`    | Base64 encoded JSON key file for connecting to Google Cloud (using secret)                                                                                                                                                                                                                                                                               |         |
| `datasources.<name>.export.gcs.credentialsFromSecret.key`     | Base64 encoded JSON key file for connecting to Google Cloud (using secret)                                                                                                                                                                                                                                                                               |         |
| `datasources.<name>.export.aws.key`                           | The AWS Access Key ID to use for the export bucket                                                                                                                                                                                                                                                                                                       |         |
| `datasources.<name>.export.aws.secret`                        | The AWS Secret Access Key to use for the export bucket                                                                                                                                                                                                                                                                                                   |         |
| `datasources.<name>.export.aws.secretFromSecret.name`         | The AWS Secret Access Key to use for the export bucket (using secret)                                                                                                                                                                                                                                                                                    |         |
| `datasources.<name>.export.aws.secretFromSecret.key`          | The AWS Secret Access Key to use for the export bucket (using secret)                                                                                                                                                                                                                                                                                    |         |
| `datasources.<name>.export.aws.region`                        | The AWS region of the export bucket                                                                                                                                                                                                                                                                                                                      |         |
| `datasources.<name>.export.redshift.arn`                      | An ARN of an AWS IAM role with permission to write to the configured bucket (see export.name)                                                                                                                                                                                                                                                            |         |
| `datasources.<name>.export.mountDir`                          | The mount path to use for a Databricks DBFS mount                                                                                                                                                                                                                                                                                                        |         |
| `datasources.<name>.export.azure.key`                         | The Azure Access Key to use for the export bucket                                                                                                                                                                                                                                                                                                        |         |
| `datasources.<name>.export.azure.keyFromSecret.name`          | The Azure Access Key to use for the export bucket (using secret)                                                                                                                                                                                                                                                                                         |         |
| `datasources.<name>.export.azure.keyFromSecret.key`           | The Azure Access Key to use for the export bucket (using secret)                                                                                                                                                                                                                                                                                         |         |
| `datasources.<name>.export.azure.tenantId`                    | The Azure tenant ID to use for the export bucket                                                                                                                                                                                                                                                                                                         |         |
| `datasources.<name>.export.azure.clientId`                    | The Azure client ID to use for the export bucket                                                                                                                                                                                                                                                                                                         |         |
| `datasources.<name>.export.azure.clientSecret`                | The Azure client secret to use for the export bucket                                                                                                                                                                                                                                                                                                     |         |
| `datasources.<name>.export.azure.clientSecretFromSecret.name` | The Azure client secret to use for the export bucket (using secret)                                                                                                                                                                                                                                                                                      |         |
| `datasources.<name>.export.azure.clientSecretFromSecret.key`  | The Azure client secret to use for the export bucket (using secret)                                                                                                                                                                                                                                                                                      |         |
| `datasources.<name>.ssl.enabled`                              | If true, enables SSL encryption for database connections from Cube.js                                                                                                                                                                                                                                                                                    | `false` |
| `datasources.<name>.ssl.rejectUnAuthorized`                   | If true, verifies the CA chain with the system's built-in CA chain                                                                                                                                                                                                                                                                                       |         |
| `datasources.<name>.ssl.ca`                                   | The contents of a CA bundle in PEM format, or a path to one                                                                                                                                                                                                                                                                                              |         |
| `datasources.<name>.ssl.cert`                                 | The contents of an SSL certificate in PEM format, or a path to one                                                                                                                                                                                                                                                                                       |         |
| `datasources.<name>.ssl.key`                                  | The contents of a private key in PEM format, or a path to one                                                                                                                                                                                                                                                                                            |         |
| `datasources.<name>.ssl.ciphers`                              | The ciphers used by the SSL certificate                                                                                                                                                                                                                                                                                                                  |         |
| `datasources.<name>.ssl.serverName`                           | The server name for the SNI TLS extension                                                                                                                                                                                                                                                                                                                |         |
| `datasources.<name>.ssl.passPhrase`                           | he passphrase used to encrypt the SSL private key                                                                                                                                                                                                                                                                                                        |         |
| `datasources.<name>.preAggregations`                          | A dedicated connection used to build and store this data source's pre-aggregations (CUBEJS_PRE_AGGREGATIONS_*). Accepts the same keys as the data source itself. Configure it in full: only type is inherited, unset keys fall back to driver defaults. ssl.ca/cert/key/ciphers/serverName/passPhrase are not supported, Cube uses the main connection's |         |

### Athena datasource parameters

| Name                                              | Description                                                                        | Value |
| ------------------------------------------------- | ---------------------------------------------------------------------------------- | ----- |
| `datasources.<name>.athena.key`                   | The AWS Access Key ID to use for database connections                              |       |
| `datasources.<name>.athena.keyFromSecret.name`    | The AWS Access Key ID to use for database connections (using secret)               |       |
| `datasources.<name>.athena.keyFromSecret.key`     | The AWS Access Key ID to use for database connections (using secret)               |       |
| `datasources.<name>.athena.region`                | The AWS region of the Cube.js deployment                                           |       |
| `datasources.<name>.athena.s3OutputLocation`      | The S3 path to store query results made by the Cube.js deployment                  |       |
| `datasources.<name>.athena.secret`                | The AWS Secret Access Key to use for database connections                          |       |
| `datasources.<name>.athena.secretFromSecret.name` | The AWS Secret Access Key to use for database connections (using secret)           |       |
| `datasources.<name>.athena.secretFromSecret.key`  | The AWS Secret Access Key to use for database connections (using secret)           |       |
| `datasources.<name>.athena.workgroup`             | The name of the workgroup in which the query is being started                      |       |
| `datasources.<name>.athena.catalog`               | The name of the catalog to use by default                                          |       |
| `datasources.<name>.athena.assumeRoleArn`         | The ARN of the IAM role to assume for Athena access                                |       |
| `datasources.<name>.athena.assumeRoleExternalId`  | The external ID to use when assuming the IAM role, if required by its trust policy |       |

### Bigquery datasource parameters

| Name                                                     | Description                                                                     | Value |
| -------------------------------------------------------- | ------------------------------------------------------------------------------- | ----- |
| `datasources.<name>.bigquery.projectId`                  | The Google BigQuery project ID to connect to                                    |       |
| `datasources.<name>.bigquery.location`                   | The Google BigQuery dataset location to connect to                              |       |
| `datasources.<name>.bigquery.credentials`                | A Base64 encoded JSON key file for connecting to Google BigQuery                |       |
| `datasources.<name>.bigquery.credentialsFromSecret.name` | A Base64 encoded JSON key file for connecting to Google BigQuery (using secret) |       |
| `datasources.<name>.bigquery.credentialsFromSecret.key`  | A Base64 encoded JSON key file for connecting to Google BigQuery (using secret) |       |
| `datasources.<name>.bigquery.keyFile`                    | The path to a JSON key file for connecting to Google BigQuery                   |       |

### Databricks datasource parameters

| Name                                                             | Description                                                                 | Value |
| ---------------------------------------------------------------- | --------------------------------------------------------------------------- | ----- |
| `datasources.<name>.databricks.url`                              | The URL for a JDBC connection                                               |       |
| `datasources.<name>.databricks.acceptPolicy`                     | Whether or not to accept the license terms for the Databricks JDBC driver   |       |
| `datasources.<name>.databricks.token`                            | The personal access token used to authenticate the Databricks connection    |       |
| `datasources.<name>.databricks.catalog`                          | Databricks catalog name                                                     |       |
| `datasources.<name>.databricks.oauthClientId`                    | The OAuth client ID for service principal authentication                    |       |
| `datasources.<name>.databricks.oauthClientSecret`                | The OAuth client secret for service principal authentication                |       |
| `datasources.<name>.databricks.oauthClientSecretFromSecret.name` | The OAuth client secret for service principal authentication (using secret) |       |
| `datasources.<name>.databricks.oauthClientSecretFromSecret.key`  | The OAuth client secret for service principal authentication (using secret) |       |

### DuckDB datasource parameters

| Name                                                          | Description                                                                                                         | Value             |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ----------------- |
| `datasources.<name>.duckdb.memoryLimit`                       | The maximum memory limit for DuckDB. Equivalent to SET memory_limit=<MEMORY_LIMIT>. Default is 75% of available RAM |                   |
| `datasources.<name>.duckdb.schema`                            | The default search schema                                                                                           |                   |
| `datasources.<name>.duckdb.motherduckToken`                   | The service token to use for connections to MotherDuck                                                              |                   |
| `datasources.<name>.duckdb.databasePath`                      | The database filepath to use for connection to a local database.                                                    |                   |
| `datasources.<name>.duckdb.extensions`                        | A comma-separated list of DuckDB extensions to install and load                                                     |                   |
| `datasources.<name>.duckdb.communityExtensions`               | A comma-separated list of DuckDB community extensions to install and load                                           |                   |
| `datasources.<name>.duckdb.s3.accessKeyId`                    | The Access Key ID to use for database connections                                                                   |                   |
| `datasources.<name>.duckdb.s3.secretAccessKey`                | The Secret Access Key to use for database connections                                                               |                   |
| `datasources.<name>.duckdb.s3.secretAccessKeyFromSecret.name` | The Secret Access Key to use for database connections (using secret)                                                |                   |
| `datasources.<name>.duckdb.s3.secretAccessKeyFromSecret.key`  | The Secret Access Key to use for database connections (using secret)                                                |                   |
| `datasources.<name>.duckdb.s3.endpoint`                       | The S3 endpoint                                                                                                     |                   |
| `datasources.<name>.duckdb.s3.region`                         | The region of the bucket                                                                                            |                   |
| `datasources.<name>.duckdb.s3.useSSL`                         | Use SSL for connection                                                                                              |                   |
| `datasources.<name>.duckdb.s3.urlStyle`                       | To choose the S3 URL style(vhost or path)                                                                           | `vhost` \| `path` |
| `datasources.<name>.duckdb.s3.sessionToken`                   | The token for the S3 session                                                                                        |                   |
| `datasources.<name>.duckdb.s3.useCredentialChain`             | If true, uses the credentials chain for S3 secrets. Defaults to false                                               |                   |

### Clickhouse datasource parameters

| Name                                        | Description                                                  | Value |
| ------------------------------------------- | ------------------------------------------------------------ | ----- |
| `datasources.<name>.clickhouse.readonly`    | Whether the ClickHouse user has read-only access or not      |       |
| `datasources.<name>.clickhouse.compression` | Whether the ClickHouse client has compression enabled or not |       |

### Firebolt datasource parameters

| Name                                      | Description                                    | Value |
| ----------------------------------------- | ---------------------------------------------- | ----- |
| `datasources.<name>.firebolt.account`     | Account name                                   |       |
| `datasources.<name>.firebolt.engineName`  | Engine name to connect to                      |       |
| `datasources.<name>.firebolt.apiEndpoint` | Firebolt API endpoint. Used for authentication |       |

### Hive datasource parameters

| Name                                    | Description                                     | Value |
| --------------------------------------- | ----------------------------------------------- | ----- |
| `datasources.<name>.hive.cdhVersion`    | The version of the CDH instance for Apache Hive |       |
| `datasources.<name>.hive.thriftVersion` | The version of Thrift Server for Apache Hive    |       |
| `datasources.<name>.hive.type`          | The type of Apache Hive server                  |       |
| `datasources.<name>.hive.version`       | The version of Apache Hive                      |       |

### Materialize datasource parameters

| Name                                     | Description                                       | Value |
| ---------------------------------------- | ------------------------------------------------- | ----- |
| `datasources.<name>.materialize.cluster` | The name of the Materialize cluster to connect to |       |

### Presto datasource parameters

| Name                                                 | Description                                                              | Value |
| ---------------------------------------------------- | ------------------------------------------------------------------------ | ----- |
| `datasources.<name>.presto.catalog`                  | The catalog within Presto to connect to                                  |       |
| `datasources.<name>.presto.authToken`                | The authentication token sent in the Authorization header                |       |
| `datasources.<name>.presto.authTokenFromSecret.name` | The authentication token sent in the Authorization header (using secret) |       |
| `datasources.<name>.presto.authTokenFromSecret.key`  | The authentication token sent in the Authorization header (using secret) |       |

### Snowflake datasource parameters

| Name                                                       | Description                                                              | Value |
| ---------------------------------------------------------- | ------------------------------------------------------------------------ | ----- |
| `datasources.<name>.snowFlake.account`                     | The Snowflake account ID to use when connecting to the database          |       |
| `datasources.<name>.snowFlake.region`                      | The Snowflake region to use when connecting to the database              |       |
| `datasources.<name>.snowFlake.role`                        | The Snowflake role to use when connecting to the database                |       |
| `datasources.<name>.snowFlake.warehouse`                   | The Snowflake warehouse to use when connecting to the database           |       |
| `datasources.<name>.snowFlake.clientSessionKeepAlive`      | If true, keep the Snowflake connection alive indefinitely                |       |
| `datasources.<name>.snowFlake.authenticator`               | The type of authenticator to use with Snowflake. Defaults to SNOWFLAKE   |       |
| `datasources.<name>.snowFlake.privateKeyPath`              | The path to the private RSA key folder                                   |       |
| `datasources.<name>.snowFlake.privateKeyPass`              | The password for the private RSA key. Only required for encrypted keys   |       |
| `datasources.<name>.snowFlake.host`                        | The host address the driver should connect to                            |       |
| `datasources.<name>.snowFlake.privateKey`                  | The content of the private RSA key (encrypted or not)                    |       |
| `datasources.<name>.snowFlake.privateKeyFromSecret.name`   | The content of the private RSA key (encrypted or not) (using secret)     |       |
| `datasources.<name>.snowFlake.privateKeyFromSecret.key`    | The content of the private RSA key (encrypted or not) (using secret)     |       |
| `datasources.<name>.snowFlake.oauthToken`                  | The OAuth token to use with Snowflake                                    |       |
| `datasources.<name>.snowFlake.oauthTokenFromSecret.name`   | The OAuth token to use with Snowflake (using secret)                     |       |
| `datasources.<name>.snowFlake.oauthTokenFromSecret.key`    | The OAuth token to use with Snowflake (using secret)                     |       |
| `datasources.<name>.snowFlake.oauthTokenPath`              | The path to the file containing the OAuth token                          |       |
| `datasources.<name>.snowFlake.quotedIdentifiersIgnoreCase` | Whether quoted identifiers should be case insensitive. Defaults to false |       |

### Trino datasource parameters

| Name                                                | Description                                                              | Value |
| --------------------------------------------------- | ------------------------------------------------------------------------ | ----- |
| `datasources.<name>.trino.catalog`                  | The catalog within Trino to connect to                                   |       |
| `datasources.<name>.trino.authToken`                | The authentication token sent in the Authorization header                |       |
| `datasources.<name>.trino.authTokenFromSecret.name` | The authentication token sent in the Authorization header (using secret) |       |
| `datasources.<name>.trino.authTokenFromSecret.key`  | The authentication token sent in the Authorization header (using secret) |       |

### ksqlDB datasource parameters

| Name                                           | Description                                                              | Value |
|------------------------------------------------|--------------------------------------------------------------------------|-------|
| `datasources.<name>.kafka.host`                | Kafka broker host(s) for Kafka streams mode, comma-separated             |       |
| `datasources.<name>.kafka.user`                | The username for Kafka broker authentication (SASL PLAIN)                |       |
| `datasources.<name>.kafka.pass`                | The password for Kafka broker authentication (SASL PLAIN)                |       |
| `datasources.<name>.kafka.passFromSecret.name` | The password for Kafka broker authentication (SASL PLAIN) (using secret) |       |
| `datasources.<name>.kafka.passFromSecret.key`  | The password for Kafka broker authentication (SASL PLAIN) (using secret) |       |
| `datasources.<name>.kafka.useSsl`              | If true, enables SASL_SSL for the Kafka connection. Defaults to false    |       |

### MSSQL datasource parameters

| Name                                         | Description                                                                                      | Value |
|----------------------------------------------|--------------------------------------------------------------------------------------------------|-------|
| `datasources.<name>.mssql.useNamedTimezones` | If true, time zone names are used in generated SQL instead of numeric offsets. Defaults to false |       |

### MySQL datasource parameters

| Name                                         | Description                                                                                      | Value |
|----------------------------------------------|--------------------------------------------------------------------------------------------------|-------|
| `datasources.<name>.mysql.useNamedTimezones` | If true, time zone names are used in generated SQL instead of numeric offsets. Defaults to false |       |

### Pinot datasource parameters

| Name                                                | Description                                                                    | Value |
|-----------------------------------------------------|--------------------------------------------------------------------------------|-------|
| `datasources.<name>.pinot.authToken`                | The authentication token for StarTree, passed as an HTTP header                |       |
| `datasources.<name>.pinot.authTokenFromSecret.name` | The authentication token for StarTree, passed as an HTTP header (using secret) |       |
| `datasources.<name>.pinot.authTokenFromSecret.key`  | The authentication token for StarTree, passed as an HTTP header (using secret) |       |
| `datasources.<name>.pinot.nullHandling`             | If true, enables null value support. Defaults to false                         |       |

### Redshift datasource parameters

| Name                                               | Description                                                             | Value |
|----------------------------------------------------|-------------------------------------------------------------------------|-------|
| `datasources.<name>.redshift.clusterIdentifier`    | The Redshift cluster identifier. Required for IAM authentication        |       |
| `datasources.<name>.redshift.awsRegion`            | The AWS region of the Redshift cluster. Required for IAM authentication |       |
| `datasources.<name>.redshift.assumeRoleArn`        | The ARN of the IAM role to assume for cross-account access              |       |
| `datasources.<name>.redshift.assumeRoleExternalId` | The external ID for the assumed role's trust policy                     |       |

### Cubestore parameters

| Name                       | Description                                                                                                       | Value |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------- | ----- |
| `cubestore.host`           | The hostname of the Cube Store deployment                                                                         |       |
| `cubestore.port`           | The port of the Cube Store deployment                                                                             | 3030  |
| `cubestore.maxMessageSize` | The maximum size in bytes of a single message sent to or accepted from Cube Store. Defaults to 104857600 (100 MB) |       |

### Api instance parameters

| Name                                              | Description                                                                                                         | Value   |
| ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ------- |
| `api.serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                | `false` |
| `api.serviceAccount.name`                         | Name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`    |
| `api.serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                                      | `true`  |
| `api.serviceAccount.annotations`                  | Annotations for service account. Evaluated as a template. Only used if create is true.                              | `{}`    |
| `api.apiCount`                                    | Number of api instances to deploy                                                                                   | `1`     |
| `api.affinity`                                    | Affinity for pod assignment                                                                                         | `{}`    |
| `api.spreadConstraints`                           | Topology spread constraint for pod assignment                                                                       | `[]`    |
| `api.resources`                                   | Define resources requests and limits for single Pods                                                                | `{}`    |
| `api.livenessProbe.enabled`                       | Enable livenessProbe                                                                                                | `true`  |
| `api.livenessProbe.initialDelaySeconds`           | Initial delay seconds for livenessProbe                                                                             | `10`    |
| `api.livenessProbe.periodSeconds`                 | Period seconds for livenessProbe                                                                                    | `30`    |
| `api.livenessProbe.timeoutSeconds`                | Timeout seconds for livenessProbe                                                                                   | `3`     |
| `api.livenessProbe.successThreshold`              | Success threshold for livenessProbe                                                                                 | `1`     |
| `api.livenessProbe.failureThreshold`              | Failure threshold for livenessProbe                                                                                 | `3`     |
| `api.readinessProbe.enabled`                      | Enable readinessProbe                                                                                               | `true`  |
| `api.readinessProbe.initialDelaySeconds`          | Initial delay seconds for readinessProbe                                                                            | `10`    |
| `api.readinessProbe.periodSeconds`                | Period seconds for readinessProbe                                                                                   | `30`    |
| `api.readinessProbe.timeoutSeconds`               | Timeout seconds for readinessProbe                                                                                  | `3`     |
| `api.readinessProbe.successThreshold`             | Success threshold for readinessProbe                                                                                | `1`     |
| `api.readinessProbe.failureThreshold`             | Failure threshold for readinessProbe                                                                                | `3`     |
| `api.startupProbe.enabled`                        | Enable startupProbe                                                                                                 | `false` |
| `api.startupProbe.initialDelaySeconds`            | Initial delay seconds for startupProbe                                                                              | `10`    |
| `api.startupProbe.periodSeconds`                  | Period seconds for startupProbe                                                                                     | `30`    |
| `api.startupProbe.timeoutSeconds`                 | Timeout seconds for startupProbe                                                                                    | `3`     |
| `api.startupProbe.successThreshold`               | Success threshold for startupProbe                                                                                  | `1`     |
| `api.startupProbe.failureThreshold`               | Failure threshold for startupProbe                                                                                  | `3`     |
| `api.customLivenessProbe`                         | Custom livenessProbe that overrides the default one                                                                 | `{}`    |
| `api.customReadinessProbe`                        | Custom readinessProbe that overrides the default one                                                                | `{}`    |
| `api.customStartupProbe`                          | Custom startupProbe that overrides the default one                                                                  | `{}`    |
| `api.extraEnvVars`                                | Extra environment variables to pass on to the pod. The value is evaluated as a template                             | `[]`    |
| `api.extraEnvVarsFromConfigMap`                   | Name of a Config Map containing extra environment variables to pass on to the pod                                   |         |
| `api.extraEnvVarsFromSecret`                      | Name of a Secret containing extra environment variables to pass on to the pod                                       |         |

### Worker parameters

| Name                                                 | Description                                                                                                         | Value   |
| ---------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ------- |
| `worker.enabled`                                     | Set to true to enable refresh worker                                                                                | `true`  |
| `worker.serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                | `false` |
| `worker.serviceAccount.name`                         | Name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`    |
| `worker.serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                                      | `true`  |
| `worker.serviceAccount.annotations`                  | Annotations for service account. Evaluated as a template. Only used if create is true.                              | `{}`    |
| `worker.affinity`                                    | Affinity for pod assignment                                                                                         | `{}`    |
| `worker.spreadConstraints`                           | Topology spread constraint for pod assignment                                                                       | `[]`    |
| `worker.resources`                                   | Define resources requests and limits for single Pods                                                                | `{}`    |
| `worker.livenessProbe.enabled`                       | Enable livenessProbe                                                                                                | `true`  |
| `worker.livenessProbe.initialDelaySeconds`           | Initial delay seconds for livenessProbe                                                                             | `10`    |
| `worker.livenessProbe.periodSeconds`                 | Period seconds for livenessProbe                                                                                    | `30`    |
| `worker.livenessProbe.timeoutSeconds`                | Timeout seconds for livenessProbe                                                                                   | `3`     |
| `worker.livenessProbe.successThreshold`              | Success threshold for livenessProbe                                                                                 | `1`     |
| `worker.livenessProbe.failureThreshold`              | Failure threshold for livenessProbe                                                                                 | `3`     |
| `worker.readinessProbe.enabled`                      | Enable readinessProbe                                                                                               | `true`  |
| `worker.readinessProbe.initialDelaySeconds`          | Initial delay seconds for readinessProbe                                                                            | `10`    |
| `worker.readinessProbe.periodSeconds`                | Period seconds for readinessProbe                                                                                   | `30`    |
| `worker.readinessProbe.timeoutSeconds`               | Timeout seconds for readinessProbe                                                                                  | `3`     |
| `worker.readinessProbe.successThreshold`             | Success threshold for readinessProbe                                                                                | `1`     |
| `worker.readinessProbe.failureThreshold`             | Failure threshold for readinessProbe                                                                                | `3`     |
| `worker.startupProbe.enabled`                        | Enable startupProbe                                                                                                 | `false` |
| `worker.startupProbe.initialDelaySeconds`            | Initial delay seconds for startupProbe                                                                              | `10`    |
| `worker.startupProbe.periodSeconds`                  | Period seconds for startupProbe                                                                                     | `30`    |
| `worker.startupProbe.timeoutSeconds`                 | Timeout seconds for startupProbe                                                                                    | `3`     |
| `worker.startupProbe.successThreshold`               | Success threshold for startupProbe                                                                                  | `1`     |
| `worker.startupProbe.failureThreshold`               | Failure threshold for startupProbe                                                                                  | `3`     |
| `worker.customLivenessProbe`                         | Custom livenessProbe that overrides the default one                                                                 | `{}`    |
| `worker.customReadinessProbe`                        | Custom readinessProbe that overrides the default one                                                                | `{}`    |
| `worker.customStartupProbe`                          | Custom startupProbe that overrides the default one                                                                  | `{}`    |
| `worker.extraEnvVars`                                | Extra environment variables to pass on to the pod. The value is evaluated as a template                             | `[]`    |
| `worker.extraEnvVarsFromConfigMap`                   | Name of a Config Map containing extra environment variables to pass on to the pod                                   |         |
| `worker.extraEnvVarsFromSecret`                      | Name of a Secret containing extra environment variables to pass on to the pod                                       |         |

## Ingress parameters

| Name                       | Description                                                                     | Value                    |
| -------------------------- | ------------------------------------------------------------------------------- | ------------------------ |
| `ingress.enabled`          | Set to true to enable ingress record generation                                 | `false`                  |
| `ingress.hostname`         | When the ingress is enabled, a host pointing to this will be created            | `cube.local`             |
| `ingress.path`             | The Path to Cube                                                                | `/`                      |
| `ingress.pathPrefix`       | The PathPrefix                                                                  | `ImplementationSpecific` |
| `ingress.ingressClassName` | The Ingress class name                                                          |                          |
| `ingress.annotations`      | Ingress annotations                                                             | `{}`                     |
| `ingress.tls`              | Enable TLS configuration for the hostname defined at ingress.hostname parameter | `false`                  |
