#!/usr/bin/env nodejs

var cluster     = require('cluster');
var http        = require('http');
var os          = require('os');
var querystring = require('querystring');
var kafka = require('kafka-node'),
    HighLevelProducer = kafka.HighLevelProducer,
    KeyedMessage = kafka.KeyedMessage,
    client = new kafka.Client('zk:2181/'),
    producer = new HighLevelProducer(client);

producer.on('ready', function () {
  console.log('ready');
});

producer.on('error', function (err) {
  console.log("ERR", err);
  console.dir(err);
}).on('uncaughtException', function (err) {
  console.log('uncaughtException', err);
});

function process(producer, req, res) {

  if (req.method != 'POST') {
    res.writeHead(200);
    res.end();
    return;
  }

  var body = '';
  req.on('data', function(chunk) {
    body += chunk;
  });

  req.on('end', function() {
    var params = querystring.parse(body);
    if (params.value) {
      var msg = [{ topic: 'topic1', messages: params.value }];
      producer.send(msg, function (err, data) {
        console.log("sent value: " + params.value, err || data);
      });
    }

    res.writeHead(200);
    res.end();
    return;
  });
}

function createServer() {
  http.createServer(function(req, res) {
    process(producer, req, res);
  }).listen(80);
}


if (cluster.isMaster) {
  for (var i = 0; i < os.cpus().length; i++) {
    cluster.fork();
  }

  cluster.on('exit', function(worker, code, signal) {
    console.log('worker ' + worker.process.pid + ' died');
  });

} else {
  createServer();
}
