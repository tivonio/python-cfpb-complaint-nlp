/*
PURPOSE
Load the CFPB credit card complaint CSV into the raw staging table.

SIGNIFICANCE
This step brings the source data into Postgres in a reproducible way using the
project's mounted raw data folder. It creates the database starting point for
all later checks, views, and Python extracts.

DEPENDENCIES
- Table must already exist: raw_cfpb_credit_card
- Docker bind mount must expose the raw file at:
  /data/raw/cfpb_consumer_complaints_credit_card.csv

OUTPUT
- Rows loaded into: raw_cfpb_credit_card

NOTES
- TRUNCATE is used so the load can be rerun cleanly.
- The file path is container-relative, not a local Windows path.
- Expected row count after load: 89,749
*/

TRUNCATE TABLE raw_cfpb_credit_card;

COPY raw_cfpb_credit_card
FROM '/data/raw/cfpb_consumer_complaints_credit_card.csv'
WITH (
    format csv,
    header true
);

SELECT count(*) as row_count
FROM raw_cfpb_credit_card;