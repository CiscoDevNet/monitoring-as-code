
# Monitor ECS Fargate with AppDynamics  

Amazon Elastic Container Service (ECS) is a scalable container management service that makes it easy to run, stop, and manage Docker containers on Amazon EC2 clusters.

This project demonstrates how AppDynamics agents can be embedded into an existing ECS/Fargate setup using 

- CloudFormation
- Terraform and
- Ansible

The primary considerations that went into the design of this project are:

- Customers' existing container images and/or the image build process should be unaltered.
- The deployment process must remain immutable.
- Idempotency - customers should get the same instrumentation result even if the terraform config is applied multiple times.
- AppDynamics access key must be stored and accessed from AWS secret manager, not as a plaintext.

## How it works

Our approach is consistent regardless of the automation tool in use - customers would have to introduce AppDynamics container into the task using the <a href="https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-attribute-dependson.html"> `DependsOn` </a> attribute.

At deploy time, we acquire AppDynamics Java or .Net core agent from DockerHub, load the agent binaries into a shared ephemeral storage and exit the AppDynamics container. When the main application container is starting up, it mounts the shared agent volume and injects the agent.

The approach described above is similar to the Kubernetes init container pattern.

An alternative approach is to mount the agent binaries into persistent storage - such as `EFS`, then mount into the container when it is starting up. The disadvantage with this approach is you would have to create yet another automation process to regularly update the agent versions.  

## What is next?

There are two aspects to monitoring ECS Fargate: 

- The containerised application
- The ECS cluster/task health

Now that we have completed the first phase, which is containerised Java and .Net Core application, our next focus is to provide visibility into the cluster/task health. We will achieve this by developing a lambda function that collects <a href="https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-metrics-ECS.html"> `ECS cluster ECS Container Insights Metrics` </a> from CloudWatch into AppDynamics custom analytics schema.

Since custom analytics data and APM data does not correlate in AppDynamics, we will also provide an automated dashboard template via  <a href="https://appdynamics.github.io/ConfigMyApp/"> ConfigMyApp </a> - that combines both ECS APM and the cluster health visibility in a single pane of glass.  ConfigMyApp can also be used to create or update the related health rules.

## How about ECS EC2 launch type?

We do not plan to support EC2 launch type due to low demand, but feel free to contact us if you need it. 

## How do I contact you?

Please create an issue in this repo
