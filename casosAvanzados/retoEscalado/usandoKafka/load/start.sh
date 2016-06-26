#!/bin/sh
RATE=${RATE:-10}
HITS=${HITS:-10}
if [ -z ${THESERVER+x} ]; then 
  docker run --link reto1server -e "RATE=$RATE" -e "HITS=$HITS" --name reto1load reto1load
else
  docker run -e "THESERVER=$THESERVER" -e "RATE=$RATE" -e "HITS=$HITS" --name reto1load reto1load
fi
