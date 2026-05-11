# Topic Modeling CFPB Credit Card Complaints with Python

This repo contains the complete SQL + Python walkthrough for the blog post published on tivon.io:

**Topic Modeling CFPB Credit Card Complaints with Python**

It uses public CFPB credit card complaint narratives to demonstrate a common external-monitoring problem:

- A stakeholder wants to know what consumers are complaining about in the credit card market
- The public complaint source does not represent the full market
- The analyst still needs a practical way to surface recurring pain points, measure how common they are, and track how the complaint mix changes over time

* * *

## What you will reproduce

You will reproduce a full workflow for turning public CFPB credit card complaint narratives into a set of broader complaint groups that can be tracked over time.

The workflow includes:

- SQL staging of the raw CFPB export
- Validation of row counts, dates, and scope assumptions
- Python text preparation
- Removal of redaction artifacts
- Exact duplicate handling before theme modeling
- TF-IDF + NMF topic modeling
- Manual theme labeling
- Grouping weaker or issuer-specific topics into broader reporting categories
- Quarterly trend summaries for the final reporting groups

You will also reproduce the two main figures used in the post:

- A bar chart of broader complaint group share
- A quarterly trend chart of broader complaint group share

* * *

## Export the CFPB data

This project uses a filtered export from the CFPB Consumer Complaint Database rather than the full complaint file.

### Export scope

Use the CFPB Consumer Complaint Database and filter to:

- **Product:** Credit card
- **Date received:** 2024-01-01 through 2025-12-31
- **Public narrative:** complaints with published narrative text

Then export the filtered results as a **CSV** and save the file as:

data/raw/cfpb_consumer_complaints_credit_card.csv

* * *

## Repo contents

### `data/raw/`

Place the exported CFPB CSV here:

- `cfpb_consumer_complaints_credit_card.csv`

### `sql/`

Run these in order:

1. `00_create_raw_cfpb_credit_card.sql`  
   Creates the raw staging table using the original CFPB CSV headers.

2. `01_load_raw_cfpb_credit_card.sql`  
   Loads the raw CSV into Postgres via server-side `COPY` from `/data/raw`.

3. `02_base_view.sql`  
   Standardizes column names, parses dates, and filters to complete analytical records.

4. `03_data_checks.sql`  
   Validates row counts, date ranges, product scope, quarter coverage, and field completeness.

5. `04_extract_for_python.sql`  
   Creates `vw_cfpb_credit_card_python_input`, the analysis-ready extract used by the notebooks.

### `notebooks/`

Run these in order:

1. `00_setup.ipynb`  
   Connects to Postgres, loads the Python input view into pandas, validates the scoped extract, and saves a processed file.

2. `01_text_prep.ipynb`  
   Cleans the complaint narratives, removes redaction artifacts, and prepares the text for modeling.

3. `02_theme_analysis.ipynb`  
   Runs TF-IDF + NMF, reviews top terms and example narratives, assigns manual theme labels, creates broader reporting groups, and summarizes quarterly trend changes.

### `outputs/figures/`

Final saved figures:

- `final_theme_group_share_bar.png`
- `final_theme_group_quarterly_trend.png`

### `outputs/tables/`

Final saved tables:

- `theme_summary.csv`
- `final_theme_summary.csv`
- `quarterly_group_summary.csv`
- `first_last_compare.csv`

* * *

## Key modeling decisions

### Exact scope before modeling

The project began with a broad question, but the final analysis was constrained to:

- public CFPB credit card complaints
- usable public narrative text
- complaints received from `2024-01-01` through `2025-12-31`
- one complaint narrative treated as one document
- quarterly trend analysis

The original plan was to use a three-year period. After staging the data and validating date coverage, I found that the 2023 portion of the export was incomplete for this project, so I narrowed the scope to a clean two-year window.

### Raw and analytical layers stay separate

