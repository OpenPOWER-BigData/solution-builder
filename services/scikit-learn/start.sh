#!/bin/bash
#set -ex
#cd /$work_dir
exec jupyter notebook --ip=`hostname -i` --port 9999 --no-browser --allow-root &> /dev/null &
