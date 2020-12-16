# 1. Preparation steps for application and APM agent deployment

Instrumenting NodeJS applications with AppDynamics agent can be done in multiple ways:
- Use Auto-Instrumentation (recommended)
- Use Init Containers
- Use a Dockerfile

## a) Auto-instrumentation (recommended) 

We are recommending auto-instrumentation whenever possible. 

You can auto-instrument:
- Node.js applications with the Node.js Agent
- .NET Core on Linux application with the .NET Agent for Linux
- Java applications with the Java Agent

[Requirements and Supported environments](https://docs.appdynamics.com/display/PRO45/Cluster+Agent+Requirements+and+Supported+Environments)

## b) Init containers

We will cover the option of using init containers in the following documentation, as it does not require re-building images but does require updating application manifests to mount volume and override startup command.

All necessary resources for this instrumentation approach can be found in `init-container-resources` sub-folder.

## c) Dockerfile

For the last option that involves building images from scratch, please refer to the [documentation](https://docs.appdynamics.com/display/PRO45/Install+the+Node.js+Agent+in+Containers#InstalltheNode.jsAgentinContainers-dockerfile).

## Create a project/namespace  [Optional]

Create a project/namespace that is going to contain application resources.

OpenShift:
```
oc new-project nodejs-project
```
Kubernetes:
```
kubectl create namespace nodejs-project
kubectl config set-context --current --namespace=nodejs-project
```

### Execute namespace permission fix [OpenShift only]

You either need to give the service account anyuid SCC or change the uid range for the project (appdynamics) to include 1001
``` 
./permission-fix.sh
```
In platforms such as Kubernetes and OpenShift this will be the equivalent of allowing UID 0, or root user, both inside and outside the container.
https://www.openshift.com/blog/managing-sccs-in-openshift

In case that project is still not visible from the OpenShift console,  add your currrent user (alice below) to project admins, for example:

```
oc adm policy add-role-to-user admin alice -n nodejs-project
```

## Deploy secrets

Provide the value of `account-access-key` as base64 encoded string, and apply the secrets file.

To encode a secret:
```
echo -n "plain-text-secret-value-here" | base64
```
To decode:
```
echo "base64-encoded-secret-here" | base64 -d
```
To apply:
```
oc apply -f appd-secrets.yaml
```

If created successfully, secret is going to be visible in the OpenShift project resources as well:
![Secrets](https://user-images.githubusercontent.com/23483887/101013432-2e00cd80-355c-11eb-9cf9-2a87fb884a76.png)

```
kubectl apply -f appd-secrets.yaml --namespace=nodejs-project
```

## Deploy ConfigMap

A ConfigMap is an API object used to store non-confidential data in key-value pairs. Pods can consume ConfigMaps as environment variables, command-line arguments, or as configuration files in a volume.

A [ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/) allows you to decouple environment-specific configuration from your container images, so that your applications are easily portable.

## a) Auto-instrumentation (recommended) 

Provide environment variable values in plaintext format and apply to a cluster.

```
oc apply -f nodejs-config-map.yaml
```
```
kubectl apply -f nodejs-config-map.yaml -n nodejs-project
```

You should be seeing created ConfigMap in resources.

## b) Init containers

Provide environment variable values in plaintext format, and update value of `APP_ENTRY_POINT` to match your app's entry point.

Apply changes to the cluster. 

```
oc apply -f nodejs-config-map.yaml
```
```
kubectl apply -f nodejs-config-map.yaml
```

You should be seeing created ConfigMap in resources.

Besides this, deploy 2 additional ConfigMaps:

### 1) shim.js

Compete list of NodeJS agent settings can be found in the documentation [here](https://docs.appdynamics.com/display/PRO45/Node.js+Settings+Reference).

Environment variables applied are used to copnfigure those necessary settings, mapping is provided in the following ConfigMap file:
```
appd-shim-config-map.yml
```
ConfigMap resource created from `shim.js` script, in the following way:

`kubectl create configmap appd-shim --from-file=shim.js -o yaml --dry-run=client`

This JavaScript code is created in order to change a behavior and correct already existing code, it's going to require appdynamics package ans start the application in a way specified in `APP_ENTRY_POINT` environment variable.

### 2) stars.sh

Additionally, the following file needs to be applied in this instrumentation scenario: 
```
appd-start-config-map.yml
```
This ConfigMap is created from a `start.sh` script that installs appdynamics dependencies and starts the previously created `shim.js` script.

## Create service account [OpenShift only]

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

# 2. Deploy application

Deploy Pods or Deployments, instrument with AppD agents using init containers (init-cont.yml) or auto-instrumentation (auto-instr.yml):

AppDynamics documentation about how to deploy NodeJS agent can be found [here](https://docs.appdynamics.com/display/PRO45/Install+the+Node.js+Agent+in+Containers).

## a) Use auto-instrumentation (recommended)

Make sure to deploy Cluster Agent before proceeding with this approach, an example can be found in the following file:

```
cluster-agent-nodejs.yml
```

In this scenario, you only deploy an application in a usual manner, without the need to change any of the manifests, and the example is provided in the file below:

```
oc apply -f nodejs-deployment-auto-instr.yml
```
```
kubectl apply -f nodejs-deployment-auto-instr.yml
```

Auto-instrumentation is then enabled by adding auto-instrumentation config section in `cluster-agent.yaml` file, and Cluster Agent automatically and dynamically applies the configuration changes to all applications in the cluster. An example of cluster agent configuration:

<img width="598" alt="Auto-Instrumentation Config Example" src="https://user-images.githubusercontent.com/23483887/101016659-02ccad00-3561-11eb-8217-f8cd217b6c88.png">

Refer to our documentation for all of the auto-instrumentation parameters explained in detail [Auto-Instrumentation Parameters](https://docs.appdynamics.com/display/PRO45/Enable+Auto-Instrumentation+of+Supported+Applications).

Complete documentation about Cluster Agent auto-instrumentation can be found [here](https://docs.appdynamics.com/display/PRO45/Enable+Auto-Instrumentation+of+Supported+Applications).

Note: Auto-instrumentation is available for Deployments only, for pods use init-containers.

## b) Use init containers

Cluster Agent is not necessary with this approach, however, an example can be found in `cluster-agent-node-init-cont.yml` file.

Init containers are an option available in Kubernetes environments to run additional containers at startup time that help initialize an application.

Appdynamics provides APM agent images in the [Docker Hub](https://hub.docker.com/u/appdynamics), and when used as init containers, can act as a delivery mechanism to copy the APM agent files into the application container at deploy time and then terminate.

In the repo, examples of how to use init containers with Deployments:

```
oc apply -f nodejs-deployment-init-cont.yml
```

# 3. Set namespaces/projects to monitor

## Include-exclude namespaces

When it comes to choosing which namespaces to monitor, there are two options below that are available, and usage of ClusterAgent configuration file (`custer-agent.yaml`) recommended to be used whenever possible.

### a) From the Controller UI panel

1) In the upper-right corner, click the Settings icon  > AppDynamics Agents.
2) Select the Cluster Agents tab to display a list of clusters. Click Configure.
3) Add or remove namespaces/projects

![UI namespaces](https://user-images.githubusercontent.com/23483887/101017420-fb59d380-3561-11eb-94a0-63aaf830151f.png)

### b) Using Cluster Agent configuration (recommended)

This is achieved by modifying the __nsToMonitor__ and/or __nsToMonitorRegex__ field in the `cluster-agent.yaml` file before deploying the Cluster Agent. 
Namespaces mentioned in the __nsToMonitor__ field are only considered during initial registration. However, __nsToMonitorRegex__ field can be dynamically changed.

Also, note that __nsToMonitorRegex__ parameter supersedes nsToMonitor. If you do not specify any value for this parameter, Cluster Agent uses the default value of __nsToMonitor__.

To use the __nsToMonitorRegex__ field, ensure that you are using the Controller version 20.10 or later and the agent version 20.9 or later.

An example of namespace and pod filters:

<img width="601" alt="Namespaces to monitor" src="https://user-images.githubusercontent.com/23483887/101020373-4f66b700-3566-11eb-9e09-02ba98302bb1.png">

More details can be found in the documentation [here](https://docs.appdynamics.com/display/PRO45/Use+the+Cluster+Agent).

#### Namespace update common scenarios

The following are common namespace behavior scenarios with the __nsToMonitor__ field:

- After the Cluster Agent's initial registration, the namespaces are retrieved from the Cluster Agent YAML file.
- After initial registration, if the Cluster Agent restarts and the Controller is running, the Controller UI's user namespace settings take precedence.
- After initial registration, if the Controller restarts and the Cluster Agent is running, any previous changes made to the namespaces in the Controller UI are preserved.
- If both the Cluster Agent and the Controller restart, the namespaces are retrieved from the YAML file.

These scenarios are also covered in the documentation [here](https://docs.appdynamics.com/display/PRO45/Use+the+Cluster+Agent).

# 4. Correlate APM agents with Cluster Agent

Correlation of APM agents and Cluster Agent depends on deployment techniquie previously chosen in [Deploy application](https://github.com/Appdynamics/monitoring-as-code/tree/features/openshift/OpenShift/DotNetCore#deploy-application) section.

It enables a direct link between Cluster agent monitored Pod and APM application in AppDynamics Applications. When successful, a link similar to this appears in Cluster Agent view:

![APM Correlation](https://user-images.githubusercontent.com/23483887/101019373-c8fda580-3564-11eb-8add-de67358eae6e.png)

## a) When you are using auto-instrumentation (recommended)

Without the need to use init containers, auto-instrumentation can be used to inject agent and correlate APM with cluster agent.

No additional actions are required in order to enable correlation.

## b) When you are using init containers

Set the UNIQUE_HOST_ID environment variable to enable APM correlation with the Cluster Agent. 

Documentation can be found [here](https://docs.appdynamics.com/display/PRO45/.Install+the+Node.js+Agent+in+Containers+v20.6#id-.InstalltheNode.jsAgentinContainersv20.6-SettheUNIQUE_HOST_IDEnvironmentVariable).

```
spec:
  containers:
    command: ["/bin/sh"]
    args: ["-c", "export UNIQUE_HOST_ID=$(sed -rn '1s#.*/##; 1s/(.{12}).*/\\1/p' /proc/self/cgroup) && node /nodejsapp/myapp.js"]
```

Refer to node application manifest `nodejs-deployment-init-cont.yml`.

# 5. Failed pods - when pods are getting deleted?

Failed Pods are deleted when:
1) namespace/project is deleted
2) namespace/project is set to un-monitor

Refer to [this](https://appdynamics.zendesk.com/agent/tickets/243414) support ticket for more details.




