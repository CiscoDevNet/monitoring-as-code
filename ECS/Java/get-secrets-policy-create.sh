#!/bin/bash

# create policy
aws iam create-policy --policy-name AppdynamicsAgentGetSecretsPolicy \
--policy-document file://get-secrets-policy.json \
--profile <my-aws-profile>
