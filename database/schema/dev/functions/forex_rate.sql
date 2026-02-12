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

    * ``dev.missing_forex_for_currencies_udf`` - To find the missing
        forex rates for a list of currencies.

The functions are to be used by developers and/or administrators of
the datbase, thus a seperate schema is defined for schema level grant
permission settings.
********************************************************************/

CREATE OR REPLACE FUNCTION dev.missing_date_in_forex_udf (
    p_start_date DATE DEFAULT NULL
    , p_end_date DATE DEFAULT NULL
)
RETURNS TABLE (
    missing_date DATE
) AS $$

BEGIN
    RETURN QUERY

    SELECT
        CAST(dates AS DATE) AS missing_date
    FROM GENERATE_SERIES(
        CASE
            WHEN p_start_date IS NULL THEN
                (SELECT MIN(effective_date) FROM common.forex_rate_tx)
            ELSE p_start_date
        END
        , CASE
            WHEN p_end_date IS NULL THEN
                (SELECT MAX(effective_date) FROM common.forex_rate_tx)
            ELSE p_end_date
        END
        , INTERVAL '1 D'
    ) AS dates
    WHERE dates NOT IN (SELECT DISTINCT effective_date FROM common.forex_rate_tx)
    ORDER BY dates DESC;

END; $$
LANGUAGE 'plpgsql';


CREATE OR REPLACE FUNCTION dev.missing_currency_in_forex_udf (
    p_start_date DATE DEFAULT NULL
    , p_end_date DATE DEFAULT NULL
)
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
        WHERE
            (effective_date BETWEEN
                CASE
                    WHEN p_start_date IS NULL THEN
                        (SELECT MIN(effective_date) FROM common.forex_rate_tx)
                    ELSE p_start_date
                END
                AND
                CASE
                    WHEN p_end_date IS NULL THEN
                        (SELECT MAX(effective_date) FROM common.forex_rate_tx)
                    ELSE p_end_date
                END
            )
    )
    ORDER BY currency_code;

END; $$
LANGUAGE 'plpgsql';


CREATE OR REPLACE FUNCTION dev.missing_forex_for_currencies_udf (
    p_start_date DATE DEFAULT NULL
    , p_end_date DATE DEFAULT NULL
    , p_currency_codes CHAR(3)[] DEFAULT ARRAY['INR', 'USD', 'EUR', 'JPY', 'GBP']
) RETURNS TABLE (
    missing_date DATE
    , missing_currency CHAR(3)
    , missing_currency_name VARCHAR(64)
    , missing_currency_type CHAR(1)
    , missing_currency_subtype CHAR(1)
) AS $$

BEGIN
    RETURN QUERY

    SELECT
        gs.dates::DATE AS missing_date
        , curlist.currency_code AS missing_currency
        , currency.currency_name AS missing_currency_name
        , currency.currency_type AS missing_currency_type
        , currency.currency_subtype AS missing_currency_subtype
    FROM (
        SELECT GENERATE_SERIES(
            CASE
                WHEN p_start_date IS NULL THEN
                    (SELECT MIN(effective_date) FROM common.forex_rate_tx)
                ELSE p_start_date
            END
            , CASE
                WHEN p_end_date IS NULL THEN
                    (SELECT MAX(effective_date) FROM common.forex_rate_tx)
                ELSE p_end_date
            END
            , INTERVAL '1 D'
        ) AS dates
    ) gs

    CROSS JOIN (
        SELECT UNNEST(p_currency_codes) AS currency_code
    ) curlist

    LEFT JOIN common.forex_rate_tx forex ON
        gs.dates = forex.effective_date
        AND curlist.currency_code = forex.target_currency_code

    LEFT JOIN common.currency_mw currency ON
        curlist.currency_code = currency.currency_code

    WHERE forex.target_currency_code IS NULL
    ORDER BY
        gs.dates DESC
        , currency.currency_code;

END; $$
LANGUAGE 'plpgsql';
