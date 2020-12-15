# 1. Overview

There are three methods of monitoring containerised applications running on Kubernetes and OpenShift clusters. They are: 
1. Bundle the APM agent binaries into your Docker image 
2. Using the Init container approach and 
3. Auto-instrumentation using the Cluster agent. 

Option 3 is the recommended approach for three main reasons: 
- It provides cluster-to-container correlation health monitoring  
- It does not require modification of Docker files or your existing kubernetes manifests and yaml file.  This means app owners can continue to deploy their - applications without AppD’s awareness. 
- It is in line with our long term zero-touch observability strategy 

This is an excerpt from our documentation: 
“AppDynamics recommends auto-instrumentation of containers because it provides the simplest operational experience. However, if you cannot use auto-instrumentation, you should use init containers to copy agent files to simplify the agent upgrade and promote separation of concerns. For non-Kubernetes environments, Dockerfiles is the best option to use when copying the agent files at build time.”

Follow [this](https://docs.appdynamics.com/display/PRO45/Deploy+the+AppDynamics+Operator+on+Red+Hat+OpenShift) link to navigate to OpenShift-specific Cluster Agent documentation.

Steps below are going to apply for OpenShift (`oc` commands) and Kubernetes (`kubectl` commands). Please also note that for OpenShift additional permission steps are going to be required, and those chapters are going to be marked with [OpenShift only].

# 2. Preparation steps

## 2.1 Verify the environment

Before starting the installation, verify that you have:

- kubectl version 1.11.3 or later
- Access to a Kubernetes cluster version 1.14 or later
- AppDynamics Controller versions 20.3.0 and later, and configured the Controller Settings for the Cluster Agent

Refer to the [documentation](https://docs.appdynamics.com/display/PRO45/Cluster+Agent+Requirements+and+Supported+Environments) for a full list of supported environments.

## Prepare CLuster [OpenShift only]
Start a cluster:
```
oc cluster up --public-hostname=<host-name>
```
Login to console:
```
oc whoami
```
e.g. system:admin

## Create a project/namespace

Create a project/namespace that is going to contain AppDynamics resources.

OpenShift:
```
oc new-project appdynamics
```
![openshift-cluster-agent-project](https://user-images.githubusercontent.com/23483887/101359401-214de380-3894-11eb-82f9-df66e76c1979.png)

Kubernetes:
```
kubectl create namespace appdynamics
kubectl config set-context --current --namespace=appdynamics
```
<img width="597" alt="kubernetes-cluster-agent-project" src="https://user-images.githubusercontent.com/23483887/102226371-35bb5d00-3ee0-11eb-9869-e702dc7317d6.png">

### Verify

Verify that you can see newly created project/namespace

OpenShift:
```
oc get project
```
Kubernetes:
```
kubectl config view --minify --output 'jsonpath={..namespace}'
```

## Deploy secrets

Secrets needed to be provided to Cluster Agent depend on monitoring strategy that you choose.

Documentation about these secret values can be found in the documentation [here](https://docs.appdynamics.com/display/PRO45/Enable+Auto-Instrumentation+of+Supported+Applications#EnableAuto-InstrumentationofSupportedApplications-enable).

To get controller access key and account, click on a Gear icon at the top right of the controller's screen, choose License from a drop-down menu and Account tab, where Name value is account's name and Access key is a hidden value that can be shown.

### 1) Auto-instrumentation (recommended)

Additional secret is needed in case when auto-instrumentation is used. The `api-user` with Administrator access added here is required to mark the nodes historical upon pod deletion.

```
Secrets/secret-auto-instrumentation.sh
```

![cluster-agent-secret](https://user-images.githubusercontent.com/23483887/101352766-88ff3100-388a-11eb-8ec3-0cbef4f5299a.png)

Update `<access-key>` with a plaintext controller's access key and replace `<username>@<customer>:<password>` with your user's values.

Apply to cluster:
```
oc apply -f Secrets/secret-auto-instrumentation.sh
```
```
kubectl apply -f Secrets/secret-auto-instrumentation.sh
```

### 2) Init containers

In case of this instrumentation strategy, update `<access-key>` with a plaintext controller's access key:

```
Secrets/secret-init-containers.sh
```

Apply to cluster:
```
oc apply -f Secrets/secret-auto-instrumentation.sh
```
```
kubectl apply -f Secrets/secret-auto-instrumentation.sh
```

## Execute permission fix [OpenShift only]

In order not to get perission denied when creating a cluster agent resource, as below, permission fix needs to be executed.

![cluster-agent-permissiion-denied](https://user-images.githubusercontent.com/23483887/101352817-987e7a00-388a-11eb-9b3a-473d9f72c667.png)

```
./permission-fix-20.7+.sh
```

## User rights [OpenShift only]

Make sure user has rights to perform updates on the cluster:

```
oc adm policy add-role-to-user <role> <user>
```
e.g. 
```
oc adm policy add-role-to-user admin system
```
    
# 3. Deploy Cluster Agent

## Create operator

Download Cluster agent files from our AppDynamics [download centre](https://download.appdynamics.com/download/#version=&apm=cluster-agent&os=&platform_admin_os=&appdynamics_cluster_os=&events=&eum=&page=1&apm_os=windows%2Clinux%2Calpine-linux%2Cosx%2Csolaris%2Csolaris-sparc%2Caix).

Operator file can be found in your download bundle (OpenShift example below):

`./appdynamics-cluster-agent-<version>/cluster-agent-operator-openshift.yaml`
  
Here, custom resources that are extending mechanisms of Kuberetees are defined, and when applied to a cluster will be running in the cluster pods, interacting with Kubernetes API and sending metrics back to Appdynamics controller.

After deploying an operator (`kubectl apply` or `oc apply`), in order to configure a Cluster agent, `cluster-agent.yaml` is used, that when deployed to a cluster is configuring a Clusteragent custom resource defined in the operator.

```
kubectl apply -f Kubernetes/cluster-agent-operator.yaml -n appdynamics
```

```
oc apply -f OpenShift/cluster-agent-operator-openshift.yaml
```

Documentation about how to deploy an Operator can be found [here](https://docs.appdynamics.com/display/PRO45/Deploy+the+AppDynamics+Operator+on+Kubernetes).

Also, you can find a ClusterAgent Operator GitHub project [here](https://github.com/Appdynamics/appdynamics-operator) where issues can be raised and latest examples accessed from.

## Configure and deploy cluster agent

Configure Cluster Agent to connect to controller, filter namespaces to monitor, instrument applications, set logging level and similar.

<img width="615" alt="cluster-agent-config" src="https://user-images.githubusercontent.com/23483887/101360739-fc5a7000-3895-11eb-9747-2de9070ec31c.png">

On how to configure any of the available YAML config parameters, refer to the [documentation](https://docs.appdynamics.com/display/PRO45/Configure+the+Cluster+Agent).

Apply Cluster Agent to the cluster:

```
kubectl apply -f cluster-agent.yaml -n appdynamics
```

```
oc apply -f cluster-agent.yaml
```

Minimal configuration for a ClusterAgent can be found in `cluster-agent-minimal.yaml`, and full configuration in a file `cluster-agent-full.yaml`.

For a detailed documentation about ClusterAgent configuration, refer to the official [documentation](https://docs.appdynamics.com/display/PRO45/Configure+the+Cluster+Agent).

### Validate

If everything run as expected, you should be seeing Cluster Agent under the Servers > Clusters menu:

![cluster-agent-servers](https://user-images.githubusercontent.com/23483887/101352639-60773700-388a-11eb-86bb-3f10a16300b7.png)

Here, you can access the dashboard for each monitored cluster:

![cluster-agent-dash](https://user-images.githubusercontent.com/23483887/101352708-771d8e00-388a-11eb-8f99-586ccf0cb939.png)

Also, resources created are going to be visible in the console:

![cluster-agent-pods](https://user-images.githubusercontent.com/23483887/101352656-6836db80-388a-11eb-83d8-4592a017ed70.png)

# 4. Set namespaces/projects to monitor

## Include-exclude namespaces

When it comes to choosing which namespaces to monitor, there are two options available:

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


# 5. Additional resources

GitHub repo with additional resources ia also available, and can be found [here](https://github.com/Appdynamics/appdynamics-operator#clusteragent-deployment).


# 6. Infrastructure visibility

I order to monitor nodes, infrastructure visibility can be deployed to instrument each machine. 
This is not an recommended approach as it can consume additional resources and monitoring should be based on cluster events and pod monitoring, however, if needed, deploy infrastructure visibility agent:

```
kubectl apply -f infraviz-agent.yaml
```

```
oc apply -f infraviz-agent.yaml
```

You can access a GitHub with examples [here](https://github.com/Appdynamics/appdynamics-operator#the-machine-agent-deployment).




