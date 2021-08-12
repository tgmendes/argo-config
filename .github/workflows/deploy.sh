#!/usr/bin/env bash
set -e

ENVS=$(echo $1 | jq -r '.labels[] | select(.name | startswith("env-")).name')
SERVICES=$(echo $1 | jq -r '.labels[] | select(.name | startswith("svc-")).name')
DOCKER_IMAGE=$(echo $1 | jq -r '.tags')
COMMIT_HASH=$(echo $DOCKER_IMAGE | cut -d ':' -f 2)

COMMIT_MSG="Deployment summary: \n\r\n\r"

RAN=false
for env in $ENVS
do
  if [ ! -d "nonprod/$env" ]; then
    echo "environment $env doesn't exist"; exit 1;
  fi

  COMMIT_MSG+="Deploying to $env \n"

  for svc in $SERVICES
  do
    SERVICE_PATH=nonprod/$env/services/$svc
    echo "processing $SERVICE_PATH"

    COMMIT_MSG+="Deploying $svc \n"

    mkdir -p "$SERVICE_PATH"
    helm template charts/application \
      --set commitHash=$COMMIT_HASH \
      --set env=$env \
      --set service.name=$svc \
      --set service.image=$DOCKER_IMAGE > $SERVICE_PATH/app.yaml

    RAN=true
  done
done

if [ $RAN = false ]; then
  exit 1;
fi

tree nonprod

git config user.name the-deployer
git config user.email the-deployer@github.com
git add .
git commit -m "$COMMIT_MSG"
git push
