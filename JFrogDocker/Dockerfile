# start from an AppDynamics image as a base
FROM appdynamics/java-agent:latest as build

# build an image 
# this second FROM instruction starts a new build stage with the machine agent image as its base
FROM curlimages/curl

LABEL maintainer your@email.com

ENV APPD_DIRECTORY=/opt/appdynamics
#todo - update with location on your image
ENV APPD_DIRECTORY_MY_IMAGE=/tmp/appdynamics 

RUN mkdir $APPD_DIRECTORY_MY_IMAGE

RUN whoami
USER root

#todo - e.g. image hardening goes here
RUN adduser -D limited_user
USER limited_user

# COPY --from= line copies just extension files from the previous stage
COPY --from=build $APPD_DIRECTORY $APPD_DIRECTORY_MY_IMAGE


