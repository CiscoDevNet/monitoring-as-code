#!/bin/bash

# 1. create configMap
oc apply -f ca-config-map.yaml
oc apply -f ca-appd-secrets.yaml 

# check
#oc describe configmaps appd-controller-config
#oc get configmaps appd-controller-config -o yaml