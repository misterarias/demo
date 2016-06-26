#!/bin/sh
docker exec reto3db cqlsh -e "SELECT min(insertion_time) FROM http_request_log.http_request_time ALLOW FILTERING;"
docker exec reto3db cqlsh -e "SELECT max(insertion_time) FROM http_request_log.http_request_time ALLOW FILTERING;"

loop
  docker exec reto3db cqlsh -e "SELECT count(insertion_time) FROM http_request_log.http_request_time WHERE "
