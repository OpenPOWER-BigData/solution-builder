#!/bin/bash
rm cuda_installed
rm mldl-repo-local_*.deb cuda-repo-ubuntu1604*.deb
apt-get purge -yqq cuda*
apt-get purge -yqq libcuda1-*
rm /etc/apt/sources.list.d/cuda.list /etc/apt/sources.list.d/ibm-mldl-repo-local.list
apt-get update -y 

