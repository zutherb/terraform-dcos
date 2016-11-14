FROM java:openjdk-7u95-jre

ENV DOWNLOAD_FILENAME apache-cassandra-2.2.5-bin.tar.gz

RUN apt-get update && \
    apt-get install -y python && \
    mkdir -p /opt/cassandra && \
    wget -O /tmp/$DOWNLOAD_FILENAME http://downloads.mesosphere.com/cassandra-mesos/artifacts/1.0.4-2.2.5/$DOWNLOAD_FILENAME && \
    tar xvzf /tmp/$DOWNLOAD_FILENAME -C "/tmp" && \
    tar xvzf /tmp/$DOWNLOAD_FILENAME --strip-components=1 -C "/opt/cassandra" && \
    rm -vf /tmp/$DOWNLOAD_FILENAME && \
    rm -vf /tmp/apache-cassandra-2.1.4-bin.tar.gz && \
    rm -vf /tmp/cassandra-mesos-executor.jar && \
    rm -vf /tmp/cassandra-mesos-framework.jar

# Expose ports
EXPOSE 7199 7000 7001 9160 9042

WORKDIR /opt/cassandra/bin

CMD ["/opt/cassandra/bin/cassandra", "-f"]
