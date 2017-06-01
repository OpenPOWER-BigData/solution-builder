#!/bin/bash
#set -ex
set -ex
export LC_ALL=C
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
        apt-get -y update
        apt-get install -yqq python3 python ipython ipython3 python3-pip python-pip python3-sklearn python3-seaborn python3-pandas python3-matplotlib
        pip3 install --upgrade pip
        pip3 install  jupyter
        pip installl https://dist.apache.org/repos/dist/dev/incubator/toree/0.2.0/snapshots/dev1/toree-pip/toree-0.2.0.dev1.tar.gz
        #pip3 install toree
        python3 -m pip install --upgrade ipykernel
      ;;
      *)
      ### TBD 
esac
