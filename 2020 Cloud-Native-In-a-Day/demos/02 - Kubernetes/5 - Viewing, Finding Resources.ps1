# Get commands with basic output
kubectl get services                          # List all services in the namespace
kubectl get pods --all-namespaces             # List all pods in all namespaces
kubectl get pods -o wide                      # List all pods in the current namespace, with more details
kubectl get deployment my-dep                 # List a particular deployment
kubectl get pods                              # List all pods in the namespace
kubectl get pod my-pod -o yaml                # Get a pod's YAML

# For ad-hoc testing or troubleshooting, local port forwarding is useful
kubectl port-forward nginx-d46f5678b-gzg7w 6000:80 # Listen on port 6000 on the local machine and forward to port 80 on the pod

# Describe commands with verbose output
kubectl describe nodes my-node
kubectl describe pods my-pod

# List Services Sorted by Name
kubectl get services --sort-by=.metadata.name

# List pods Sorted by Restart Count
kubectl get pods --sort-by='.status.containerStatuses[0].restartCount'

# List PersistentVolumes sorted by capacity
kubectl get pv --sort-by=.spec.capacity.storage

# Get all running pods in the namespace
kubectl get pods --field-selector=status.phase=Running

# List Events sorted by timestamp
kubectl get events --sort-by=.metadata.creationTimestamp

