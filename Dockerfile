FROM ubuntu:latest

LABEL org.opencontainers.image.source=https://github.com/mitchnemirov/cronker

ENV PGID=1000
ENV TZ=UTC

RUN apt-get update && \
    apt-get install -yqq --no-install-recommends \
    cron \
    tzdata && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf \
    /var/lib/apt \
    /var/lib/dpkg \
    /var/lib/cache \
    /var/lib/log

COPY entrypoint.sh /entrypoint.sh

RUN mkdir -p -m 0744 /scripts /cron && \
    chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
