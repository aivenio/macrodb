<div align = "center">

# Macroeconomics DB

**Database Management System | Project `macrodb` | PostgreSQL**

</div>

<div align = "justify">

This project provides a centralized PostgreSQL database for aggregating macroeconomic data from  *open-source* and 
*proprietary* sources. The database enables data-driven analysis across multiple  geographic levels (country, state, city)
and seamless integration with forecasting models through structured indicators and rapid query capabilities.

## Dependent Project(s)

A list of dependent projects that uses the **`macrodb`** as a base. These projects may/may not be related/owned by the
current repository/organization owner and may follow a different licensing options. Please check individual repository for
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

### Published Tables

The typical metadata information to maintain a schema (say, social indicators) that is not bound to a particular geography requires a
special approach in data handling and scrutiny. The following macroeconomic tables are published. The publication script file is
available at [publication.cong.sql](./database/publication.cong.sql) file. Details of each type of publication are as follows.

#### Geography Information | `macrodb_geography_table`

The MacroDB structure is defined to make the data non-geographically aligned, thus the country, state, and city information are
exposed to the subscriber databases for foreign key mapping.

## Project Disclaimer

This service is intended solely to provide a data structure that enables efficient management of databases containing various
data points for macroeconomic analysis. Certain *non-sensitive* data that is *available in the public domain* may be distributed
with the project. Other data may not be shared, and the organization is under no obligation to make such data available to the
general public. For details, please refer to the [disclaimer](./DISCLAIMER.md) statement.

</div>
