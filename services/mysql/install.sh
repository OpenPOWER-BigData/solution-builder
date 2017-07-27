#!/bin/bash
SERVICE_NAME=$1
BD_USER=$2
arg1=$3
arg2=$4
arg3=$5
solution_args=$6
SQL_ROOT_PASSWRD=$solution_args

echo $SQL_ROOT_PASSWRD
export LC_ALL=C
service_name=$SERVICE_NAME-installed
if [ -f $service_name ]; then
        exit
fi
UBUNTU=`cat /etc/*-release | grep ubuntu`
#################### Add installation steps here ######

if [ ! -z "$UBUNTU" ]; then
  debconf-set-selections <<< 'mysql-server mysql-server/root_password password $SQL_ROOT_PASSWRD'
  debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password $SQL_ROOT_PASSWRD'
  apt-get -y update
  apt-get -y install mysql-server
else 
  echo TBD
fi


#####################################################
touch $service_name

