#!/bin/bash
#rm -rf pkg_bigtop
#apt-get purge -qqy python wget fuse openssl liblzo2-2 openjdk-8-jdk unzip netcat-openbsd apt-utils openssh-server libsnappy1v5 libsnappy-java ntp cpufrequtils
rm hadoop_client_installed
rm hadoop_client_configured
rm -rf /usr/lib/hadoop
apt-get purge -yqq hadoop_*
apt-get purge -yqq zookeeper*.
apt-get purge -yqq spark-*
rm -rf /var/lib/hadoop-*
rm -rf /etc/spark
rm -rf /var/lib/spark
rm -rf /etc/hadoop
