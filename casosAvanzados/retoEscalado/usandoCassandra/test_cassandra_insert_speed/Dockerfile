FROM develar/java:latest
MAINTAINER German Blanco

ADD target/lib /root/lib
ADD target/testinsertspeed-1.jar /root/testinsertspeed.jar
ADD files/start.sh /root/start.sh

RUN chmod +x /root/start.sh

ENTRYPOINT ["/root/start.sh"]
