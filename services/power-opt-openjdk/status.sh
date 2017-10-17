#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m' # No Color
RED='\033[0;31m'
service="Optimized Openjdk"

install_path=/opt/openjdk-1.8

if [  ! -f "$install_path" ]; then
	printf "$service is ${GREEN}installed${NC}\n"
        java -version
else
	printf "$service is ${RED}Not installed${NC}\n"

fi
