# CloudFormation Templates for Elastic Container Service (ECS)

The following guide provides information and reference to additional documentation about steps to create Task definition and resources needed to define application and AppDynamics agents in Serverless ECS Fargate environment by utilizing AWS CloudFormation templates.

Please note that screenshots are taken for the .NET Core application Stack, however, the same applies to other languages.

## Preparation

### Create Secrets [Optional]

We are using AWS Secret Manager as a secrets management service, where we are storing AppDynamics Controller's access key.

Store the value as plaintext, without quotes, as that is going to be a value of our environment variable.

![aws-secret-create](https://user-images.githubusercontent.com/23483887/101659141-a294aa00-3a3d-11eb-8890-45de5af81174.png)

We named this variable `APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY_STAGING`.

![aws-secret-name](https://user-images.githubusercontent.com/23483887/101659151-a45e6d80-3a3d-11eb-8e3f-054e94dd124e.png)

Keep note of the *Secret ARN* created as we are going to need this value later on.

![aws-secret-arn](https://user-images.githubusercontent.com/23483887/101660379-04094880-3a3f-11eb-9318-21cbfa9edb5f.png)

### Create Log Group [Optional]

In case that all of the logs are produced in a specific ECS environment, you would like to keep under a single Log Group in CloudWatch, follow the next steps. Also, you may reuse an existing Log Group if applicable.

A log group is a group of log streams that share the same retention, monitoring, and access control settings. More about Log Groups and Log Streams can also be found [here](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/Working-with-log-groups-and-streams.html).

![CloudWatch-Management-Console-DotNet-Log-Group](https://user-images.githubusercontent.com/23483887/101661164-dffa3700-3a3f-11eb-85b7-31e30e528b9d.png)

### IAM Policies and Roles

AWS Identity and Access Management (IAM) is a web service that helps you securely control access to AWS resources.

You manage access in AWS by creating policies and attaching them to IAM identities or AWS resources. 

Policies are JSON documents in AWS that, when attached to an identity or resource, define their permissions. This is how all the requests in AWS are authorized (answers the question: do I have permissions?, while authentication is a process of verifying the identity of a person or device e.g. when you sign in with your username and password).

We are going to need to be allowed to fetch the created secret, and in case that we already do not have an IAM role ready for a CloudFormation stack, we are going to need to create a policy to attach to its IAM Role. 

An IAM role is an IAM identity that you can create in your account that has specific permissions. More about IAM Roles can be found [here](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html).

#### Secrets Policy

In order to be able to enable APM agent to get created secrets' value, we need to create a policy that enables this action on the AWS Secret Manager resource, that is going to be previously created Secret ARN.

The following policy document `get-secrets-policy.json`, can be added to your AWS account manually through AWS Console (IAM > Policies > Create Policy), or by using AWS CLI and executing a script `get-secrets-policy-create.sh`.

Please note that the Resource element's value need sot be updated with your account's Secret ARN (make sure that region and account number are correct), and in case that you are using CLI, it needs to be configured - AWS [documentation](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) provides step-by-step guidance on how to do that.

Upon successful creation, take a note of *Secret Policy ARN* and proceed to the next steps. This value is going to be returned in the API response in case you used AWS CLI, or can be found in AWS Console in IAM > Policies > [select policy] > [copy Policy ARN].

#### CloudFormation Policy and Role

In order to assign permissions, following the least-privilege principle, in `cloud-formation-policy.json` file a policy is defined that needs at least to be assigned to a CloudFormation role in order for it to be able to create, delete, get and modify resources to deploy desired applications and their dependencies.

Create a policy, manually in AWS Console (IAM > Policies > Create Policy) or using an AWS CLI (file `cloud-formation-policy-create.sh`).

Attach the policy to an existing CloudFormation role (IAM > Roles > [select role] > Attach Policies), or create a new one (IAM > Roles > Create role) and follow the same principle. Here also you can utilise an AWS CLI functionality (refer to `cloud-formation-policy-create.sh`).

## Review and Update CloudFormation Template

CloudFormation template can be found in the following file: `CF_TaskDefinition_ECSFargate_DotNetCore.yaml`.

Example application provided in the template is ready to go and provision Microsoft .NET Core application (configurable in next step) alongside with AppDynamics agent in ECS as an AWS Serverless Fargate resource, and here before creating a stack you can review and update non-parametrized fields.

In this step, remove `LogGroup` in case that CloudWatch Log Groups are not to be used before proceeding to the next steps.

Learn more about [Task definition properties](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-taskdefinition.html).

## Execute CloudFormation Stack 

Navigate to CloudFormation Service and create a Stack, pick an option to do so from an existing resource, as we already have a template provided `CF_TaskDefinition_ECSFargate_DotNetCore.yaml`.

![CloudFormation-CreateStack](https://user-images.githubusercontent.com/23483887/101669603-1341c380-3a4a-11eb-947c-4c540032391e.png)

To name the stack, provide intuitive naming at the top of the screen:

![CloudFormation-NameStack](https://user-images.githubusercontent.com/23483887/101670344-f1950c00-3a4a-11eb-9213-9780fdb39454.png)

In the same step, update parameters, besides controller connection details, make sure to update the following fields:
- `AppDSecretAccessKey` - value should be *Secret ARN* 
- `PolicyGetSecrets` - value should be *Secret Policy ARN*
- `LogGroup`, `LogPrefix`, `LogRegion` - CloudWatch Log Group details

![CloudFormation-Parameters](https://user-images.githubusercontent.com/23483887/101676355-f8c01800-3a52-11eb-84f9-07ba9a91c999.png)

Here, note that `ApplicationServiceName` is going to determine your Task definition name, so set it accordingly, and bear in mind that to this name "TaskDefinition" string is going to be appended at the end to form a Task definition name.

In the next step, make sure to assign an IAM Role that has enough permissions to create template resources (refer to CloudFormation Policy and Role):

![CloudFormation-Role](https://user-images.githubusercontent.com/23483887/101676585-43da2b00-3a53-11eb-8449-65964d507dd3.png)

Acknowledge that CloudFormation can create resources from the template on your behalf (note that those are not limited to provisioning services, but also creating roles, users, and policies), and create a Stack.

![CloudFormation-AckAndCreate](https://user-images.githubusercontent.com/23483887/101676206-c6161f80-3a52-11eb-9443-5617175429d5.png)

Stack Events can be observed and when status changes to UPDATE_COMPLETED, proceed to the next section.

![CloudFormation-Created](https://user-images.githubusercontent.com/23483887/101676729-771cba00-3a53-11eb-83e2-4150293adc32.png)

## Run Task

Navigate to Elastic Container Service (ECS) > Task Definitions in AWS Console, and find a Task named as `ApplicationServiceName` + TaskDefinition of the used Stack. 

"Task definitions specify the container information for your application, such as how many containers are part of your task, what resources they will use, how they are linked together, and which host ports they will use." [learn more](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html)

Create an ECS cluster there if there are no suitable ones already, by selecting Clusters from the left-hand side menu > Create Cluster > Networking Only > [provide name].

Now, you can run a Task:

![ECS-TaskDefinition-Run](https://user-images.githubusercontent.com/23483887/101673199-c7454d80-3a4e-11eb-8553-931439a2a15e.png)

Configure Service parameters:
- Launch type - Fargate,
- Cluster - pick a cluster from a drop-down,
- Service name - good practice is to be `ApplicationServiceName` + Service,
- Number of tasks - number of times to spin an application, can be 1,
- Cluster VPC - Virtual Private Cloud where the service is going to run, can be the default for testing purposes,
- Auto-assign public IP - Enabled -in case that your application needs to have an accessible IP address.

Create a Service and take note of the Security Group in case that application ports need to be open and Security Group Inbound rules to be added.
