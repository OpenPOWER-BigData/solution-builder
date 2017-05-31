#!/bin/bash
set -ex
cd /work_dir
jupyter notebook --ip=`hostname -i` --no-browser --allow-root
 

