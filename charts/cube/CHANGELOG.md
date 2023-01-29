# Change Log

The release numbering uses [semantic versioning](http://semver.org).

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
