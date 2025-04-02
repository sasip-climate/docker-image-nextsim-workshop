# Generation of the docker image for nextsim workshop

Dockerfile and requirements for a docker image to be used at the nextsim workshop

The docker image is automatically generated with repo2docker following [2i2c tutorial](https://docs.2i2c.org/admin/howto/environment/hub-user-image-template-guide/) and saved at this adress https://quay.io/repository/auraoupa/nextsim-workshop

## Local build

### From this repo

 - Clone the repo and build the docker image with ```docker build -t nextsim-workshop:v1 -f Dockerfile .```
 - Check your iamge : ```docker image ls```
 - Check the containers running ```docker ps -a```
 - Kill a running container : ```docker rm NAMES```
 - 
