##build nextsimdg model
FROM ghcr.io/nextsimhub/nextsimdg-dev-env:latest

RUN git clone https://github.com/nextsimhub/nextsimdg.git /nextsimdg

WORKDIR /nextsimdg/build

ARG mpi=OFF
ARG xios=OFF
ARG jobs=1

RUN . /opt/spack-environment/activate.sh && cmake -DENABLE_MPI=$mpi -DENABLE_XIOS=$xios -Dxios_DIR=/xios .. && make -j $jobs


##install nedas required libraries
FROM python:3.11

RUN git clone https://github.com/nansencenter/NEDAS.git /NEDAS

WORKDIR /NEDAS
RUN git checkout -b develop origin/develop

RUN pip install -r requirements.txt
RUN pip install numba jupyter

##run notebook
WORKDIR /nextsim-workshop
CMD [ "jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root" ]

