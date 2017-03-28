#!/bin/bash
set -ex


if [ $HOSTTYPE = "powerpc64le" ] ; then
   arch="-ppc64le"
fi
if [ -f UBUNTU ]; then
  wget -q https://ci.bigtop.apache.org/view/Packages/job/Bigtop-trunk-packages-by-jenkins/COMPONENTS=zeppelin,OS=ubuntu-16.04$arch/lastSuccessfulBuild/artifact/output/zeppelin/zeppelin_0.7.0-1_all.deb
  RUNLEVEL=1 dpkg -i zeppelin*.deb
  rm zeppelin_*.deb
else 
 yum install -y -q zeppelin*.rpm
fi

