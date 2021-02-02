ARG APPD_VERSION=0.6.6

FROM appdynamics/cluster-agent-operator:${APPD_VERSION} as build

# build an image 
# this second FROM instruction starts a new build stage with the machine agent image as its base
#todo replace with base image
FROM curlimages/curl 

LABEL maintainer your@email.com

ENV OPERATOR_DIR=/usr/local/bin/appdynamics-operator
ENV LICENSE_DIR=/licenses/
ENV BUILD_DIR=/usr/local/bin

ENV OPERATOR=appdynamics-operator \
    USER_UID=1001 \
    USER_NAME=appdynamics-operator

USER root
RUN mkdir $OPERATOR_DIR
RUN mkdir $LICENSE_DIR

# COPY --from= line copies just extension files from the previous stage
COPY --from=build $OPERATOR_DIR $OPERATOR_DIR
COPY --from=build $LICENSE_DIR $LICENSE_DIR
COPY --from=build $BUILD_DIR $BUILD_DIR

# RUN ls $BUILD_DIR
# RUN /usr/local/bin/ensure-user.sh

ENTRYPOINT ["/usr/local/bin/start.sh"]

USER 1001
