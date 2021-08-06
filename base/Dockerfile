FROM openjdk:8-jdk-slim

ENV HADOOP_VERSION 3.3.1
ENV HADOOP_MINOR_VERSION 3.2.1
ENV HADOOP_HOME /usr/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin

RUN apt-get update \
    && apt-get install -y wget nano ssh openssh-server curl iputils-ping

COPY hadoop-3.3.1.tar.gz /

# RUN wget \
#     "http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" \

RUN tar zvxf hadoop-${HADOOP_VERSION}.tar.gz -C /usr/ \
    && rm hadoop-${HADOOP_VERSION}.tar.gz \
    && rm -rf ${HADOOP_HOME}/share/doc \
    && chown -R root:root ${HADOOP_HOME}

# Diretórios LOG
RUN mkdir ${HADOOP_HOME}/logs

# KEYS
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 600 ~/.ssh/authorized_keys
COPY /config/config /root/.ssh
RUN chmod 600 /root/.ssh/config

# SET variables in hadoop-env.sh
COPY config/hadoop/hadoop-env.sh ${HADOOP_CONF_DIR}/

COPY config/hadoop/*.xml ${HADOOP_CONF_DIR}/
COPY config/scripts /

ENTRYPOINT ["/bin/bash", "entrypoint.sh"]