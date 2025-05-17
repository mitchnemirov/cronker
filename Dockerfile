FROM ubuntu:latest

LABEL org.opencontainers.image.source=https://github.com/mitchnemirov/cronker

RUN apt-get update && \
    apt-get install -yqq --no-install-recommends \
    cron && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf \
    /var/lib/apt \
    /var/lib/dpkg \
    /var/lib/cache \
    /var/lib/log

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
