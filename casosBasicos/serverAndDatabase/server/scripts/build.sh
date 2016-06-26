#!/bin/sh
SCRIPTDIR=$(cd $(dirname $0) ; pwd)
docker build -t server $SCRIPTDIR/..
