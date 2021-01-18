# CloudFormation Templates for Elastic Container Service (ECS)

The following guide provides information and reference to additional documentation about steps to create Task definition and resources needed to define application and AppDynamics agents in Serverless ECS Fargate environment by utilizing AWS CloudFormation templates.

Please note that screenshots are taken for the .NET Core application Stack, however, the same applies to other languages.

## Preparation

Creating resources is going to be performed by using *ClouFormation* service, that can be accessed from AWS cosnole:

![cloud_formation](https://user-images.githubusercontent.com/23483887/104907306-c8866600-597c-11eb-9ed9-b116523ab14f.png)

CloudFormation is AWS tool of choice for achieving infrastructure-as-a-code (Iaas) as it gains popularity with stability, consistency and cost reduction it accompanies.

CloudFormation provides infrastructure on AWS by utilizing *Templates* representing a collection of resource definitions that make up a *Stack*. As templates are nothing but YAML or JSON files that can be handled any text editor, easy to understand by humans and machines, and that easily can be version controlled.

Note that using CloudFormation service is free, but you are paying for the resources that you create in the process.

Here, new resources ar going to be created:

![create_stack](https://user-images.githubusercontent.com/23483887/104905300-10f05480-597a-11eb-9fa1-1610104a79c6.png)

And since templates are already provided, they can be uploaded from a computer location:

![create_stack_prepare_template](https://user-images.githubusercontent.com/23483887/104908327-3a12e400-597e-11eb-9cef-f65219f7d0f3.png)

Alternatively, you can upload templates to S3 bucket and fetch them from there.

### Create Secrets

We are using AWS Secret Manager as a secrets management service, where we are storing AppDynamics Controller's access key.

Secret value is stored as a as plaintext, without quotes, as that is going to be a value of our environment variable.

For this purpose, CloudFormation template is provided in "ECS/Common/CF_Secret_ECSFargate.yaml"

When uploading a template, update the value of `AppdAccountSecretKey` to match your controller's value. There is an option to update the secret key, but note that in that case application templates should be updates as well in order to fetch this new key by name.

When secret gets's created keep note of the *Secret ARN* created as we are going to need this value later on.

![aws-secret-arn](https://user-images.githubusercontent.com/23483887/101660379-04094880-3a3f-11eb-9318-21cbfa9edb5f.png)

### IAM Policies and Roles

AWS Identity and Access Management (IAM) is a web service that helps you securely control access to AWS resources.

You manage access in AWS by creating policies and attaching them to IAM identities or AWS resources. 

Policies are JSON documents in AWS that, when attached to an identity or resource, define their permissions. This is how all the requests in AWS are authorized (answers the question: do I have permissions?, while authentication is a process of verifying the identity of a person or device e.g. when you sign in with your username and password).

We are going to need to be allowed to fetch the created secret, and in case that we already do not have an IAM role ready for a CloudFormation stack, we are going to need to create a policy to attach to its IAM Role. 

An IAM role is an IAM identity that you can create in your account that has specific permissions. More about IAM Roles can be found [here](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html).

#### CloudFormation Policy and Role

In order to assign permissions, following the least-privilege principle, in `ECS/Common/cf-cluster-cloud-formation-policy.json` file a policy is defined that needs at least to be assigned to a CloudFormation role in order for it to be able to create, delete, get and modify resources to deploy desired applications and their dependencies.

Create a policy, manually in AWS Console (IAM > Policies > Create Policy) or using an AWS CLI (file `cloud-formation-policy-create.sh`).

Attach the policy to an existing CloudFormation role (IAM > Roles > [select role] > Attach Policies), or create a new one (IAM > Roles > Create role) and follow the same principle. Here also you can utilise an AWS CLI functionality (refer to `cloud-formation-policy-create.sh`).

## Create monitored application's Task Definition

CloudFormation template of a .NET Core application can be found in the following file: `ECS/DotNetCore/CF_TaskDefinition_ECSFargate_DotNetCore.yaml`.

Example application provided in the template is ready to go and provision Microsoft .NET Core application (configurable in next step) alongside with AppDynamics agent in ECS as an AWS Serverless Fargate resource, and here before creating a stack you can review and update non-parametrized fields.

Learn more about [Task definition properties](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ecs-taskdefinition.html).

## Execute CloudFormation Stack 

Navigate to CloudFormation Service and create a Stack, pick an option to do so from an existing resource, as we already have a template provided `CF_TaskDefinition_ECSFargate_DotNetCore.yaml`.

![CloudFormation-CreateStack](https://user-images.githubusercontent.com/23483887/101669603-1341c380-3a4a-11eb-947c-4c540032391e.png)

To name the stack, provide intuitive naming at the top of the screen:

![CloudFormation-NameStack](https://user-images.githubusercontent.com/23483887/101670344-f1950c00-3a4a-11eb-9213-9780fdb39454.png)

In the same step, update parameters, besides controller connection details, make sure to update the following fields:
- `AppDSecretAccessKey` - value should be *Secret ARN* 

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
