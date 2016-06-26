#!/bin/bash

/entrypoint.sh mysqld &
sleep 60
mysql -h$HOSTNAME -uroot -ppasswd --execute="CREATE DATABASE reto;"
mysql -h$HOSTNAME -uroot -ppasswd reto --execute="CREATE TABLE reto (value VARCHAR(100) NOT NULL, insert_time TIMESTAMP NOT NULL);"

wait %1
