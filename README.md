# Generation of the docker image for nextsim workshop

Dockerfile and requirements for a docker image to be used at the nextsim workshop

The docker image is automatically generated with repo2docker following [2i2c tutorial](https://docs.2i2c.org/admin/howto/environment/hub-user-image-template-guide/)

Step 1: download the notebooks and test data from /summer/sasip/nextsim-workshop to your local disk

Step 2: Build the docker image: `docker build -t nextsim-workshop:latest .`

Step 3: Start the container: `docker run --rm -v /aboslute_path_to/nextsim-workshop2025:/nextsim-workshop -p 8888:8888 nextsim-workshop:latest`

Step 4: Open notebook on local browser: `localhost:8888` with the token given at runtime by the container