The raw table preserves the original export structure as closely as possible. Standardization, filtering, and analysis-ready cleanup happen downstream in the base view and Python input view. That separation makes it easier to rerun the project from the original CSV and trace the analytical layers back to source.

### Exact duplicates are removed before theme discovery

During text preparation, I found that some complaint narratives were repeated exactly. Those exact duplicate cleaned narratives were removed before fitting the topic model so repeated scripts would not overwhelm the themes.

### Theme discovery and final reporting are not the same thing

The NMF model produces recurring word patterns, not finished business categories. After reviewing top terms and example narratives, I manually labeled the model themes and grouped weaker or issuer-specific themes into broader reporting categories. That reporting layer is what supports the final interpretation in the post.

* * *

## Checks

`03_data_checks.sql` validates the scoped dataset before it moves into Python.

Checks include:

1. Raw row count
2. Raw date range
3. Base row count and retained share
4. Base date range and quarter coverage
5. Product scope
6. Sub-product distribution
7. Duplicate complaint ID check
8. Key field completeness
9. Quarterly complaint counts

If those checks do not line up with the intended project scope, stop and debug before moving into text preparation and theme modeling.

* * *

## Prerequisites

- Docker Desktop
- A PostgreSQL container
- The CFPB credit card complaint CSV export placed in `data/raw/`
- Python virtual environment
- Jupyter Notebook or VS Code notebook support
- Python dependencies listed in `requirements.txt`

* * *

## Quickstart (PowerShell)

### 1) Clone the repo

```powershell
cd $HOME
git clone https://github.com/tivonio/python-cfpb-complaint-nlp.git
cd python-cfpb-complaint-nlp
```

### 2) Create and activate a virtual environment

```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
```

### 3) Install Python dependencies

```powershell
pip install -r requirements.txt
```

### 4) Start PostgreSQL with Docker Compose

```powershell
docker compose up -d
```

Confirm the container is running:

```powershell
docker ps
```

* * *

## Load the CFPB dataset

This project uses server-side `COPY`, which means the CSV path must be visible to the Postgres server.

The included `docker-compose.yml` mounts:

- `./data/raw` (host) → `/data/raw` (container, read-only)

So the CSV must exist inside the container at:

```text
/data/raw/cfpb_consumer_complaints_credit_card.csv
```

After the container is running, execute the SQL files in this order:

1. `sql/00_create_raw_cfpb_credit_card.sql`
2. `sql/01_load_raw_cfpb_credit_card.sql`
3. `sql/02_base_view.sql`
4. `sql/03_data_checks.sql`
5. `sql/04_extract_for_python.sql`

* * *

## Run the notebooks

Run the notebooks in this order:

1. `notebooks/00_setup.ipynb`
2. `notebooks/01_text_prep.ipynb`
3. `notebooks/02_theme_analysis.ipynb`

The final notebook produces:

- complaint-level modeled output
- detailed theme summary
- broader reporting group summary
- quarterly trend summary
- first-vs-last quarter share comparison
- final figures used in the post

* * *

## What the results support

After exact deduplication and broader reporting-group interpretation, the complaint mix was led by three main issue families:

- Card opening and account change issues
- Late fee and payment posting disputes
- Merchant charge disputes and refund resolution

From `2024 Q1` to `2025 Q4`, the mix shifted away from card opening/account change issues and toward merchant dispute/refund problems and credit reporting accuracy disputes.

The goal is not to estimate the full market or prove causation. The goal is to use a public complaint source as an external signal for competitive monitoring.

* * *

## Limitations

- CFPB complaint narratives are a public complaint signal, not a full measure of customer experience in the credit card market
- Public complaint narratives are not representative of the full market
- Complaint text can include legal boilerplate, issuer-specific language, and template-style wording
- Exact duplicate cleaned narratives were removed, but near-duplicate narratives remain
- Final theme labels and broader reporting groups reflect analyst interpretation
- The results describe pattern shifts, not causal explanations
