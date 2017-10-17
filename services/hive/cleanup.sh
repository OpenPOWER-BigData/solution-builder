#!/bin/bash

if [ -f UBUNTU ]; then
   apt-get purge -yqq hive-hcatalog hive libmysql-java
else 
   yum remove -y -q hive-hcatalog hive libmysql-java
fi
