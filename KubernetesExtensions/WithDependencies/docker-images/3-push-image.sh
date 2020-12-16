#!/bin/bash

dockerhub_handle=${1}
image_name=${2}
image_tag=${3}

if [ "$dockerhub_handle" = "" ]; then
    dockerhub_handle="appdynamics"
fi

if [ "$image_name" = "" ]; then
    image_name="machine-agent-extension"
fi

if [ "$image_tag" = "" ]; then
    image_tag="latest"
fi

docker push "${dockerhub_handle}/${image_name}:${image_tag}"
