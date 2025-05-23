/********************************************************************
Get the FOREX Rate(s) for a Date Range from a desired Data Source

The FOREX Rate(s) are stored under the ``common.forex_rate_tx`` table
and the function consideres input parameters - date range and data
source name (internal private name) to fetch the data.

The user defined dynamic function is customizable and is accepts the
following parameters:

    * ``p_start_date`` - The start date of the range (default is 365
        days back from current date),
    * ``p_final_date`` - The final date of the range (default is 
        current date),
    * ``p_base_currency_code`` - The base currency code (default is
        INR),
    * ``p_data_source_private`` - The private data source name
        (default is ERAPI).

For simplicity purpose, the function(s) are named with "source" short
for "data source" and "range" for the "date range", to reduce the
length of the function name.

Copywright © [2025] Debmalya Pramanik, DigitPhilia INC.
********************************************************************/

CREATE OR REPLACE FUNCTION common.forex_from_source_for_range_udf (
    p_start_date DATE DEFAULT (CURRENT_DATE - INTERVAL '365 D')::DATE,
    p_final_date DATE DEFAULT CURRENT_DATE,
    p_date_source_proxy_id INTEGER DEFAULT 1

) RETURNS TABLE (
    effective_date DATE,
    base_currency_code CHAR(3),
    target_currency_code CHAR(3),
    exchange_rate NUMERIC(19, 6)
) AS $$

BEGIN
    RETURN QUERY

    SELECT
        forex.effective_date
        , forex.base_currency_code
        , forex.target_currency_code
        , forex.exchange_rate
    FROM common.forex_rate_tx AS forex
    WHERE
        forex.effective_date BETWEEN p_start_date AND p_final_date
        AND forex.data_source_proxy_id = p_date_source_proxy_id
    ORDER BY
        forex.effective_date DESC
        , forex.base_currency_code
        , forex.target_currency_code;

END; $$
LANGUAGE 'plpgsql';


CREATE OR REPLACE FUNCTION common.forex_from_source_for_range_base_udf (
    p_start_date DATE DEFAULT (CURRENT_DATE - INTERVAL '365 D')::DATE,
    p_final_date DATE DEFAULT CURRENT_DATE,
    p_date_source_proxy_id INTEGER DEFAULT 1,
    p_base_currency_code CHAR(3) DEFAULT 'INR'

) RETURNS TABLE (
    effective_date DATE,
    base_currency_code CHAR(3),
    target_currency_code CHAR(3),
    exchange_rate NUMERIC(19, 6)
) AS $$

BEGIN
    RETURN QUERY

    SELECT
        ltbl.effective_date
        , rtbl.target_currency_code AS base_currency_code
        , ltbl.target_currency_code AS target_currency_code
        , (ltbl.exchange_rate / rtbl.exchange_rate)::NUMERIC(19, 6) AS exchange_rate
    FROM common.forex_from_source_for_range_udf(
        p_start_date
        , p_final_date
        , p_date_source_proxy_id
    ) ltbl
    JOIN common.forex_from_source_for_range_udf(
        p_start_date
        , p_final_date
        , p_date_source_proxy_id
    ) rtbl ON ltbl.effective_date = rtbl.effective_date
    WHERE
        rtbl.target_currency_code = p_base_currency_code
    ORDER BY
        ltbl.effective_date DESC
        , ltbl.target_currency_code;

END; $$
LANGUAGE 'plpgsql';
