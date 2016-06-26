# RETO 3 - Procesamiento

## ¿Qué hay que hacer?

Obtener información (resumida) sobre un flujo de datos que supera la capacidad de almacenamiento en disco del sistema.

La información que tenemos de los retos anteriores, parece decir que podemos almacenar varios cientos de líneas por segundo en nuestra base de datos MySQL. En este reto, el objetivo será procesar 5000 HTTP request por segundo y obtener el número de mensajes recibidos por el sistema cada 10 milisegundos, cada segundo y cada minuto. El resultado de esas estadísticas se podrá obtener por consola ejecutando un comando distinto para cada uno de los tres periodos de tiempo.

## ¿Cómo hacerlo?

Nuestra propuesta inicial será utilizar un Cassandra para las insercciones, realizándolas en modo batch cada 10 milisegundos, y evaluar si alcanza el rendimiento exigido. En caso de no llegar a dicho rendimiento, almacenar solo el resumen.

Nos basaremos en el servidor java del primer reto https://github.com/germanblanco/RETO1/tree/master/server_java

## Lista de Tareas

### Fase 0

- crear un repositorio en GitHub para el proyecto. Hecho!

### Fase 1

- Crear un docker de Cassandra ... facil porque esta en el docker hub ... ya estaria hecho. Pero no deberia costar mucho hacer un docker que ademas de tener Cassandra crease una tabla para insertar nuestros datos como se hacia (al parecer no muy finamente) en MySQL ... https://github.com/misterarias/RETO2/tree/master/DB. Necesitamos una sola tabla con los datos en crudo.

- Comprobar la velocidad de insercion maxima en ese Cassandra (con un solo thread). Hacer una aplicacion standalone Java con un bucle que inserte datos a toda velocidad y ver cuanto da. Usar batches de unos 50 registros (5000 por segundo son unos 50 por 10 ms.). Usar prepared statements y binding.

- Hacer tres scripts, como sea, que lean la tabla de mensajes en crudo y saquen el numero de mensajes cada 10ms, cada segundo y cada minuto respectivamente.

- Adaptar el servidor Java para que escriba en Cassandra en batches.

- hacer un docker-compose que lance el sistema

Con la fase 1 completada ya damos el pego. 

### fase 2

- Hacer un docker que saque estadisticas de CPU, RAM y disco y las ponga en un log.

- Hacer otro docker que saque estadisticas de LAG y TPSs y las ponga en un log.

- Docker con el logstash para insertar en Kibana CPU, RAM, disco, LAG y TPSs

- Docker con el logstash para insertar en Kibana el numero de mensajes por 10 ms, segundo y minuto.

- Montar el elasticsearch y el Kibana. A ser posible el Kibana con un dashboard en el que se vean las estadisticas.

- hacer un docker-compose que lance el sistema completo

### Fase 3.1

- Si no llegamos a las 5000. Hacer el servidor Java multithreaded y probar el rendimiento

### Fase 3.2

- Si no llegamos a las 5000. Poner una fase intermedia que almacene solamente el resumen

### Fase 4.3

- Hacer un analisis de las estadisticas.

### Fase 4.3

- montar un load balancer en algun docker

### Fase 4.3

- Hacer el cluster y tomar medidas
