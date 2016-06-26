#FROM alpine:3.3
FROM  mhart/alpine-node:latest

USER root
WORKDIR /
RUN apk add --no-cache make gcc g++ python

COPY files/dummy-web-server.js /src/dummy-web-server.js
COPY files/package.json /src/package.json
RUN cd /src ; npm install --production

ENTRYPOINT ["node", "/src/dummy-web-server.js"]
