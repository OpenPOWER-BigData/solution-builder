#!/bin/bash
bd_user=$1

export PYSPARK_PYTHON=python3 pyspark
export PYSPARK_DRIVER_PYTHON=jupyter 
export PYSPARK_DRIVER_PYTHON_OPTS='notebook'

if [ -z "$SPARK_HOME" ]; then
  su $bd_user -c "jupyter notebook  2> /dev/null &"
else
  su $bd_user -c "pyspark  2> /dev/null &"
fi

