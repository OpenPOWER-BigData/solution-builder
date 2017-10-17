#!/bin/bash
SERVICE_NAME=$1
BD_USER=$2
arg1=$3
arg2=$4
arg3=$5
solution_args=$6

set -ex
service_name=$SERVICE_NAME-installed
if [ -f $service_name ]; then
        exit
fi
UBUNTU=`cat /etc/*-release | grep ubuntu`
#################### Add installation steps here ######

if [ -f UBUNTU ]; then
  
else 
  
fi


#####################################################
touch $service_name

