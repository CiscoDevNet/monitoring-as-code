# OpenShift cluster and login
Start OpenShift cluster
Login to console

# Deploy and configure cluster agent
./ClusterAgent

# Deploy and configure application agent
./DotNetCore

_______


resolve dns:

https://www.openshift.com/blog/troubleshooting-openshift-internal-networking

oc get pods -o wide
oc run box --image=busybox --restart=Never -ti --rm -- /bin/sh "while true; do wget -O- 172.17.0.6; done"


.net lab: 
https://github.com/Appdynamics/ContainerLabs/blob/master/Labs/Lab-2.12-DotNet/Linux/dotnet-app.yaml

