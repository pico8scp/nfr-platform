#!/bin/sh
set -eu
STAMP='full-backup-20260427-124606'
REMOTE="/tmp/$STAMP"
ARCHIVE="/tmp/$STAMP.tgz"
case "$REMOTE" in
  /tmp/full-backup-*) rm -rf "$REMOTE" ;;
  *) echo "Unsafe remote backup path: $REMOTE" >&2; exit 2 ;;
esac
mkdir -p "$REMOTE/code" "$REMOTE/db" "$REMOTE/meta"
date '+%F %T %Z' > "$REMOTE/meta/server-date.txt"
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}' > "$REMOTE/meta/docker-ps.txt"
docker inspect nfr-storefront-web --format '{{json .}}' > "$REMOTE/meta/nfr-storefront-web.inspect.json"
docker inspect crmeb-app --format '{{json .}}' > "$REMOTE/meta/crmeb-app.inspect.json"
tar --exclude='web/node_modules' --exclude='web/.nuxt' --exclude='web/.output.bak*' --exclude='web/.output_prev*' --exclude='web/web-output*.tgz' --exclude='web/*.bak-*' -czf "$REMOTE/code/nfr-storefront-web-current.tgz" -C /www/nfr-storefront web
tar --exclude='data' --exclude='env' --exclude='*/node_modules' -czf "$REMOTE/code/trade-v2-code-no-env-current.tgz" -C /www trade-v2
docker exec crmeb-app sh -c "tar --exclude='crmeb/public/uploads' --exclude='crmeb/runtime' --exclude='crmeb/.env' -czf - -C /var/www crmeb" > "$REMOTE/code/crmeb-code-no-env-current.tgz"
docker exec crmeb-app sh -c "tar -czf - -C /var/www/crmeb/public/admin bridge1688" > "$REMOTE/code/crmeb-admin-bridge1688-current.tgz"
docker exec crmeb-app sh -c "tar -czf - -C /var/www bridge1688-runtime" > "$REMOTE/code/bridge1688-runtime-current.tgz"
docker exec crmeb-app sh -c "mysqldump -h127.0.0.1 -ucrmeb -p123456 --no-tablespaces --no-data --routines --triggers --events --single-transaction crmeb" > "$REMOTE/db/crmeb-schema.sql"
docker exec trade-v2-mysql sh -c "mysqldump -uroot -ptrade_v2_root_password_2026 --no-tablespaces --no-data --routines --triggers --events --single-transaction trade_v2" > "$REMOTE/db/trade-v2-schema.sql"
find "$REMOTE" -maxdepth 3 -type f -printf '%P\t%s bytes\n' | sort > "$REMOTE/manifest.tsv"
tar -czf "$ARCHIVE" -C /tmp "$STAMP"
ls -lh "$ARCHIVE"