FROM ubuntu:latest

LABEL org.opencontainers.image.source=https://github.com/mitchnemirov/cronker

ENV PUID=1000
ENV PGID=1000

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

COPY --chown=${PUID}:${PGID} entrypoint.sh /entrypoint.sh

RUN mkdir -p -m 0744 /scripts /cron && \
    chown -R ${PUID}:${PGID} /scripts /cron && \
    chmod +x /entrypoint.sh && \
    chmod u+s /usr/sbin/cron

USER ${PUID}:${PGID}

ENTRYPOINT ["/entrypoint.sh"]
