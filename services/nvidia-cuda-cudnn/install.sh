#!/bin/bash
#set -ex
if [ -f cuda_installed ] ; then
	exit
fi
apt-get -yqq update
apt-get -yqq install python-pip python3-pip  ipython ipython3 initramfs-tools curl wget
wget -q https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2v2_8.0.61-1_ppc64el-deb
dpkg -i cuda-repo-ubuntu1604-8-0-local-ga2v2_8.0.61-1_ppc64el-deb
apt-get update -y
apt-get install -y cuda
rm cuda-repo-ubuntu1604-8-0-local-ga2v2_8.0.61-1_ppc64el-deb
export PATH=/usr/local/cuda-8.0/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
cd nvidia-cuda-cudnn
wget -q http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/ppc64el/libcudnn6_6.0.21-1+cuda8.0_ppc64el.deb
wget -q http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/ppc64el/libcudnn6-dev_6.0.21-1%2Bcuda8.0_ppc64el.deb
dpkg -i libcudnn6_6.0.21-1+cuda8.0_ppc64el.deb
dpkg -i libcudnn6-dev_6.0.21-1+cuda8.0_ppc64el.deb
#pkg -i libcudnn6_6.0.21-1+cuda8.0_ppc64el.deb

cd ..
apt-get -yqq update
wget -q https://download.boulder.ibm.com/ibmdl/pub/software/server/POWER/Linux/mldl/ubuntu/mldl-repo-network_4.0.0_ppc64el.deb
dpkg -i mldl-repo-*.deb
apt-get -y update
touch cuda_installed
