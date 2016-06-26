package net.bluetab.bigdataactivity.testcassandra;

import com.datastax.driver.core.Cluster;
import com.datastax.driver.core.Session;
import com.datastax.driver.core.SimpleStatement;

public class Main {

   public Cluster cluster;

   public void connect(String node) {
      cluster = Cluster.builder()
            .addContactPoint(node).build();
   }

   public static void main(String[] args) {
      Main client = new Main();
      client.connect("reto3db");
      Session session = client.cluster.connect("http_request_log");
      for (int i = 0; i < 100000; i++) {
         long nowMillis = System.currentTimeMillis();
         session.execute(new SimpleStatement("INSERT INTO http_request_time " + 
                                             "(creation_time, host, id,       insertion_time) VALUES (" +
                                               nowMillis +  ",0," + i + "," + nowMillis + ")"));
      } 
      System.out.println ("Finished !!!\n");
      client.cluster.close();
   }
}
