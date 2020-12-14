#!/bin/bash

DOCKERHUB_HANDLE="alexappd"
IMAGE_NAME="machine-agent-apigee"
TAG="latest"

docker run --env-file=local.docker.env "${DOCKERHUB_HANDLE}/${IMAGE_NAME}:${TAG}"