/********************************************************************
A Developer Function for Reporting/Auditing for FOREX Rates Table

The functions are typically for reporting and auditing purpose built
on top-of the foreign exchange rates table, which is stored under the
common schema as ``common.forex_rate_tx``. The function(s) are:

    * ``dev.missing_date_in_forex_udf`` - To find the missing dates
        in the forex rates table, which is useful for auditing purpose.

Copywright © [2025] Debmalya Pramanik, DigitPhilia INC.
********************************************************************/

CREATE OR REPLACE FUNCTION dev.missing_date_in_forex_udf ()
RETURNS TABLE (
    missing_date DATE
) AS $$

BEGIN
    RETURN QUERY

    SELECT
        CAST(dates AS DATE) AS missing_date
    FROM GENERATE_SERIES(
        (SELECT MIN(effective_date) FROM common.forex_rate_tx)
        , (SELECT MAX(effective_date) FROM common.forex_rate_tx)
        , INTERVAL '1 D'
    ) AS dates
    WHERE dates NOT IN (SELECT DISTINCT effective_date FROM common.forex_rate_tx)
    ORDER BY dates DESC;

END; $$
LANGUAGE 'plpgsql';
