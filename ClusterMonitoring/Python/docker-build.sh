#!/bin/bash

dockerhub_handle=${1}
image_name=${2}
image_tag=${3}

if [ "$dockerhub_handle" = "" ]; then
    dockerhub_handle="appdynamics"
fi

if [ "$image_name" = "" ]; then
    image_name="python-flask-docker-agent"
fi

if [ "$image_tag" = "" ]; then
    image_tag="latest"
fi

docker build -t $dockerhub_handle/$image_name:$image_tag . -f  Dockerfile.instr


# docker build -t alexappd/python-flask-docker-agent:latest . -f  Dockerfile.instr
# docker run -p 8080:8080 alexappd/python-flask-docker-agent:latest
