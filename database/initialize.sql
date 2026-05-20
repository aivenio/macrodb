/********************************************************************
Configure and Initialize a PostgreSQL Macroeconomics Database

The macroeconomics database (macrodb) is a structured data of various
factors like currency, inflation, etc., that can be used to analyze a
country's performance using different indicators. The database is
created independently, thus providing seamless access to other forward
looking at models, keeping the core structure intact.

Copyright © [2021] Debmalya Pramanik (ZenithClown), AivenIO DBA
********************************************************************/

\echo 'Creating Schema(s) ...'

CREATE SCHEMA IF NOT EXISTS
    common AUTHORIZATION postgres;

CREATE SCHEMA IF NOT EXISTS
    dev AUTHORIZATION postgres;

/********************************************************************
SQL Table Schema Execution Order - STRICT Follow
********************************************************************/

\i database/schema/public/initialize.sql
\i database/schema/common/initialize.sql

-- ? Initialize "dev" schema at the end; it contains table mapping
\i database/schema/dev/initialize.sql
