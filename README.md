# Docker Images for OpenTAO

This repo contains the DockerFile to build a docker image containing OpenTAO and all PHP/Apache dependencies.


Clone this repo then build & run the Dockerfile & image

`
cd docker-stmath-opentao
sudo docker build -t stmath-opentao .
sudo docker run -d -p 8019:80 -v /tank/docker/opentao/data:/data:z --name opentao stmath-opentao
`

Go to: [http://localhost:8019](http://localhost:8019) to run the setup wizard
