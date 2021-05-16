/********************************************************************
World Currency & Derivatives Details for Economic Factor Analysis

The following tables contains information like the currency name,
symbol, code and minor units among typical things to be used for a
set of analysis or as a proxy for economic factors.

WiKi Data ID: A field is added to each table to keep track of the
source of the data from the WiKiPedia website. More details on the ID
is available at https://www.wikidata.org/wiki/Wikidata:Identifiers.
Entity IDs can also be used globally using the unique URLs that follow
`https://www.wikidata.org/entity/ID` pattern.
********************************************************************/

CREATE TABLE IF NOT EXISTS common.currency_type_mw (
    currency_type
        CHAR(1)
        CONSTRAINT pk_currency_type PRIMARY KEY,

    currency_type_name
        VARCHAR(32) NOT NULL
        CONSTRAINT uq_currency_type_name UNIQUE,

    currency_type_desc
        VARCHAR(128) NOT NULL,

    wikidata_id
        VARCHAR(12) NOT NULL
        CONSTRAINT uq_currency_type_wikidata_id UNIQUE
);


CREATE TABLE IF NOT EXISTS common.currency_subtype_mw (
    currency_subtype
        CHAR(1)
        CONSTRAINT pk_currency_subtype PRIMARY KEY,

    currency_subtype_name
        VARCHAR(48) NOT NULL
        CONSTRAINT uq_currency_subtype_name UNIQUE,

    currency_type
        CHAR(1) NOT NULL
        CONSTRAINT fk_currency_subtype_currency_type
            REFERENCES common.currency_type_mw(currency_type)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,

    currency_subtype_desc
        VARCHAR(128) NOT NULL,

    wikidata_id
        VARCHAR(12) NOT NULL
        CONSTRAINT uq_currency_subtype_wikidata_id UNIQUE
);


CREATE TABLE IF NOT EXISTS common.currency_mw (
    currency_code
        CHAR(3)
        CONSTRAINT pk_currency_code PRIMARY KEY,

    currency_name
        VARCHAR(64) NOT NULL
        CONSTRAINT uq_currency_name UNIQUE,

    currency_symbol
        VARCHAR(16)
        CONSTRAINT uq_currency_symbol UNIQUE,

    currency_type
        CHAR(1) NOT NULL
        CONSTRAINT fk_currency_currency_type
            REFERENCES common.currency_type_mw(currency_type)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,

    currency_subtype
        CHAR(1)
        CONSTRAINT fk_currency_currency_subtype
            REFERENCES common.currency_subtype_mw(currency_subtype)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,

    n_decimals
        INTEGER NOT NULL DEFAULT 2,

    minor_unit_name
        VARCHAR(32),

    minor_unit_symbol
        VARCHAR(16),

    minor_unit_factor
        INTEGER,

    CONSTRAINT ck_minor_currency_null CHECK (
        NUM_NULLS(
            minor_unit_name, minor_unit_symbol, minor_unit_factor
        ) IN (0, 3)
    )
);
