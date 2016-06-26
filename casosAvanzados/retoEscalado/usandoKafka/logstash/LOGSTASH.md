
Para probarlo una vez lanzadas la base de datos, el servidor y tsung

cd logstash

cp files/logstash.conf ../shared/logstash.conf

docker run -it --rm -v "$PWD"/../shared:/shared logstash logstash -f /shared/logstash.conf

Se deberían mostrar los mensajes json que se generan a partir de los logs.



Aún no está desrrollada la parte de TPS y LAG por lo que los valores son falsos. Lo hago a lo largo de la semana.

Para enlazar con elasticsearch hay que configurar el output en files/logstash.conf. Hay una configuración que me ha funcionado pero habrá que afinarla.

