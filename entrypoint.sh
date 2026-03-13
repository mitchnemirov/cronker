#!/usr/bin/env bash

set -euo pipefail

if [ -n "${TZ:-}" ]; then
    ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime 2>/dev/null || true
    echo ${TZ} > /etc/timezone 2>/dev/null || true
fi

groupadd -f -g ${PGID} cronker 2>/dev/null || true

if ! id -u cronker &>/dev/null; then
    useradd -g ${PGID} -s /bin/bash -d /home/cronker cronker 2>/dev/null || true
fi

mkdir -p /home/cronker /var/log/cronker
chown -R :${PGID} /home/cronker /scripts /cron /var/log/cronker
chmod +x /scripts/*

cat /cron/* | crontab -

exec cron -f
