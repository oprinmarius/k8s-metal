#!/bin/bash

### Add cluster to Argo CD
# Commands to run on the management cluster

# Get kubeconfig for kub-poc cluster
clusterctl get kubeconfig kub-poc -n tink-system > ~/.kube/kub-poc.kubeconfig
cat ~/.kube/kub-poc.kubeconfig | pbcopy

# Get shell into Argo CD server pod name
kubectl exec -it -n argo-cd deploy/argo-cd-argocd-server -c server -- sh -c "clear; (bash || ash || sh)"

# Create kubeconfig file
cat <<EOF > kub-poc.kubeconfig
<copy kubeconfig from clipboard>
EOF

# Add cluster to Argo CD
argocd cluster add kub-poc-admin@kub-poc \
   --kubeconfig ./kub-poc.kubeconfig \
   --server argo-cd.mgmt.kub-poc.local \
   --insecure
