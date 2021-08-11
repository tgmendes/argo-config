#!/usr/bin/env bash

FILTEREDLABELS=$(jq -r '.labels' "$1" | jq -r '.[] | .name ')

DOCKER_IMAGE=$(jq -r '.tags' "$1")

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
