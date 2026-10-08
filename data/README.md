# Data

This folder contains documentation related to the NYC 311 dataset used in the project.


## Dataset Source

The analysis uses the NYC 311 Service Requests dataset from the NYC Open Data platform.


[Official dataset - NYC Open Data - 311 Service Requests](https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2020-to-Present/erm2-nwe9/about_data)


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

## Data Files

Raw database/CSV: The original dataset is not included in this repository because of the large file size.

The cleaned dataset used for the Tableau analysis was created using SQL and exported as:

`nyc_311_clean.csv`

Cleaning and validation steps can be found in:

`../sql/nyc_311_analysis.sql`


## Privacy

The NYC Open Data source states that the dataset does not reveal personally identifying information about the customer who made the service request.


