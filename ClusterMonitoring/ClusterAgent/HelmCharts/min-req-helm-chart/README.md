
## enable metric server 
test env: minikube

## update rbac permissions 
updated helm chart yaml files:
- cr-agent-generic.yaml 
- cr-agent-instrumentation.yaml
- r-operator.yaml

## test

Instead of:
`helm install --set controllerInfo.accessKey="<secret-key>" --set clusterAgent.appName="auto-instrumentation-javadotnet-label"  cluster-agent appdynamics-charts/cluster-agent -f 1-values-master.yaml -f 2-values-secrets.yaml -f 3-values-controller-prod.yaml -f 4-values-master-auto-instr.yaml  --namespace appdynamics-helm`

Use local version:
`helm install min-cluster-agent min-req-helm-chart/ -f min-req-helm-chart/1-values-master.yaml -f min-req-helm-chart/2-values-secrets.yaml -f min-req-helm-chart/3-values-controller-prod.yaml -f min-req-helm-chart/4-values-master-auto-instr.yaml  --set controllerInfo.accessKey="<secret-key>" --set clusterAgent.appName="min-cluster-agent" --namespace appd-min`

## deploy test applications
`cd ../helm-charts/application-examples/`
`kubectl create sa appd-account`
`kubectl apply -f . -n dev`

## package
`helm package ./min-req-helm-chart/`

## (opt) upload to jfrog, nexus,...
#!todo run nexus server frm docker file and upload packaged helm chart > install from remote repo

## clean-up 
`k delete -f . -n dev`
`helm delete min-cluster-agent --namespace appd-min`