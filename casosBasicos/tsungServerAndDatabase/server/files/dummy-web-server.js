#!/usr/bin/env nodejs

var cluster     = require('cluster');
var http        = require('http');
var os          = require('os');
var mysql       = require('mysql');
var querystring = require('querystring');


function process(pool, req, res) {

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
		var params = querystring.parse(body)
		if (!params.value) {
			res.writeHead(200);
			res.end();
			return;
		}
	
    		pool.getConnection(function(err, connection) {
      			if (err) {
        			console.log(err);
        			if (connection !== undefined) {
          				connection.release(); 
        			}

        			res.writeHead(500);
        			res.end('<html><body><h1>Error</h1><p>' + err + '</p></body></html>');
        			return;
      			}  
  
      			connection.query("insert into reto values (?, now())", params.value, function(err, result) {
        			if (err) {
					connection.release(); 
          				console.log(err);
          				return;
        			} 
        			connection.release();
  
        			res.writeHead(200);
        			res.end('<html><body><h1>POST!</h1></body></html>');
     			});
  
      			connection.on('error', function(err) {      
        			console.log(err);
      			});
    		});
	});
}

function createServer() {
	var pool = mysql.createPool({
		connectionLimit : 10, 
		host     : 'db',
		user     : 'root',
		password : 'passwd',
		database : 'reto',
		debug    : false
	});

	http.createServer(function(req, res) {
		process(pool, req, res);
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
