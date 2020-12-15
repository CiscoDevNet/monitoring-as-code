# Monitoring Python Applications with AppDynamics

# 1. Preparation

## Check Supported Environments

Refer to the [documentation](https://docs.appdynamics.com/display/PRO45/Python+Supported+Environments) for latest list of supported environments.

"AppDynamics has tested the Python Agent on Tornado, Django, Flask, CherryPy, Bottle, and Pyramid.
You can configure the agent to instrument any WSGI-based application or framework as Python Web [...]."

## Create a project/namespace [Optional]

Create a project/namespace that is going to contain application resources.

OpenShift:
```
oc new-project python-project
```
Kubernetes:
```
kubectl create namespace python-project
kubectl config set-context --current --namespace=python-project
```

## Service account [OpenShift only]

A service account provides an identity for processes that run in a Pod. 
https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/

Create a service account:
```
oc create sa appd-account
```

Set Security Context Constraints for service account:
```
oc adm policy add-scc-to-user anyuid -z appd-account
```

`anyuid` - the equivalent as allowing UID 0, or root user, both inside and outside the container
https://www.openshift.com/blog/managing-sccs-in-openshift

### Provide agent configuration

Update YAML file to enable agent to connect to the controller, and apply to your project.

Compete list of NodeJS agent settings can be found in the documentation [here](https://docs.appdynamics.com/display/PRO45/Node.js+Settings+Reference).

```
oc apply -f python-agent-config-map.yml
```
```
kubectl apply -f python-agent-config-map.yml
```

# 2. Deploy an Agent

In this project as an underlying application we used Python app utilizing Flask framework, and it can be found in `python-flask-docker` folder of this project, or downloaded from https://github.com/lvthillo/python-flask-docker.git.

With python agent, you can 1) build an image that is going to contain Appdynamics package, or 2) use an existing image but override entrypoint command. In the section below, we'll cover both scenarios.

For any of the scenarios, bear in mind that Django and Flask applications need to be started with `pyagent`, so a startup command probably needs to be updated.

### 1) Building an image with AppDynamics package (recommended)

Install AppDynamics package and configuration during a build phase, by adding commands to your existing Docker files. Build instructions for the underlying application can be found in the `Dockerfile.instr`.

Build an image based on this file by executing `docker-build.sh`, pass the DockerHub handle, image name and tag name, for example:

```
./docker-build.sh appd my-new-python-agent-image
```

You can run your image to test it before proceedinf to the next section.

```
docker run -p 8080:8080 appd/my-new-python-agent-image:latest
```

For a complete manifest example, refer to `python-deployment-rewriting-dockerfile.yml` file.

### 2) Override existing image entrypoint command

This option does not require re-building an image, however, required packages and way of starting an application are overridden in manifest's `command` and `args` section. 

Build your image as you usually do, or use existing ones, in our case, steps of bulding an image without instrumentation can be found in this file `Dockerfile.withoutInstr`.

Then, manifest is updated to install required packange and start an application qith `pyagent`:

<img width="878" alt="python-override-entrypoint-manifest" src="https://user-images.githubusercontent.com/23483887/101621403-9c86d500-3a0d-11eb-9b70-b47c065e862d.png">

Refer to `python-deployment-no-image-updates.yml` file for a complete example.

## Provide agent configuration

Agent configuration is applied as a ConfigMap and mounted as a volume.

<img width="756" alt="python-config-volume-mount" src="https://user-images.githubusercontent.com/23483887/101621715-069f7a00-3a0e-11eb-97fb-aa2a98a32596.png">

```
oc apply -f python-agent-config-map.yml
```
```
kubectl apply -f python-agent-config-map.yml
```

<img width="652" alt="python-config-configmap-as-volume" src="https://user-images.githubusercontent.com/23483887/101621816-26cf3900-3a0e-11eb-9319-7c0ed8bc745b.png">


