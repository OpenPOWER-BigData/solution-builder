#!/bin/bash
if [ -f UBUNTU ]; then
   RUNLEVEL=1 apt-get -qqy install spark-master spark-history-server
else
   yum install -y -q spark-master spark-history-server
fi
