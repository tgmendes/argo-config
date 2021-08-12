#!/usr/bin/env bash

curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

helm version

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
