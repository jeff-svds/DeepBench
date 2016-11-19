FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y apt-utils && apt-get upgrade -y
RUN apt-get install -y software-properties-common && add-apt-repository ppa:graphics-drivers/ppa
RUN apt-get update && apt-get install -y nvidia-370 nvidia-370-dev

ENV HOME /root
COPY openmpi.sh $HOME/openmpi.sh
COPY nccl.sh $HOME/nccl.sh
RUN chmod u+x $HOME/openmpi.sh && chmod u+x $HOME/nccl.sh

RUN $HOME/openmpi.sh
ENV MPI_LIB_DIR /usr/lib/openmpi

RUN apt-get install -y git
ENV NCCL_HOME /usr/local/ncc
ENV CUDA_HOME /usr/local/cuda
RUN $HOME/nccl.sh

COPY code $HOME/code
RUN cd $HOME/code && make CUDA_PATH=$CUDA_HOME CUDNN_PATH=$CUDA_HOME \
    MPI_PATH=$MPI_LIB_DIR NCCL_PATH=$HOME/nccl ARCH=sm_61
ENV LD_LIBRARY_PATH $CUDA_HOME/lib64:$CUDA_HOME/extras/CUPTI/lib64:$MPI_LIB_DIR:$NCCL_HOM

ENTRYPOINT $HOME/code/bin/gemm_bench
