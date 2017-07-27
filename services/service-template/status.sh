#!/bin/bash
SERVICE_NAME=$1
BD_USER=$2
arg1=$3
arg2=$4
arg3=$5
solution_args=$6

GREEN='\033[0;32m'
NC='\033[0m' # No Color
RED='\033[0;31m'

service={SERVICE PROCESS NAME HERE}
result=`pgrep -w $service | awk '{print $2}'`
if [  ! -z  $result ]; then
	printf "$service is ${GREEN}Active${NC}\n"
else
	printf "$service is ${RED}Not Active${NC}\n"

fi

