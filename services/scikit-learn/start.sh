#!/bin/bash
set -ex
cd /WORK_DIR
jupyter notebook --ip=`hostname -i` --no-browser --allow-root
 

