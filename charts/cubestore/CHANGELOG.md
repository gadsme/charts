# Change Log

The release numbering uses [semantic versioning](http://semver.org).

## 1.0.0

- update to cubestore 1.2.0

## 0.12.1

- update to cubestore 0.35.76

## 0.12.0

- update to cubestore 0.35.67

## 0.11.0

- update to cubestore 0.34.56
- add aws accessKeyID from secret

## 0.10.0

- update to cubestore 0.34.23
- made initRouter image repository and tag configurable

## 0.9.4

- add workers statsd sidecar to get metrics

## 0.9.3

- update to cubestore 0.33.48
- add metrics statsd sidecar container
- run containers as non root

## 0.9.2

- add init-router resource configuration

## 0.9.1

- fix documentation

## 0.9.0

- Update to cubestore 0.33.4
- Add annotations and types to the router service
- Define environment variables specific to either router or workers

## 0.8.0

- Update to cubestore 0.32.14

## 0.7.0

- Update to cubestore 0.32.7
- add persistance storageClass config

## 0.6.0

- Update to cubestore 0.31.58
- disable router mysql port by default
- set default PVC to `ReadWriteMany` storage class

## 0.5.1

- add missing `cloudStorage.minio.subPath` and `cloudStorage.minio.credentialsRefreshEveryMinutes` config

## 0.5.0

- Upgrade to cubestore 0.31.55

## 0.4.0

- add `config.telemetry`
- Upgrade to cubestore 0.31.47
