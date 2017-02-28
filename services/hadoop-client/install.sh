#!/bin/bash
#set -ex
echo "deploy arguemnt="$@
for i in "$@"
do
    case $i in
        --spark-version )
           SPARK_VERSION=$1
           shift
           ;;
        * )
        shift;;
    esac
    shift
done
SPARK="spark"

if [ -f /etc/os-release ]; then
    . /etc/os-release
else
    if [ -f /etc/redhat-release ]; then
	    ID=RHEL
	    VERSION_ID=7
    fi
fi
case ${ID}-${VERSION_ID} in
      ubuntu-*)
        BIGTOP_OS_TYPE="ubuntu-16.04"  
        touch UBUNTU
        apt-get install -f -y
        apt-get update -qqy
        apt-get install -qqy python wget fuse openssl liblzo2-2 openjdk-8-jdk unzip netcat-openbsd apt-utils openssh-server libsnappy1v5 libsnappy-java ntp cpufrequtils curl
      ;;
      *)
        BIGTOP_OS_TYPE="fedora-25"
        yum -y -q update
        yum install -y -q sudo hostname gzip wget vim java-1.8.0-openjdk-devel openssl zlib compat-libstdc++-33 snappy openssh-clients openssh-server initscripts nc unzip fuse curl
        NOARCH="noarch"
          
esac
jsvcarch="amd64"
zkarch="x86_64"
if [ $HOSTTYPE = "powerpc64le" ] ; then
	arch="-ppc64le"
	jsvcarch="ppc64el"
        zkarch="ppc64le"
fi

if [[ $SPARK_VERSION == 1* ]]; then 
   SPARK="spark1" 
fi


install_package(){
	URL=$1
	FILE=$2
        wget "$URL/$FILE.deb" -qO $FILE.deb &&  dpkg -i $FILE.deb
        rm $FILE.deb
        
}



if [ -f hadoop_client_installed ] ; then
	exit
fi

service ntp start
if [ -f UBUNTU ]; then
 ufw disable
else
 service firewalld stop
 systemctl disable firewalld 
fi

ulimit -n 10000
echo "downloading Apache Bigtop Stack (Hadoop 2.7.3 and Spark $SPARK_VERSION) ......."
BIGTOP_BASE_URL="https://ci.bigtop.apache.org/job/Bigtop-trunk-packages/COMPONENTS"
	
pkg_dir=$PWD/pkg_bigtop
#if [ ! -d $pkg_dir  ] ; then
	rm -rf $pkg_dir; mkdir $pkg_dir; cd $_
	wget -qO hadoop.zip $BIGTOP_BASE_URL=hadoop,OS=$BIGTOP_OS_TYPE$arch/lastSuccessfulBuild/artifact/*zip*/archive.zip
	wget -qO spark.zip $BIGTOP_BASE_URL=$SPARK,OS=$BIGTOP_OS_TYPE$arch/lastSuccessfulBuild/artifact/*zip*/archive.zip
        unzip hadoop.zip; unzip spark.zip; find -name "*.rpm" -o -name "*.deb" | xargs -I{} mv {} .; rm -rf hadoop; rm -rf spark; rm -f *.zip
#fi

echo "download complete ......."

cd $pkg_dir
if [ $ID = "ubuntu" ]; then
   install_package $BIGTOP_BASE_URL=bigtop-utils,OS=$BIGTOP_OS_TYPE$arch/lastSuccessfulBuild/artifact/output/bigtop-utils bigtop-utils_1.2.0-1_all
   install_package $BIGTOP_BASE_URL=bigtop-groovy,OS=$BIGTOP_OS_TYPE$arch/lastSuccessfulBuild/artifact/output/bigtop-groovy bigtop-groovy_2.4.4-1_all
   install_package $BIGTOP_BASE_URL=bigtop-jsvc,OS=$BIGTOP_OS_TYPE$arch/lastSuccessfulBuild/artifact/output/bigtop-jsvc bigtop-jsvc_1.0.15-1_$jsvcarch
   install_package $BIGTOP_BASE_URL=bigtop-tomcat,OS=$BIGTOP_OS_TYPE$arch/lastSuccessfulBuild/artifact/output/bigtop-tomcat  bigtop-tomcat_6.0.45-1_all
   install_package $BIGTOP_BASE_URL=zookeeper,OS=$BIGTOP_OS_TYPE/lastSuccessfulBuild/artifact/output/zookeeper zookeeper_3.4.6-1_all
   RUNLEVEL=1 dpkg -i hadoop_*.deb hadoop-client_*.deb hadoop-conf*.deb hadoop-hdfs*.deb hadoop-httpfs*.deb  hadoop-mapreduce*.deb hadoop-yarn*.deb libhdfs0_*.deb
   RUNLEVEL=1 dpkg -i spark*.deb 
else
   rm -f *.src.rpm
   yum install -y -q $BIGTOP_BASE_URL=bigtop-utils,OS=$BIGTOP_OS_TYPE$arch/lastSuccessfulBuild/artifact/output/bigtop-utils/noarch/bigtop-utils-1.2.0-1.fc25.noarch.rpm
   yum install -y -q $BIGTOP_BASE_URL=bigtop-groovy,OS=$BIGTOP_OS_TYPE$arch/lastSuccessfulBuild/artifact/output/bigtop-groovy/noarch/bigtop-groovy-2.4.4-1.fc25.noarch.rpm
   yum install -y -q $BIGTOP_BASE_URL=bigtop-jsvc,OS=$BIGTOP_OS_TYPE$arch/lastSuccessfulBuild/artifact/output/bigtop-jsvc/ppc64le/bigtop-jsvc-1.0.15-1.fc25.ppc64le.rpm
   yum install -y -q $BIGTOP_BASE_URL=bigtop-tomcat,OS=$BIGTOP_OS_TYPE$arch/lastSuccessfulBuild/artifact/output/bigtop-tomcat/noarch/bigtop-tomcat-6.0.45-1.fc25.noarch.rpm
   yum install -y -q $BIGTOP_BASE_URL=zookeeper,OS=$BIGTOP_OS_TYPE$arch/lastSuccessfulBuild/artifact/output/zookeeper/ppc64le/zookeeper-3.4.6-1.fc25.$zkarch.rpm
#yum install -y -q hadoop-2*.rpm hadoop-client-*.rpm  hadoop-conf*.rpm hadoop-hdfs*.rpm hadoop-httpfs*.rpm  hadoop-mapreduce*.rpm hadoop-yarn*.rpm libhdfs0*.rpm
   yum install -y -q hadoop-2.*.rpm hadoop-client-*.rpm hadoop-conf-pseudo-*.rpm hadoop-hdfs-*.rpm hadoop-yarn-*.rpm hadoop-mapreduce-*.rpm hadoop-yarn-nodemanager*.rpm hadoop-hdfs-datanode*.rpm hadoop-hdfs-secondarynamenode*.rpm hadoop-yarn-resourcemanager*.rpm hadoop-mapreduce-historyserver*.rpm hadoop-hdfs-namenode*.rpm --exclude=hadoop-hdfs-fuse-*
   yum install -y -q spark-*.rpm
fi

cd .. 
touch hadoop_client_installed
