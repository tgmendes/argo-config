#!/usr/bin/env bash
set -e

helm version

ENVS=$(echo $1 | jq -r '.labels[] | select(.name | startswith("env-")).name')
SERVICES=$(echo $1 | jq -r '.labels[] | select(.name | startswith("svc-")).name')
DOCKER_IMAGE=$(echo $1 | jq -r '.tags')

for env in $ENVS
do
  if [ ! -d "nonprod/$env" ]; then
    echo "environment $env doesn't exist"; exit 1;
  fi

  for svc in $SERVICES
  do
    SERVICE_PATH=nonprod/$env/services/$svc
    echo "processing $SERVICE_PATH"

    mkdir -p $SERVICE_PATH
    helm template charts/application --set service.name=$svc --set service.image=$DOCKER_IMAGE > $SERVICE_PATH/app.yaml
  done
done

tree nonprod
