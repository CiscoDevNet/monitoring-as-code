## 1. Preparation steps

### Download
Download an extension from [AppDynamics exchange](https://www.appdynamics.com/community/exchange/).

### Configure Extension
Extensions are usually configured inside of an accompanying JSON or YAML config file. Based on extension's documentation provided in the [AppDynamics exchange](https://www.appdynamics.com/community/exchange/) update the values and test configuration locally. 

### Compress binaries
Create a `.zip` file that is going to be copied in the image building phase, and recommended is to keep it in the `docker-images` directory.

## 2. Building an image 

Define Dockerfile that is going to be used to containerize the application. It will contain a series of steps executed in sequential order that are going to enable us to build an image containing extension and all necessary dependencies. We are going to run these images as containers in various environments including Kubernetes and OpenShift.

Refer to the following file in this repo as a starting point:
`docker-images/Dockerfile`

Replace two areas marked with *#todo* depending on your extension name and dependencies. More about it find in the following sub-sections.

#### Use AppDynamics as base image

We are using machine agent image as a base as it already containing machine agent files, and by using this approach updating machine agent binaries requires changing the base image tag and it's left to appDynamics to take care of lifecycle of the images in the Hub.

### Update environment variable
Set value of `EXTENSION_SOURCE_FILE_NAME` to match your `.zip` file name created as a preparation step. This file is going to be copied and unzipped in multi-stage build Dockerfile.

#### Installing dependencies [Extension WithDependencies only]

Use Docker `RUN` command to update existing packages and execute additional dependency installations, for example:

<img width="483" alt="ext-run-install-packages" src="https://user-images.githubusercontent.com/23483887/102370343-dc712d80-3fb4-11eb-97ca-c77045b9ab6e.png">

### Build an image and run a container

To build an image execute the following script and provide your input arguments in the following order: docker handle, image name and image tag:

```
./docker-images/1-build-image.sh appdynamics apigee-extension v1
```

In order to run an image as a container, you can use the following script:

```
./docker-images/2-run-container.sh appdynamics apigee-extension v1
```

Observe running containers, and inspect files if needed:
```
docker ps
docker exec -it <container-id> /bin/sh
```

### Push image to your image repository

For this purpose you can utilize the script:
```
./docker-images/3-push-image.sh appdynamics apigee-extension v1
```
where `appdynamics` is DockerHub handle, `apigee-extension` is an image name and `v1` an image tag.

### Create service account [Optional]

You can use existing service accounts, but in case that you would like to create a new one you can use the following command:
```
kubectl create sa appd-account
```

## 3. Deploying extension

In order to run an image n a cluster, we are going to need a manifest file that defines the resource

### Update manifest file

Update #todo section, reference your image built and pushed to the image repo:

`kubernetes-manifests/machine-agent-extension-pod.yml`

or create a pod definition:

```
kubectl run machine-agent-extension --image=<image-name-here> --dry-run=client -o yaml > machine-agent-extension-pod.yml
```

### Apply to a cluster

Apply changes to the cluster:

```
kubectl apply -f kubernetes-manifests/machine-agent-extension-pod.yml
```
