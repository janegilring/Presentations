Start-Process 'https://docs.docker.com/engine/context/aci-integration/'

docker context

docker context list

docker login azure --tenant-id b5fb2192-06f1-43f4-a44f-1d42a9106deb

docker context create aci AzureContainerInstances-JER

<# VS Code extension for Docker

F1->Docker->Focus on Contexts view
F1->Docker->Context->Create Azure Container Instances context

#>

# Change context to ACI
docker context use AzureContainerInstances-JER

# Deploy a single container
docker --context AzureContainerInstances-JER run -p 80:80 nginx
#or
docker context use AzureContainerInstances-JER
docker run -d -p 80:80 nginx


cd "~\OneDrive\Presentasjoner\Microsoft\2020 Cloud-Native-In-a-Day\demos\01 - Docker\06 - azure container instances"

psedit .\docker-compose.yaml

docker compose up docker-compose.yaml

docker compose down

docker context use default

# Also worth mentioning: Web App for Containers in Azure App Service
Start-Process 'https://azure.microsoft.com/en-us/services/app-service/containers/'