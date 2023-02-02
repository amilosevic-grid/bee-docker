#!/bin/sh

DRIVER_LOGLEVEL=INFO
EXECUTOR_LOGLEVEL=WARN
BEE_JAR=/bee/beecore_2.12-0.6-assembly.jar
CONF_FILE=/conf/hello.conf

echo "Running spark-submit!"

/opt/spark/bin/spark-submit\
    --class com.vodafone.automotive.spark.bee.core.BeeCore\
    --conf spark.jars.ivy=/tmp/.ivy\
    --jars /bee/jars/beeutilities_2.12-0.5-assembly.jar\
    --deploy-mode client $BEE_JAR -c $CONF_FILE -f hocon
