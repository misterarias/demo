#!/bin/sh
docker run --name database -e MYSQL_ROOT_PASSWORD=passwd -p 3306:3306 database
