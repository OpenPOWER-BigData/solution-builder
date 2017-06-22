#!/bin/bash
#set -ex
if [ -f cuda_installed ] ; then
	exit
fi
apt-get -yqq update
apt-get -yqq install python-pip python3-pip  ipython ipython3 initramfs-tools curl wget
wget -q http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/ppc64el/cuda-repo-ubuntu1604_8.0.61-1_ppc64el.deb
dpkg -i cuda-repo-ubuntu1604_8.0.61-1_ppc64el.deb
apt-get update -y
apt-get install -y cuda
export PATH=/usr/local/cuda-8.0/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
cd nvidia-cuda-cudnn
dpkg -i libcudnn5*deb
cd ..
apt-get -yqq update
wget -q https://download.boulder.ibm.com/ibmdl/pub/software/server/POWER/Linux/mldl/ubuntu/mldl-repo-network_3.4.0_ppc64el.deb
dpkg -i mldl-repo-*.deb
apt-get -y update
touch cuda_installed
