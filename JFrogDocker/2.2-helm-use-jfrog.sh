

# Install helm chart from JFrog Artifactory
# Note: helm-virtual
helm install ca-artifactory helm-virtual/cluster-agent --set controllerInfo.accessKey="<controller-key-here>" --set clusterAgent.appName="helm-virtual-jfrog" \
 -f values.yaml --namespace <namespace-here>