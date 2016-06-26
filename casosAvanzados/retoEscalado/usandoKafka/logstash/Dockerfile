FROM logstash:latest
MAINTAINER Inigo Crespo

ADD files/logstash.conf /root/logstash.conf
ADD files/start.sh /root/start.sh

RUN chmod +x /root/start.sh

ENTRYPOINT ["/root/start.sh"]
