FROM rvinicius/base-node-hadoop:3.3.1

# https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/ClusterSetup.html#Slaves_File
# List all worker hostnames or IP addresses
COPY config/hadoop/masters $HADOOP_HOME/conf 
COPY config/hadoop/slaves $HADOOP_HOME/conf

# Default ports in Hadoop 3
# https://www.stefaanlippens.net/hadoop-3-default-ports.html

# Mapreduce jobhistory
EXPOSE 19888
# DFS Health
EXPOSE 9870
# Node Manager
EXPOSE 8042
# Resource Manager
EXPOSE 8088

ENTRYPOINT ["/bin/bash", "entrypoint.sh"]