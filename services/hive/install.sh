#!/bin/bash
#set -ex

#################### Add installation steps here ######

if [ -f UBUNTU ]; then
   apt-get install -yqq hive-hcatalog hive libmysql-java
else 
   yum install -y -q hive-hcatalog hive libmysql-java
fi


#####################################################
# add additional installation tools for namenode node here
