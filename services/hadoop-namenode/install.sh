#!/bin/bash
if [ -f UBUNTU ]; then
   RUNLEVEL=1 apt-get -qqy install hadoop-hdfs-namenode
else
   yum install -y -q hadoop-hdfs-namenode
fi

