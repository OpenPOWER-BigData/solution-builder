SPARK_EXAMPLE=`find /usr/lib/spark -name spark-examples.jar`
spark-submit --class org.apache.spark.examples.SparkPi $SPARK_EXAMPLE 10
