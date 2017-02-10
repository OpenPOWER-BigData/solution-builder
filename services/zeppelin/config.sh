#!/bin/bash
set -ex
NAMENODE=$1
RESOURCEMANAGER=$2
SPARK_MASTER=$3
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

sed -i -e 's|yarn-client|spark://$SPARK_MASTER:7077|g' /etc/zeppelin/conf/zeppelin-env.sh
sed -i -e 's|ZEPPELIN_PORT=8080|ZEPPELIN_PORT=8888|g' /etc/zeppelin/conf/zeppelin-env.sh
echo "export ZEPPELIN_JAVA_OPTS=\"-Dspark.executor.memory=1G -Dspark.cores.max=4\"" | tee -a /etc/zeppelin/conf/zeppelin-env.sh
cd ~ 

sudo -u hdfs hdfs dfs -mkdir /user/zeppelin
sudo -u hdfs hdfs dfs -chown -R zeppelin /user/zeppelin
chown -R zeppelin.  /var/log/zeppelin
chown -R zeppelin.  /var/run/zeppelin
