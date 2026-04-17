# -------------------------------------------------------------------
# Dockerfile for PostgreSQL Macroeconomics Database (MacroDB)
#
# The dockerfile sets up a PostgreSQL database of the latest available
# version and sets up environment for automatic testing. Use the
# initialization (initialize.sql) file to set up the database.
# 
# The container is configured to listen on the default port (5432) as
# per the PostgreSQL standards. The password is kept empty and should
# be set as an environment variable or passed during runtime.
#
# Build: docker build -t macrodb .
# Run:   docker run -e POSTGRES_PASSWORD=<secret> -p 5432:5432 macrodb
# -------------------------------------------------------------------

FROM postgres:18.1-bookworm

LABEL maintainer="Debmalya Pramanik (ZenithClown)" \
      description="PostgreSQL Database for Macroeconomics Data Testing" \
      version="1.0"

ENV POSTGRES_DB="macrodb" \
    POSTGRES_USER="postgres" \
    PGDATA="/var/lib/postgresql/data/pgdata"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        postgresql-contrib && \
    rm -rf /var/lib/apt/lists/*

# initialize database/schema and copy necessary files
COPY database/schema/ /database/schema/

# number the files with prefixes, as not automatically enforced
COPY database/initialize.sql       /docker-entrypoint-initdb.d/01_initialize.sql
COPY database/publication.conf.sql /docker-entrypoint-initdb.d/02_publication.conf.sql

# setup postgresql.conf for additional configuration
COPY postgresql.conf /etc/postgresql/postgresql.conf

EXPOSE 5432

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=5 \
    CMD pg_isready -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" || exit 1

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]
