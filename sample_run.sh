#!/bin/bash

numExe=7
exeCores=5
exeMem=10GB
driCores=4
drivMem=4GB
src=prod

export HADOOP_OPTS="$HADOOP_OPTS -Dhttps.protocols=TLSv1.1,TLSv1.2 -Djava.library.path=/opt/cloudera/parcels/CDH-5.8.2-1.cdh5.8.2.p0.3/lib/hadoop/lib/native"
export CLASSPATH="$CLASSPATH:/hadoop/jars/*:/opt/cloudera/parcels/CDH-5.8.2-1.cdh5.8.2.p0.3/jars/ojdbc6.jar"

rc=0
echo `date +"%Y%m%d %H:%M:%S"` StartingScript

spark-submit -v --name "jdbc2Hive-${src}"  \
--class pub.ayada.scala.sparkUtils.HiveLoad \
--master yarn --deploy-mode cluster \
--num-executors ${numExe} --executor-cores ${exeCores} --executor-memory ${exeMem} \
--driver-cores ${driCores} --driver-memory ${drivMem} \
--conf spark.hadoop.hadoop.security.credential.provider.path=jceks://hdfs/keystore/alias.jceks \
--conf spark.driver.extraJavaOptions="-XX:MaxPermSize=2048m -XX:PermSize=1024m" \
--conf spark.executor.extraJavaOptions="-XX:MaxPermSize=2048m -XX:PermSize=1024m" \
--jars /opt/cloudera/parcels/CDH-5.8.2-1.cdh5.8.2.p0.3/jars/mysql-connector-java.jar,/opt/cloudera/parcels/CDH-5.8.2-1.cdh5.8.2.p0.3/jars/ojdbc6.jar \
/hadoop/jars/SparkUtils-0.1-jar-with-dependencies.jar \
"jdbc2Hive" --JobConf "hdfs:///user/k-ayada/${src}.xml" >./${src}.log 2>&1

rc=$?

echo `date +"%Y%m%d %H:%M:%S"` Ending Script RC:$rc
