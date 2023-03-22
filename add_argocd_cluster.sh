#!/bin/bash

### Add cluster to Argo CD
# Commands to run on the management cluster

# Get kubeconfig for kub-poc cluster
clusterctl get kubeconfig kub-poc -n tink-system > ~/.kube/kub-poc.kubeconfig

# Copy kubeconfig to Argo CD server pod
kubectl cp ~/.kube/kub-poc.kubeconfig -n argo-cd deploy/argo-cd-argocd-server -c server

# Get shell into Argo CD server pod name
kubectl exec -it -n argo-cd deploy/argo-cd-argocd-server -c server -- sh -c "clear; (bash || ash || sh)"

# Argo CD login
argocd login argo-cd.mgmt.kub-poc.local \
   --username admin --password \
   $(kubectl get secret argocd-initial-admin-secret -n argo-cd -o jsonpath="{.data.password}" | base64 -d) \
   --insecure
   
# Add cluster to Argo CD
argocd cluster add kub-poc-admin@kub-poc \
   --kubeconfig ./kub-poc.kubeconfig \
   --server argo-cd.mgmt.kub-poc.local \
   --insecure
