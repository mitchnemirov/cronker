#!/usr/bin/env bash

chmod +x /scripts/*

cat /cron/* | crontab -

echo "Starting cron with UID:${id -u} and GID:${id -g}..."

cron -f
