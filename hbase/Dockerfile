FROM openjdk:8

ENV HBASE_VERSION=2.4.12

RUN apt-get update
RUN apt-get install -y netcat

RUN mkdir -p /var/hbase && \
    cd /opt && \
    wget -q https://archive.apache.org/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz && \
    tar xzf hbase-${HBASE_VERSION}-bin.tar.gz

WORKDIR /opt/hbase-${HBASE_VERSION}

COPY hbase-site.xml conf

CMD ./bin/start-hbase.sh && tail -F logs/hbase*.log