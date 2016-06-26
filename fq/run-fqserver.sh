#!/bin/sh
docker run -d -p 8080:8080 --link fqdb --name fqserver icbluetab/fqserver

