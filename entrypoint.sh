#!/usr/bin/env bash

mkdir -p -m 0744 /scripts /cron

chmod +x /scripts/*

cat /cron/* | crontab -

cron -f
