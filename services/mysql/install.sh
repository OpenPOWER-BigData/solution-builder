#!/bin/bash
SERVICE_NAME=$1
BD_USER=$2
arg1=$3
arg2=$4
arg3=$5
solution_args=$6
SQL_ROOT_PASSWRD=$solution_args

CURDIR=`pwd`            # Inside hadoop-cluster-utils directory where run.sh is exist
current_time=$(date +"%Y.%m.%d.%S")

if [ ! -d $CURDIR/logs ];
then
    mkdir logs
fi

log=`pwd`/logs/solutuion_builder_$current_time.log
echo -e | tee -a $log

echo $SQL_ROOT_PASSWRD
export LC_ALL=C
service_name=$SERVICE_NAME-installed
if [ -f $service_name ]; then
        exit
fi
UBUNTU=`cat /etc/*-release | grep ubuntu`
#################### Add installation steps here ######

if [ ! -z "$UBUNTU" ]; then
  	echo "Setting up mysql"
  	python -mplatform  |grep -i redhat >/dev/null 2>&1
  	# Ubuntu
	if [ $? -ne 0 ]; then
	  	dpkg -l | grep mysql >/dev/null 2>&1
	  	if [ $? -ne 0 ]; then
	  		sudo apt-key update
	  		sudo apt-get -y update
	  		sudo apt-get -y dist-upgrade
	  		dpkg -S /usr/bin/mysql
	  		if [ $? -ne 0 ]; then
	  			sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password ${SQL_ROOT_PASSWRD}'
				sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password ${SQL_ROOT_PASSWRD}'
	  			sudo apt-get -y install mysql-server --force-yes
	  			sudo apt-get -y install mysql-client --force-yes
	  		fi
	  	else
	  		echo "mysql is already installed"
	  	fi 
	  	if [ ! -f /usr/share/java/mysql-connector-java.jar ]
		then
			sudo apt-get -y install libmysql-java --force-yes
		else
			echo "mysql connector is installed already" | tee -a $log
	  	fi

	  	sudo netstat -tap | grep mysql >/dev/null 2>&1
	  	if [ $? -ne 0 ]
		then
			sudo systemctl restart mysql.service
			sudo netstat -tap | grep mysql
			if [ $? -ne 0 ]; then
				echo "Failed to start mysql" | tee -a $log
				exit 255
			fi
			
		fi
	fi
