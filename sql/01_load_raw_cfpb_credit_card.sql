/*
File
  - sql/01_load_raw_cfpb_credit_card.sql

Purpose
  - Load the CFPB credit card complaint CSV into the raw staging table.

Significance
  - Brings the source data into Postgres in a reproducible way using the
    project's mounted raw data folder.
  - Establishes the starting point for all later checks, views, and Python extracts.

Dependencies
  - Requires:
    - raw_cfpb_credit_card
      (00_create_raw_cfpb_credit_card.sql)
    - /data/raw/cfpb_consumer_complaints_credit_card.csv
      (docker-compose.yml, data/raw/cfpb_consumer_complaints_credit_card.csv)

Output
- Loads:
  - raw_cfpb_credit_card

Notes
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