#!/usr/bin/env bash

helm version

ENVS=$(echo $1 | jq -r '.labels[] | select(.name | startswith("env-")).name')
SERVICES=$(echo $1 | jq -r '.labels[] | select(.name | startswith("svc-")).name')
DOCKER_IMAGE=$(echo $1 | jq -r '.tags')

for env in $ENVS
do
  for svc in $SERVICES
  do
    SERVICE_PATH=nonprod/$env/services/$svc
    echo "processing $SERVICE_PATH"

    mkdir -p $SERVICE_PATH
    helm template charts/application --set service.name=$svc --set service.image=$DOCKER_IMAGE > $SERVICE_PATH/app.yaml

    ls -lhart $SERVICE_PATH
  done
done

## @TODO support "all-env" "all-app" ect
#for label in $FILTEREDLABELS
#do
#    if [[ $label == "env-"* ]]; then
#      NAMESPACES+=($label)
#    fi
#
#    if [[ $label == "svc-"* ]]; then
#      APPS+=($label)
#    fi
#done
#
#echo "docker-image: $DOCKER_IMAGE"
#echo "namespaces: ${NAMESPACES[@]}"
#echo "apps: ${APPS[@]}"
