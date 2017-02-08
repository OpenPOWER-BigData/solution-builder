#!/bin/bash
if [ -f UBUNTU ]; then
 apt-get purge -qqy zeppelin 
else 
 yum remove -y -q zeppelin
fi

