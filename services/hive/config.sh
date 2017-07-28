#!/bin/bash
set -ex
SERVICE_NAME=$1
BD_USER=$2
NAMENODE=$3
RESOURCEMANAGER=$4
SPARK_MASTER=$5
solution_args=$6
MYSQL_ROOT_PAS=$solution_args

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

mysql -u root -p$MYSQL_ROOT_PAS --execute "CREATE USER '$BD_USER'@'localhost' IDENTIFIED BY '$BD_USER'"
mysql -u root -p$MYSQL_ROOT_PAS --execute "GRANT ALL PRIVILEGES ON *.* TO '$BD_USER'@'localhost'"
mysql -u root -p$MYSQL_ROOT_PAS --execute "CREATE USER '$BD_USER'@'%' IDENTIFIED BY '$BD_USER'"
mysql -u root -p$MYSQL_ROOT_PAS --execute "GRANT ALL PRIVILEGES ON *.* TO '$BD_USER'@'%'"
mysql -u root -p$MYSQL_ROOT_PAS --execute "FLUSH PRIVILEGES"
mysql -u root -p$MYSQL_ROOT_PAS --execute "GRANT ALL PRIVILEGES ON *.* TO '$BD_USER'@'localhost' WITH GRANT OPTION"
mysql -u root -p$MYSQL_ROOT_PAS --execute "GRANT ALL PRIVILEGES ON *.* TO '$BD_USER'@'%' WITH GRANT OPTION;"

export HIVE_HOME=/usr/lib/hive
export HIVE_CONF_DIR=/etc/hive/conf
cp /usr/share/java/mysql.jar $HIVE_HOME/lib
export PATH=$PATH:$HIVE_HOME/bin:$HIVE_HOME/scripts
chown $BD_USER:hadoop -R $HIVE_CONF_DIR
