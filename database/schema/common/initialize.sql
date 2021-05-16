\echo 'Creating Common Table(s) ...'

\i database/schema/common/tables/country.sql
\i database/schema/common/tables/currency.sql

\echo 'Populating with Initial Seed Data ...'

\i database/schema/common/seed/country.sql
\i database/schema/common/seed/currency.sql
