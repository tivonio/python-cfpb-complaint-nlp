/*
File
    - sql/02_base_view.sql

Purpose
    - Create the base analysis view for CFPB credit card complaint narratives.

Significance
    - Bridges the raw import layer and later analysis steps.
    - Standardizes column names, converts blank strings to NULL, parses dates,
      and keeps only records with usable complaint narratives.

Dependencies
    - Requires:
        - raw_cfpb_credit_card
          (00_create_raw_cfpb_credit_card.sql, 01_load_raw_cfpb_credit_card.sql)

Output
    - Creates:
        - vw_cfpb_credit_card_base

Notes
    - The raw table preserves the CSV as is; this view makes the data easier to
      query and analyze.
    - Product is retained as a validation check even though the source export
      was already filtered for credit card complaints.
    - Rows without a complaint narrative are excluded because they are not
      useful for the NLP workflow.
*/

DROP VIEW IF EXISTS vw_cfpb_credit_card_base;

CREATE VIEW vw_cfpb_credit_card_base AS
SELECT
    NULLIF(TRIM("Complaint ID"), '')::BIGINT AS complaint_id,
    TO_DATE(NULLIF(TRIM("Date received"), ''), 'FMMM/FMDD/YYYY') AS date_received,
    NULLIF(TRIM("Product"), '') AS product,
    NULLIF(TRIM("Sub-product"), '') AS sub_product,
    NULLIF(TRIM("Issue"), '') AS issue,
    NULLIF(TRIM("Sub-issue"), '') AS sub_issue,
    NULLIF(TRIM("Consumer complaint narrative"), '') AS consumer_complaint_narrative,
    NULLIF(TRIM("Company public response"), '') AS company_public_response,
    NULLIF(TRIM("Company"), '') AS company,
    NULLIF(TRIM("State"), '') AS state,
    NULLIF(TRIM("ZIP code"), '') AS zip_code,
    NULLIF(TRIM("Tags"), '') AS tags,
    NULLIF(TRIM("Consumer consent provided?"), '') AS consumer_consent_provided,
    NULLIF(TRIM("Submitted via"), '') AS submitted_via,
    TO_DATE(NULLIF(TRIM("Date sent to company"), ''), 'FMMM/FMDD/YYYY') AS date_sent_to_company,
    NULLIF(TRIM("Company response to consumer"), '') AS company_response_to_consumer,
    NULLIF(TRIM("Timely response?"), '') AS timely_response,
    NULLIF(TRIM("Consumer disputed?"), '') AS consumer_disputed
FROM raw_cfpb_credit_card
WHERE NULLIF(TRIM("Consumer complaint narrative"), '') IS NOT NULL;

SELECT COUNT(*) AS row_count
FROM vw_cfpb_credit_card_base;