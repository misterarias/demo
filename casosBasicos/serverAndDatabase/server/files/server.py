#!/usr/bin/env python
"""
Very simple HTTP server in python.
Usage::
    ./server.py [<port>]
Send a GET request::
    curl http://localhost
Send a HEAD request::
    curl -I http://localhost
Send a POST request::
    curl -d "foo=bar&bin=baz" http://localhost
"""
from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
from cgi import parse_header, parse_multipart
from urlparse import parse_qs
import SocketServer
import MySQLdb

mysql_conn = MySQLdb.connect(
        host= "database",
        user="root",
        passwd="passwd",
        db="reto1")
x = mysql_conn.cursor()
line_number = 0

class S(BaseHTTPRequestHandler):
    def parse_POST(self):
        ctype, pdict = parse_header(self.headers['content-type'])
        if ctype == 'multipart/form-data':
            postvars = parse_multipart(self.rfile, pdict)
        elif ctype == 'application/x-www-form-urlencoded':
            length = int(self.headers['content-length'])
            postvars = parse_qs(
                    self.rfile.read(length),
                    keep_blank_values=1)
        else:
            postvars = {}
        return postvars

    def _set_headers(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

    def do_GET(self):
        self._set_headers()
        self.wfile.write("<html><body><h1>hHola Mundo</h1></body></html>")

    def do_HEAD(self):
        self._set_headers()

    def do_POST(self):
        # Inserts posted data in MySQL server
        global mysql_conn
        global x

        postvars = self.parse_POST()
        x.execute("INSERT INTO reto1 VALUES (%s, current_timestamp(6) );" , postvars.get("value"))

        mysql_conn.commit()
        self._set_headers()
        self.wfile.write("<html><body><h1>POST!</h1></body></html>")

def run(server_class=HTTPServer, handler_class=S, port=80):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print 'Starting httpd...'
    httpd.serve_forever()

if __name__ == "__main__":
    from sys import argv

    if len(argv) == 2:
        run(port=int(argv[1]))
    else:
        run()
