#!/usr/bin/env bash

if [ -z "$(which jq)" ]; then
  echo 'This script requires jq'
  exit 1
fi

# Creates service account, binds them to admin
kubectl apply -f ./kube/serviceaccount.yaml
kubectl apply -f ./kube/clusterrolebinding.yaml

SECRET=`kubectl get serviceaccounts --namespace kube-system admin-user -o json | jq '.secrets[0].name' -r`
TOKEN=`kubectl get secrets --namespace kube-system $SECRET -o yaml`
echo "$(tput setaf 2)Copy the following into AzureDevOps Service Connections (Project Settings -> Service Connections -> New Service Connection -> Kubernetes -> Service Account -> Secret)"
echo "$(tput setaf 1)Connection Name:"
echo "$(tput setaf 3)gke-cluster"
echo "$(tput setaf 1)Server URL:"
echo "$(kubectl cluster-info | grep 'Kubernetes master' | awk '{print $(NF)}')"
echo "$(tput setaf 1)Secret:"
echo "$(tput setaf 3)$TOKEN$(tput sgr0)"
