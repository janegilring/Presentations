Write-Host "Demo!"
break

docker volume ls

docker volume create DemoData01

docker volume inspect DemoData01

docker volume inspect DemoData01 | ConvertFrom-Json

# If you start a container with a volume that does not yet exist, Docker creates the volume for you

docker run --rm -it --name DemoContainer01 --mount source=DemoData01,target=/DemoData01 mcr.microsoft.com/powershell:7.1.0-alpine-3.10

docker volume rm DemoData01

