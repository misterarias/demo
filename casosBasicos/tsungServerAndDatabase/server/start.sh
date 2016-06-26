#!/bin/sh
docker run --link db --name server -p 80:80 -d server
