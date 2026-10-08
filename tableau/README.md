# Tableau

This folder contains documentation for the Tableau analysis and dashboards developed for the NYC 311 Operations Analysis project.

## Tableau Workbook

The Tableau workbook contains the analytical worksheets and dashboards created from the cleaned NYC 311 dataset.

The analysis focuses on:

- Request volume
- Monthly and hourly demand patterns
- Borough and agency request volume
- Problem type request volume
- Resolution performance
- Agency resolution performance
- Problem type resolution performance
- Request volume versus resolution time

  
## Dashboards

### NYC 311 Operations Dashboard — 2025

Executive level dashboard showing:

- Total requests
- Median resolution time
- Average resolution time
- Invalid resolution records
- Monthly request volume
- Requests by borough
- Top 10 problem types
- Agency resolution performance

### NYC 311 Operational Performance — 2025

Operational performance dashboard showing:

- Request volume by hour
- Median resolution time by hour
- Median resolution time by problem type
- Agency request volume versus median resolution time

## Tableau Techniques

The project demonstrates:

- Calculated fields
- Parameters
- Table calculations
- Filters
- KPI development
- Interactive visualizations
- Trend lines
- Dashboard design
- Data storytelling

A parameter was created to allow users to switch between Fastest and Slowest agency resolution performance.

## Data Source

The Tableau analysis uses the cleaned analytical dataset created in SQLite and exported to CSV.

The data preparation and transformation process is documented in:

`../sql/nyc_311_analysis.sql`
