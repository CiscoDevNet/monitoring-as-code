## Cluster agent operator

### Building an image

Source code for AppDynamics Cluster agent operator can be found (here)[https://github.com/Appdynamics/appdynamics-operator].

Based on a (Dockerfile)[https://github.com/Appdynamics/appdynamics-operator/blob/master/build/Dockerfile] provided, multi-stage Dockerfile that can be found in this directory is provided.

By running a `1-build.sh` script, and providing necessary parameters, an image is built based steps defined in `Dockerfile`.

Image can then be pushed to any image repository:

`docker push <registryname>/<accountname>/cluster-agent-operator:<Agent-version>`