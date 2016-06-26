#!/bin/sh
docker run --name reto1db -e MYSQL_ROOT_PASSWORD=passwd -p 3306:3306 reto1db
