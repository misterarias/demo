FROM postgres:9.4

#RUN apt-get update && apt-get install -y wget ca-certificates 
#RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
#RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
RUN apt-get update -y && apt-get install -y postgresql-9.4-ip4r postgresql-9.4-repmgr postgresql-9.4-postgis-2.2

RUN pg_createcluster 9.4 main --start

# Add some schemas & scripts
COPY scripts /tmp/scripts
RUN chmod -R 777 /tmp/scripts && chown -R postgres /tmp/scripts

USER postgres
RUN bash /tmp/scripts/db_init.sh "/var/lib/postgresql/9.4/main"

EXPOSE 5432

# Set the default command to run when starting the container
CMD ["/usr/lib/postgresql/9.4/bin/postgres", "-D", "/var/lib/postgresql/9.4/main", "-c", "config_file=/var/lib/postgresql/9.4/main/postgresql.conf"]
