
# exec into the container
kubectl exec -it vault-0 -- /bin/sh

# vault-0 copntainer commands below
vault kv put secret/appd/config appd_access_key="b0248ceb-c954-4a37-97b5-207e90418cb4"

vault policy write appd-policy - <<EOF
path "secret*" {
  capabilities = ["read"]
}
EOF

vault write auth/kubernetes/role/appd-role \
    bound_service_account_names=appd-app \
    bound_service_account_namespaces=vault-demo \
    policies=appd-policy \
    ttl=24h

vault auth enable kubernetes

vault write auth/kubernetes/config \
    token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
    kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
    kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

