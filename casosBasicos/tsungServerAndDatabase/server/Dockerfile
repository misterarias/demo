FROM alpine:latest
MAINTAINER Inigo Crespo Bluetab

RUN apk add --update nodejs && npm install --prefix=/root  mysql

ADD files/dummy-web-server.js /root/dummy-web-server.js
ADD files/start.sh /root/start.sh

RUN chmod +x /root/dummy-web-server.js
RUN chmod +x /root/start.sh

ENTRYPOINT ["/root/start.sh"]
