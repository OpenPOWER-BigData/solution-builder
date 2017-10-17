#!/bin/bash
#set -ex
rm ${PWD##*/}-installed
UBUNTU=`cat /etc/*-release | grep ubuntu`

if [ ! -z  "$UBUNTU" ]; then
   sudo apt-get purge -y mysql-server 
   sudo apt-get autoremove
   sudo apt-get autoclean
else 
   yum remove mysql mysql-server
fi


