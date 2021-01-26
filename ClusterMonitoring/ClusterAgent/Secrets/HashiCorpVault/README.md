# HashiCorp Vault - Secrets

#  Prerequisites

Create a HashiCorp Vault pods in your minikube's namespace for the purpose of testing:

https://learn.hashicorp.com/tutorials/vault/kubernetes-minikube?in=vault/kubernetes

Or connect to the existing external Vault:

https://learn.hashicorp.com/tutorials/vault/kubernetes-external-vault?in=vault/kubernetes


# Store the secrets

Refer to the `./create-vault.sh` file for steps performed in order to exec into the controller, create secrets roles, and policies.

https://www.hashicorp.com/blog/injecting-vault-secrets-into-kubernetes-pods-via-a-sidecar

# Deploy application that is using the secrets

Applying `app-vault-secret.yml` deployment, using annotation injects Vault secrets that can be accessed with the command:

`kubectl exec -it -c app <pod-id> -- cat /vault/secrets/appdaccesskey`
