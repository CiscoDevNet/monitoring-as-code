# start from a base image
FROM curlimages/curl as build

# set environment variables
ENV EXTENSION_SOURCE_FILE_NAME apigee-monitoring-extension-3.2.zip
ENV EXTENSION_CONTAINER_DIRECTORY /tmp/appd-extension

# copy files from local file system
COPY $EXTENSION_SOURCE_FILE_NAME /tmp

# create a temp directory
RUN mkdir $EXTENSION_CONTAINER_DIRECTORY

# unzip files to temp directory
RUN unzip /tmp/${EXTENSION_SOURCE_FILE_NAME} -d $EXTENSION_CONTAINER_DIRECTORY

# build an image 
# this second FROM instruction starts a new build stage with the machine agent image as its base
FROM appdynamics/machine-agent-analytics:20.8.0
ENV APPD_DIRECTORY=/opt/appdynamics
ENV EXTENSION_CONTAINER_DIRECTORY /tmp/appd-extension

WORKDIR $APPD_DIRECTORY

# install dependencies needed to run an extension
RUN apt update -y && \
  apt install jq -y && \
  apt install curl -y

# COPY --from= line copies just extension files from the previous stage into to machine agent's `monitors` folder
COPY --from=build $EXTENSION_CONTAINER_DIRECTORY /opt/appdynamics/monitors/


