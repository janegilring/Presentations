#region Virtual machines

    psedit "~\Git\Presentations\2021 Norwegian MVP Day\Demos\Invoke-AzureVMUptimePolicy.ps1"

#endregion

#region Azure Kubernetes Service

    <#
    Your AKS workloads may not need to run continuously, for example a development cluster that is used only during business hours.
    This leads to times where your Azure Kubernetes Service (AKS) cluster might be idle, running no more than the system components.
    You can reduce the cluster footprint by scaling all the User node pools to 0, but your System pool is still required to run the system components
    while the cluster is running. To optimize your costs further during these periods, you can completely turn off (stop) your cluster.
    This action will stop your control plane and agent nodes altogether,
    allowing you to save on all the compute costs, while maintaining all your objects (except standalone pods) and cluster state stored for
    when you start it again. You can then pick up right where you left of after a weekend or to have your cluster running only while you run your batch jobs.
    #>

    # Documentation
    Start-Process 'https://docs.microsoft.com/en-us/azure/aks/start-stop-cluster?tabs=azure-powershell'

    # PowerShell
    Stop-AzAksCluster -Name myAKSCluster -ResourceGroupName myResourceGroup
    Start-AzAksCluster -Name myAKSCluster -ResourceGroupName myResourceGroup

    # CLI
    az aks stop --name myAKSCluster --resource-group myResourceGroup
    az aks start --name myAKSCluster --resource-group myResourceGroup

#endregion

#region Azure Application Gateway

    $appgw = Get-AzApplicationGateway -Name demo-agw -ResourceGroupName demo-rg

    # You will only get charged for the public IP associated to the stopped Application Gateway
    Stop-AzApplicationGateway -ApplicationGateway $appgw
    Start-AzApplicationGateway -ApplicationGateway $appgw

#endregion