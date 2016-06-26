#!/bin/sh
SCRIPTDIR=$(cd $(dirname $0) ; pwd)
docker run  \
  -v "$SCRIPTDIR"/../files:/root/ \
  -p 8080:80 \
  --link database:database \
  -ti server \
  python /root/server.py
