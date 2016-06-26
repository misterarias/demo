FROM develar/java:latest
MAINTAINER German Blanco

ADD target/lib /root/lib
ADD target/web-server-1.jar /root/web-server.jar
ADD files/start.sh /root/start.sh

RUN chmod +x /root/start.sh

ENTRYPOINT ["/root/start.sh"]
