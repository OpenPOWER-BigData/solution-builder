#!/bin/bash
if [ -f UBUNTU ]; then
   RUNLEVEL=1  apt-get -qqy install hadoop-yarn-nodemanager
else
   yum install -y -q hadoop-yarn-nodemanager
fi

