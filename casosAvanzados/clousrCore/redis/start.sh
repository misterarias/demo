#!/bin/bash

redis-server &

sleep 1

# Needed for connections to be accepted from within the docker network
redis-cli config set protected-mode no

# Some starting values
redis-cli hset 'e589f180d00df0bcac4bef7c7f282231'  'domain' '.clousr.net'
redis-cli hset 'e589f180d00df0bcac4bef7c7f282231'  'active' 'true'

wait
