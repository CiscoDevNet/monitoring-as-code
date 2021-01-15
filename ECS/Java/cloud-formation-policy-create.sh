#!/bin/bash

# create policy
aws iam create-policy --policy-name AppdynamicsStackCloudFormationPolicy \
--policy-document file://cloud-formation-policy.json \
--profile default

# attach policy to role. Alrady have this role.. arn:aws:iam::181357337174:role/CloudFormationECSRole| arn:aws:iam::181357337174:policy/CloudFormationECSPolicy
aws iam attach-role-policy --policy-arn arn:aws:iam::181357337174:policy/AppdynamicsAgentGetSecretsPolicy \
--role-name <Cloud-Formation-Role-Name> \
--profile default
