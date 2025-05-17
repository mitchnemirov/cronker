#!/usr/bin/env sh

set -e

PUSH=true

while test $# -gt 0; do
  key=$1

  case $key in
    --no-push)
      PUSH=false
      shift ;;
    *)
      break ;;
  esac
done

docker build -t ghcr.io/mitchnemirov/cronker:prod .
if ($PUSH); then
  docker push ghcr.io/mitchnemirov/cronker:prod
fi
