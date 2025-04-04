# neXtSIMDG container
FROM  ghcr.io/nextsimhub/nextsimdg-dev-env:latest as next

# Activate spack env for nextsimdg build
COPY --from=next /opt/spack-environment/activate.sh /opt/spack-environment/activate.sh
RUN . /opt/spack-environment/activate.sh

# Compile nextsimdg
RUN mkdir build
WORKDIR build
RUN git clone -b develop https://github.com/nextsimdg/nextsimdg.git \
 && cd nextsimdg \
 && cmake -DCMAKE_BUILD_TYPE=Release .. \
 && make -j 4

# Micromamba container
FROM mambaorg/micromamba:1.5.8 as micromamba

# Final container
FROM pangeo/pangeo-notebook:2025.01.24

# Disable announcements
RUN jupyter labextension disable "@jupyterlab/apputils-extension:announcements"

USER root

ARG MAMBA_USER=mambauser
ARG MAMBA_USER_ID=57439
ARG MAMBA_USER_GID=57439
ENV MAMBA_USER=$MAMBA_USER
ENV MAMBA_ROOT_PREFIX="/opt/conda"
ENV MAMBA_EXE="/bin/micromamba"

COPY --from=micromamba "$MAMBA_EXE" "$MAMBA_EXE"
COPY --from=micromamba /usr/local/bin/_activate_current_env.sh /usr/local/bin/_activate_current_env.sh
COPY --from=micromamba /usr/local/bin/_dockerfile_shell.sh /usr/local/bin/_dockerfile_shell.sh
COPY --from=micromamba /usr/local/bin/_entrypoint.sh /usr/local/bin/_entrypoint.sh
COPY --from=micromamba /usr/local/bin/_dockerfile_initialize_user_accounts.sh /usr/local/bin/_dockerfile_initialize_user_accounts.sh
COPY --from=micromamba /usr/local/bin/_dockerfile_setup_root_prefix.sh /usr/local/bin/_dockerfile_setup_root_prefix.sh

RUN /usr/local/bin/_dockerfile_initialize_user_accounts.sh && \
    /usr/local/bin/_dockerfile_setup_root_prefix.sh

USER $MAMBA_USER

SHELL ["/usr/local/bin/_dockerfile_shell.sh"]

ENTRYPOINT ["/usr/local/bin/_entrypoint.sh"]
CMD ["/bin/bash"]

COPY environment.yml /usr/local/bin/environment.yml
WORKDIR /usr/local/bin
RUN micromamba install --yes --name base -f environment.yml

USER root

RUN apt-get -y -q update \
 && apt-get -y -q upgrade \
 && apt-get -y -q install \
        bash-completion \
        libnetcdf-c++4-dev \
        libboost-log1.74 \
        libboost-program-options1.74 \
        libeigen3-dev \
        netcdf-bin \
        vim \
        wget \
        cmake \
        git \
&& rm -rf /var/lib/apt/lists/*

# Copy from build container
COPY --from=next /build/nextsimdg/build/ /opt/nextsimdg
RUN  ln -s /opt/nextsimdg/nextsim /usr/local/bin/

WORKDIR 
RUN git clone -b develop https://github.com/nextsimdg/nextsimdg.git
