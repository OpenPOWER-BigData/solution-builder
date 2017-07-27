#!/bin/bash
#set -ex

if [ -f UBUNTU ]; then
   RUNLEVEL=1 apt-get -qqy install hadoop-hdfs-datanode libhdfs0
else
   rm -f *.src.rpm
   yum install -y -q hadoop-hdfs-datanode
fi
