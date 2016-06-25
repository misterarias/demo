#!/bin/sh
docker run  -d -ti busybox  /bin/sh -c "while : ; do echo 'Hola Mundo'; sleep 1 ; done"
