# Monitoring Python Applications with AppDynamics


# Preparation

## Check Supported Environments

Refer to the [documentation](https://docs.appdynamics.com/display/PRO45/Python+Supported+Environments) for latest list of supported environments.

"AppDynamics has tested the Python Agent on Tornado, Django, Flask, CherryPy, Bottle, and Pyramid.
You can configure the agent to instrument any WSGI-based application or framework as Python Web [...]."

## Create a project 

```
oc new-project python-project
```

## Service account

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

```
oc apply -f python-agent-config-map.yml
```

# Deploy an Agent

In this project as an underlying application we used Python app utilizing Flask framework, and it can be found in `python-flask-docker` folder of this project, or downloaded from https://github.com/lvthillo/python-flask-docker.git.

With python agent, you can 1) build an image that is going to contain Appdynamics package, or 2) use an existing image but override entrypoint command. In the section below, we'll cover both scenarios.

For any of the scenarios, bear in mind that Django and Flask applications need to be started with `pyagent`, so a startup command probably needs to be updated.

### 1) Building an image with AppDynamics package

Install AppDynamics package and configuration during a build phase, by adding commands to your existing Docker files. Build instructions for the underlying application can be found in the `Dockerfile.instr`.

Build an image based on this file by executing `docker-build.sh`, pass the DockerHub handle, image name and tag name, for example:

```
./docker-build.sh appd my-new-python-agent-image
```

### 2) Override existing image entrypoint command

This option does not require re-building an image, however, required packages and way of starting an application are overridden in manifest's `command` and `args` section. 







