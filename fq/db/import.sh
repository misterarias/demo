#!/bin/sh
#docker exec fqdb sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" fastquotation' < fq.sql
mysql -uroot -ptemporal -h 127.0.0.1 -P 3306 fastquotation < fq.sql


