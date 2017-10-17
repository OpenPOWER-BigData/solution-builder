#!/bin/bash
SERVICE_NAME=$1
BD_USER=$2
NAMENODE=$3
RESOURCEMANAGER=$4
SPARK_MASTER=$5
solution_args=$6

export PYSPARK_PYTHON=python3 pyspark
export PYSPARK_DRIVER_PYTHON=jupyter 
export PYSPARK_DRIVER_PYTHON_OPTS='notebook'

if [ -z "$SPARK_HOME" ]; then
  su $BD_USER -c "jupyter notebook  2> /dev/null &"
else
  su $BD_USER -c "pyspark  2> /dev/null &"
fi

