SPARK_EXAMPLE=`find /usr/lib/spark -name spark-examples.jar`
spark-submit --class org.apache.spark.examples.SparkPi  --master spark://master:7077 $SPARK_EXAMPLE 10
