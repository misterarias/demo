#!/bin/sh
RATE=${RATE:-500}
HITS=${HITS:-10}
if [ -z ${THESERVER+x} ]; then 
  docker run --link reto3server -e "RATE=$RATE" -e "HITS=$HITS" --name reto3load reto3load
else
  docker run -e "THESERVER=$THESERVER" -e "RATE=$RATE" -e "HITS=$HITS" --name reto3load reto3load
fi
