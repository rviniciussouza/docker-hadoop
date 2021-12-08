#!/bin/bash

# Arquivos de entrada
echo "Copiando arquivos de entrada para o HDFS..."
$HADOOP_HOME/bin/hdfs dfs -put -f $PATH_DATASET /datasets/
echo "Copiando arquivos com as consultas para o HDFS..."
$HADOOP_HOME/bin/hdfs dfs -put -f $PATH_QUERIES /consultas/
echo "Copiando arquivos com os pivos para o HDFS..."
$HADOOP_HOME/bin/hdfs dfs -put -f $PATH_PIVOTS /pivots/

# Formatando o diretório de saída
$HADOOP_HOME/bin/hdfs dfs -rm -r $OUTPUT_DFS
# Formatando o diretório com resultados intermediarios
$HADOOP_HOME/bin/hdfs dfs -rm -r -f /intermediary

# Submetendo o MapReduce Job
echo "Submetendo o JOB"
time $HADOOP_HOME/bin/hadoop jar $PATH_TO_JAR $CLASSNAME \
    -D format.records=$HEAD_DATASET \
    -D mapper.number.partitions=$NUMBER_PARTITIONS \
    -D mapper.pivots.file=$PATH_PIVOTS_DFS \
    -D brid.threshold=$THRESHOLD \
    -D brid.K=$K $INPUT_DFS $INTERMEDIARY_DFS $OUTPUT_DFS/$EXPERIMENT_ID/ $PATH_QUERIES 

# Print
if [ $PRINT_RESULT == 1 ]; then    
    $HADOOP_HOME/bin/hdfs dfs -cat /outputs/*
fi

echo "Copiando arquivos de saída para o sistema de arquivos local"
$HADOOP_HOME/bin/hdfs dfs -copyToLocal -f /outputs/$EXPERIMENT_ID data/outputs/
