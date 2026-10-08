# SQL Analysis — NYC 311 Operations

## Overview

This folder contains the SQL script used to prepare, clean, validate, and analyze New York City 311 service requests created in 2025.

The analysis uses SQLite to transform the raw data into a clean dataset and calculate operational performance metrics for further analysis in Tableau.

## Database and Tables

* **`nyc_311_raw`** — The raw source data filtered to requests created in 2025.
* **`nyc_311_clean`** — The cleaned and transformed dataset used for analysis.

The raw dataset contains 3,655,041 records.

## SQL Workflow

The SQL analysis includes the following steps:

1. **Data exploration:** Reviewed the table structure, record counts, date ranges, boroughs, agencies, and problem types.
2. **Data quality checks:** Checked for duplicate unique keys and missing values in key fields, including Created Date, Closed Date, Agency, and Problem.
3. **Date and time transformation:** Converted the source's 12 hour AM/PM date strings into standardized 24-hour datetime values.
4. **Resolution time calculation:** Calculated elapsed time between request creation and closure using SQLite date time functions.
5. **Invalid resolution checks:** Identified records where the Closed Date occurs before the Created Date.
6. **Data preparation for analysis**: Prepared the cleaned dataset and calculated resolution time fields in SQLite for use in Tableau. Operational analysis and visualizations across agencies, boroughs, problem types, months, and hours of the day were developed in Tableau.

## Data Quality Decisions

* No duplicate unique keys were identified in the initial checks.
* No missing values were found in the checked key fields.
* 915 records had a Closed Date earlier than the Created Date. These records were flagged as invalid for resolution time analysis and excluded from valid resolution metrics.
* Records with zero resolution time were retained.
* Requests created in 2025 but closed in 2026 were retained because they were part of the 2025 created request population.

## Resolution Time

Resolution time was calculated as the difference between the standardized Closed Date and Created Date timestamps, using SQLite's `julianday()` function.

The analysis reports resolution duration in hours. Invalid negative durations are excluded from valid resolution time metrics.

## SQL Script

The main SQL script is [`nyc_311_analysis.sql`](nyc_311_analysis.sql).

It contains the queries used for data preparation, validation, transformation, and operational analysis.


## Data Source

[NYC 311 Service Requests from 2020 to Present — NYC Open Data](https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2020-to-Present/erm2-nwe9/about_data)

This project focuses on requests created between January 1 and December 31, 2025.


