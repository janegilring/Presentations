# Build Docker images for both content-api & content-web.

cd "~\OneDrive\Presentasjoner\Microsoft\2020 Cloud-Native-In-a-Day\demos\01 - Docker\03 - building images\Fabrikam\content-api"

psedit Dockerfile

# Cleanup if necessary
docker image ls
docker image rm 927d864159d8 -f

docker build -t content-api .

cd "~\OneDrive\Presentasjoner\Microsoft\2020 Cloud-Native-In-a-Day\demos\01 - Docker\03 - building images\Fabrikam\content-web"

psedit Dockerfile

docker build -t content-web .

# Run the applications in the Docker containers in a network and verify access

# Create a Docker network named **fabmedical**:
docker network create fabmedical

# Run each container using a name and using the **fabmedical** network. The containers should be run in "detached" mode so they don’t block the command prompt.
docker rm api # Cleanup
docker rm web # Cleanup
docker run -d -p 3001:3001 --name api --net fabmedical content-api
docker run -d -p 3000:3000 --name web --net fabmedical content-web

# NOTE:** The value specified in the `--name` parameter of the `docker run` command for content-api will be the DNS name for that container on the docker network.
# Therefore, the value of the **CONTENT_API_URL** environment variable in the content-web Dockerfile should match it.

docker ps

docker image list
