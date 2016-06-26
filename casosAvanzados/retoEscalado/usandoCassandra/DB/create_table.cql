CREATE KEYSPACE http_request_log
  WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };
USE http_request_log;
CREATE TABLE http_request_time (
  creation_time timestamp,
  host int,
  id bigint,
  insertion_time timestamp,
  PRIMARY KEY (creation_time, host, id)
);
