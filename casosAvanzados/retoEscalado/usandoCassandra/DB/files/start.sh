#!/bin/sh
#cassandra -Rf &
/docker-entrypoint.sh cassandra -f &
until cqlsh -e "describe keyspace system;"
do
  echo "Waiting Cassandra..."
  sleep 3
done
echo "Cassandra UP!!"
cqlsh -f /root/create_table.cql
echo "Keyspace and table created."
wait %1
