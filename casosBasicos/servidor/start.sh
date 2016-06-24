#/bin/sh
docker run \
  -v "$PWD"/server:/opt/flask/ \
  -p 8080:80 \
  servidor
