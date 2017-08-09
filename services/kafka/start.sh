#!/bin/bash
set -ex
SERVICE_NAME=$1
BD_USER=$2
arg1=$3
arg2=$4
arg3=$5
solution_args=$6

UBUNTU=`cat /etc/*-release | grep ubuntu`
#################### Add installation steps here ######

if [ ! -z "$UBUNTU" ]; then
 echo TBD
else 
 ./$ZOOKEEPER_HOME/bin/zkServer.sh start
 ./$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties &
  
fi
