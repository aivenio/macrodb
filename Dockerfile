# -------------------------------------------------------------------
# Dockerfile for PostgreSQL Database Testing
#
# The dockerfile sets up a PostgreSQL database of the latest available
# version and sets up environment for automatic testing. Use the
# initialization (initialize.sql) file to set up the database.
# -------------------------------------------------------------------

FROM postgres:latest

# set metadata for the image, project test bench
LABEL maintainer = "Debmalya Pramanik (ZenithClown)"
LABEL description = "PostgreSQL Database for Macroeconomics Data Testing"

LABEL version = "1.0"

# ! environment variables, setup to run tests
ENV POSTGRES_DB = "macrodb"
ENV POSTGRES_USER = "postgres"
ENV POSTGRES_PASSWORD = "password"

ENV PGDATA = "/var/lib/postgresql/data/pgdata"

# ? install additional tools, copy initialization, database script
RUN apt update && \
  apt install -y --no-cache curl postgresql-contrib

COPY initialize.sql /docker-entrypoint-initdb.d
COPY database/* /docker-entrypoint-initdb.d/

# directory for custom configuration
RUN mkdir -p /etc/postgresql/

COPY postgresql.conf /etc/postgresql/postgresql.conf

# port listening, health check files
EXPOSE 5432

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB} || exit 1
