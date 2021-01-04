## 1. Preparation

### Set namespace
In our environment we will be working in `dev` namespace:
```
kubectl config set-context --current --namespace=dev
```

### Deploy secrets
Provide the value of account-access-key as base64 encoded string, and apply the secrets file.

To encode a secret:
```
echo -n "plain-text-secret-value-here" | base64
```
To decode:
```
echo "base64-encoded-secret-here" | base64 -d
```
To apply:
```
kubectl apply -f appd-secrets.yml --namespace=dev
```

### Deploy Machine Agent configuration

Update values in `ma-config-map.yml` in order to connect to your controller and apply to cluster: 
```
kubectl apply -f ma-config-map.yml
```

## 2. Configure and deploy Machine agent with extension

### Prepare extension configuration

Most of the extensions use configuration files (yaml or json), and in order to create a ConfigMap resource based on those values the following command format can be used:
```
kubectl create configmap my-config --from-file=./my/path/to/config.yaml
```

This ConfigMap is going to be mounted as a volume in the one of the following steps. For this particular case, the command looks like this:
```
kubectl create configmap extension-config --from-file=config.yaml -o yaml --dry-run=client > extension-config-config-map.yml
```

Update the values in the config file to match your desired configuration before or after creating ConfigMap file.

Apply changes to the cluster:
```
kubectl apply -f extension-config-config-map.yml
```

### Update environment variables

Update `EXTENSION_URL` environment variable value to match the extension URL download link from [AppDynamics exchange](https://www.appdynamics.com/community/exchange/).

Update `APPDYNAMICS_AGENT_APPLICATION_NAME` environment variable value to contain your application's name.

### Deploy Machine agent with AppDynamics extension

Init container running a `curlimages/curl` image downloads the AppDynamics extension, based on `EXTENSION_URL`, and copies the necessary files to the mounted volume `appd-extension-volume`.

ConfigMap `extension-config` created above is mounted as a volume `extension-config-volume`.

Manifest can be applied:
```
kubectl apply -f machine-agent-pod.yml
```

If everything went well, you should be seeing extension files in `/opt/appdynamics/monitors` folder, and Custom metrics reported to the controller.