#!/bin/bash
set -ex
SERVICE_NAME=$1
BD_USER=$2
arg1=$3
arg2=$4
arg3=$5
solution_args=$6

 ./$KAFKA_HOME/bin/kafka-server-stop.sh 
 ./$ZOOKEEPER_HOME/bin/zkServer.sh stop

