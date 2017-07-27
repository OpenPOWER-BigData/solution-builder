#!/bin/bash
#set -ex
rm ${PWD##*/}-installed
UBUNTU=`cat /etc/*-release | grep ubuntu`

if [ ! -z  "$UBUNTU" ]; then
   apt-get purge -y mysql-server 
   apt autoremove
else 
  echo "TBD" 
fi


