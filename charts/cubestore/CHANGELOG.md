# Change Log

The release numbering uses [semantic versioning](http://semver.org).

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
