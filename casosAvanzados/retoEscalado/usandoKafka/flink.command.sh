docker exec -ti reto3_taskmanager_1 /usr/local/flink/bin/flink run  \
  -c net.bluetab.retos.TsungConsumer \
  /tmp/thejar.jar \
  --topic topic1 --bootstrap.servers kafka:9092 --zookeeper.connect zookeeper:2181 --group.id myId
