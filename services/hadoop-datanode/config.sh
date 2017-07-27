#!/bin/bash
#set -ex
SERVICE_NAME=$1
BD_USER=$2
NAMENODE=$3
RESOURCEMANAGER=$4
SPARK_MASTER=$5
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

change_hdfs_dir(){
    suffix=$1
    option_name=$2

    j=1
    value=""
    while read i
    do
        if [ -z $i ]; then continue; fi
        dir_name="file:///hdd${j}/${suffix}"
        if [ -z $value ]; then
            value=${dir_name}
        else
            value=${value}","${dir_name}
        fi
        j=$[$j+1]
    done < $SERVICE_NAME/disk_list

    change_xml_element $option_name $value "/etc/hadoop/conf/hdfs-site.xml"
}

change_spark_local_dir(){
    suffix=$1

    j=1
    value=""
    while read i
    do
        if [ -z $i ]; then continue; fi
        dir_name="/hdd${j}/${suffix}"
        if [ -z $value ]; then
            value=${dir_name}
        else
            value=${value}","${dir_name}
        fi
        sudo mkdir -p ${dir_name}
        j=$[$j+1]
    done < $SERVICE_NAME/disk_list

    echo "export SPARK_LOCAL_DIRS=$value" >>/etc/spark/conf/spark-env.sh
}


if [ -f $SERVICE_NAME/disk_list ]; then
    ./prep_disks.sh $SERVICE_NAME/disk_list
    chown -R hdfs:hadoop /hdd*

    change_hdfs_dir "hdfs/name" "dfs.namenode.name.dir"
    change_hdfs_dir "hdfs/data" "dfs.datanode.data.dir"

    change_spark_local_dir "spark/local"
    sudo chown -R spark:spark /hdd*/spark/*
    sudo chmod -R 1777 /hdd*/spark/*
fi
	
