# Contexts

kubectl config set-context my-context --namespace=mystuff

kubectl config use-context my-context

#JSONPath query language

kubectl --% get pods kuard -o jsonpath --template={.status.podIP}

kubectl describe <resource-name> <obj-name>

kubectl apply -f obj.yaml

kubectl edit <resource-name> <obj-name>

kubectl apply -f myobj.yaml view-last-applied

kubectl delete -f obj.yaml

kubectl delete <resource-name> <obj-name>

# Labeling

kubectl label pods bar color=red

kubectl label pods bar color

# Debugging

kubectl logs <pod-name>

kubectl exec -it <pod-name> -- bash

kubectl attach -it <pod-name>

kubectl cp <pod-name>:</path/to/remote/file> </path/to/local/file>

kubectl port-forward <pod-name> 8080:80

kubectl help
or:
kubectl help <command-name>


kubectl top pod
kubectl top node