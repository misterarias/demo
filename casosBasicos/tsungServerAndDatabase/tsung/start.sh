#!/bin/sh
RATE=${RATE:-10}
HITS=${HITS:-10}

docker run --link server -e "RATE=$RATE" -e "HITS=$HITS" --name tsung tsung
