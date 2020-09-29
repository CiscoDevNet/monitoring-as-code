#!/bin/bash

# 1. create configMap
oc create configmap game-config --from-file=ca-config-map.yaml

# check
oc describe configmaps appd-controller-config
oc get configmaps appd-controller-config -o yaml