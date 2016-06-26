#!/bin/sh
docker run --name db -e MYSQL_ROOT_PASSWORD=passwd -p 3306:3306 -d db
