# OpenShift

# Cluster Agent

## Overview

The AppDynamics Cluster Agent is a lightweight Agent written in Golang for monitoring Kubernetes and OpenShift clusters. The Cluster Agent helps you monitor and understand how Kubernetes infrastructure affects your applications and business performance. With the Cluster Agent, you can collect metadata, metrics, and events for a Kubernetes cluster. The Cluster Agent works on Red Hat OpenShift and cloud-based Kubernetes platforms, such as: Amazon EKS, Azure AKS, and Pivotal PKS.

The Cluster Agent monitors events and metrics of Kubernetes or OpenShift clusters. It also tracks the state of most Kubernetes resources: pods, replica sets, deployments, services, persistent volumes, nodes, and so on. The data is received through the Kubernetes API at a configurable interval, and is sent to the AppDynamics Controller.

For a detailed list of metrics refer to [documentation](https://docs.appdynamics.com/display/PRO45/Cluster+Metrics).

Complete documentation about Cluster Agent can be found [here](https://docs.appdynamics.com/display/PRO45/Monitoring+Kubernetes+with+the+Cluster+Agent).

## Deploy and configure

References to relevant documentation sections, working examples and implementation steps you can find in `ClusterAgent` section of this repo.

#  Application agents

## Overview

There are three methods of monitoring containerised applications running on Kubernetes and OpenShift clusters. They are: 
1. Bundle the APM agent binaries into your Docker image 
2. Using the Init container approach and 
3. Auto instrumentation using the Cluster agent. (recommended)

“AppDynamics recommends auto-instrumentation of containers because it provides the simplest operational experience. However, if you cannot use auto-instrumentation, you should use init containers to copy agent files to simplify the agent upgrade and promote separation of concerns. For non-Kubernetes environments, Dockerfiles is the best option to use when copying the agent files at build time.”

## Deploy and configure

For a detailed instructions how to instrument Java, .NET Core, NodeJS and Python applications, please refer to corresponding sub-directories.


