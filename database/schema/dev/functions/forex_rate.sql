/********************************************************************
A Developer Function for Reporting/Auditing for FOREX Rates Table

The functions are typically for reporting and auditing purpose built
on top-of the foreign exchange rates table, which is stored under the
common schema as ``common.forex_rate_tx``. The function(s) are:

    * ``dev.missing_date_in_forex_udf`` - To find the missing dates
        in the forex rates table, which is useful for auditing purpose.

    * ``dev.missing_currency_in_forex_udf`` - To find the missing
        currencies in the forex rates table, which is defined under
        the currency master ``common.currency_mw`` table.

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


CREATE OR REPLACE FUNCTION dev.missing_currency_in_forex_udf ()
RETURNS TABLE (
    missing_currency CHAR(3)
    , missing_currency_name VARCHAR(64)
    , missing_currency_type CHAR(1)
    , missing_currency_subtype CHAR(1)
) AS $$

BEGIN
    RETURN QUERY

    SELECT
        currency_code AS missing_currency
        , currency_name AS missing_currency_name
        , currency_type AS missing_currency_type
        , currency_subtype AS missing_currency_subtype
    FROM common.currency_mw
    WHERE currency_code NOT IN (
        SELECT
            DISTINCT target_currency_code
        FROM common.forex_rate_tx
    )
    ORDER BY currency_code;

END; $$
LANGUAGE 'plpgsql';
