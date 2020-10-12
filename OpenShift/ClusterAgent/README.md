

# Documentation
https://docs.appdynamics.com/display/PRO45/Deploy+the+AppDynamics+Operator+on+Red+Hat+OpenShift

# Start OpenShift cluster
`
oc cluster up --public-hostname=<host-name>
`

# Login to console
`
oc whoami
`
e.g. system:admin

# Create a project
`
oc new-project appdynamics
`

## Verify
`
oc get project
`

# Deploy secrets
./secret.sh

# Execute permission fix
./permission-fix-20.7.sh
`
oc adm policy add-role-to-user <role> <user>
`
e.g. 
`
oc adm policy add-role-to-user admin system
`

# Create operator
`
oc create -f cluster-agent-operator-openshift.yaml
`

# Configure and deploy cluster agent

`
oc apply -f cluster-agent.yaml
`

