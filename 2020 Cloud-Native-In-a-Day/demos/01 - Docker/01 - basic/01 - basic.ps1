Write-Host "Demo!"
break

# Linux container mode must be enabled

# Docker for Windows
# https://www.docker.com/docker-windows

wsl.exe -l -v

# Public Docker Hub
Start-Process 'https://hub.docker.com/'

# 01 - Run container
# This will run the latest version of the Azure PowerShell image
docker run --rm -it mcr.microsoft.com/azure-powershell:latest
# -it       run interactive
# --rm      automatically remove container

# latest is great for testing, but all production usage should specify the exact version/tag required
docker run --rm -it mcr.microsoft.com/azure-powershell:5.1.0-ubuntu-18.04

# show running container (from a different CLI instance)
docker ps

# how to know which versions is available?
Start-Process 'https://hub.docker.com/_/microsoft-azure-powershell'

# show that container have been removed
docker ps
docker container list

# show local images
docker images

# tag = version (VERY simplified)
# run specific version of the image
docker run --rm -it azuresdk/azure-cli-python:2.0.18

# show version 2.0.18 of the image is downloaded
docker images

# run image again without --rm
docker run -it mcr.microsoft.com/azure-powershell:5.0.0-ubuntu-18.04

# inside image, run command 'az show'
# from another terminal session:
docker ps

# now we see the running container.
# get it's id - and run
docker logs <id>
# everything written to stderr and stdout is shown with 'logs'

# start long running container
docker run --detach alpine:latest /bin/sleep 1000

# show that container is running in the background
docker ps

# attach to running container
docker attach <id>
# ctrl+x to exit

# docker exec

#docker run -p 443:443

# delete container
docker rm <id> -f

# show that it's gone
docker ps

# A more practical example - Home Assistant
docker run --init -d --name="home-assistant" -e "TZ=Europe/Oslo" -v "//c/Users/Jan Egil Ring/homeassistant:/config" -p 8123:8123 homeassistant/home-assistant:0.118.3

# Azure Cloud Shell
Start-Process 'https://github.com/Azure/CloudShell'

docker pull mcr.microsoft.com/azure-cloudshell:latest
docker run -it mcr.microsoft.com/azure-cloudshell /bin/bash