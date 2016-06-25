var express = require('express');
var os = require("os");

var app = express();

app.get('/', function (req, res) {
	  res.send('<html><body>Hola Mundo</body></html>');
});

app.listen(80);
console.log('Running on http://localhost');
