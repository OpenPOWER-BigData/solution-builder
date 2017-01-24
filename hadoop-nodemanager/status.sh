#!/bin/bash


GREEN='\033[0;32m'
NC='\033[0m' # No Color
RED='\033[0;31m'
service=NodeManager
result=`jps | grep -w $service | awk '{print $2}'`
if [  ! -z  $result ]; then
	printf "$service is ${GREEN}Active${NC}\n"
else
	printf "$service is ${RED}Not Active${NC}\n"
fi

