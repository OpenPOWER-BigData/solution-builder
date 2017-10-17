#!/bin/bash
#set -ex
if [ -f UBUNTU ]; then
   RUNLEVEL=1 apt-get -qqy install hadoop-mapreduce-historyserver

else
   yum install -y -q hadoop-mapreduce-historyserver
fi


