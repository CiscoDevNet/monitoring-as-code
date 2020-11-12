
# Create project
```
oc new-project appd-dotnet-project
```

# Execute namespace permission fix
```
permission-fix.sh
```

# Deploy secrets
```
oc apply -f dotnet-appd-secrets.yaml
```

# Deploy ConfigMap
```
oc apply -f dotnet-config-map.yaml
```

# Service account

Create service account:
```
oc create sa appd-account
```

Set Security Context Constraints for service account:
```
oc adm policy add-scc-to-user anyuid -z appd-account
```

`anyuid` - the equivalent as allowing UID 0, or root user, both inside and outside the container
https://www.openshift.com/blog/managing-sccs-in-openshift


# Deploy application
Deploy Pods or Deployments, instrument with AppD agents using init containers (init-cont.yml) or auto-instrumentation (auto-instr.yml):

## a) Use pod to deploy the application with AppD agent
```
oc apply -f dotnet-pod-init-cont.yml
oc apply -f dotnet-pod-auto-instr.yml
```

## b) Use deployment
```
oc apply -f dotnet-deployment-init-cont.yml
oc apply -f dotnet-deployment-auto-instr.yml
```

# Set namespaces to monitor

## Include-exclude namespaces

There are two options available:

### a) From the Controller UI panel
In the upper-right corner, click the Settings icon  > AppDynamics Agents.
Select the Cluster Agents tab to display a list of clusters. Click Configure.
Add or remove namespaces (projects)

### b) Using Cluster Agent configuration (preferred)

"Modify the nsToMonitor field in the cluster-agent.yaml file before deploying the Cluster Agent. Namespaces mentioned in the nsToMonitor field are only considered during initial registration." [...] however nsToMonitorRegex field can be dynamically changed.
https://docs.appdynamics.com/display/PRO45/Use+the+Cluster+Agent

Note that 'nsToMonitorRegex' parameter supersedes nsToMonitor. If you do not specify any value for this parameter, Cluster Agent uses the default value of nsToMonitor.

To use the 'nsToMonitorRegex' field, ensure that you are using the Controller version 20.10 or later and the agent version 20.9 or later.

## Namespace update common scenarios

The following are common namespace behavior scenarios with the nsToMonitor field:

- After the Cluster Agent's initial registration, the namespaces are retrieved from the Cluster Agent YAML file.
- After initial registration, if the Cluster Agent restarts and the Controller is running, the Controller UI's user namespace settings take precedence.
- After initial registration, if the Controller restarts and the Cluster Agent is running, any previous change made to the namespaces in the Controller UI are preserved.
- If both the Cluster Agent and the Controller restart, the namespaces are retrieved from the YAML file.

https://docs.appdynamics.com/display/PRO45/Use+the+Cluster+Agent

# Instrument application and correlate APM agents with Cluster Agent

There are two main options to consider:

## Init containers
When init container is used, UNIQUE_HOST_ID can be set in order to correlate APM agent and cluster agent metrics:
https://docs.appdynamics.com/display/PRO45/Configure+App+Agents+to+Correlate+with+Cluster+Agent

To be used with Java applications only.

## Auto-instrumentation (preferred)

Without need to use init containers, auto-instrumentation can be used to inject agent and correlate APM with cluster agent.

Make sure to deploy Cluster Agent resources before proceeding with this approach.

Note the following limitation:
"If your Controller is using a self-signed certificate, only auto-instrumentation for Java applications is supported."

This requires cluster configuration to be updated (`cluster-agent.yaml`), and auto-instrumentation config to be added, for example:

```
instrumentationMethod: Env
  nsToInstrumentRegex: ecom|books|groceries
  appNameStrategy: manual
```

Note that for this approach, an additional secret needs to be added, so instead of `secret-init-containers.sh` use `secret-auto-instrumentation.sh`.

# Failed pods - when pods are getting deleted?

I did check internally, and the developers confirmed Failed Pods are deleted when:
1)namespace is deleted
2)namespace is set to un-monitor

Controller Version: 20.7.0-1516
Failed pods (Historical/Non-Historical) are successfully deleted from the controller on namespace deletion

https://appdynamics.zendesk.com/agent/tickets/243414


