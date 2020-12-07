# Create service account
oc create sa appd-account

# Assign rights
oc adm policy add-scc-to-user anyuid -z appd-account