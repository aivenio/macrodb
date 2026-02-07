/********************************************************************
The Foreign Exchange Rates (FOREX) Tracking Table

The foreign exchange rates sourced from different vendors/data source
providers are tracked in this table and is a common table to one/more
projects in the system. The table is created to keep track of the
exchange rates that can be provided from multiple sources - check
data sources for more information.
********************************************************************/

CREATE TABLE IF NOT EXISTS common.forex_rate_tx (
    forex_record_id
        INTEGER GENERATED ALWAYS AS IDENTITY
        CONSTRAINT pk_forex_record_id PRIMARY KEY,

    effective_date
        DATE NOT NULL,

    base_currency_code
        CHAR(3) NOT NULL
        CONSTRAINT fk_base_currency_code
            REFERENCES common.currency_mw(currency_code)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,

    target_currency_code
        CHAR(3) NOT NULL
        CONSTRAINT fk_target_currency_code
            REFERENCES common.currency_mw(currency_code)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,

    exchange_rate
        NUMERIC(19, 6) NOT NULL,

    data_source_id
        CHAR(5) NOT NULL
        CONSTRAINT fk_forex_data_source_id
            REFERENCES public.data_source_mw(data_source_id)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,

    CONSTRAINT uq_forex_value_from_source
        UNIQUE (
            effective_date
            , base_currency_code
            , target_currency_code
            , data_source_id
        )
);
