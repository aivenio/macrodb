<div align = "center">

# Macroeconomics DB

**Database Management System | Project `macrodb` | PostgreSQL**

</div>

<div align = "justify">

This project provides a centralized PostgreSQL database for aggregating macroeconomic data from  *open-source* and 
*proprietary* sources. The database enables data-driven analysis across multiple  geographic levels (country, state, city)
and seamless integration with forecasting models through structured indicators and rapid query capabilities.

## Dependent Project(s)

A list of dependent projects that use the **`macrodb`** as a base. These projects may/may not be related/owned by the
current repository/organization owner and may follow different licensing options. Please check the individual repository for
more details.

<details>
<summary>Click Here to Dependent Project(s)</summary>

### FOREX-Rates

A unified codebase for fetching Foreign Exchange Rates from different API sources. The repository provides ready-made
examples to start your own server by providing API credentials that can be used to populate the data - the schema
and codes are integrated to work with this project.

<div align = "center">

| Repository URI | LICENSE | Programing Language |
| :---: | :---: | :---: |
| [sharkutilities/forexrates](https://github.com/sharkutilities/forexrates) | MIT | `python` |

</div>

</details>

## Logical Replication(s)

PostgreSQL's logical replication provides higher flexibility and advantages over a physical replication of the database
schema. The **`macrodb`** project is considered a *publication server* that exposes the most vital metadata information to
the subscriber databases. To setup a logical replication, the WAL (write-ahead-log) LEVEL needs to be configured:

```shell
nano path/to/postgresql.conf

# setting wal_level always requires server restart, mandatory
# wal_level = logical
sudo systemctl restart postgresql
```

More information is available in [documentations](https://postgresqlco.nf/doc/en/param/wal_level/) and also in a video format
[YouTube Video](https://www.youtube.com/watch?v=OvSzLjkMmQo). The *publisher-subscriber* model allows a single source of metadata
that has a logical copy in all the subscriber databases.

### Subscribers Configuration

To maintain a single source of truth, a published data table's copy only has a `SELECT` access to all the users, including `postgres`
user. This ensures that there is no accidental data insertion or key creation.

```sql
REVOKE INSERT, UPDATE, DELETE ON <table> FROM PUBLIC;
```

A subscriber schema must have the table schema already present to fetch data, but we can safely ignore all the foreign key constraints
in the subscriber table, which is a common practice to reduce dependency and load-time check as `SUBSCRIBER` does not guarantee the
order in which a table is logically fetched ([docs](https://www.postgresql.org/docs/17/logical-replication.html)) thus we can remove
the constraints to keep the data synced without an error.

```sql
CREATE TABLE <table> (
  record_id
    INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
...
);

# check the list of foreign keys in the table using the information schema
SELECT
  tc.table_catalog
  , tc.table_name
  , tc.table_schema
  , tc.constraint_name
  , kcu.column_name
  , ccu.table_catalog AS foreign_table_catalog
  , ccu.table_name AS foreign_table_name
  , ccu.column_name AS foreign_column_name
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc

JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu ON
  tc.constraint_name = kcu.constraint_name
  AND tc.constraint_schema = kcu.constraint_schema

JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ccu ON
  tc.constraint_name = ccu.constraint_name
  AND tc.constraint_schema = ccu.constraint_schema

WHERE
  tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_name = '<table-name>'

# then all the constraints can be dropped one by one
DROP CONSTRAINT fk_* -- all foreign keys should be dropped
```

### Published Tables

The typical metadata information to maintain a schema (say, social indicators) that is not bound to a particular geography requires a
special approach in data handling and scrutiny. The following macroeconomic tables are published. The publication script file is
available at [publication.conf.sql](./database/publication.conf.sql) file. Details of each type of publication are as follows.

#### Geography Information | `macrodb_geography_table`

The MacroDB structure is defined to make the data non-geographically aligned; thus, the country (`common.country_mw`),
state (`common.state_mw`), and city (`common.city_mw`) information are exposed to the subscriber databases for foreign key mapping.

#### Currency Master Table | `macrodb_currency_table`

The `common.currency_mw` table exposes a global list of currencies, their standard ISO codes, minor units and other details that
may be required to build an agnostic system.

## CI/CD Pipeline(s)

[**Project Archon**](https://github.com/aivenio/project.archon) is a one-stop solution that integrates and updates
data across all the projects in the organization. The details of dependent workflows for this project are as follows:

<details>
<summary>Click Here to View CI/CD Workflows</summary>

  1. FOREX Rates ([`forexrates.yml`](https://github.com/aivenio/project.archon/blob/master/.github/workflows/forexrates.yml)) -
    Updates the FOREX rates from the selected data source on a periodic (monthly) interval. The function file is available
    [here](https://github.com/aivenio/project.archon/blob/master/main/forexrates_dbupdate.py).

</details>

## Project Disclaimer

This service is intended solely to provide a data structure that enables efficient management of databases containing various
data points for macroeconomic analysis. Certain *non-sensitive* data that is *available in the public domain* may be distributed
with the project. Other data may not be shared, and the organization is under no obligation to make such data available to the
general public. For details, please refer to the [disclaimer](./DISCLAIMER.md) statement.

</div>
