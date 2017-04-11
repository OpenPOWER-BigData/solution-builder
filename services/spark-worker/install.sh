#!/bin/bash
if [ -f UBUNTU ]; then
   RUNLEVEL=1 apt-get install -qqy spark-worker
else
   yum install -y -q spark-worker
fi
