# python-cfpb-complaint-nlp

Work-in-progress NLP project using public CFPB Consumer Complaint Data.

## Status

Early project setup. The analytical framing, working question, and final project scope are still being refined.

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