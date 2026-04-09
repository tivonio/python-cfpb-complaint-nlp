/*
PURPOSE
Create the raw staging table for the CFPB credit card complaint export.

SIGNIFICANCE
This table preserves the source file as closely as possible before any cleaning,
typing, renaming, or filtering. Keeping a raw table makes the project easier to
audit and rerun.

DEPENDENCIES
- Database: cfpb_nlp
- Source file headers from:
  data/raw/cfpb_consumer_complaints_credit_card.csv

OUTPUT
- Table created: raw_cfpb_credit_card

NOTES
- Column names intentionally match the CSV headers exactly.
- All columns are loaded as text in the raw layer to reduce import friction.
- Data typing and column standardization will happen later in a base view.
*/

DROP TABLE IF EXISTS raw_cfpb_credit_card;

CREATE TABLE raw_cfpb_credit_card (
    "Date received" text,
    "Product" text,
    "Sub-product" text,
    "Issue" text,
    "Sub-issue" text,
    "Consumer complaint narrative" text,
    "Company public response" text,
    "Company" text,
    "State" text,
    "ZIP code" text,
    "Tags" text,
    "Consumer consent provided?" text,
    "Submitted via" text,
    "Date sent to company" text,
    "Company response to consumer" text,
    "Timely response?" text,
    "Consumer disputed?" text,
    "Complaint ID" text
);