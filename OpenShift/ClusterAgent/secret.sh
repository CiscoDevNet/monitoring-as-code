#!/bin/bash
oc -n appdynamics create secret generic cluster-agent-secret \
--from-literal=controller-key="<controller-access-key>"

# edit secret value:
# oc -n appdynamics edit secret cluster-agent-secret
# echo -n "plain-text-secret" | base64