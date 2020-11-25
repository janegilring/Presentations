# Install kubectl - https://kubernetes.io/docs/tasks/tools/install-kubectl/
az aks install-cli

kubectl config view # Show Merged kubeconfig settings.

# use multiple kubeconfig files at the same time and view merged config
KUBECONFIG=~/.kube/config:~/.kube/kubconfig2

kubectl config view
kubectl config get-contexts                          # display list of contexts
kubectl config current-context                       # display the current-context
kubectl config use-context my-cluster-name           # set the default context to my-cluster-name
kubectl config use-context docker-desktop

# Pro tip: Configure tab completion for kubectl

# Bash
source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.

# PowerShell

Install-Module -Name PSKubectlCompletion

Import-Module PSKubectlCompletion
Set-Alias k -Value kubectl
Register-KubectlCompletion
