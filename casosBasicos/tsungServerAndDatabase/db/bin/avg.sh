mysql -h127.0.0.1 -P3306 -uroot -ppasswd reto --execute="select avg(k) from (select count(*) k from reto group by insert_time) as t;"

