#!/bin/bash

dockerhub_handle=${1}
image_name=${2}
image_tag=${3}

if [ "$dockerhub_handle" = "" ]; then
    dockerhub_handle="alexappd"
fi

if [ "$image_name" = "" ]; then
    image_name="cluster-agent"
fi

if [ "$image_tag" = "" ]; then
    image_tag="latest"
fi

docker build -t "${dockerhub_handle}/${image_name}:${image_tag}" -f Dockerfile . --no-cache