else
	# RedHat
	mdb=0
	for i in mariadb mariadb-server mariadb-libs
	do
		rpm -qa |grep $i >/dev/null 2>&1
		if [ $? -ne 0 ]; then
		mdb=1
		fi
	done
			
	if [ $mdb -ne 0 ]; then
		sudo yum -y install mariadb mariadb-server mariadb-libs >/dev/null 2>&1
		sudo systemctl start mariadb.service
		sudo systemctl enable mariadb.service

		rpm -qa | grep expect >/dev/null 2>&1
		if [ $? -ne 0 ] ; then
			sudo yum -y install expect >/dev/null 2>&1
		fi

				echo "Setting mysql root password to ${SQL_ROOT_PASSWRD}" | tee -a $log
				SECURE_MYSQL=$(expect -c "
				set timeout 10
				spawn mysql_secure_installation
				expect \"Enter current password for root (enter for none):\"
				send \"\r\"
				expect \"Set root password?\"
				send \"y\r\"
				expect \"New password:\"
				send \"$MYSQL\r\"
				expect \"Re-enter new password:\"
				send \"$MYSQL\r\"
				expect \"Remove anonymous users?\"
				send \"y\r\"
				expect \"Disallow root login remotely?\"
				send \"y\r\"
				expect \"Remove test database and access to it?\"
				send \"y\r\"
				expect \"Reload privilege tables now?\"
				send \"y\r\"
				expect eof
				")

					
	else
		echo "mysql is already installed" 
	fi

	if [ ! -f /usr/share/java/mysql-connector-java.jar ]
	then
		sudo sudo yum -y install mysql-connector-java
	else
		echo "mysql connector is installed already" 
	fi
fi
	
mysql -u root -p${SQL_ROOT_PASSWRD} -e 'select user from mysql.user where user="hive" and host="localhost";' 2>&1 | grep -w hive >/dev/null
		if [ $? -ne 0 ]
		then
			mysql -u root -p${SQL_ROOT_PASSWRD} -e "CREATE USER 'hive'@'%' IDENTIFIED BY 'hivepassword';GRANT all on *.* to 'hive'@localhost identified by 'hivepassword';flush privileges;"
			if [ $? -ne 0 ]
			then
				echo "Failed to create hive user"
				exit 255
			fi
			echo "User hive added to mysql"
		else
			mysql -u hive -phivepassword -e "show databases;" >/dev/null 2>&1
			if [ $? -ne 0 ]
			then
				echo "Note: Error accessing hive user with the password: hivepassword;"
				echo "      Ensure that the ConnectionUserName/ConnectionPassword in hive-site.xml"
				echo "      in Spark conf directory matches with the mysql's hive user"
			fi
			echo "Existing user hive in mysql is sufficient."
		fi

#Copying hive-site.xml into ${SPARK_HOME}/conf/

		if [ ! -f /usr/lib/spark/conf/hive-site.xml ]
		then
			cp /home/user1/solution-builder/services/hive/hive-site.xml /usr/lib/spark/conf/hive-site.xml
			if [ $? -eq 0 ]
			then
			   echo "Sucessfully placed /usr/lib/spark/conf/hive-site.xml"
			fi
		else
			echo "/usr/lib/spark/conf/hive-site.xml exist already."
			echo "Note: Check it out javax.jdo.option.ConnectionUserName"
			echo "      and javax.jdo.option.ConnectionPassword attributes"
			echo "      it should match with the mysql's hive user"
		fi

		echo "Adding mysql connector to Spark Classpath"
		grep spark.executor.extraClassPath /usr/lib/spark/conf/spark-defaults.conf | grep -v "^#" | grep mysql-connector-java.jar >/dev/null 2>&1
		if [ $? -ne 0 ]; then
			grep spark.executor.extraClassPath /usr/lib/spark/conf/spark-defaults.conf | grep -v "^#" >/dev/null 2>&1
			if [ $? -ne 0 ]; then
			# Fresh entry
				echo "spark.executor.extraClassPath /usr/share/java/mysql-connector-java.jar" >> /usr/lib/spark/conf/spark-defaults.conf
			else
			# append to the existing CLASSPATH
				sed -i '/^spark.executor.extraClassPath/ s~$~:/usr/share/java/mysql-connector-java.jar~' /usr/lib/spark/conf/spark-defaults.conf
			fi
			echo "Added mysql-connector-java.jar to spark executor classpath"
		fi

		grep spark.driver.extraClassPath /usr/lib/spark/conf/spark-defaults.conf | grep -v "^#" | grep mysql-connector-java.jar >/dev/null 2>&1
		if [ $? -ne 0 ]; then
			grep spark.driver.extraClassPath /usr/lib/spark/conf/spark-defaults.conf | grep -v "^#" >/dev/null 2>&1
			if [ $? -ne 0 ]; then
			# Fresh entry
				echo "spark.driver.extraClassPath /usr/share/java/mysql-connector-java.jar" >> /usr/lib/spark/conf/spark-defaults.conf
			else
			# append to the existing CLASSPATH
				sed -i '/^spark.driver.extraClassPath/ s~$~:/usr/share/java/mysql-connector-java.jar~' /usr/lib/spark/conf/spark-defaults.conf
			fi
			echo "Added mysql-connector-java.jar to spark driver classpath"
		fi
		
	
    echo "---------------------------------------------"

echo "Setup Complete !! "

#####################################################
touch $service_name
