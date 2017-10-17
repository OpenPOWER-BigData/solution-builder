#!/bin/bash
if [ -f UBUNTU ]; then
   apt-get purge -qqy hadoop-yarn-resourcemanager 
else 
   yum remove -q -y hadoop-yarn-resourcemanager 
fi 
