# Dockerfile PostGIS

## Info

This Dockerfile creates a container running PostGIS 2.1 in PostgreSQL 9.3

- expose port `5432`
- initializes a database in `/var/lib/postgresql/9.3/main`
- superuser in the database: `docker/docker`

## Install

- `docker build -t "postgis:2.1" .`
- `docker run -d postgis:2.1`


## Persistance

You can mount the database directory as a volume to persist your data:

`docker run -d -v $HOME/postgres_data:/var/lib/postgresql postgis:2.1`

Makes sure first need to create source folder: `mkdir -p ~HOME/postgres_data`.

If you copy existing postgresql data, you need to set permission properly (chown/chgrp)


## Meta

Build width docker version `0.7.0`


## References

- Docker index: [helmi03/postgis](https://index.docker.io/u/helmi03/postgis/)
- [stigi/dockerfile-postgresql](https://github.com/stigi/dockerfile-postgresql)
