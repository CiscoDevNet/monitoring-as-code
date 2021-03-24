#!/bin/bash

# Package helm chart 
# docs: https://docs.bitnami.com/tutorials/create-your-first-helm-chart/
helm package ./helm-chart

# Setup JFrog server:
jfrog rt config jfrogservername --url=https://jfrogservername.jfrog.io/artifactory --apikey=<key-here> --user=aleksjovovic@gmail.com
jfrog rt use jfrogservername
jfrog rt ping

# https://www.jfrog.com/confluence/display/JFROG/Helm+Chart+Repositories
# Note: "Artifactory only supports resolution of Helm charts from virtual Helm chart repositories."
helm repo add helm-virtual https://jfrogservername.jfrog.io/artifactory/helm-virtual-repository/ --username <username-here> --password <pass-here>
helm repo update
helm search repo cluster-agent

