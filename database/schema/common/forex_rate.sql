/********************************************************************
The Foreign Exchange Rates (FOREX) Tracking Table

The foreign exchange rates sourced from different vendors/data source
providers are tracked in this table and is a common table to one/more
projects in the system. The schema considers data source proxy to the
internal data source schema.

Copywright © [2025] Debmalya Pramanik, DigitPhilia INC.
********************************************************************/

CREATE TABLE IF NOT EXISTS common.forex_rate_tx (
    _id
        SERIAL PRIMARY KEY,

    effective_date
        DATE NOT NULL,

    base_currency_code
        CHAR(3) NOT NULL
        CONSTRAINT fk_base_currency_code
            REFERENCES common.currency_master(currency_code)
            ON UPDATE CASCADE
            ON DELETE SET NULL,

    target_currency_code
        CHAR(3) NOT NULL
        CONSTRAINT fk_target_currency_code
            REFERENCES common.currency_master(currency_code)
            ON UPDATE CASCADE
            ON DELETE SET NULL,

    exchange_rate
        NUMERIC(19, 6) NOT NULL,

    created_on
        TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_on
        TIMESTAMPTZ,

    data_source_proxy_id
        SMALLINT NOT NULL
        CONSTRAINT fk_forex_data_source_proxy_id
            REFERENCES public.data_source_proxy_mw(data_source_proxy_id)
            ON UPDATE CASCADE
            ON DELETE SET NULL
);
