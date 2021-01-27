#!/bin/bash
# 

# 1 - build an image just to inject secrets using annotations and get them mounted
echo -e "> Create a container and inject asecret from the Vault \n"

cd ./HashiCorpVault/

NAMESPACE_NAME="vault-demo"

kubectl apply -f app-vault-secret.yml -n $NAMESPACE_NAME

sleep 12

echo "> Get pods \n"
kubectl get pods -n $NAMESPACE_NAME

# 2 - using script get the values -- cat

echo -e "> Set environment variable"

# pods=$(kubectl get pods)
# echo "PODS $pods"
POD_NAME=$(kubectl get pods | grep -o 'app[^[:space:]]*')

echo -e ">> Exec into pod \n"
echo "kubectl exec -it -c app $POD_NAME -n $NAMESPACE_NAME -- cat /vault/secrets/appdaccesskey"

VAULT_ACCESS_KEY=$(kubectl exec -it -c app $POD_NAME -n $NAMESPACE_NAME -- cat /vault/secrets/appdaccesskey)

echo $VAULT_ACCESS_KEY
# e.g. value is:  b0248ceb-c954-4a37-97b5-207e90418cb4

echo -e "> Upgrade AppDynamics Helm chart (or delete and create) \n"

cd ../../helm-charts/

#helm delete cluster-agent --namespace appdynamics-helm

echo "helm upgrade --set controllerInfo.accessKey=$VAULT_ACCESS_KEY --set clusterAgent.appName=custom-cluster-name \
      cluster-agent appdynamics-charts/cluster-agent -f values.yaml --namespace appdynamics-helm"

helm upgrade --set controllerInfo.accessKey=$VAULT_ACCESS_KEY --set clusterAgent.appName="custom-cluster-name" \
      cluster-agent appdynamics-charts/cluster-agent -f values.yaml --namespace appdynamics-helm


