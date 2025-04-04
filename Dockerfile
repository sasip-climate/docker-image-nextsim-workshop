##build nextsimdg model
FROM ghcr.io/nextsimhub/nextsimdg-dev-env:latest

RUN git clone https://github.com/nextsimhub/nextsimdg.git /nextsimdg

WORKDIR /nextsimdg/build

ARG mpi=OFF
ARG xios=OFF
ARG jobs=1

RUN . /opt/spack-environment/activate.sh && cmake -DENABLE_MPI=$mpi -DENABLE_XIOS=$xios -Dxios_DIR=/xios .. && make -j $jobs

##install nedas required libraries
RUN apt-get update && apt-get install -y python3-pip && rm -rf /var/lib/apt/lists/*
RUN pip3 install --upgrade pip

RUN git clone https://github.com/nansencenter/NEDAS.git /NEDAS

WORKDIR /NEDAS
RUN git checkout -b develop origin/develop

RUN pip install -r requirements.txt
RUN pip install numba jupyter

###run notebook
WORKDIR /nextsim-workshop

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root" ]
