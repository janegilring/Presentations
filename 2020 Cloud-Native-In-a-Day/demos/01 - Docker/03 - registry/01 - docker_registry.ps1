Write-Host "Demo!"
break

az login

az account set -s "380d994a-e9b5-4648-ab8b-815e2ef18a2b"

az account show

# To create the registry from the CLI, use:
az acr create -n <name of registry> -g <resource group> --sku Standard

#To login to the ACR, use:
`az acr login --name <name of ACR>`

az acr login --name janegilring

# To tag images, use:
docker tag <name of image> <name of ACR>/<namespace>/<name of image>

# For example:
`docker tag content-web acr01.azurecr.io/wthaks/content-web`
`docker tag content-api acr01.azurecr.io/wthaks/content-api`

docker tag content-web janegilring.azurecr.io/fabrikam/content-web
docker tag content-api janegilring.azurecr.io/fabrikam/content-api

# show our new tagged image
docker images

# To push the docker image, use:
# `docker push <name of ACR>/<namespace>/<name of image> `

# For example:
 `docker push acr01.azurecr.io/wthaks/content-web `

 docker push janegilring.azurecr.io/fabrikam/content-web
 docker push janegilring.azurecr.io/fabrikam/content-api

# To list images in the repository, use:
`az acr repository list --name <name of ACR>`

az acr repository list --name janegilring

# From a different machine:

az login

az account set -s "380d994a-e9b5-4648-ab8b-815e2ef18a2b"

az account show

az acr login --name janegilring

# pull image from registry
docker pull janegilring.azurecr.io/fabrikam/content-web:latest
docker pull janegilring.azurecr.io/fabrikam/content-api:latest

# Create a Docker network named **fabmedical**:
docker network create fabmedical

# Run each container using a name and using the **fabmedical** network. The containers should be run in "detached" mode so they don’t block the command prompt.
docker run -d -p 3001:3001 --name api --net fabmedical janegilring.azurecr.io/fabrikam/content-api:latest
docker run -d -p 3000:3000 --name web --net fabmedical janegilring.azurecr.io/fabrikam/content-web:latest