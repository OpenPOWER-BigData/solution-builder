#!/bin/bash
SERVICE_NAME=$1
BD_USER=$2
NAMENODE=$3
RESOURCEMANAGER=$4
SPARK_MASTER=$5
solution_args=$6

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

if [ -f hadoop_client_configured ] ; then
	exit
fi

export HADOOP_PREFIX=/usr/lib/hadoop
export HADOOP_HOME=$HADOOP_PREFIX
if [ -z "$JAVA_HOME" ]; then
  export JAVA_HOME=`find /usr/lib/jvm -name java*1*8*openjdk-*`
fi

echo "export JAVA_HOME=$JAVA_HOME" |  tee -a  /etc/environment $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_CONF_DIR=/etc/hadoop/conf"  |  tee -a /etc/environment $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_PREFIX=/usr/lib/hadoop"  |  tee -a $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_LIBEXEC_DIR=/usr/lib/hadoop/libexec" |  tee -a  $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_LOGS=/usr/lib/hadoop/logs"  |  tee -a $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_COMMON_HOME=/usr/lib/hadoop" |  tee -a  $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_HDFS_HOME=/usr/lib/hadoop-hdfs" |  tee -a  $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_MAPRED_HOME=/usr/lib/hadoop-mapreduce" |  tee -a $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_YARN_HOME=/usr/lib/hadoop-yarn" |  tee -a $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
echo "export HADOOP_HOME=$HADOOP_PREFIX"  |  tee -a /etc/environment
echo "export SPARK_HOME=/usr/lib/spark"  |  tee -a /etc/environment

export HADOOP_CONF_DIR=/etc/hadoop/conf

chown -R $BD_USER:hadoop /usr/lib/hadoop*
chown -R hdfs:hadoop /var/log/hadoop-hdfs*
chown -R yarn:hadoop /var/log/hadoop-yarn*
chown -R mapred:hadoop /var/log/hadoop-mapred*
chown -R $BD_USER:hadoop /etc/hadoop

# Support $HADOOP_HOME/bin/hdfs
ln -s /usr/bin/hdfs $HADOOP_HOME/bin/hdfs

## Add and init yarn.resourcemanager.address in yarn-site.xml
sed -i s/localhost/$NAMENODE/ /etc/hadoop/conf/core-site.xml
sed -i s/localhost/$RESOURCEMANAGER/ /etc/hadoop/conf/mapred-site.xml

### Spark configuration
SPARK_LOG_DIR=hdfs:///history_logs

sed -i '/SPARK_HISTORY_OPTS/d' /etc/spark/conf/spark-env.sh
sed -i '/STANDALONE_SPARK_MASTER_HOST/d' /etc/spark/conf/spark-env.sh
echo "export STANDALONE_SPARK_MASTER_HOST=$SPARK_MASTER" >> /etc/spark/conf/spark-env.sh
echo "export SPARK_MASTER_IP=$SPARK_MASTER" >>/etc/spark/conf/spark-env.sh
echo "export SPARK_MASTER_URL=spark://\$STANDALONE_SPARK_MASTER_HOST:\$SPARK_MASTER_PORT" >>/etc/spark/conf/spark-env.sh
echo "export SPARK_HISTORY_OPTS=\"\$SPARK_HISTORY_OPTS -Dspark.history.fs.logDirectory=$SPARK_LOG_DIR -Dspark.history.ui.port=18082\"" >>/etc/spark/conf/spark-env.sh

cp /etc/spark/conf/spark-defaults.conf.template /etc/spark/conf/spark-defaults.conf
echo "spark.master                     spark://$SPARK_MASTER:7077" >>/etc/spark/conf/spark-defaults.conf
echo "spark.eventLog.enabled           true" >>/etc/spark/conf/spark-defaults.conf
echo "spark.eventLog.dir               $SPARK_LOG_DIR" >>/etc/spark/conf/spark-defaults.conf
echo "spark.yarn.am.memory             1024m" >>/etc/spark/conf/spark-defaults.conf

cp /etc/spark/conf/log4j.properties.template /etc/spark/conf/log4j.properties
echo "log4j.rootCategory=ERROR, console">>/etc/spark/conf/log4j.properties

chown -R $BD_USER:hadoop /etc/spark
add_element "yarn.resourcemanager.hostname" "$RESOURCEMANAGER" "/etc/hadoop/conf/yarn-site.xml"
add_element "yarn.resourcemanager.address" "$RESOURCEMANAGER:8032" "/etc/hadoop/conf/yarn-site.xml"
add_element "yarn.resourcemanager.resource-tracker.address" "$RESOURCEMANAGER:8031" "/etc/hadoop/conf/yarn-site.xml"
add_element "yarn.resourcemanager.scheduler.address" "$RESOURCEMANAGER:8030" "/etc/hadoop/conf/yarn-site.xml"
add_element "yarn.nodemanager.pmem-check-enabled" "false" "/etc/hadoop/conf/yarn-site.xml"
add_element "yarn.nodemanager.vmem-check-enabled" "false" "/etc/hadoop/conf/yarn-site.xml"
add_element "dfs.namenode.datanode.registration.ip-hostname-check" "false" "/etc/hadoop/conf/hdfs-site.xml"
echo "*                soft    nofile          100000" | tee -a  /etc/security/limits.conf
echo "*                hard    nofile          100000" | tee -a  /etc/security/limits.conf
touch hadoop_client_configured
