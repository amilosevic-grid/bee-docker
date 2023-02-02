# Bee - Cloudera Docker

This repository serves as a playground example of running Bee locally using docker images.

# Prerequisites

To run these images you require docker-desktop or the open-source rancher-desktop.
So far it has been tested on Unix software; it should not behave much differently on Windows, except for the `get_parcel.sh` which relies on some Unix commands to download the parcels. However, it should not be too hard to replicate the behaviour using wget for Windows.

# Components

### Data

Location of data used. Inside there is a mock json with nested columns. Feel free to add any data you need here.

### Conf

Location of configuration files for running bee. Samples are provided, feel free to add your own.

### Hbase

Folder containing the image for Hbase

### Kafka

Folder containing the images for Zookeeper, Kafka and SchemaRegistry.

### Bee

Folder containing jars, scripts and other utils necessary to run Bee in a docker image

### Bee/jars

In this folder you can put all the jars you need for running Bee with additional software necessary; ie. if you want to run Bee and write to HBase, you will need several jars related to hadoop/hbase.

### Bee/get_parcel.sh -> Optional step

`get_parcel.sh` is a bash script that is used to download all the jars that CDP7 private cloud is distributing. After download, it will unpack to parcel. From `parcel/jars/` you can move all the jars you need to the `bee/jars` folder.
This step is optional, since for a lot of spark applications you dont need more than what is provided in the apache/spark image. However, hbase, hadoop, kafka connectors are located in the CDP distribution.
Note: the parcel tgz file is 7GB large, so it might take some time to download.

### Bee/submit_serde.sh

An example of a script used to call a bee job.

## Run instructions

Before running bee, we need to compile the fat jars of utilities and beeCore and put them inside the bee folder.

```
sbt clean
sbt compile
sbt assembly
mv {beeutilities_folder or beeCore_folder}/target/scala_2.12/*.jar bee
```

In order to start bee, you can run the following commands from the repository root:
`docker run [(optional if running with kafka) --network kafka_default] -p 4040:4040 -v $(pwd)/bee:/bee -v $(pwd)/conf:/conf -v $(pwd)/data:/data -it apache/spark /bin/bash`

Note: HOME is /Users/amilosevic/ in my case; change the command to fit where your repository is located.

This will put you on a shell inside a docker container. You can `cd` your way to the root, and from there call `bash submit_bee.sh hello.conf`

### Using Kafka with Bee

Before starting Bee as explained in the previous step, you can start Kafka by entering the Kafka folder and running docker-compose.yaml. This will start the Zookeeper instance, Kafka Broker(broker:29092) and Schema Registry.

You can play around in this container by using `docker exec -ti {ContainerID} /bin/bash`. To find the ContainerID use `docker ps`.
Inside the container all the regular Kafka CLI commands are available, as well as curl calls to the schema registry.

### Using Hbase with Bee

You can use HBase after building the base image by running `docker build -t my-hbase .` inside of the hbase folder.
After that you can run the image by running the following command `docker run -it [(optional if running with kafka) --network kafka_default] -p 2181:2181 -p 2888:2888 -p 3888:3888 -p 16010:16010 -p 16000:16000 -p 16020:16020 -p 16030:16030 -p 8080:8080  my-hbase`

#### Why is the network kafka_default?

In order for all containers to be able to communicate with each other, they have to be in the same internal network. Since Kafka is started from the folder kafka with `docker-compose up`, docker will create a network called kafka_default, where we will put all other services as well. In case of running without kafka, just omit the --network kafka_default from the run command.

### Tips & Limitations

- ```--jars $(ls -d /bee/jars/* | tr '\n' ',')\``` can be used inside of the spark-submit to attach all the jars from bee/jars to the spark process.

- Due to the implementation of the HBase Connection inside BeeUtilities, it is not currently possible to do streaming writes to HBase.

- Any spark application can be packaged inside the bee folder as a fat jar and run with a similar script to submit_bee, with changed values.
