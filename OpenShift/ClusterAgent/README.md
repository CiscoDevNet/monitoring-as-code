

# Documentation
https://docs.appdynamics.com/display/PRO45/Deploy+the+AppDynamics+Operator+on+Red+Hat+OpenShift

# Start OpenShift cluster
```
oc cluster up --public-hostname=<host-name>
```

# Login to console
```
oc whoami
```
e.g. system:admin

# Create a project
```
oc new-project appdynamics
```

## Verify
```
oc get project
```

# Deploy secrets
## 1) when init containers are used:
```
./secret-init-containers.sh
```
## 2) when auto-instrumentation is used (preferred)
```
secret-auto-instrumentation.sh
```
Docs: https://docs.appdynamics.com/display/PRO45/Enable+Auto-Instrumentation+of+Supported+Applications#EnableAuto-InstrumentationofSupportedApplications-enable

# Execute permission fix

./permission-fix-20.7.sh

# Make sure user has rights to perform updates on the cluster
```
oc adm policy add-role-to-user <role> <user>
```
e.g. 
```
oc adm policy add-role-to-user admin system
```

# Create operator
```
oc create -f cluster-agent-operator-openshift.yaml
```

# Configure and deploy cluster agent
```
oc apply -f cluster-agent.yaml
```

# If needed, deploy infrastructure visibility agent:
```
oc apply -f infraviz-agent.yaml
```


# Refs (examples)

## cluster agent
https://github.com/Appdynamics/appdynamics-operator#clusteragent-deployment

## infrastructure visibility
https://github.com/Appdynamics/appdynamics-operator#the-machine-agent-deployment
