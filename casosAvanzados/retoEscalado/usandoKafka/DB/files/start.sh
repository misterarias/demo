#!/bin/bash

/entrypoint.sh mysqld &
until mysql -h$HOSTNAME -uroot -ppasswd --execute="CREATE DATABASE reto1;"
do
  echo "Creating database failed. Trying again in three seconds ..."
  sleep 3
done
mysql -h$HOSTNAME -uroot -ppasswd reto1 --execute="CREATE TABLE reto1 (creation_time DATETIME(6), insert_time DATETIME(6) );"
echo Done!!!!!
wait %1
