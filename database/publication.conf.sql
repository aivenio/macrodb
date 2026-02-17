/********************************************************************
Configuration of Published Tables from MacroDB for Subscribers

The configuration file is created to keep track of all the published
information in macrodb with a list of objects that are available.
The list may expand with time, thus, it is recommended to keep track
of all the changes and create migration scripts.
********************************************************************/

CREATE PUBLICATION macrodb_geography_table
FOR TABLE
  common.country_mw
  , common.state_mw
  , common.city_mw;
