#!/bin/bash

# Arquivos de entrada
echo "Copiando arquivos de entrada para o HDFS..."
if ! $HADOOP_HOME/bin/hdfs dfs -test -e /datasets/$DATASET_NAME/; then
    $HADOOP_HOME/bin/hdfs dfs -mkdir /datasets/$DATASET_NAME
fi
$HADOOP_HOME/bin/hdfs dfs -put $PATH_DATASET /datasets/$DATASET_NAME/

echo "Copiando arquivos com as consultas para o HDFS..."
if ! $HADOOP_HOME/bin/hdfs dfs -test -e /consultas/$DATASET_NAME/; then
    $HADOOP_HOME/bin/hdfs dfs -mkdir /consultas/$DATASET_NAME
fi
$HADOOP_HOME/bin/hdfs dfs -put $PATH_QUERIES /consultas/$DATASET_NAME/

IDX_PATH_PIVOT=2
for K in $SIZE
do
    for PARTITIONS in $NUMBER_PARTITIONS
    do
        if ! $HADOOP_HOME/bin/hdfs dfs -test -e /pivots/$DATASET_NAME/; then
            $HADOOP_HOME/bin/hdfs dfs -mkdir /pivots/$DATASET_NAME
        fi
        echo "Copiando arquivos com os pivos para o HDFS..."
        $HADOOP_HOME/bin/hdfs dfs -put $PATH_PIVOTS/$IDX_PATH_PIVOT /pivots/$DATASET_NAME/

        # Formatando o diretório de saída do experimento
        $HADOOP_HOME/bin/hdfs dfs -rm -r $OUTPUT_DFS/$EXPERIMENT_ID/
        # Formatando o diretório com resultados intermediarios do experimento
        $HADOOP_HOME/bin/hdfs dfs -rm -r $INTERMEDIARY_DFS/$EXPERIMENT_ID/
        # Limpando o diretório de logs do experimento
        $HADOOP_HOME/bin/hdfs dfs -rm -r $PATH_LOGS_NUMBER_METRIC_CALLS/$EXPERIMENT_ID
        $HADOOP_HOME/bin/hdfs dfs -rm -r $PATH_LOGS_NUMBER_DUPLICATES/$EXPERIMENT_ID

        # Submetendo o MapReduce Job
        echo "Submetendo o JOB"
        echo "INFORMAÇÕES DO EXPERIMENTO:"
        echo "ID: ${EXPERIMENT_ID}"
        echo "K: ${K}"
        echo "DATASET: ${PATH_DATASET}"
        echo "CONSULTAS: ${PATH_QUERIES}"
        echo "PIVOTS: ${PATH_PIVOTS}/${IDX_PATH_PIVOT}"
        echo "FACTOR: ${FACTOR}"

        echo "# PARTICOES: ${PARTITIONS}"
        time $HADOOP_HOME/bin/hadoop jar $PATH_TO_JAR $CLASSNAME \
            -D format.records=$HEAD_DATASET \
            -D mapper.number.partitions=$PARTITIONS \
            -D mapper.pivots.file=$PATH_PIVOTS_DFS/$IDX_PATH_PIVOT \
            -D brid.factor.f=$FACTOR \
            -D experiment.logs.metric.calls=$PATH_LOGS_NUMBER_METRIC_CALLS/$EXPERIMENT_ID/ \
            -D experiment.logs.duplicates=$PATH_LOGS_NUMBER_DUPLICATES/$EXPERIMENT_ID/ \
            -D brid.K=$K $INPUT_DFS/$DATASET_NAME $INTERMEDIARY_DFS/$EXPERIMENT_ID/ $OUTPUT_DFS/$EXPERIMENT_ID/ $PATH_QUERIES $METHOD_PARTITIONING

        echo "Copiando arquivos de saída para o sistema de arquivos local"
        $HADOOP_HOME/bin/hdfs dfs -copyToLocal -f /outputs/$EXPERIMENT_ID data/outputs/

        echo "Mesclando e copiando logs de calculo de distância para sistema de arquivos local"
        $HADOOP_HOME/bin/hdfs dfs -getmerge -nl $PATH_LOGS_NUMBER_METRIC_CALLS/$EXPERIMENT_ID /data/logs/metric_calls/$EXPERIMENT_ID

        if [ "$METHOD_PARTITIONING" = "PivotBasedOverlapping" ]; then
            echo "Mesclando e copiando logs de duplicação de dados para sistema de arquivos local"
            $HADOOP_HOME/bin/hdfs dfs -getmerge -nl $PATH_LOGS_NUMBER_DUPLICATES/$EXPERIMENT_ID /data/logs/duplicates/$EXPERIMENT_ID
        fi

        ((IDX_PATH_PIVOT++))
        ((EXPERIMENT_ID++))
    done
done