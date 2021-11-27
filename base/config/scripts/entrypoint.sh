#!/bin/bash

/etc/init.d/ssh start

if [[ $HOSTNAME = master-node ]]; then
    hdfs namenode -format
    $HADOOP_HOME/sbin/start-dfs.sh
    $HADOOP_HOME/sbin/start-yarn.sh
    $HADOOP_HOME/bin/mapred --daemon start historyserver
    hdfs dfs -mkdir /datasets
    hdfs dfs -mkdir /consultas
    hdfs dfs -mkdir /pivots
else
    $HADOOP_HOME/sbin/hadoop-daemon.sh start datanode &
    $HADOOP_HOME/bin/yarn nodemanager
fi
while :; do sleep 10000; done