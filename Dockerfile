FROM  ghcr.io/nextsimhub/nextsimdg-dev-env:latest

# Create dirs
RUN mkdir /bin
RUN mkdir /opt/conda

# Install curl
RUN apt-get update 
RUN apt-get install -y gcc
RUN apt-get install -y curl

# Install mamba
RUN curl -L "https://micro.mamba.pm/api/micromamba/linux-64/2.0.8" \
| tar -xj -C "/" "bin/micromamba"

# Install dependencies
RUN micromamba install -y -n base -f environment.yml 

ARG MAMBA_USER=mambauser
ARG MAMBA_USER_ID=57439
ARG MAMBA_USER_GID=57439
ENV MAMBA_USER=$MAMBA_USER
ENV MAMBA_USER_ID=$MAMBA_USER_ID
ENV MAMBA_USER_GID=$MAMBA_USER_GID
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV ENV_NAME="base"
ENV MAMBA_ROOT_PREFIX="/opt/conda"
ENV MAMBA_EXE="/bin/micromamba"

USER $MAMBA_USER
