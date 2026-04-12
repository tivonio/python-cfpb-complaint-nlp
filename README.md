# python-cfpb-complaint-nlp

Work-in-progress NLP project using public CFPB Consumer Complaint Data.

## Project brief

This project uses public Consumer Financial Protection Bureau (CFPB) credit card complaint narratives from 2024 through 2025 to identify recurring consumer pain points, measure how common they are, and track how theme prevalance changes by quarter. The goal is not to estimate the full market or prove causation, but to use a public complaint source as an external signal for competitive monitoring. The final output should surface the main complaint themes, show how themes are becoming more or less prominent, and highlight the ones that may matter most for competitor weakness, persistent customer friction, emerging risk, or unmet customer needs that could create market opportunity.

## Current status

Early project setup. Project framing is defined. The SQL staging layer is in progress.

## Current contents

- Docker-based PostgreSQL setup
- Raw data staging scripts
- Initial project folder structure

## Project structure

```text
data/
  raw/
  processed/

notebooks/

outputs/
  figures/
  tables/

sql/
  00_create_raw_cfpb_credit_card.sql
  01_load_raw_cfpb_credit_card.sql
  02_base_view.sql
  03_data_checks.sql
  04_extract_for_python.sql