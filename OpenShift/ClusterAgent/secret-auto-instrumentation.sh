 
#!/bin/bash

# Create a Cluster Agent secret with the Controller access key and API client credentials

# 'api-user' can be any user who has access to the controller with the assigned role as Administrator
# The api-user is required to mark the nodes historical upon pod deletion.

oc -n appdynamics create secret generic cluster-agent-secret \
--from-literal=controller-key=<access-key> \
--from-literal=api-user="<username>@<customer>:<password>"