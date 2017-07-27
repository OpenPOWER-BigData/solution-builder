#!/bin/bash
if [ -f UBUNTU ]; then
 RUNLEVEL=1 apt-get install -yqq zeppelin
else 
 yum install -y -q zeppelin
fi

