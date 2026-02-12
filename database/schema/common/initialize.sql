\echo 'Creating Common Table(s) ...'

\i database/schema/common/tables/country.sql
\i database/schema/common/tables/currency.sql
\i database/schema/common/tables/forex_rate.sql

\echo 'Populating with Initial Seed Data ...'

\i database/schema/common/seed/country.sql
\i database/schema/common/seed/currency.sql

\echo 'Creating Common Function(s) at Initialization ...'
\i database/schema/common/functions/forex_rate.sql
