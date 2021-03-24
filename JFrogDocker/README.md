# Using JFrog Artifactory with AppDynamics Images and Helm Charts

### Prerequisites

In order interact with a JFrog server from a command line, Artifactory server must exist and be available to use for a user working with these resources. In order to do so, follow the official JFrog [documentation](https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory#CLIforJFrogArtifactory-Configuration). This information together with sufficient access rights are prerequisites fro building and pushing the Docker image to Artifactory.

## Images

JFrog Artifactory can be used as a [Docker registry](https://www.jfrog.com/confluence/display/JFROG/Getting+Started+with+Artifactory+as+a+Docker+Registry), as a Cloud or On-prem solution. 


### Using the resources

Please refer to the example `Dockerfile` for building an image to be pushed can be found in this directory. This file is used in `1.1-images-build-and-push.sh` to build an image and push it to JFrog Artifactory, where it can be pulled from and used across organization. Please refer to its content for implementation details, and adjust according to your specific use-case.

Find below an example of using this script by providing necessary values in runtime:
`./1.1-build-and-push.sh curl-appd 20.11 jfrogservername.jfrog.io repo-name user1 ug785HJH-access-key`

## Helm charts

"Artifactory offers fully-featured operation with Helm through support for local, remote and virtual Helm chart repositories.", as stated in the documentation [here](https://www.jfrog.com/confluence/display/JFROG/Kubernetes+Helm+Chart+Repositories).

You would add and use AppDynamics helm charts as any regular helm chart already stored in the virtual repository. In order to package and add helm chart to artifactory pleas follow the instructions from a script `2.1-helm-config-jfrog.sh`, and then to check how to use those charts when deploting AppDYnamics Cluster agent and Cluster agent operator, refer to `2.2-helm-use-jfrog.sh`.
