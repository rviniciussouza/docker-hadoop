#!/bin/bash

# Arquivos de entrada
echo "Copiando arquivos de entrada para o HDFS..."
$HADOOP_HOME/bin/hdfs dfs -put -f $PATH_DATASET /datasets/

# Formatando o diretório de saída
$HADOOP_HOME/bin/hdfs dfs -rm -r $OUTPUT_DFS

# Submetendo o MapReduce Job
echo "Submetendo o JOB"
$HADOOP_HOME/bin/hadoop jar $PATH_TO_JAR $CLASSNAME $INPUT_DFS $OUTPUT_DFS

# Print
if [ $PRINT_RESULT == 1 ]; then    
    $HADOOP_HOME/bin/hdfs dfs -cat /output/*
if

echo "Copiando arquivos de saída para o sistema de arquivos local"
$HADOOP_HOME/bin/hdfs dfs -copyToLocal -f /output/ data/outputs/${CLASSNAME}_$(date +%Y%m%d%H%M%S)/