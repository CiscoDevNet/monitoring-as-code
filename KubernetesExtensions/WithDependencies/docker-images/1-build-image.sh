#!/bin/bash

DOCKERHUB_HANDLE="alexappd"
IMAGE_NAME="machine-agent-apigee"
TAG="latest"

docker build -t "${DOCKERHUB_HANDLE}/${IMAGE_NAME}:${TAG}" . --no-cache
