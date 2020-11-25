# Azure Kubernetes Service

az login

az account show

az account set -s "380d994a-e9b5-4648-ab8b-815e2ef18a2b"

az group create --name=cloud-native-workshop-rg --location=westeurope

az aks create --resource-group=cloud-native-workshop-rg --name=cloud-native-workshop

# While the command runs - let us explore the options for creating an AKS cluster in the portal
# Reference: https://docs.microsoft.com/en-gb/azure/aks/kubernetes-walkthrough-portal


az aks get-credentials --resource-group=cloud-native-workshop-rg --name=cloud-native-workshop

# Note: Azure automatically creates a seconds resource group named "MC_${ResourceGroup}_${ClusterName}_${Location}"

kubectl version

kubectl get componentstatuses

kubectl get nodes

kubectl describe nodes aks-nodepool1-40811069-vmss000000

kubectl get daemonsets --namespace=kube-system kube-proxy

# DNS

kubectl get deployments --namespace=kube-system core-dns

kubectl get services --namespace=kube-system core-dns

# UI/Dashboard
kubectl get deployments --namespace=kube-system kubernetes-dashboard

kubectl get services --namespace=kube-system kubernetes-dashboard

# You can use kubectl proxy to access this UI. Launch the Kubernetes proxy using:
kubectl proxy

<#
This starts up a server running on localhost:8001. If you visit http://localhost:
8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/
proxy/ in your web browser, you should see the Kubernetes web UI. You can use this
interface to explore your cluster, as well as create new containers.
#>

