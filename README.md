# Cluster Hadoop v.3.*

O objetivo deste repositório é a configuração de um cluster pseudo-distribuído utilizando o [Apache Hadoop](https://hadoop.apache.org/) para simulação e testes de algoritmos utilizando o framework MapReduce. A versão do Hadoop utilizada é a 3.3.1, no entanto isso pode ser configurado no arquivo ```base/Dockerfile```.

A arquitetura inicial do cluster possui um nó master e dois nós escravos (datanodes). Se novos nós escravos forem adicionados, eles devem ser registrados no arquivo de configuração ```master/config/hadoop/slaves```.
## Deploy do cluster

```
make build
docker-compose up
```

## Execução de um job

Os parâmetros para execução do job devem ser especificados no arquivo ```submit-params.env```.

```
INPUT_DFS - caminho para o diretório ou arquivo de entrada no HDFS (default /datasets)
OUTPUT_DFS - caminho para o diretório de saída no HDFS (default /output)
PATH_TO_JAR - caminho para o arquivo .jar 
CLASSNAME - nome da classe principal
PATH_DATASET - caminho para o diretório ou arquivo de entrada na máquina host
```

Submissão:

```
make submit
```

### Acesso as interfaces gráficas

- Job History - http://master-node:19888/jobhistory/ 
- Resource Manager - http://master-node:8088/
- Namenode - http://master-node:9870/dfshealth.html
- NodeManager - http://master-node:8042/node
- DataNode - http://master-node:9864/datanode.html

Para facilitar, o script ```open-webapp.sh``` abre todas essas páginas no google chrome.

## Configuração do cluster

Os arquivos de configuração do cluster estão na pasta ```base/config/hadoop/```

- core-site.xml
- hadoop-env.sh
- hdfs-site.xml
- mapred-site.xml
- yarn-site.xml
