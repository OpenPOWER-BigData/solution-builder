#!/bin/bash
set -ex
#################### Add installation steps here ######

if [ -f UBUNTU ]; then
	dpkg -l | grep hive >/dev/null 2>&1
	if [ $? -ne 0 ]; then
   	apt-get install -yqq hive-hcatalog hive libmysql-java
   	else
   		echo "hive is already installed"
   	fi
else 
   
   for i in hive-hcatalog hive libmysql-java
	do
		rpm -qa |grep $i >/dev/null 2>&1
		if [ $? -ne 0 ]; then
		mdb=1
		fi
	done
	if [ $mdb -ne 0 ]; then
		yum install -y -q hive-hcatalog hive libmysql-java
	else
		echo "hive connector is installed already" 
fi


#####################################################


echo "Setup Hive Complete !! "
hive -e "SHOW TABLES;"
echo "Hive test Completed"
