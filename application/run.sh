#!/bin/bash

# Arquivos de entrada
$HADOOP_HOME/bin/hdfs dfs -put -f $PATH_DATASET /datasets/

# Formatando o diretório de saída
$HADOOP_HOME/bin/hdfs dfs -rm -r $OUTPUT_DFS

# Submetendo o MapReduce Job
echo "Submetendo o JOB"
$HADOOP_HOME/bin/hadoop jar $PATH_TO_JAR $CLASSNAME $INPUT_DFS $OUTPUT_DFS

# Print
echo "Copiando arquivos de saída para o sistema de arquivos local"
$HADOOP_HOME/bin/hdfs dfs -cat /output/*
$HADOOP_HOME/bin/hdfs dfs -copyToLocal -f /output user_data/ 