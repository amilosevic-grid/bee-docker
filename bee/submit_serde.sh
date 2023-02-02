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
    --files "log4j-driver.properties,log4j-executor.properties"\
    --packages org.apache.spark:spark-avro_2.12:3.2.1 \
    --conf spark.driver.extraJavaOptions="-Dlog4j.configuration=file:log4j-driver.properties -Dvm.logging.level=INFO -Dvm.logging.name=BeeCore" \
    --conf spark.executor.extraJavaOptions="-Dlog4j.configuration=file:log4j-executor.properties -Dvm.logging.level=WARN -Dvm.logging.name=BeeCore" \
    --deploy-mode client $BEE_JAR -it -c $CONF_FILE -f hocon
