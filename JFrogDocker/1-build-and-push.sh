#!/bin/bash

# example script usage:
# ./1-build-and-push.sh curl-appd 20.11 my-server.jfrog.io repo-name alex ug785HJH-my-access-key-UFJKHJ56321

image_name=${1}
image_tag=${2}

jfrog_server=${3}
jfrog_repo=${4}
jfrog_user=${5}
jfrog_apikey=${6}


if [ "$image_name" = "" ]; then
    image_name="curlimages-appd-agent-files"
fi

if [ "$image_tag" = "" ]; then
    image_tag="latest"
fi


if [ "$jfrog_server" = "" ]; then
    jfrog_server="my-server.jfrog.io"
fi

if [ "$jfrog_repo" = "" ]; then
    jfrog_repo="docker-local-repository"
fi

if [ "$jfrog_user" = "" ]; then
    jfrog_user="<username-here>"
fi

if [ "$jfrog_apikey" = "" ]; then
    jfrog_apikey="<access-key-here>"
fi

handle="$jfrog_server/$jfrog_repo"

# 1. Build Docker image
docker build -t "${handle}/${image_name}:${image_tag}" . --no-cache

# 2. JFrog artifactory server needs to be set before the following step
# docs: https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory#CLIforJFrogArtifactory-Configuration
## for example:
## jfrog rt config my-server-id --url https://my-server.jfrog.io/artifactory --user <user-here> --apikey <api-key-here>
## jfrog rt use my-server-id

# 3. Run Docker image
# docker run alexappd/curlimages-appd-agent-files:latest

# 4. Push Docker image to JFrog Artifactory
# docs: https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory#CLIforJFrogArtifactory-PushingDockerImagesUsingtheDockerClient

jfrog rt docker-push "${handle}/${image_name}:${image_tag}" $jfrog_repo --url="https://$jfrog_server/artifactory" --user="$jfrog_user" --apikey="$jfrog_apikey"

# 5. Pull images
# docs: https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory#CLIforJFrogArtifactory-PullingDockerImagesUsingtheDockerClient

jfrog rt docker-pull "${handle}/${image_name}:${image_tag}" $jfrog_repo --url="https://$jfrog_server/artifactory" --user="$jfrog_user" --apikey="$jfrog_apikey"