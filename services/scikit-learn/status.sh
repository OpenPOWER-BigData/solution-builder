#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m' # No Color
RED='\033[0;31m'
service=jupyter
result=`pgrep jupyter`
echo $result > jupyter_pid
if [  ! -z  "$result" ]; then
	printf "$service is ${GREEN}Active${NC}\n"
else
	printf "$service is ${RED}Not Active${NC}\n"
fi
