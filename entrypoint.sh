#!/usr/bin/env bash

set -eo pipefail

if [[ -n "${TZ}" ]]; then
    ln -snf /usr/share/zoneinfo/"${TZ}" /etc/localtime 2>/dev/null || true
    echo "${TZ}" > /etc/timezone 2>/dev/null || true
fi

export USER=$(id -u -n "${PUID}")
groupadd -f -g "${PGID}" cronker 2>/dev/null || true
usermod -g "${PGID}" -s /bin/bash "$USER" 2>/dev/null || true
export GROUP=$(id -g -n "$USER")

chown -R "${PUID}":"${PGID}" /app/scripts
chmod +x /app/scripts/*

touch /app/cron.task

if [[ -n "${SCRIPTS}" ]]; then
  IFS=, read -r -a scripts <<< "${SCRIPTS}"
  for script in "${scripts[@]}"; do
    echo "Adding crontab entry for $script"
    export COMMAND="/app/scripts/$script"
    envsubst < /app/cron.template >> /app/cron.task
  done
elif [[ -n "${COMMAND}" ]]; then
  echo "Adding crontab entry for $COMMAND"
  export COMMAND="${COMMAND}"
  envsubst < /app/cron.template > /app/cron.task
else
  echo "Need at least SCRIPT or COMMAND set."
  exit 1
fi

cat /app/cron.task | crontab -

exec "$@"
