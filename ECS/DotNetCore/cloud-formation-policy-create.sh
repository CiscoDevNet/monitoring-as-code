#!/bin/bash

# create policy
aws iam create-policy --policy-name AppdynamicsStackCloudFormationPolicy \
--policy-document file://cloud-formation-policy.json \
--profile <my-aws-profile>

# attach policy to role
aws iam attach-role-policy --policy-arn <Created-Policy-ARN> \
--role-name <Cloud-Formation-Role-Name> \
--profile <my-aws-profile>
