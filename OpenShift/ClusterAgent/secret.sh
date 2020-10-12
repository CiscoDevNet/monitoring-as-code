#!/bin/bash
oc -n appdynamics create secret generic cluster-agent-secret \
--from-literal=controller-key="<controller-access-key>"