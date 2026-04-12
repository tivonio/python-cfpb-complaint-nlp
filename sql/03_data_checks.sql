/*
File
    - sql/03_data_checks.sql

Purpose
    - Run validation checks on the raw and base CFPB credit card complaint data.

Significance
    - Confirms that the project scope was applied as intended before the data
      moves into the Python NLP workflow.
    - Checks whether the base view is suitable for theme extraction, prevalence
      measurement, and quarterly trend analysis.

Dependencies
    - Requires:
        - raw_cfpb_credit_card
          (00_create_raw_cfpb_credit_card.sql, 01_load_raw_cfpb_credit_card.sql)
        - vw_cfpb_credit_card_base
          (02_base_view.sql)

Output
    - Produces:
        - Validation result sets from raw_cfpb_credit_card

Notes
    - These checks are aligned to the project scope:
      CFPB credit card complaints, usable narratives, 2024-01-01 through
      2025-12-31, quarterly trend analysis.
    - This file is for validation and profiling only. It does not create
      tables or views.
*/


-- ==============================================================================
-- 1)   Raw row count
--      Expected: 76,880
-- ==============================================================================
SELECT
    COUNT(*) AS raw_row_count
FROM raw_cfpb_credit_card;


-- ==============================================================================
-- 2)   Raw date range
--      Expected: 2024-01-01 through 2025-12-31
-- ==============================================================================
SELECT
    MIN(TO_DATE(NULLIF(TRIM("Date received"), ''), 'FMMM/FMDD/YYYY')) AS raw_min_date_received,
    MAX(TO_DATE(NULLIF(TRIM("Date received"), ''), 'FMMM/FMDD/YYYY')) AS raw_max_date_received
FROM raw_cfpb_credit_card;


-- ==============================================================================
-- 3)   Base row count and retained share
--      Shows how many rows remain after requiring usable narratives
-- ==============================================================================
SELECT
    raw.raw_row_count,
    base.base_row_count,
    raw.raw_row_count - base.base_row_count AS rows_removed,
    ROUND(100.0 * base.base_row_count / NULLIF(raw.raw_row_count, 0), 2) AS pct_retained
FROM
    (SELECT COUNT(*) AS raw_row_count
     FROM raw_cfpb_credit_card) raw
CROSS JOIN
    (SELECT COUNT(*) AS base_row_count
     FROM vw_cfpb_credit_card_base) base;


-- ==============================================================================
-- 4)   Base date range and quarter coverage
--      Expected: 2024-01-01 through 2025-12-31 and 8 quarters
-- ==============================================================================
SELECT
    MIN(date_received) AS base_min_date_received,
    MAX(date_received) AS base_max_date_received,
    COUNT(DISTINCT DATE_TRUNC('quarter', date_received)) AS quarters_covered
FROM vw_cfpb_credit_card_base;


-- ==============================================================================
-- 5)   Product values kept in the base view
--      Expectation: Credit card only
-- ==============================================================================
SELECT
    product,
    COUNT(*) AS complaint_count
FROM vw_cfpb_credit_card_base
GROUP BY product
ORDER BY complaint_count DESC, product;


-- ==============================================================================
-- 6)   Sub-product distribution
-- ==============================================================================
SELECT
    sub_product,
    COUNT(*) AS complaint_count
FROM vw_cfpb_credit_card_base
GROUP BY sub_product
ORDER BY complaint_count DESC, sub_product;


-- ==============================================================================
-- 7)   Duplicate complaint ID check
--      Expectation: zero duplicate complaint_id values
-- ==============================================================================
SELECT
    complaint_id,
    COUNT(*) AS row_count
FROM vw_cfpb_credit_card_base
GROUP BY complaint_id
HAVING COUNT(*) > 1
ORDER BY row_count DESC, complaint_id;