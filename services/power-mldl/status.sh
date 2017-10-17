#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m' # No Color
RED='\033[0;31m'
service="power-mldl"
result=`apt-cache search $service | grep $service`
if [  ! -z  "$result" ]; then
	printf "$service is ${GREEN}installed${NC}\n"
else
	printf "$service is ${RED}not installed${NC}\n"
fi
