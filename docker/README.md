# Install

Configure DB (in docker container):

```
docker exec -it skladis-db bash
psql -U postgres
CREATE DATABASE skladis_development;
CREATE USER skladis WITH PASSWORD 'password'; # change password
GRANT ALL PRIVILEGES ON DATABASE "skladis_development" to skladis;
ALTER DATABASE skladis_development OWNER TO skladis;

CREATE DATABASE skladis_test;
CREATE USER skladis_test WITH PASSWORD 'skladis';
GRANT ALL PRIVILEGES ON DATABASE "skladis_test" to skladis_test;
ALTER DATABASE skladis_test OWNER TO skladis_test;
ALTER USER skladis_test CREATEDB;
```

Start the backend:

```
docker compose up -d --build
```
