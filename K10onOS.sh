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

