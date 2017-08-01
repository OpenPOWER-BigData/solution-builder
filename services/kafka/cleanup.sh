#!/bin/bash
set -ex
SERVICE_NAME=$1
BD_USER=$2
arg1=$3
arg2=$4
arg3=$5
solution_args=$6

rm $SERVICE_NAME-installed
UBUNTU=`cat /etc/*-release | grep ubuntu`
if [ ! -z "$UBUNTU" ]; then
  echo TBD
else 
  yum remove -y kafka
  yum remove -y zookeeper
fi


