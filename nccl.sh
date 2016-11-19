#!/bin/bash -e

cd $HOME
git clone https://github.com/NVIDIA/nccl.git
cd nccl/
#git checkout -
make CUDA_HOME=$CUDA_HOME test
mkdir -p $NCCL_HOME
make PREFIX=$NCCL_HOME install

