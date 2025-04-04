##build nextsimdg model
FROM ghcr.io/nextsimhub/nextsimdg-dev-env:latest

RUN git clone https://github.com/nextsimhub/nextsimdg.git /nextsimdg

WORKDIR /nextsimdg/build

ARG mpi=OFF
ARG xios=OFF
ARG jobs=1

RUN . /opt/spack-environment/activate.sh && cmake -DENABLE_MPI=$mpi -DENABLE_XIOS=$xios -Dxios_DIR=/xios .. && make -j $jobs

##install nedas
RUN git clone -b develop https://github.com/nansencenter/NEDAS.git /NEDAS

##install libraries with mamba
FROM mambaorg/micromamba:1.5.8 as micromamba

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

##install other utilities    
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


###run notebook
WORKDIR /nextsim-workshop

COPY /nextsimdg/* /nextsim-workshop/

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root" ]
