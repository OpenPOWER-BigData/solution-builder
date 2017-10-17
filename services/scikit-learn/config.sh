#!/bin/bash
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

echo "export PYSPARK_PYTHON=python3 pyspark" >> /etc/environment
echo "export PYSPARK_DRIVER_PYTHON=jupyter" >> /etc/environment
echo "export PYSPARK_DRIVER_PYTHON_OPTS='notebook'" >> /etc/environment
pushd /home/$BD_USER
su $BD_USER -c "yes | jupyter notebook --generate-config"
jupyter_file=/home/$BD_USER/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.port = 9999" >> $jupyter_file
echo "c.NotebookApp.ip = '`hostname -i`'" >> $jupyter_file
echo "c.NotebookApp.open_browser = False" >> $jupyter_file
echo "c.NotebookApp.notebook_dir = '/home/$BD_USER'" >> $jupyter_file

popd
