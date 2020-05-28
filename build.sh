#!/bin/bash

set -e

IMAGE_PATH=presidenten
IMAGE_NAME=lazygit
IMAGE_VERSION=1.0.1

USER_UID=1001
USER_GID=1001

DOCKER_BUILDKIT=1 docker image build -t ${IMAGE_NAME}:${IMAGE_VERSION} \
  --build-arg UID=$USER_UID \
  --build-arg GID=$USER_GID \
  .

docker image tag ${IMAGE_NAME}:${IMAGE_VERSION} ${IMAGE_PATH}/${IMAGE_NAME}:${IMAGE_VERSION}
docker image tag ${IMAGE_NAME}:${IMAGE_VERSION} ${IMAGE_PATH}/${IMAGE_NAME}:${IMAGE_VERSION}

docker image ls | grep ${IMAGE_NAME} | grep $IMAGE_VERSION
