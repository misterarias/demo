#!/bin/sh
docker run -v "$PWD"/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=temporal -e MYSQL_DATABASE=fastquotation  -p 3306:3306 --name fqdb -d mysql:latest
