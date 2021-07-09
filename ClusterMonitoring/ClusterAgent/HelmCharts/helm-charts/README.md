# Cluster Agent Helm Chart

### Add AppDynamics helm repo
```bash
helm repo add appdynamics-charts https://appdynamics.github.io/appdynamics-charts
```

### Create/update values yaml to override defaults
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

## Commands

### Using helm charts
```bash
helm install cluster-agent appdynamics-charts/cluster-agent -f <values-file>.yaml --namespace appdynamics
```

### Apply multiple value files and set access-key secret
```bash
helm install --set controllerInfo.accessKey="c5c7e458-MY-KEY-099868f11869" --set clusterAgent.appName="auto-instrumentation-label-based"  cluster-agent appdynamics-charts/cluster-agent -f 1-values-master.yaml -f 2-values-secrets.yaml -f 3-values-controller-prod.yaml -f 4-values-master-auto-instr.yaml --namespace appdynamics-helm
```

#### Update values
```bash
helm upgrade cluster-agent appdynamics-charts/cluster-agent -f <values-file>.yaml --namespace appdynamics-helm
```

#### Delete chart
```bash
helm delete cluster-agent --namespace appdynamics-helm
```

### Documentation
For more details and config options please visit official [documentation](https://docs.appdynamics.com/display/PRO45/Deploy+the+Cluster+Agent+with+Helm+Charts).
