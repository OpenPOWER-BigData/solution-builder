#!/bin/bash
set -ex


if [ $HOSTTYPE = "powerpc64le" ] ; then
   arch="-ppc64le"
fi
if [ -f UBUNTU ]; then
  wget -q https://ci.bigtop.apache.org/job/Bigtop-trunk-packages/COMPONENTS=zeppelin,OS=ubuntu-16.04$arch/lastSuccessfulBuild/artifact/output/zeppelin/zeppelin_0.6.2-1_all.deb
  RUNLEVEL=1 dpkg -i zeppelin_0.6.2-1_all.deb
  rm zeppelin_0.6.2-1_all.deb
else 
 yum install -y -q zeppelin*.rpm
fi

