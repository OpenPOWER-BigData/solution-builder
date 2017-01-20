#!/bin/bash
#set -ex
BD_USER=$1
SPARK_VERSION=$2
SPARK="spark"
if [[ $SPARK_VERSION == 1* ]]; then 
   SPARK="spark1" 
fi

install_package(){
	URL=$1
	FILE=$2
	wget "$URL" -qO $FILE &&  dpkg -i $FILE
	rm $FILE
}

if [ -f hadoop_client_installed ] ; then
	exit
fi
apt-get update -qqy
apt-get install -qqy python wget fuse openssl liblzo2-2 openjdk-8-jdk unzip netcat-openbsd apt-utils openssh-server libsnappy1v5 libsnappy-java ntp cpufrequtils
service ntp start
#ufw disable
ulimit -n 10000
	
arch2="amd64"
if [ $HOSTTYPE = "powerpc64le" ] ; then
	arch="-ppc64le"
	arch2="ppc64el"
fi
pkg_dir=$PWD/pkg_bigtop
if [ ! -d $pkg_dir  ] ; then
	mkdir $pkg_dir; cd $_
	
	wget -qO hadoop.zip https://ci.bigtop.apache.org/job/Bigtop-trunk-packages/COMPONENTS=hadoop,OS=ubuntu-16.04$arch/lastSuccessfulBuild/artifact/*zip*/archive.zip
	unzip hadoop.zip; mv archive/output/hadoop/*.deb .; rm -rf hadoop; rm hadoop.zip
	wget -qO spark.zip https://ci.bigtop.apache.org/job/Bigtop-trunk-packages/COMPONENTS=$SPARK,OS=ubuntu-16.04-ppc64le/lastSuccessfulBuild/artifact/*zip*/archive.zip
	unzip spark.zip; mv archive/output/$SPARK/*.deb .; rm -rf spark; rm spark.zip

fi
	install_package https://ci.bigtop.apache.org/job/Bigtop-trunk-packages/COMPONENTS=bigtop-utils,OS=ubuntu-16.04$arch/lastSuccessfulBuild/artifact/output/bigtop-utils/bigtop-utils_1.2.0-1_all.deb bigtop-utils_1.2.0-1_all.deb
	install_package https://ci.bigtop.apache.org/job/Bigtop-trunk-packages/COMPONENTS=bigtop-groovy,OS=ubuntu-16.04$arch/lastSuccessfulBuild/artifact/output/bigtop-groovy/bigtop-groovy_2.4.4-1_all.deb bigtop-groovy_2.4.4-1_all.deb
	install_package https://ci.bigtop.apache.org/job/Bigtop-trunk-packages/COMPONENTS=bigtop-jsvc,OS=ubuntu-16.04$arch/lastSuccessfulBuild/artifact/output/bigtop-jsvc/bigtop-jsvc_1.0.15-1_$arch2.deb bigtop-jsvc.deb
	install_package https://ci.bigtop.apache.org/job/Bigtop-trunk-packages/COMPONENTS=bigtop-tomcat,OS=ubuntu-16.04$arch/lastSuccessfulBuild/artifact/output/bigtop-tomcat/bigtop-tomcat_6.0.45-1_all.deb  bigtop-tomcat_6.0.45-1_all.deb
	install_package https://ci.bigtop.apache.org/job/Bigtop-trunk-packages/COMPONENTS=zookeeper,OS=ubuntu-16.04/lastSuccessfulBuild/artifact/output/zookeeper/zookeeper_3.4.6-1_all.deb zookeeper_3.4.6-1_all.deb 

cd $pkg_dir
RUNLEVEL=1 dpkg -i hadoop_*.deb hadoop-client*.deb hadoop-conf*.deb hadoop-hdfs*.deb hadoop-httpfs*.deb  hadoop-mapreduce*.deb hadoop-yarn*.deb libhdfs0_*.deb
RUNLEVEL=1 dpkg -i spark*.deb 
cd .. 
touch hadoop_client_installed
