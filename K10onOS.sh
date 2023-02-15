#!/bin/bash
echo "list oc nodes"
oc get nodes

echo "install Helm"
curl -L https://mirror.openshift.com/pub/openshift-v4/clients/helm/latest/helm-linux-amd64 -o /usr/local/bin/helm
chmod +x /usr/local/bin/helm

# Wait for 120 seconds
sleep 120

echo "helm version"
helm version

echo "k10 preflight checks"
curl https://docs.kasten.io/tools/k10_primer.sh | bash

echo "Creation of the Kasten charts repo and namespace"
helm repo add kasten https://charts.kasten.io/
kubectl create namespace kasten-io

echo "install Kasten K10"
helm install k10 kasten/k10 --namespace=kasten-io --set scc.create=true --set route.enabled=true --set route.path="/k10" --set auth.tokenAuth.enabled=true
