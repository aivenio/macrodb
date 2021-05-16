/********************************************************************
Global World Continent, Region, Country, States, Cities Table Details

The following table contains the list of continents, regions, country,
states and cities details which can be used for various functionality
and may also serve as indexation for transactional data.

WiKi Data ID: A field is added to each table to keep track of the
source of the data from the WiKiPedia website. More details on the ID
is available at https://www.wikidata.org/wiki/Wikidata:Identifiers.
Entity IDs can also be used globally using the unique URLs that follow
`https://www.wikidata.org/entity/ID` pattern.
********************************************************************/

CREATE TABLE IF NOT EXISTS common.continent_mw (
    continent_code
        CHAR(2)
        CONSTRAINT pk_continent_code PRIMARY KEY,

    continent_name
        VARCHAR(64) NOT NULL
        CONSTRAINT uq_continent_name UNIQUE,

    wikidata_id
        VARCHAR(8) NOT NULL
        CONSTRAINT uq_continent_wikidata_id UNIQUE,

    geoname_id
        VARCHAR(8) NOT NULL
        CONSTRAINT uq_continent_geoname_id UNIQUE
);


CREATE TABLE IF NOT EXISTS common.region_mw (
    region_code
        CHAR(3)
        CONSTRAINT pk_region_code PRIMARY KEY,

    region_name
        VARCHAR(64) NOT NULL
        CONSTRAINT uq_region_name UNIQUE,

    wikidata_id
        VARCHAR(8) NOT NULL
        CONSTRAINT uq_region_wikidata_id UNIQUE
);


CREATE TABLE IF NOT EXISTS common.subregion_mw (
    subregion_code
        CHAR(3)
        CONSTRAINT pk_subregion_code PRIMARY KEY,

    subregion_name
        VARCHAR(64) NOT NULL
        CONSTRAINT uq_subregion_name UNIQUE,

    region_code
        CHAR(3) NOT NULL
        CONSTRAINT fk_subregion_region_code
            REFERENCES common.region_mw(region_code)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,

    wikidata_id
        VARCHAR(8) NOT NULL
        CONSTRAINT uq_subregion_wikidata_id UNIQUE
);


CREATE TABLE IF NOT EXISTS common.country_mw (
    country_code
        CHAR(3)
        CONSTRAINT pk_country_code PRIMARY KEY,

    country_name
        VARCHAR(64) NOT NULL
        CONSTRAINT uq_country_name UNIQUE,

    continent_code
        CHAR(2) NOT NULL
        CONSTRAINT fk_country_continent_code
            REFERENCES common.continent_mw(continent_code)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,

    region_code
        CHAR(3) NOT NULL
        CONSTRAINT fk_country_region_code
            REFERENCES common.region_mw(region_code)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,

    subregion_code
        CHAR(3) NOT NULL
        CONSTRAINT fk_country_subregion_code
            REFERENCES common.subregion_mw(subregion_code)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,

    iso2_code
        CHAR(2) NOT NULL
        CONSTRAINT uq_country_iso2 UNIQUE,

    numeric_code
        CHAR(3) NOT NULL
        CONSTRAINT uq_country_numeric_code UNIQUE,

    top_level_domain
        CHAR(3)
        CONSTRAINT uq_country_top_level_domain UNIQUE,

    wikidata_id
        VARCHAR(8)
        CONSTRAINT uq_country_wikidata_id UNIQUE,

    geoname_id
        VARCHAR(8)
        CONSTRAINT uq_country_geoname_id UNIQUE,

    country_flag_uri
        VARCHAR(256)
        CONSTRAINT uq_country_flag_uri UNIQUE
);


CREATE TABLE IF NOT EXISTS common.state_type_mw (
    state_type_code
        CHAR(3)
        CONSTRAINT pk_state_type PRIMARY KEY,

    state_type_name
        VARCHAR(64) NOT NULL
        CONSTRAINT uq_state_type_name UNIQUE
);


CREATE TABLE IF NOT EXISTS common.state_mw (
    state_uuid
        CHAR(5)
        CONSTRAINT pk_state_uuid PRIMARY KEY,

    state_code
        VARCHAR(5),

    state_name
        VARCHAR(64) NOT NULL,

    country_code
        CHAR(3) NOT NULL
        CONSTRAINT fk_state_country_code
            REFERENCES common.country_mw(country_code)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,

    state_type
        CHAR(3)
        CONSTRAINT fk_state_state_type
            REFERENCES common.state_type_mw(state_type_code)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,

    state_latitude
        NUMERIC(9, 6),

    state_longitude
        NUMERIC(9, 6),

    wikidata_id
        VARCHAR(8)
        CONSTRAINT uq_state_wikidata_id UNIQUE,

    geoname_id
        VARCHAR(8)
        CONSTRAINT uq_state_geoname_id UNIQUE,

    CONSTRAINT uq_state_name UNIQUE (country_code, state_name),
    CONSTRAINT uq_state_code UNIQUE (country_code, state_code)
);


CREATE TABLE IF NOT EXISTS common.city_mw (
    city_code
        CHAR(5)
        CONSTRAINT pk_city_code PRIMARY KEY,

    city_name
        VARCHAR(64) NOT NULL,

    country_code
        CHAR(3) NOT NULL
        CONSTRAINT fk_city_country_code
            REFERENCES common.country_mw(country_code)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,

    state_uuid
        CHAR(5) NOT NULL
        CONSTRAINT fk_city_state_uuid
            REFERENCES common.state_mw(state_uuid)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,

    city_type
        VARCHAR(32),

    city_latitude
        NUMERIC(9, 6),

    city_longitude
        NUMERIC(9, 6),

    wikidata_id
        VARCHAR(8)
        CONSTRAINT uq_city_wikidata_id UNIQUE,

    geoname_id
        VARCHAR(8)
        CONSTRAINT uq_city_geoname_id UNIQUE,

    CONSTRAINT uq_city_name UNIQUE (country_code, state_uuid, city_name)
);
