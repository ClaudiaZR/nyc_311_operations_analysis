# Data

This folder contains documentation related to the NYC 311 dataset used in the project.

## Dataset

The analysis uses the NYC 311 Service Requests dataset from the NYC Open Data platform.

For this project, the dataset was filtered to include service requests created form January 1 to December 31, 2025, 
resulting in 3,655,041 records.


## Data Workflow

The raw data was:

1. Extracted from NYC Open Data.
2. Loaded into SQLite as `nyc_311_raw`.
3. Explored and validated using SQL.
4. Transformed into the clean analytical table `nyc_311_clean`.
5. Exported to CSV for analysis in Tableau.

## Data Quality

The dataset was validated for:

- Duplicate request IDs
- Missing dates
- Missing agency values
- Missing problem types
- Date ranges
- Invalid resolution times

A total of 915 records were identified where the closed date occurred before the created date. These records were retained but flagged as:

`Invalid - Closed Before Created`

They were excluded from resolution time metrics.

## Privacy

No personally identifiable information was intentionally added to this repository.

The raw dataset and database files are not included in the repository.
