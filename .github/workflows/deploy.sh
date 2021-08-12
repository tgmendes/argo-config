#!/usr/bin/env bash

FILTEREDLABELS=$(echo $1 | jq '.labels' | jq -r '.[] | .name ')

DOCKER_IMAGE=$(echo $1 | jq '.tags')

APPS=()
NAMESPACES=()

# @TODO support "all-env" "all-app" ect
for label in $FILTEREDLABELS
do
    if [[ $label == "env-"* ]]; then
      NAMESPACES+=($label)
    fi

    if [[ $label == "svc-"* ]]; then
      APPS+=($label)
    fi
done

echo "docker-image: $DOCKER_IMAGE"
echo "namespaces: ${NAMESPACES[@]}"
echo "apps: ${APPS[@]}"
