#!/bin/sh
docker exec fqdb sh -c 'exec mysqldump fastquotation -uroot -p"$MYSQL_ROOT_PASSWORD"' > fq.sql
