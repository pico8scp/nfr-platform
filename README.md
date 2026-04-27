# NFR Server Full Backup

Backup time: 2026-04-27 12:46 Asia/Shanghai
Source server: 192.168.1.67
Archive: full-backup-20260427-124606.tgz
SHA256: B9065DBDBF5514A2CFE008D27B1236D74A2469DD8D942841B5D30B501702F994

## Scope

This backup is generated from the current server runtime, not from the local workspace.

### Code archives

- code/nfr-storefront-web-current.tgz
  - Source: /www/nfr-storefront/web
  - Includes current source and current .output
  - Excludes node_modules, .nuxt, historical .output backups, old web-output archives

- code/crmeb-code-no-env-current.tgz
  - Source: crmeb-app:/var/www/crmeb
  - Excludes public/uploads, runtime, .env

- code/crmeb-admin-bridge1688-current.tgz
  - Source: crmeb-app:/var/www/crmeb/public/admin/bridge1688

- code/bridge1688-runtime-current.tgz
  - Source: crmeb-app:/var/www/bridge1688-runtime

- code/trade-v2-code-no-env-current.tgz
  - Source: /www/trade-v2
  - Excludes data, env, node_modules

### Database schema only

- db/crmeb-schema.sql
  - no data, schema only
  - CREATE TABLE count: 171

- db/trade-v2-schema.sql
  - no data, schema only
  - CREATE TABLE count: 0

## Notes

- No database business data is included.
- Runtime secret env files are excluded from code archives.
- MySQL dump was generated with --no-tablespaces to avoid PROCESS privilege dependency.
- Docker inspect metadata is included for version comparison and mount/port verification.