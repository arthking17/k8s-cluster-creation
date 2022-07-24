#/bin/bash

az group create --name kubernetes-cluster --location northeurope
az deployment group create --resource-group kubernetes-cluster --template-file template.json --parameters @kube-01.json
az deployment group create --resource-group kubernetes-cluster --template-file template.json --parameters @kube-02.json
az deployment group create --resource-group kubernetes-cluster --template-file template.json --parameters @master.json
