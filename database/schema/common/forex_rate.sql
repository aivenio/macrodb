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
        INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    effective_date
        DATE NOT NULL,

    base_currency_code
        CHAR(3) NOT NULL
        CONSTRAINT fk_base_currency_code
            REFERENCES common.currency_mw(currency_code)
            ON UPDATE CASCADE
            ON DELETE SET NULL,

    target_currency_code
        CHAR(3) NOT NULL
        CONSTRAINT fk_target_currency_code
            REFERENCES common.currency_mw(currency_code)
            ON UPDATE CASCADE
            ON DELETE SET NULL,

    exchange_rate
        NUMERIC(19, 6) NOT NULL,

    data_source_proxy_id
        CHAR(4) NOT NULL
        CONSTRAINT fk_forex_data_source_proxy_id
            REFERENCES public.data_source_proxy_mw(data_source_proxy_id)
            ON UPDATE CASCADE
            ON DELETE SET NULL,

    CONSTRAINT uq_forex_value_from_source
        UNIQUE (effective_date, base_currency_code, target_currency_code, data_source_proxy_id)
);
