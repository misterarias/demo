-- Create an user for remote connections
CREATE USER clousr WITH PASSWORD 'clousr';
GRANT ALL PRIVILEGES ON DATABASE clousrdb TO clousr;
GRANT ALL ON ALL TABLES IN SCHEMA public TO clousr;

