/*
File
  - sql/00_create_raw_cfpb_credit_card.sql

Purpose
  - Create the raw staging table for the CFPB credit card complaint export.

Significance
  - Preserves the source file structure before any cleaning, typing, renaming or filtering.
  - Creates a reproducible raw layer that can be reloaded from the original CSV.

Dependencies
  - Requires:
    - data/raw/cfpb_consumer_complaints_credit_card.csv

Output
- Creates:
  - raw_cfpb_credit_card

Notes
- Column names intentionally match the CSV headers exactly.
- All columns are loaded as text in the raw layer to reduce import friction.
- Data typing, renaming, and filtering happen in downstream SQL files.
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