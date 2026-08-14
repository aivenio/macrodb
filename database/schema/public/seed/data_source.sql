INSERT INTO public.data_source_mw (data_source_id, data_source_name, data_source_desc, data_source_uri) VALUES
    ('ERAPI', 'Exchange Rates API', 'Historical and Real-Time Exchange Rates', 'https://exchangeratesapi.io/'),
    ('XECCV', 'XE Currency Converter', 'Live Exchange Rates for Personal & Business', 'https://www.xe.com/currencyconverter/'),
    ('OSEXR', 'Open Source Exchange Rates API', 'Currency API Data at a Granular Level', 'https://openexchangerates.org/'),
    ('OWIDT', 'Our World in Data', 'Oxford University Affiliated, Open Data on Global Problems like Health, Hunger, etc.', 'https://ourworldindata.org/')
ON CONFLICT (data_source_id) DO UPDATE SET
    data_source_name = EXCLUDED.data_source_name
    , data_source_desc = EXCLUDED.data_source_desc
    , data_source_uri = EXCLUDED.data_source_uri;
