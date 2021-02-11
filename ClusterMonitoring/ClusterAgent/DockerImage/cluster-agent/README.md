## Cluster agent

### Building an image

There are two main approaches that can be taken in order to build a Cluster agent image.

### 1. Building an image from binaries

Following the documentation about building a Cluster agent image that can be found [here](https://docs.appdynamics.com/display/PRO21/Build+the+Cluster+Agent+Container+Image), after downloading files from the [download portal](https://accounts.appdynamics.com/downloads#version=&apm=cluster-agent&os=&platform_admin_os=&appdynamics_cluster_os=&events=&eum=&page=1), focus on the `cluster-agent/docker` folder for this process.

Cluster agent folder already contains the `cluster-agent.zip` file, that can be replaced with custom files. This would be a simple process of unzipping cluster-agent compressed collection, updating desired values, and creating a zip file that can be used for this process.

Note: Replace currently used base image with your company's approved base image where it is outlined in the Dockerfile with #todo comment before proceeding. In case that an image is being built for test and proof-of-concept purposes, you can continue with the current one. 

By running a `1-build.sh` script, and providing necessary parameters, an image is built based steps defined in `Dockerfile`.

Image can then be pushed to any image repository, as also outlined in the [documentation](https://docs.appdynamics.com/display/PRO21/Build+the+Cluster+Agent+Container+Image#BuildtheClusterAgentContainerImage-custom-image):

`docker push <registryname>/<accountname>/cluster-agent:<Agent-version>`

### 2. Building an image with multi-stage build

Using the approach of building an Cluster agent operator, instead of zipping files, they can be transferred directly from pre-built Cluster image AppDynamics publishes and stores in DockerHub, [here](https://hub.docker.com/r/appdynamics/cluster-agent).

In case you are going to follow this approach and need more examples on it, reach out to AppDynamics representative and we can provide a working example.

