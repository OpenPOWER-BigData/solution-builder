#!/bin/bash
SERVICE_NAME=$1
BD_USER=$2
arg1=$3
arg2=$4
arg3=$5
solution_args=$6
SQL_ROOT_PASSWRD=$solution_args


change_xml_element() {
    name=$1
    value=$2
    file=$3
    sed  -i "/<name>$name<\/name>/!b;n;c<value>$value</value>" $file
} 

add_element(){
    name=$1
    value=$2
    xml_file=$3

    CONTENT="<property>\n<name>$name</name>\n<value>$value</value>\n</property>"
    C=$(echo $CONTENT | sed 's/\//\\\//g')
    sed -i -e "/<\/configuration>/ s/.*/${C}\n&/" $xml_file
}

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
    cp $CURDIR/services/hive/hive-site.xml /usr/lib/spark/conf/hive-site.xml
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
