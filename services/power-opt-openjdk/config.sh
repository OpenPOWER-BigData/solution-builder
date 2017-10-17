#!/bin/bash
SERVICE_NAME=$1
BD_USER=$2
arg1=$3
arg2=$4
arg3=$5
solution_args=$6

change_xml_element() {
    name=$1
    value=$2
    file=$3
    sed  -i "/<name>$name<\/name>/!b;n;c<value>$value</value>" $file
} 

add_element(){
    name=$1
    value=$2
    xml_file=$3

    CONTENT="<property>\n<name>$name</name>\n<value>$value</value>\n</property>"
    C=$(echo $CONTENT | sed 's/\//\\\//g')
    sed -i -e "/<\/configuration>/ s/.*/${C}\n&/" $xml_file
}
if [ -f opt_openjdk_configured ] ; then
        exit
fi
install_path=/opt/openjdk-1.8
JAVA_HOME=$install_path
echo "export JAVA_HOME=$JAVA_HOME" |  tee -a  /etc/environment
echo "export PATH=$install_path/bin:$PATH"  |  tee -a  /etc/environment
touch opt_openjdk_configured
source /etc/environment
