#!/bin/sh

DRIVER_LOGLEVEL=INFO
EXECUTOR_LOGLEVEL=WARN
BEE_JAR=/bee/beecore_2.12-0.6-assembly.jar
CONF_FILE=/conf/avro_serde.conf

echo "Running spark-submit!"

/opt/spark/bin/spark-submit\
    --class com.vodafone.automotive.spark.bee.core.BeeCore\
    --conf spark.jars.ivy=/tmp/.ivy\
    --jars /bee/jars/beeutilities_2.12-0.5-assembly.jar\
    --packages org.apache.spark:spark-avro_2.12:3.3.1\
    --deploy-mode client $BEE_JAR -it -c $CONF_FILE -f hocon
