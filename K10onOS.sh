#!/bin/bash
sudo -i
echo "list cluster nodes"
oc get nodes

echo "install Helm"
curl -L https://mirror.openshift.com/pub/openshift-v4/clients/helm/latest/helm-linux-amd64 -o /usr/local/bin/helm
chmod +x /usr/local/bin/helm
sleep 10
exit

echo "helm version"
helm version

echo "Creation of the Kasten charts repo and namespace"
helm repo add kasten https://charts.kasten.io/
kubectl create namespace kasten-io

echo "k10 preflight checks"
curl https://docs.kasten.io/tools/k10_primer.sh | bash

echo "install Kasten K10"
helm install k10 kasten/k10 --namespace=kasten-io --set scc.create=true --set route.enabled=true --set route.path="/k10" --set auth.tokenAuth.enabled=true

echo "wait 60 seconds for the K10 pod deployment"
sleep 60

echo "verify the K10 pod status"
kubectl get pods -n kasten-io -w --request-timeout=5s bash

echo "check the route information"
oc get route -n kasten-io
oc describe route k10-route -n kasten-io

echo "generate and get K10 acces token"
sa_secret=$(kubectl get serviceaccount k10-k10 -o jsonpath="{.secrets[0].name}" --namespace kasten-io)
kubectl get secret $sa_secret --namespace kasten-io -ojsonpath="{.data.token}{'\n'}" | base64 --decode

echo "port forward” to access the K10 dashboard"
kubectl --namespace kasten-io port-forward service/gateway 8080:8000

echo "fim"
