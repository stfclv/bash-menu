#!/bin/bash

ansible kafkaconnectnodes -m shell -a 'confluent-hub install  --no-prompt confluentinc/kafka-connect-datagen:latest && systemctl restart confluent-kafka-connect'
ansible kafkaconnectnodes -m shell -a 'curl http://localhost:8083/connector-plugins | jq'

###Push the Datagen Source to generate data (users and pageviews) to the Kafka Connect Cluster 
ansible kafkaconnectnodes -m shell -a 'curl -X POST -H "Content-Type: application/json" --data @datagen-users.json http://localhost:8083/connectors'
ansible kafkaconnectnodes -m shell -a 'curl -X POST -H "Content-Type: application/json" --data @datagen-pageviews.json http://localhost:8083/connectors'

### Write the Table, Streams and Persistend queries on the Kafka Connect Cluster
ansible kafkaksqldb -m shell -a 'echo -e "RUN SCRIPT '/root/ksql_poc_queries.sql'"  | ksql http://sclairville-cah-hg24.c.solutionsarchitect-01.internal:8088'
