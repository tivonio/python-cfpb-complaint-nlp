/*
File
    - sql/04_extract_for_python.sql

Purpose
    - Create the analysis-ready extract for the Python NLP workflow.

Significance
    - Narrows the base complaint view to the fields needed for text analysis,
      theme prevalence meausrement, and quarterly trend tracking.
    - Provides a clean bridge between SQL data prep and Python NLP workflows
      with visualization.

Dependencies
    - Requires:
        - raw_cfpb_credit_card
          (00_create_raw_cfpb_credit_card.sql, 01_load_raw_cfpb_credit_card.sql)
        - vw_cfpb_credit_card_base
          (02_base_view.sql)
        - validation checks from vw_cfpb_credit_card_base
          (03_data_checks.sql)

Output
    - Creates:
        - vw_cfpb_credit_card_python_input

Notes
    - This extract is aligned to the project scope:
      CFPB credit card complaints, usable narratives, 2024-01-01 through
      2025-12-31, quarterly trend analysis.
    - The company field is retained for possible later extension, but issuer
      comparison is not a primary objective in this project.
    - The extract keeps one row per complaint narrative.
    - Excludes incomplete records.
*/

DROP VIEW IF EXISTS vw_cfpb_credit_card_python_input;

CREATE VIEW vw_cfpb_credit_card_python_input AS
SELECT
    complaint_id,
    date_received,
    EXTRACT(YEAR FROM date_received)::int AS complaint_year,
    EXTRACT(QUARTER FROM date_received)::int AS complaint_quarter,
    DATE_TRUNC('quarter', date_received)::date AS quarter_start,
    TO_CHAR(DATE_TRUNC('quarter', date_received)::date, 'YYYY "Q"Q') AS quarter_label,
    product,
    sub_product,
    issue,
    sub_issue,
    company,
    company_response_to_consumer,
    timely_response,
    consumer_complaint_narrative
FROM vw_cfpb_credit_card_base
WHERE complaint_id IS NOT NULL
    AND date_received IS NOT NULL
    AND consumer_complaint_narrative IS NOT NULL;

SELECT
    COUNT(*) AS row_count,
    MIN(date_received) AS min_date_received,
    MAX(date_received) AS max_date_received,
    COUNT(DISTINCT quarter_start) AS quarters_covered
FROM vw_cfpb_credit_card_python_input;

SELECT *
FROM vw_cfpb_credit_card_python_input
LIMIT 10;