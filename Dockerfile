FROM ubuntu:latest

LABEL org.opencontainers.image.source=https://github.com/mitchnemirov/cronker

ENV PUID=1000
ENV PGID=1000
ENV TZ=UTC

RUN apt-get update && \
    apt-get install -yqq --no-install-recommends \
    cron \
    tzdata \
    gettext && \
    apt-get autoremove -y && \
    apt-get clean autoclean && \
    rm -rf \
    /var/lib/apt \
    /var/lib/dpkg \
    /var/lib/cache \
    /var/lib/log

WORKDIR /app

COPY . .

RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]

CMD ["cron", "-f"]
