# postgresql

![Version: 1.0.6](https://img.shields.io/badge/Version-1.0.6-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

An object-relational database management system, a database server.

**Homepage:** <https://www.postgresql.org/>

## Source Code

* <https://github.com/InseeFrLab/helm-charts-databases/tree/master/charts/postgresql>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | postgresql | 16.2.5 |
| https://inseefrlab.github.io/helm-charts-interactive-services | library-chart | 1.5.33 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| discoverable.allow | bool | `true` |  |
| postgresql.auth.database | string | `"defaultdb"` |  |
| postgresql.auth.password | string | `""` |  |
| postgresql.auth.postgresPassword | string | `""` |  |
| postgresql.auth.username | string | `""` |  |
| postgresql.extensions.postgis | bool | `false` |  |
| postgresql.image.pullPolicy | string | `"IfNotPresent"` |  |
| postgresql.image.tag | string | `"16"` |  |
| postgresql.primary.initdb.scriptsConfigMap | string | `"{{ include \"library-chart.fullname\" . }}"` |  |
| postgresql.primary.networkPolicy.enabled | bool | `false` |  |
| postgresql.primary.resources.limits | object | `{}` |  |
| postgresql.primary.resources.requests.cpu | string | `"250m"` |  |
| postgresql.primary.resources.requests.memory | string | `"256Mi"` |  |
| postgresql.service.ports.postgresql | int | `5432` |  |
| security.networkPolicy.enabled | bool | `true` |  |
| userPreferences.language | string | `"en"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)