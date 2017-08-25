
# nubis-docker-deploy

Docker image for deploying applications into a Nubis account

[Install docker](https://docs.docker.com/engine/installation/linux/ubuntu/)

```bash

docker build -t nubis-deploy .

docker login

docker tag nubis-deploy nubisproject/nubis-deploy:v0.1.0

docker push nubisproject/nubis-deploy:v0.1.0

docker pull nubisproject/nubis-deploy:v0.1.0

ACCOUNT='<account-to-build-in>'

aws-vault exec "${ACCOUNT}-admin" -- docker run --interactive --tty --env-file ~/.docker_env --volume "$PWD":/nubis/data nubisproject/nubis-deploy:v0.1.0

aws-vault exec "${ACCOUNT}-admin" -- docker run --interactive --tty --env-file ~/.docker_env --volume "$PWD":/nubis/data nubisproject/nubis-deploy:v0.1.0 apply




```
