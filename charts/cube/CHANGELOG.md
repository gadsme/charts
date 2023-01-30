# Change Log

The release numbering uses [semantic versioning](http://semver.org).

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
