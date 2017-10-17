#!/bin/bash
#set -ex
if [ -f hadoop_client_installed ] ; then
	exit
fi
#echo "deploy arguemnt="$@
#for i in "$@"
#do
#    case $i in
#        --spark-version )
#           SPARK_VERSION=$1
#           shift
#           ;;
#        * )
#        shift;;
#    esac
#    shift
#done
#SPARK="spark"

if [ -f /etc/os-release ]; then
    . /etc/os-release
else
    if [ -f /etc/redhat-release ]; then
	    ID=RHEL
	    VERSION_ID=7
    fi
fi
export LC_ALL=C
if [ $HOSTTYPE = "powerpc64le" ] ; then
      repo_arch=".ppc64le"
fi

case ${ID}-${VERSION_ID} in
      ubuntu-*)
        BIGTOP_OS_TYPE="ubuntu-16.04"  
        wget -O- http://archive.apache.org/dist/bigtop/bigtop-1.2.0/repos/GPG-KEY-bigtop | sudo apt-key add -
        touch UBUNTU
        apt-get install -f -y
        apt-get update -qqy
        apt-get install -qqy python wget fuse openssl liblzo2-2 openjdk-8-jdk unzip netcat-openbsd apt-utils openssh-server libsnappy1v5 libsnappy-java ntp cpufrequtils curl
        wget -O /etc/apt/sources.list.d/bigtop-1.2.0.list https://www.apache.org/dist/bigtop/bigtop-1.2.0/repos/ubuntu16.04$repo_arch/bigtop.list
        apt-get update -qqy
      ;;
      *)
        BIGTOP_OS_TYPE="fedora-25"
#      yum -y -q update
        yum install -y -q sudo hostname gzip wget vim java-1.8.0-openjdk-devel openssl zlib compat-libstdc++-33 snappy openssh-clients openssh-server initscripts nc unzip fuse curl
        wget -O /etc/yum.repos.d/bigtop.repo http://archive.apache.org/dist/bigtop/bigtop-1.2.0/repos/fedora25$repo_arch/bigtop.repo
        NOARCH="noarch"       
esac

#if [[ $SPARK_VERSION == 1* ]]; then 
#   SPARK="spark1" 
#fi


service ntp start
if [ -f UBUNTU ]; then
 ufw disable
else
 service firewalld stop
 systemctl disable firewalld 
fi

ulimit -n 10000

if [ $ID = "ubuntu" ]; then
   RUNLEVEL=1 apt-get -qqy install hadoop-client hadoop-conf-pseudo libhdfs_*
   RUNLEVEL=1 apt-get install -qqy spark-core 
   RUNLEVEL=1 apt-get install -qqy spark-external spark-datanucleus spark-history-server spark-thriftserver spark-yarn-shuffle spark-python
else
   rm -f *.src.rpm
   yum install -y -q hadoop-client hadoop-conf-pseudo libgdfs_*
   yum install -y -q spark-core spark-external spark-datanucleus spark-history-server spark-thriftserver spark-yarn-shuffle spark-python
fi

cd .. 
touch hadoop_client_installed
