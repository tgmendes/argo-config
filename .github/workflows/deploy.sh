#!/usr/bin/env bash

helm version

ENVS=$(echo $1 | jq -r '.labels[] | select(.name | startswith("env-")).name')
SERVICES=$(echo $1 | jq -r '.labels[] | select(.name | startswith("svc-")).name')
DOCKER_IMAGE=$(echo $1 | jq -r '.tags')

echo $ENVS
echo $SERVICES
echo $DOCKER_IMAGE

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
