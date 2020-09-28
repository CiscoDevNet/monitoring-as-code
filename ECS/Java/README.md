# Elastic Container Service (ECS)

## What is ECS?

Amazon ECS is a regional service that simplifies running containers in a highly available manner across multiple Availability Zones within a Region. You can create Amazon ECS clusters within a new or existing VPC. After a cluster is up and running, you can create task definitions that define which container images to run across your clusters. Your task definitions are used to run tasks or create services. Container images are stored in and pulled from container registries, for example Amazon Elastic Container Registry.

https://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html


## ECS terminology

Task Definition — This a blueprint that describes how a docker container should launch. It contains settings like exposed port, docker image, cpu shares, memory requirement, command to run and environmental variables.
https://docs.aws.amazon.com/AmazonECS/latest/userguide/task_definitions.html

Task — This is a running container with the settings defined in the Task Definition. It can be thought of as an “instance” of a Task Definition.

Service — An Amazon ECS service enables you to run and maintain a specified number of instances of a task definition simultaneously in an Amazon ECS cluster. If any of your tasks should fail or stop for any reason, the Amazon ECS service scheduler launches another instance of your task definition to replace it in order to maintain the desired number of tasks in the service.

Cluster — A logic group of EC2 instances. When an instance launches the ecs-agent software on the server registers the instance to an ECS Cluster.

Container Instance — This is just an EC2 instance that is part of an ECS Cluster and has docker and the ecs-agent running on it.

# EC2 vs. Fargate
An Amazon ECS cluster is a logical grouping of tasks or services. You can register one or more Amazon EC2 instances, also referred to as container instances with your cluster to run tasks on, or you can use the serverless infrastructure that Fargate provides. When your tasks are run on Fargate, your cluster resources are managed by Fargate.
For more control, you can host your tasks on a cluster of Amazon EC2 instances that you manage by using the EC2 launch type. 

## Task definition properties
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-taskdefinition.html

## Volumes
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ecs-taskdefinition-volumes.html

### Bind mounts
https://docs.amazonaws.cn/en_us/AmazonECS/latest/developerguide/bind-mounts.html

## Secrets
https://docs.amazonaws.cn/en_us/AmazonECS/latest/userguide/ecs-ug.pdf [pg 54]

# Networking
When you use the awsvpc network mode in your task definitions, every task that is launched from that task definition gets its own elastic network interface (ENI) and a primary private IP address. 
https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-networking.html


