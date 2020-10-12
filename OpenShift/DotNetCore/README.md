

# Create project
oc new-project appd-dotnet-project

# Deploy secrets
oc apply -f dotnet-appd-secrets.yaml

# Deploy ConfigMap
oc apply -f dotnet-config-map.yaml

# Deploy application with AppD init container agent
oc apply -f dotnet-pod-init-cont.yml


# Add application project to server 

The following are common namespace behavior scenarios with the nsToMonitor field:

    After the Cluster Agent's initial registration, the namespaces are retrieved from the Cluster Agent YAML file.
    After initial registration, if the Cluster Agent restarts and the Controller is running, the Controller UI's user namespace settings take precedence.
    After initial registration, if the Controller restarts and the Cluster Agent is running, any previous change made to the namespaces in the Controller UI are preserved.
    If both the Cluster Agent and the Controller restart, the namespaces are retrieved from the YAML file.

## include-exclude namespaces

From the Controller UI panel:
    In the upper-right corner, click the Settings icon  > AppDynamics Agents.
    Select the Cluster Agents tab to display a list of clusters. Click Configure.
    Add or remove namespaces (projects)

OR

 "Modify the nsToMonitor field in the cluster-agent.yaml file before deploying the Cluster Agent. Namespaces mentioned in the nsToMonitor field are only considered during initial registration." [...]but nsToMonitorRegex field can be dynamically changed.
 https://docs.appdynamics.com/display/PRO45/Use+the+Cluster+Agent

To use the nsToMonitorRegex field, ensure that you are using the Controller version 20.10 or later and the agent version 20.9 or later.


# Correlate Application agents with ClusterAgent

https://docs.appdynamics.com/display/PRO45/Configure+App+Agents+to+Correlate+with+Cluster+Agent

UNIQUE_HOST_ID

https://kubernetes.io/docs/tasks/inject-data-application/define-interdependent-environment-variables/#define-an-environment-dependent-variable-for-a-container