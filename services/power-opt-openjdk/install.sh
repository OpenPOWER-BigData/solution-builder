#!/bin/bash
#set -ex
service_name=power_opt_openjdk_installed
if [ -f  $service_name ]; then
 exit 
fi
install_path=/opt/openjdk-1.8
mkdir -p $install_path
tar xvfz power-opt-openjdk/openjdk-image.tar.gz -C $install_path --strip-components 1
JAVA_HOME=$install_path
touch $service_name

