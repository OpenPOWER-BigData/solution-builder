#!/bin/bash
#set -ex
export LC_ALL=C
#apt-get install -yqq linux-tools-common cpufrequtils lsb-release
#apt-get install -yqq tensorflow
#cpupower -c all frequency-set -g performance
apt-get -y update
apt-get install -yqq  python ipython python-pip python-seaborn python-pandas python-matplotlib
pip install --upgrade pip
#pip install  jupyter
#python2 -m pip install ipykernel
#python2 -m ipykernel install --user
pip install  jupyter
apt-get install -yqq linux-tools-common cpufrequtils lsb-release
apt-get install -yqq tensorflow
#cpupower -c all frequency-set -g performance

