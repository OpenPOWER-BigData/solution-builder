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
pushd /home/$BD_USER
su $BD_USER -c "python2 -m pip install ipykernel"
su $BD_USER -c "python2 -m ipykernel install --user"

wget https://github.com/aymericdamien/TensorFlow-Examples/archive/master.zip
unzip master.zip
rm master.zip
chown $BD_USER: -R TensorFlow-Examples-master
su $BD_USER -c "yes | jupyter notebook --generate-config"
jupyter_file=/home/$BD_USER/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.port = 9999" >> $jupyter_file
echo "c.NotebookApp.ip = '`hostname -i`'" >> $jupyter_file
echo "c.NotebookApp.open_browser = False" >> $jupyter_file
echo "c.NotebookApp.notebook_dir = '/home/$BD_USER'" >> $jupyter_file
echo "source /opt/DL/tensorflow/bin/tensorflow-activate" >> /home/$BD_USER/.bashrc
echo "source $HADOOP_CONF_DIR/hadoop-env.sh"  >> /home/$BD_USER/.bashrc
echo "export CLASSPATH=\$(\$HADOOP_HDFS_HOME/bin/hdfs classpath --glob)" >> /home/$BD_USER/.bashrc
popd
