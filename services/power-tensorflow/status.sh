#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m' # No Color
RED='\033[0;31m'
service="PowerAI-TensorFlow"
result=`dpkg --get-selections | grep tensorflow`
if [  ! -z  "$result" ]; then
	printf "$service is ${GREEN}installed${NC}\n"
else
	printf "$service is ${RED}not installed${NC}\n"
fi
