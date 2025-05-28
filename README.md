# Generation of the docker image for nextsim workshop

Dockerfile and requirements for a docker image to be used at the nextsim workshop

The docker image is automatically generated with repo2docker following [2i2c tutorial](https://docs.2i2c.org/admin/howto/environment/hub-user-image-template-guide/) when a pull request is merged

So if you want to modify, please open a branch or a fork first, test the docker image locally before opening a pull request

To test it locally you need to :

 - Build the docker image: `docker build -t nextsim-workshop:latest .`
 - Create a local dir : nextsim-workshop
 - Get the notebooks from the github repo : `git clone git@github.com:sasip-climate/notebooks-nextsim-workshop2025.git` in nextsim-workshop
 - Start the container: `docker run --rm -v /absolute_path_to/nextsim-workshop:/home/nextsim-workshop -p 8888:8888 nextsim-workshop:latest`
 - Open the jupyterlab on local browser: `http://127.0.0.1:8888/lab?token=...` with the token given at runtime by the container, the notebooks will be in notebooks-nextsim-workshop2025
