# Cubestore Chart

## Get Helm Repository Info

```console
helm repo add gadsme https://gadsme.github.io/charts
helm repo update
```

_See [`helm repo`](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Install Chart

```console
helm install [RELEASE_NAME] gadsme/cubestore
```

The command deploys Cubestore on the Kubernetes cluster using the default configuration.

_See [configuration](#configuration) below._

_See [`helm install`](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Uninstall Chart

```console
helm uninstall [RELEASE_NAME]
```

This removes all the Kubernetes components associated with the chart and deletes the release.

_See [`helm uninstall`](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

## Upgrading Chart

```console
helm upgrade [RELEASE_NAME] gadsme/cubestore --install
```

## Configuration

By default, a router and two workers will be deployed. You can customize the deployment using helm values.

Refer to the official documentation for more information:
https://cube.dev/docs/reference/environment-variables#cube-store

### Example

Deployment with:

- 3 workers
- GCP cloud storage (using a secret)

```bash
$ helm install my-release \
--set workers.workersCount=3 \
--set cloudStorage.gcp.credentialsFromSecret.name=<service-account-secret-name> \
--set cloudStorage.gcp.credentialsFromSecret.key=<service-account-secret-key> \
--set cloudStorage.gcp.bucket=<my-bucket>
gadsme/cubestore
```

## Persistence

### Remote dir

By default, a shared remoteDir is created to store metadata and datasets if no cloudstorage is configured.
Prefer using cloudStorage if you are running on `gcp` or `aws`.

### Local dir

By default, local dir is not persisted. You can enable persistence on router and master.

## Parameters

### Common parameters

| Name                | Description                                                  | Value |
|---------------------|--------------------------------------------------------------|-------|
| `nameOverride`      | Override the name                                            | `""`  |
| `fullnameOverride`  | Provide a name to substitute for the full names of resources | `""`  |
| `commonLabels`      | Labels to add to all deployed objects                        | `{}`  |
| `commonAnnotations` | Annotations to add to all deployed objects                   | `{}`  |

### Image parameters

| Name                | Description                                                                             | Value              |
|---------------------|-----------------------------------------------------------------------------------------|--------------------|
| `image.repository`  | Cubestore image repository                                                              | `cubejs/cubestore` |
| `image.tag`         | Cubestore image tag (immutable tags are recommended)                                    | `1.2.0`            |
| `image.pullPolicy`  | Cubestore image pull policy                                                             | `IfNotPresent`     |
| `image.pullSecrets` | If defined, uses a Secret to pull an image from a private Docker registry or repository | `[]`               |

### Global parameters

| Name                       | Description                                                                                                       | Value   |
|----------------------------|-------------------------------------------------------------------------------------------------------------------|---------|
| `config.logLevel`          | The logging level for Cube Store                                                                                  | `error` |
| `config.noUpload`          | If true, prevents uploading serialized pre-aggregations to cloud storage                                          |         |
| `config.jobRunners`        | The number of parallel tasks that process non-interactive jobs like data insertion, compaction etc. Defaults to 4 |         |
| `config.telemetry`         | If true, then send telemetry to Cube                                                                              | `false` |
| `config.queryTimeout`      | The timeout for SQL queries in seconds. Defaults to 120                                                           |         |
| `config.selectWorkers`     | The number of Cube Store sub-processes that handle SELECT queries. Defaults to 4                                  |         |
| `config.walSplitThreshold` | The maximum number of rows to keep in a single chunk of data right after insertion. Defaults to 262144            |         |

### Remote dir parameters

| Name                                   | Description                                                                | Value             |
|----------------------------------------|----------------------------------------------------------------------------|-------------------|
| `remoteDir.persistence.resourcePolicy` | Setting it to "keep" to avoid removing PVCs during a helm delete operation | `keep`            |
| `remoteDir.persistence.size`           | Persistent Volume size                                                     | `10Gi`            |
| `remoteDir.persistence.annotations`    | Additional custom annotations for the PVC                                  | `{}`              |
| `remoteDir.persistence.accessModes`    | Persistent Volume access modes                                             | [`ReadWriteOnce`] |
| `remoteDir.persistence.storageClass`   | The storage class to use for the remoteDir pvc                             | `""`              |

### Cloud Storage parameters

| Name                                                | Description                                                                                                            | Value |
|-----------------------------------------------------|------------------------------------------------------------------------------------------------------------------------|-------|
| `cloudStorage.gcp.credentials`                      | A Base64 encoded JSON key file for connecting to Google Cloud. Required when using Google Cloud Storage                |       |
| `cloudStorage.gcp.credentialsFromSecret.name`       | A Base64 encoded JSON key file for connecting to Google Cloud. Required when using Google Cloud Storage (using secret) |       |
| `cloudStorage.gcp.credentialsFromSecret.key`        | A Base64 encoded JSON key file for connecting to Google Cloud. Required when using Google Cloud Storage (using secret) |       |
| `cloudStorage.gcp.bucket`                           | The name of a bucket in GCS. Required when using GCS                                                                   |       |
| `cloudStorage.gcp.subPath`                          | The path in a GCS bucket to store pre-aggregations. Optional                                                           |       |
| `cloudStorage.aws.accessKeyID`                      | The Access Key ID for AWS. Required when using AWS S3                                                                  |       |
| `cloudStorage.aws.secretKey`                        | The Secret Access Key for AWS. Required when using AWS S3                                                              |       |
| `cloudStorage.aws.secretKeyFromSecret.name`         | The Secret Access Key for AWS. Required when using AWS S3 (using secret)                                               |       |
| `cloudStorage.aws.secretKeyFromSecret.key`          | The Secret Access Key for AWS. Required when using AWS S3 (using secret)                                               |       |
| `cloudStorage.aws.bucket`                           | The name of a bucket in AWS S3. Required when using AWS S3                                                             |       |
| `cloudStorage.aws.region`                           | The region of a bucket in AWS S3. Required when using AWS S3                                                           |       |
| `cloudStorage.aws.subPath`                          | The path in a AWS S3 bucket to store pre-aggregations. Optional                                                        |       |
| `cloudStorage.aws.refreshCredsEveryMinutes`         | The number of minutes after which Cube Store should refresh AWS credentials                                            |       |
| `cloudStorage.minio.accessKeyID`                    | The The Access Key ID for minIO. Required when using minIO                                                             |       |
| `cloudStorage.minio.secretKey`                      | The Secret Access Key for minIO. Required when using minIO                                                             |       |
| `cloudStorage.minio.secretKeyFromSecret.name`       | The Secret Access Key for minIO. Required when using minIO (using secret)                                              |       |
| `cloudStorage.minio.secretKeyFromSecret.key`        | The Secret Access Key for minIO. Required when using minIO (using secret)                                              |       |
| `cloudStorage.minio.bucket`                         | The name of the bucket that you want to use minIO. Required when using minIO                                           |       |
| `cloudStorage.minio.region`                         | The region of a bucket in S3 that you want to use minIO. Optional when using minIO                                     |       |
| `cloudStorage.minio.subPath`                        | The path in a minIO bucket to store pre-aggregations. Optional                                                         |       |
| `cloudStorage.minio.endpoint`                       | The minIO server endpoint. Required when using minIO                                                                   |       |
| `cloudStorage.minio.credentialsRefreshEveryMinutes` | The number of minutes after which Cube Store should refresh minIO credentials                                          |       |

### Metrics

| Name              | Description                                                                                                           | Value |
|-------------------|-----------------------------------------------------------------------------------------------------------------------|-------|
| `metrics.format`  | Define which metrics collector format. Set it to `statsd` if exporter.enabled is set to `true`                        |       |
| `metrics.address` | Required IP address to send metrics. Leave it blank if exporter.enabled is set to `true`                              |       |
| `metrics.port`    | Required port to send where collector server accept UDP connections. Must be set if exporter.enabled is set to `true` |       |

### Router parameters

| Name                                                 | Description                                                                                                         | Value             |
|------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|-------------------|
| `router.serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                | `false`           |
| `router.serviceAccount.name`                         | Name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`              |
| `router.serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                                      | `true`            |
| `router.serviceAccount.annotations`                  | Annotations for service account. Evaluated as a template. Only used if create is true.                              | `{}`              |
| `router.httpPort`                                    | The port for Cube Store to listen to HTTP connections on                                                            | `3030`            |
| `router.metaPort`                                    | The port for the router node to listen for connections on                                                           | `9999`            |
| `router.mysqlPort`                                   | The port for Cube Store to listen to connections on                                                                 |                   |
| `router.statusPort`                                  | The port for Cube Store to expose status probes                                                                     | `3331`            |
| `router.extraEnvVars`                                | Extra environment variables to pass on to the pod. The value is evaluated as a template                             | `[]`              |
| `router.persistence.enabled`                         | Enable persistence for local data using Persistent Volume Claims                                                    | `false`           |
| `router.persistance.size`                            | Persistent Volume size                                                                                              | `10Gi`            |
| `router.persistence.storageClass`                    | The storage class to use for the router pvc                                                                         | `""`              |
| `router.persistance.accessModes`                     | Persistent Volume access modes                                                                                      | [`ReadWriteOnce`] |
| `router.persistance.annotations`                     | Additional custom annotations for the PVC                                                                           | `{}`              |
| `router.affinity`                                    | Affinity for pod assignment                                                                                         | `{}`              |
| `router.tolerations`                                 | Tolerations for pod assignment                                                                                      | `{}`              |
| `router.nodeSelector`                                | Node selector for pod assignment                                                                                    | `{}`              |
| `router.spreadConstraints`                           | Topology spread constraint for pod assignment                                                                       | `[]`              |
| `router.resources`                                   | Define resources requests and limits for single Pods                                                                | `{}`              |
| `router.livenessProbe.enabled`                       | Enable livenessProbe                                                                                                | `true`            |
| `router.livenessProbe.initialDelaySeconds`           | Initial delay seconds for livenessProbe                                                                             | `10`              |
| `router.livenessProbe.periodSeconds`                 | Period seconds for livenessProbe                                                                                    | `30`              |
| `router.livenessProbe.timeoutSeconds`                | Timeout seconds for livenessProbe                                                                                   | `3`               |
| `router.livenessProbe.successThreshold`              | Failure threshold for livenessProbe                                                                                 | `1`               |
| `router.livenessProbe.failureThreshold`              | Success threshold for livenessProbe                                                                                 | `3`               |
| `router.readinessProbe.enabled`                      | Enable readinessProbe                                                                                               | `true`            |
| `router.readinessProbe.initialDelaySeconds`          | Initial delay seconds for readinessProbe                                                                            | `10`              |
| `router.readinessProbe.periodSeconds`                | Period seconds for readinessProbe                                                                                   | `30`              |
| `router.readinessProbe.timeoutSeconds`               | Timeout seconds for readinessProbe                                                                                  | `3`               |
| `router.readinessProbe.successThreshold`             | Failure threshold for readinessProbe                                                                                | `1`               |
| `router.readinessProbe.failureThreshold`             | Success threshold for readinessProbe                                                                                | `3`               |
| `router.customLivenessProbe`                         | Custom livenessProbe that overrides the default one                                                                 | `{}`              |
| `router.customReadinessProbe`                        | Custom readinessProbe that overrides the default one                                                                | `{}`              |
| `router.service.annotations`                         | Additional custom annotations for router service                                                                    | `{}`              |

### Workers parameters

| Name                                                  | Description                                                                                                         | Value             |
|-------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|-------------------|
| `workers.serviceAccount.create`                       | Specifies whether a ServiceAccount should be created                                                                | `false`           |
| `workers.serviceAccount.name`                         | Name of the service account to use. If not set and create is true, a name is generated using the fullname template. | `""`              |
| `workers.serviceAccount.automountServiceAccountToken` | Automount service account token for the server service account                                                      | `true`            |
| `workers.serviceAccount.annotations`                  | Annotations for service account. Evaluated as a template. Only used if create is true.                              | `{}`              |
| `workers.workersCount`                                | Number of workers to deploy                                                                                         | `1`               |
| `workers.port`                                        | The port for the router node to listen for connections on                                                           | `9001`            |
| `workers.extraEnvVars`                                | Extra environment variables to pass on to the pod. The value is evaluated as a template                             | `[]`              |
| `workers.persistence.enabled`                         | Enable persistence for local data using Persistent Volume Claims                                                    | `false`           |
| `workers.persistance.size`                            | Persistent Volume size                                                                                              | `10Gi`            |
| `workers.persistence.storageClass`                    | The storage class to use for the workers pvc                                                                        | `""`              |
| `workers.persistance.accessModes`                     | Persistent Volume access modes                                                                                      | [`ReadWriteOnce`] |
| `workers.persistance.annotations`                     | Additional custom annotations for the PVC                                                                           | `{}`              |
| `workers.affinity`                                    | Affinity for pod assignment                                                                                         | `{}`              |
| `workers.tolerations`                                 | Tolerations for pod assignment                                                                                      | `{}`              |
| `workers.nodeSelector`                                | Node selector for pod assignment                                                                                    | `{}`              |
| `workers.spreadConstraints`                           | Topology spread constraint for pod assignment                                                                       | `[]`              |
| `workers.resources`                                   | Define resources requests and limits for single Pods                                                                | `{}`              |
| `workers.service.annotations`                         | Additional custom annotations for workers service                                                                   | `{}`              |
| `workers.initRouter.image.repository`                 | Defines the image repository for the init-router initContainer                                                      | `busybox`         |
| `workers.initRouter.image.tag`                        | Defines the image tag for the init-router initContainer                                                             | `latest`          |
| `workers.initRouter.resources`                        | Defines resources for init-router initContainer                                                                     | `{}`              |

### Statsd exporter parameters

You can enable statsd-prometheus-exporter as sidecar container for router stateful set.

| Name                                   | Description                                                                                                     | Value                       |
|----------------------------------------|-----------------------------------------------------------------------------------------------------------------|-----------------------------|
| `exporter.enabled`                     | Whether statsd-prometheus-exporter will be enabled                                                              | `true`                      |
| `exporter.image.repository`            | Exporter image repo                                                                                             | `prom/statsd-exporter`      |
| `exporter.image.tag`                   | Labels to add to all deployed objects                                                                           | `v0.24.0`                   |
| `exporter.extraArgs`                   | Extra arguments for pass for statsd-prometheus-exporter                                                         | `[]`                        |
| `exporter.statsd.cacheSize`            | Maximum size of your metric mapping cache                                                                       | `1000`                      |
| `exporter.statsd.eventQueueSize`       | Size of internal queue for processing events                                                                    | `10000`                     |
| `exporter.statsd.eventFlushThreshold`  | Number of events to hold in queue before flushing                                                               | `1000`                      |
| `exporter.statsd.eventFlushInterval`   | Time interval before flushing events in queue                                                                   | `200ms`                     |
| `exporter.statsd.useDefaultMapping`    | Whether use default mapping. If set to false, you should provide your own configMap with statsd metrics mapping | `true`                      |
| `exporter.statsd.mappingConfigMapName` | Metrics mapping ConfigMap                                                                                       | `cubestore-metrics-mapping` |
| `exporter.statsd.mappingConfigMapKey`  | Name of the key inside Metric mapping ConfigMap.                                                                | `statsd.mappingConf`        |
| `exporter.livenessProbe`               | Liveness probe for exporter container                                                                           | `{ }`                       |
| `exporter.readinessProbe`              | Readiness probe for exporter container                                                                          | `{ }`                       |
| `exporter.resources`                   | Resources for exporter container                                                                                | `{ }`                       |
| `exporter.service.port`                | The address on which to expose the web interface and generated Prometheus metrics container                     | `9102`                      |
| `exporter.service.path`                | Path under which to expose metrics                                                                              | `/metrics`                  |
