#!/usr/bin/env bash

set -euo pipefail

if [[ -n "${TZ}" ]]; then
    ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime 2>/dev/null || true
    echo ${TZ} > /etc/timezone 2>/dev/null || true
fi

export USER=$(id -u -n ${PUID})
groupadd -f -g ${PGID} cronker 2>/dev/null || true
usermod -g ${PGID} -s /bin/bash $USER 2>/dev/null || true
export GROUP=$(id -g -n $USER)

mkdir -p /app/scripts
chown -R ${PUID}:${PGID} /app/scripts

if [[ -n "${SCRIPT}" ]]; then
    chmod +x /app/scripts/${SCRIPT}
    COMMAND="/app/scripts/${SCRIPT}"
fi

envsubst < /app/cron.template > /app/cron.task

cat /app/cron.task | crontab -

exec $@
