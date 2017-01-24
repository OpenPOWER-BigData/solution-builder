#!/bin/bash
#set -ex
BD_USER=$1
BD_PASSWD=$2

SUDO=sudo	
$SUDO  service hadoop-hdfs-namenode restart

if [ -f hdfs_configured ] ; then
	exit
fi

$SUDO -u hdfs hadoop fs -mkdir -p /tmp/hadoop-yarn/staging/history/done_intermediate
$SUDO -u hdfs hadoop fs -chown -R mapred:mapred /tmp/hadoop-yarn/staging
$SUDO -u hdfs hadoop fs -chmod -R 1777 /tmp
$SUDO -u hdfs hadoop fs -mkdir -p /var/log/hadoop-yarn
$SUDO -u hdfs hadoop fs -chown yarn:mapred /var/log/hadoop-yarn
$SUDO -u hdfs hadoop fs -mkdir -p /user/$BD_USER
$SUDO -u hdfs hadoop fs -chown $BD_USER /user/$BD_USER
$SUDO -u hdfs hadoop fs -mkdir -p /history_logs
$SUDO -u hdfs hadoop fs -chown -R spark:spark /history_logs
$SUDO -u hdfs hadoop fs -chmod -R 1777 /history_logs
touch hdfs_configured


