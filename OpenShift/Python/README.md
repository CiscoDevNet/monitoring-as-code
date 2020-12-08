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

# Deploying an agent




