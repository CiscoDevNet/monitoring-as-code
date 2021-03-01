# Cluster Agent Helm Chart

### Add AppDynamics helm repo
```bash
helm repo add appdynamics-charts https://appdynamics.github.io/appdynamics-charts
```
### Create values yaml to override default ones
```yaml
imageInfo:
  agentImage: docker.io/appdynamics/cluster-agent
  agentTag: 20.7.0
  operatorImage: docker.io/appdynamics/cluster-agent-operator
  operatorTag: latest
  imagePullPolicy: Always                             

controllerInfo:
  url: <controller-url>
  account: <controller-account>
  username: <controller-username>
  password: <controller-password>
  accessKey: <controller-accesskey>

agentServiceAccount: appdynamics-cluster-agent
operatorServiceAccount: appdynamics-operator
```
### Install cluster agent using helm chart
```bash
helm install cluster-agent appdynamics-charts/cluster-agent -f <values-file>.yaml --namespace appdynamics
```
### Note:
For more details and config options please visit official documentation
[https://docs.appdynamics.com/display/PRO45/Deploy+the+Cluster+Agent+with+Helm+Charts](https://docs.appdynamics.com/display/PRO45/Deploy+the+Cluster+Agent+with+Helm+Charts)

### Commands

Install helm chart:
`helm install cluster-agent appdynamics-charts/cluster-agent -f values.yaml --namespace appdynamics-helm`

Update values:
`helm upgrade cluster-agent appdynamics-charts/cluster-agent -f values.yaml --namespace appdynamics-helm`

Delete chart:
`helm delete cluster-agent --namespace appdynamics-helm`

Dry run injecting secret from environment variables:
`helm install --dry-run --set controllerInfo.accessKey=$CONTROLLER_ACCESS_KEY --debug cluster-agent appdynamics-charts/cluster-agent -f values.yaml --namespace appdynamics-helm`

Apply changes:
`helm upgrade --set controllerInfo.accessKey=$CONTROLLER_ACCESS_KEY cluster-agent appdynamics-charts/cluster-agent -f values.yaml --namespace appdynamics-helm`

Set cluster agent name:
`helm install --set controllerInfo.accessKey=$CONTROLLER_ACCESS_KEY --set clusterAgent.appName="custom-cluster-name"  cluster-agent appdynamics-charts/cluster-agent -f values.yaml --namespace appdynamics-helm`

Apply multiple value files and set access-key secret:
`helm install --set controllerInfo.accessKey="c5c7e458-bd5d-4046-85ba-099868f11869" --set clusterAgent.appName="auto-instrumentation-label-based"  cluster-agent appdynamics-charts/cluster-agent -f 1-values-master.yaml -f 2-values-secrets.yaml -f 3-values-controller-prod.yaml -f 4-values-master-auto-instr.yaml  --namespace appdynamics-helm`

