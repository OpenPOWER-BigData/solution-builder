#!/bin/bash
if [ -f UBUNTU ]; then
 apt-get install -yqq zeppelin
else 
 yum install -y -q zeppelin
fi

