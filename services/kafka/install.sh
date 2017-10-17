#!/bin/bash
SERVICE_NAME=$1
BD_USER=$2
arg1=$3
arg2=$4
arg3=$5
solution_args=$6

set -ex
service_name=$SERVICE_NAME-installed
if [ -f $service_name ]; then
        exit
fi
UBUNTU=`cat /etc/*-release | grep ubuntu`
#################### Add installation steps here ######

if [ $HOSTTYPE = "powerpc64le" ] ; then
      repo_arch=".ppc64le"
fi

if [ ! -z "$UBUNTU" ]; then
  apt-get install -y kafka
else 
 
  yum install -y -q sudo hostname gzip wget vim java-1.8.0-openjdk-devel openssl zlib snappy openssh-clients openssh-server initscripts nc unzip fuse curl
  wget -O /etc/yum.repos.d/bigtop.repo http://archive.apache.org/dist/bigtop/bigtop-1.2.0/repos/fedora25$repo_arch/bigtop.repo
  yum install -y kafka
fi


#####################################################
touch $service_name

