#!/bin/bash

# Source function library.
#INITD=/etc/rc.d/init.d
#. $INITD/functions

BPVSCHEMA="bpv"
PGDATA="${1:-/var/lib/postgresql/9.4/main}"
DB_ERROR_LOG=$(mktemp /tmp/.dblog.XXXX)
DATABASE_NAME="clousrdb"
SCRIPTS_DIR=$(cd $(dirname $0) && pwd)

/etc/init.d/postgresql stop

cat $SCRIPTS_DIR/db_postgresql.conf > $PGDATA/postgresql.conf
cat $SCRIPTS_DIR/db_pg_hba.conf > $PGDATA/pg_hba.conf

/etc/init.d/postgresql start

echo "Creating '${DATABASE_NAME}' database and default user..."
while ! createdb "${DATABASE_NAME}" ; do
  sleep 5
done
psql ${DATABASE_NAME} < $SCRIPTS_DIR/create_user.sql
psql ${DATABASE_NAME} < $SCRIPTS_DIR/create_extensions.sql

echo "Creating '${DATABASE_NAME}' tables as user 'clousr'..."
PGPASSWORD=clousr psql -h 127.0.0.1 -U clousr "$DATABASE_NAME" < "$SCRIPTS_DIR/create_db.sql"
