package net.bluetab.bigdataactivity.http_server;

public class Main {
   public static void main(String[] args) {
      // start http server
      CassandraLogHttpServer httpServer = new CassandraLogHttpServer();
      httpServer.start();
   }
}
