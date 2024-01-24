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
  - [Redis parameters](#redis-parameters)
  - [JWT parameters](#jwt-parameters)
  - [Datasources configuration](#datasources-configuration)
    - [Common parameters](#common-datasource-parameters)
    - [Athena parameters](#athena-datasource-parameters)
    - [Bigquery parameters](#bigquery-datasource-parameters)
    - [Databricks parameters](#databricks-datasource-parameters)
    - [ClickHouse parameters](#clickhouse-datasource-parameters)
    - [Firebolt parameters](#firebolt-datasource-parameters)
    - [Hive parameters](#hive-datasource-parameters)
    - [Presto parameters](#presto-datasource-parameters)
    - [Snowflake parameters](#snowflake-datasource-parameters)
    - [Trino parameters](#trino-datasource-parameters)
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

| Name                        | Description                                                                             | Value |
| --------------------------- | --------------------------------------------------------------------------------------- | ----- |
| `nameOverride`              | Override the name                                                                       | `""`  |
| `fullnameOverride`          | Provide a name to substitute for the full names of resources                            | `""`  |
| `commonLabels`              | Labels to add to all deployed objects                                                   | `{}`  |
| `commonAnnotations`         | Annotations to add to all deployed objects                                              | `{}`  |
| `extraEnvVars`              | Extra environment variables to pass on to the pod. The value is evaluated as a template | `[]`  |
| `extraEnvVarsFromConfigMap` | Name of a Config Map containing extra environment variables to pass on to the pod       |       |
| `extraEnvVarsFromSecret`    | Name of a Secret containing extra environment variables to pass on to the pod           |       |

### Image parameters

| Name                | Description                                                                             | Value          |
| ------------------- | --------------------------------------------------------------------------------------- | -------------- |
| `image.repository`  | Cube image repository                                                                   | `cubejs/cube`  |
| `image.tag`         | Cube image tag (immutable tags are recommended)                                         | `0.32.14`      |
| `image.pullPolicy`  | Cube image pull policy                                                                  | `IfNotPresent` |
| `image.pullSecrets` | If defined, uses a Secret to pull an image from a private Docker registry or repository | `[]`           |

### Config parameters

| Name                                                       | Description                                                                                                                  | Value   |
| ---------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | ------- |
| `config.apiPort`                                           | The port for a Cube deployment to listen to API connections on                                                               | `4000`  |
| `config.sqlPort`                                           | The port to listen to MySQL-compatible connections on                                                                        |         |
| `config.pgSqlPort`                                         | The port to listen to Postgres-compatible connections on                                                                     |         |
| `config.sqlUser`                                           | The username to access the SQL api                                                                                           |         |
| `config.sqlPassword`                                       | The password to access the SQL api                                                                                           |         |
| `config.sqlPasswordFromSecret.name`                        | The password to access the SQL api (using secret)                                                                            |         |
| `config.sqlPasswordFromSecret.key`                         | The password to access the SQL api (using secret)                                                                            |         |
| `config.devMode`                                           | If true, enables development mode                                                                                            | `false` |
| `config.debug`                                             | If true, enables debug logging                                                                                               | `false` |
| `config.logLevel`                                          | The logging level for Cube                                                                                                   | `warn`  |
| `config.telemetry`                                         | If true, then send telemetry to Cube                                                                                         | `false` |
| `config.apiSecret`                                         | The secret key used to sign and verify JWTs. Generated on project scaffold                                                   |         |
| `config.apiSecretFromSecret.name`                          | The secret key used to sign and verify JWTs. Generated on project scaffold (using secret)                                    |         |
| `config.apiSecretFromSecret.key`                           | The secret key used to sign and verify JWTs. Generated on project scaffold (using secret)                                    |         |
| `config.Values.config.playgroundAuthSecret`                | The secret key used to enable system APIs                                                                                    |         |
| `config.Values.config.playgroundAuthSecretFromSecret.name` | The secret key used to enable system APIs (using secret)                                                                     |         |
| `config.Values.config.playgroundAuthSecretFromSecret.key`  | The secret key used to enable system APIs (using secret)                                                                     |         |
| `config.schemaPath`                                        | The path where Cube loads schemas from. Defaults to schema                                                                   |         |
| `config.app`                                               | An application ID used to uniquely identify the Cube deployment. Can be different for multitenant setups. Defaults to cubejs |         |
| `config.rollupOnly`                                        | If true, this instance of Cube will only query rollup pre-aggregations. Defaults to false                                    |         |
| `config.scheduledRefreshTimezones`                         | A comma-separated list of timezones to schedule refreshes for                                                                |         |
| `config.webSockets`                                        | If true, then use WebSocket for data fetching. Defaults to true                                                              |         |
| `config.preAggregationsSchema`                             | The schema name to use for storing pre-aggregations true                                                                     |         |
| `config.cacheAndQueueDriver`                               | The cache and queue driver to use for the Cube deployment. Defaults to cubestore                                             |         |
| `config.concurrency`                                       | The number of concurrent connections each query queue has to the database                                                    |         |
| `config.topicName`                                         | The name of the Amazon SNS or Google Cloud Pub/Sub topicredis                                                                |         |
| `config.touchPreAggTimeout`                                | The number of seconds without a touch before pre-aggregation is considered orphaned and marked for removal                   |         |
| `config.dropPreAggWithoutTouch`                            | If true, it enables dropping pre-aggregations that Refresh Worker doesn't touch within touchPreAggTimeout                    |         |
| `config.volumes`                                           | The config volumes. Will be used to both api and worker                                                                      | `[]`    |
| `config.volumeMounts`                                      | The config volumeMounts. Will be used to both api and worker                                                                 | `[]`    |
| `config.initContainers`                                    | Add init containers to load models using volume mounts ( an alternative to using configs, example in values)                 | `[]`    |

### Redis parameters

| Name                            | Description                                                                                                                                              | Value |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `redis.url`                     | The host URL for a Redis server. Note that this must include the `redis://` protocol prefix.                                                             |       |
| `redis.password`                | The password used to connect to the Redis server                                                                                                         |       |
| `redis.passwordFromSecret.name` | The password used to connect to the Redis server (using secret)                                                                                          |       |
| `redis.passwordFromSecret.key`  | The password used to connect to the Redis server (using secret)                                                                                          |       |
| `redis.tls`                     | If true, then the connection to the Redis server is protected by TLS authentication. Defaults to false                                                   |       |
| `redis.poolMin`                 | The minimum number of connections to keep active in the Redis connection pool for a single appId (tenant). Must be lower than poolMax. Defaults to 2     |       |
| `redis.poolMax`                 | The maximum number of connections to keep active in the Redis connection pool for a single appId (tenant). Must be higher than poolMin. Defaults to 1000 |       |
| `redis.useIoRedis`              | Use ioredis instead of redis. Defaults to false                                                                                                          |       |

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

| Name                                                       | Description                                                                                   | Value   |
| ---------------------------------------------------------- | --------------------------------------------------------------------------------------------- | ------- |
| `datasources.<name>.type`                                  | A database type supported by Cube.js                                                          |         |
| `datasources.<name>.url`                                   | The URL for a database                                                                        |         |
| `datasources.<name>.host`                                  | The host URL for a database                                                                   |         |
| `datasources.<name>.port`                                  | The port for the database connection                                                          |         |
| `datasources.<name>.schema`                                | The schema within the database to connect to                                                  |         |
| `datasources.<name>.name`                                  | The name of the database to connect to                                                        |         |
| `datasources.<name>.user`                                  | The username used to connect to the database                                                  |         |
| `datasources.<name>.pass`                                  | The password used to connect to the database                                                  |         |
| `datasources.<name>.passFromSecret.name`                   | The password used to connect to the database (using secret)                                   |         |
| `datasources.<name>.passFromSecret.key`                    | The password used to connect to the database (using secret)                                   |         |
| `datasources.<name>.domain`                                | A domain name within the database to connect to                                               |         |
| `datasources.<name>.socketPath`                            | The path to a Unix socket for a MySQL database                                                |         |
| `datasources.<name>.catalog`                               | The catalog within the database to connect to                                                 |         |
| `datasources.<name>.maxPool`                               | The maximum number of connections to keep active in the database connection pool              |         |
| `datasources.<name>.queryTimeout`                          | The timeout value for any queries made to the database by Cube                                |         |
| `datasources.<name>.export.name`                           | The name of a bucket in cloud storage                                                         |         |
| `datasources.<name>.export.type`                           | The cloud provider where the bucket is hosted (gcs, s3)                                       |         |
| `datasources.<name>.export.gcs.credentials`                | Base64 encoded JSON key file for connecting to Google Cloud                                   |         |
| `datasources.<name>.export.gcs.credentialsFromSecret.name` | Base64 encoded JSON key file for connecting to Google Cloud (using secret)                    |         |
| `datasources.<name>.export.gcs.credentialsFromSecret.key`  | Base64 encoded JSON key file for connecting to Google Cloud (using secret)                    |         |
| `datasources.<name>.export.aws.key`                        | The AWS Access Key ID to use for the export bucket                                            |         |
| `datasources.<name>.export.aws.secret`                     | The AWS Secret Access Key to use for the export bucket                                        |         |
| `datasources.<name>.export.aws.secretFromSecret.name`      | The AWS Secret Access Key to use for the export bucket (using secret)                         |         |
| `datasources.<name>.export.aws.secretFromSecret.key`       | The AWS Secret Access Key to use for the export bucket (using secret)                         |         |
| `datasources.<name>.export.aws.region`                     | The AWS region of the export bucket                                                           |         |
| `datasources.<name>.export.redshift.arn`                   | An ARN of an AWS IAM role with permission to write to the configured bucket (see export.name) |         |
| `datasources.<name>.ssl.enabled`                           | If true, enables SSL encryption for database connections from Cube.js                         | `false` |
| `datasources.<name>.ssl.rejectUnAuthorized`                | If true, verifies the CA chain with the system's built-in CA chain                            |         |
| `datasources.<name>.ssl.ca`                                | The contents of a CA bundle in PEM format, or a path to one                                   |         |
| `datasources.<name>.ssl.cert`                              | The contents of an SSL certificate in PEM format, or a path to one                            |         |
| `datasources.<name>.ssl.key`                               | The contents of a private key in PEM format, or a path to one                                 |         |
| `datasources.<name>.ssl.ciphers`                           | The ciphers used by the SSL certificate                                                       |         |
| `datasources.<name>.ssl.serverName`                        | The server name for the SNI TLS extension                                                     |         |
| `datasources.<name>.ssl.passPhrase`                        | he passphrase used to encrypt the SSL private key                                             |         |

### Athena datasource parameters

| Name                                              | Description                                                              | Value |
| ------------------------------------------------- | ------------------------------------------------------------------------ | ----- |
| `datasources.<name>.athena.key`                   | The AWS Access Key ID to use for database connections                    |       |
| `datasources.<name>.athena.keyFromSecret.name`    | The AWS Access Key ID to use for database connections (using secret)     |       |
| `datasources.<name>.athena.keyFromSecret.key`     | The AWS Access Key ID to use for database connections (using secret)     |       |
| `datasources.<name>.athena.region`                | The AWS region of the Cube.js deployment                                 |       |
| `datasources.<name>.athena.s3OutputLocation`      | The S3 path to store query results made by the Cube.js deployment        |       |
| `datasources.<name>.athena.secret`                | The AWS Secret Access Key to use for database connections                |       |
| `datasources.<name>.athena.secretFromSecret.name` | The AWS Secret Access Key to use for database connections (using secret) |       |
| `datasources.<name>.athena.secretFromSecret.key`  | The AWS Secret Access Key to use for database connections (using secret) |       |
| `datasources.<name>.athena.workgroup`             | The name of the workgroup in which the query is being started            |       |
| `datasources.<name>.athena.catalog`               | The name of the catalog to use by default                                |       |

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

| Name                                         | Description                                                               | Value |
| -------------------------------------------- | ------------------------------------------------------------------------- | ----- |
| `datasources.<name>.databricks.url`          | The URL for a JDBC connection                                             |       |
| `datasources.<name>.databricks.acceptPolicy` | Whether or not to accept the license terms for the Databricks JDBC driver |       |
| `datasources.<name>.databricks.token`        | The personal access token used to authenticate the Databricks connection  |       |
| `datasources.<name>.databricks.catalog`      | Databricks catalog name                                                   |       |

### Clickhouse datasource parameters

| Name                                     | Description                                             | Value |
| ---------------------------------------- | ------------------------------------------------------- | ----- |
| `datasources.<name>.clickhouse.readonly` | Whether the ClickHouse user has read-only access or not |       |

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

### Presto datasource parameters

| Name                                | Description                             | Value |
| ----------------------------------- | --------------------------------------- | ----- |
| `datasources.<name>.presto.catalog` | The catalog within Presto to connect to |       |

### Snowflake datasource parameters

| Name                                                  | Description                                                            | Value |
| ----------------------------------------------------- | ---------------------------------------------------------------------- | ----- |
| `datasources.<name>.snowFlake.account`                | The Snowflake account ID to use when connecting to the database        |       |
| `datasources.<name>.snowFlake.region`                 | The Snowflake region to use when connecting to the database            |       |
| `datasources.<name>.snowFlake.role`                   | The Snowflake role to use when connecting to the database              |       |
| `datasources.<name>.snowFlake.warehouse`              | The Snowflake warehouse to use when connecting to the database         |       |
| `datasources.<name>.snowFlake.clientSessionKeepAlive` | If true, keep the Snowflake connection alive indefinitely              |       |
| `datasources.<name>.snowFlake.authenticator`          | The type of authenticator to use with Snowflake. Defaults to SNOWFLAKE |       |
| `datasources.<name>.snowFlake.privateKeyPath`         | The path to the private RSA key folder                                 |       |
| `datasources.<name>.snowFlake.privateKeyPass`         | The password for the private RSA key. Only required for encrypted keys |       |

### Trino datasource parameters

| Name                               | Description                            | Value |
| ---------------------------------- | -------------------------------------- | ----- |
| `datasources.<name>.trino.catalog` | The catalog within Trino to connect to |       |

### Cubestore parameters

| Name             | Description                               | Value |
| ---------------- | ----------------------------------------- | ----- |
| `cubestore.host` | The hostname of the Cube Store deployment |       |
| `cubestore.port` | The port of the Cube Store deployment     | 3030  |

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
| `api.livenessProbe.successThreshold`              | Failure threshold for livenessProbe                                                                                 | `1`     |
| `api.livenessProbe.failureThreshold`              | Success threshold for livenessProbe                                                                                 | `3`     |
| `api.readinessProbe.enabled`                      | Enable readinessProbe                                                                                               | `true`  |
| `api.readinessProbe.initialDelaySeconds`          | Initial delay seconds for readinessProbe                                                                            | `10`    |
| `api.readinessProbe.periodSeconds`                | Period seconds for readinessProbe                                                                                   | `30`    |
| `api.readinessProbe.timeoutSeconds`               | Timeout seconds for readinessProbe                                                                                  | `3`     |
| `api.readinessProbe.successThreshold`             | Failure threshold for readinessProbe                                                                                | `1`     |
| `api.readinessProbe.failureThreshold`             | Success threshold for readinessProbe                                                                                | `3`     |
| `api.customLivenessProbe`                         | Custom livenessProbe that overrides the default one                                                                 | `{}`    |
| `api.customReadinessProbe`                        | Custom readinessProbe that overrides the default one                                                                | `{}`    |

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
| `worker.livenessProbe.successThreshold`              | Failure threshold for livenessProbe                                                                                 | `1`     |
| `worker.livenessProbe.failureThreshold`              | Success threshold for livenessProbe                                                                                 | `3`     |
| `worker.readinessProbe.enabled`                      | Enable readinessProbe                                                                                               | `true`  |
| `worker.readinessProbe.initialDelaySeconds`          | Initial delay seconds for readinessProbe                                                                            | `10`    |
| `worker.readinessProbe.periodSeconds`                | Period seconds for readinessProbe                                                                                   | `30`    |
| `worker.readinessProbe.timeoutSeconds`               | Timeout seconds for readinessProbe                                                                                  | `3`     |
| `worker.readinessProbe.successThreshold`             | Failure threshold for readinessProbe                                                                                | `1`     |
| `worker.readinessProbe.failureThreshold`             | Success threshold for readinessProbe                                                                                | `3`     |
| `worker.customLivenessProbe`                         | Custom livenessProbe that overrides the default one                                                                 | `{}`    |
| `worker.customReadinessProbe`                        | Custom readinessProbe that overrides the default one                                                                | `{}`    |

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
