#!/bin/bash
bd_user=$1
set -ex
#jupyter toree install --spark_home=$SPARK_HOME --spark_opts='--master=spark://master:7077'
jupyter toree install --spark_home=$SPARK_HOME
jupyter toree install --interpreters=PySpark
#cd /$work_dir
su $bd_user -c "jupyter notebook --ip=`hostname -i` --port 9999 --no-browser --notebook-dir=/home/$bd_user &"

