#!/bin/bash
#set -ex
apt-get install -yqq linux-tools-common cpufrequtils lsb-release
apt-get purge -yqq python-socketio
apt-get install -yqq power-mldl
#cpupower -c all frequency-set -g performance

