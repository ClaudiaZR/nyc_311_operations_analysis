# NYC 311 Operations Analysis — 2025

## 1. Project Overview

This project analyzes 3.65 million NYC 311 service requests created during 2025 to understand patterns in public service demand and resolution performance across New York City.

The analysis focuses on when requests occur, where request volume is concentrated, which problems generate the most requests, and how resolution times vary across agencies, problem types, boroughs, and hours of the day.

The project follows an **ELT (Extract, Load, Transform) workflow**. The raw NYC 311 data was extracted from the source and loaded into SQLite, where it was explored, validated, cleaned, and transformed into an analytical dataset. The resulting dataset was then loaded into Tableau for calculated metrics, visual analysis, and interactive dashboard development.

The project includes two Tableau dashboards:

* **NYC 311 Operations Dashboard — 2025:** An overview of request volume and overall resolution performance.
* **NYC 311 Operational Performance — 2025:** A detailed analysis of hourly demand, resolution patterns, and agency performance.

## 2. Business Problem

NYC 311 receives millions of service requests each year across a wide range of public services and agencies. Managing this volume requires an understanding of where demand is concentrated, when service demand peaks, which types of requests require the most attention, and how efficiently requests are resolved.

The business problem addressed in this project is:

How can NYC 311 request and resolution data be used to identify demand patterns, operational bottlenecks, and differences in service performance across agencies, problem types, boroughs, and time periods?

The analysis provides an operational view of the 311 system and identifies patterns that could help decision-makers better understand request distribution and resolution performance.

## 3. Business Objectives

The main objectives of this analysis are to:

* Measure overall service demand by analyzing NYC 311 request volume in 2025.
* Identify demand patterns across months, hours of the day, boroughs, agencies, and problem types.
* Evaluate resolution performance using median and average resolution time.
* Identify differences in resolution performance across agencies, problem types, boroughs, and hours of the day.
* Examine the relationship between request volume and resolution performance.
* Identify data quality issues that could affect resolution time analysis and establish appropriate rules for handling invalid records.
* Translate findings into actionable operational insights through interactive Tableau dashboards.

## 4. Dataset

The analysis uses the 311 Service Requests from 2020 to Present dataset published on NYC Open Data.

For this project, the source data was filtered to include service requests created from January 1 through December 31, 2025, resulting in 3,655,041 records.

### 4.1 Dataset Source

[NYC Open Data — 311 Service Requests from 2020 to Present](https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2020-to-Present/erm2-nwe9/about_data)

### 4.2 Key Data Fields

| Field            | Description                                  |
| ---------------- | -------------------------------------------- |
| `Unique Key`     | Unique identifier for each service request   |
| `Created Date`   | Date and time when the request was created   |
| `Closed Date`    | Date and time when the request was closed    |
| `Agency`         | Agency responsible for the request           |
| `Agency Name`    | Full name of the responsible agency          |
| `Problem`        | Type of service request or complaint         |
| `Problem Detail` | Additional detail describing the request     |
| `Location Type`  | Type of location associated with the request |
| `Incident Zip`   | ZIP code associated with the request         |
| `Borough`        | NYC borough associated with the request      |
| `Latitude`       | Geographic latitude                          |
| `Longitude`      | Geographic longitude                         |

### 4.3 Data Scope

* **Period:** January 1–December 31, 2025, based on request creation date
* **Records:** 3,655,041
* **Geographic coverage:** New York City
* **Primary focus:** Request volume and resolution performance

## 5. Tools and Skills

### 5.1 Tools

* **CSV:** Data storage and transfer between SQLite and Tableau.
* **SQL / SQLite:** Data exploration, transformation, quality checks, and validation.
* **Tableau:** Exploratory analysis, calculated fields, parameters, visualizations, and interactive dashboards.
* **GitHub:** Project documentation and portfolio version control.

### 5.2 Skills Demonstrated

* ELT data workflow
* Data cleaning and validation
* Data quality and anomaly detection
* Datetime transformation
* Resolution time calculation
* Exploratory data analysis
* KPI development
* Statistical relationship analysis
* Tableau calculated fields and parameters
* Table calculations
* Interactive dashboard design
* Operational performance analysis
* Data storytelling

## 6. Data Preparation and Quality Checks

The raw NYC 311 data was loaded into SQLite and transformed into a clean analytical table before being imported into Tableau.

### 6.1 Data Quality Validation

The following checks were performed on the raw dataset:

* Confirmed 3,655,041 total records.
* Verified that `Unique Key` contained no duplicate values.
* Confirmed that `Created Date`, `Closed Date`, `Agency`, and `Problem` had no missing values.
* Validated the date range of the 2025 dataset.
* Reviewed request distribution across NYC boroughs, including records with an unspecified borough.

### 6.2 Date and Time Transformation

The source `Created Date` and `Closed Date` fields were stored as text in a 12-hour format containing AM/PM indicators.

The timestamps were transformed into standardized datetime values in SQLite, accounting for:

* Conversion of 12 AM to hour `00`.
* Conversion of PM hours to 24 hour time.
* Correct preservation of minutes and seconds.

This transformation enabled resolution duration to be calculated consistently.

### 6.3 Resolution Time Calculation

Resolution time was calculated as the difference between the closed and created timestamps, expressed in hours.

During validation, 915 records were identified where the closed timestamp occurred before the created timestamp. These records represented approximately 0.03% of the dataset.

Rather than deleting these records, they were retained and assigned the status:

`Invalid - Closed Before Created`

All other records were assigned:

`Valid`

Invalid records were excluded from resolution-time metrics while remaining in the analytical dataset.

### 6.4 Analytical Dataset

A clean table named `nyc_311_clean` was created containing 3,655,041 records and the fields required for analysis, including:

* Standardized created and closed datetime fields
* `resolution_hours`
* `resolution_status`

The clean dataset was exported to CSV and loaded into Tableau for analysis and visualization.

## 7. Analytical Approach

After data preparation and validation, the clean analytical dataset was loaded into Tableau for exploratory analysis, calculations, visualization, and dashboard development.

The analysis was organized into four main areas.

### 7.1 Demand Analysis

Request volume was analyzed across:

* Month
* Hour of day
* Borough
* Agency
* Problem type

This analysis identified periods and categories with higher concentrations of service demand.

### 7.2 Resolution Performance

Resolution performance was evaluated using median and average resolution time.

Median resolution time was used as the primary performance metric because resolution times are highly right skewed, with a smaller number of long running requests substantially increasing the average.

Resolution performance was compared across agencies, problem types, boroughs, and hours of the day.

### 7.3 Request Volume vs. Resolution Performance

Scatter plots and linear trend lines were used to examine whether request volume was associated with median resolution time.

This analysis was conducted at both the agency and problem type levels. The resulting R² values were used to assess how much variation in median resolution time could be explained by request volume.

### 7.4 Dashboard Development

The findings were organized into two Tableau dashboards.

**NYC 311 Operations Dashboard — 2025**

Provides an overview of:

* Overall request volume
* Median and average resolution time
* Invalid resolution records
* Monthly demand
* Borough distribution
* Top problem types
* Agency resolution performance

**NYC 311 Operational Performance — 2025**

Provides a detailed operational view of:

* Hourly request volume
* Median resolution time by hour
* Median resolution time by problem type
* Agency request volume versus median resolution time

## 8. Key Findings

### 8.1 Request Demand Is Highly Concentrated

NYC 311 received 3,655,041 service requests in 2025. A relatively small number of agencies and problem types accounted for a large share of total demand.

* **NYPD** handled 1,717,594 requests, approximately 47% of all requests.
* **HPD** handled 774,535 requests.
* **DSNY** handled 326,780 requests.
* Together, these three agencies accounted for approximately 77% of all requests.
* **Illegal Parking** was the most common problem type, with 555,257 requests, approximately 15% of total demand.
* The three most common problem types—Illegal Parking, Noise - Residential, and HEAT/Hot Water—accounted for approximately 36.5% of all requests.

This concentration indicates that a limited number of agencies and service categories account for much of the observed request volume.

### 8.2 Request Volume Varies Significantly by Time

Request demand showed clear temporal patterns.

* **January** had the highest monthly request volume, with 348,180 requests.
* **February** had the lowest, with 255,364 requests.
* **10 AM** was the busiest hour, with 217,736 requests.
* **4 AM** was the lowest volume hour, with 44,610 requests.

These findings reveal a strong daily demand cycle, with substantially higher request volume during daytime hours.

### 8.3 Resolution Time Is Highly Skewed

For valid records:

* **Median resolution time:** 6.6 hours
* **Average resolution time:** 235.9 hours

The large difference between the median and average indicates a strongly right skewed distribution. While the median describes the typical resolution time more robustly, a smaller number of long running requests substantially increase the average.

### 8.4 Resolution Performance Varies Substantially

Median resolution time differed considerably across agencies and problem types.

Among the five agencies identified as fastest by median resolution time:

* New York City Police Department: 1.26 hours
* Department of Homeless Services: 8.06 hours
* Department of Environmental Protection: 21.57 hours
* Department of Health and Mental Hygiene: 24.15 hours
* Department of Sanitation: 32.70 hours

At the slower end of the agency comparison:

* Office of Technology and Innovation: 355 hours
* Office of the Sheriff: 1,008 hours
* Department of Education: 1,317 hours
* Taxi and Limousine Commission: 1,627 hours
* Economic Development Corporation: 7,845 hours

Problem types also showed substantial differences. Among the top 10 problem types by request volume, median resolution time ranged from 0.89 hours for Noise - Street to 254.46 hours for Unsanitary Conditions.

These comparisons describe observed differences and should be interpreted in the context of each agency's responsibilities and the nature of its requests.

### 8.5 Higher Request Volume Does Not Necessarily Mean Slower Resolution

The relationship between agency request volume and median resolution time was weak and negative, with an R² of 0.0483.

Agency request volume explained approximately 4.8% of the variation in median resolution time in the linear model.

The problem type comparison produced an even weaker relationship, with an R² of 0.0082. Request volume explained less than 1% of the variation in median resolution time in that model.

These results indicate that request volume alone is not a strong predictor of resolution performance. The analysis does not establish causation or identify which other factors explain the differences.

### 8.6 Peak Demand and Resolution Performance Overlap

An important pattern appeared at 10 AM:

* Highest hourly request volume: 217,736 requests
* Highest median resolution time by hour: 24.94 hours

This overlap identifies 10 AM as a potentially important period for further operational investigation. However, the analysis does not establish that higher request volume causes slower resolution.

### 8.7 Data Quality and Long-Running Requests

The analysis identified *15 records where the closed timestamp preceded the created timestamp. These represented approximately 0.03% of all records. They were retained in the dataset but excluded from resolution-time metrics.

Long running requests were also retained rather than removed. The dataset contained 98,971 requests closed in 2026, even though they were created in 2025. These records were retained in the resolution analysis because their closure dates fell after the selected request creation period.

## 9. Recommendations

Based on the findings, the following operational areas could be considered for further investigation.

### 9.1 Plan Capacity Around Peak Demand Periods

Request volume was highest during daytime hours, with 10 AM representing the busiest hour. Operational teams could use these patterns to review staffing, queue management, and resource allocation during peak periods.

### 9.2 Investigate Service Categories With Longer Resolution Times

Large differences in median resolution time exist across problem types. Categories such as Unsanitary Conditions, Plumbing, and HEAT/Hot Water showed substantially longer median resolution times than high volume noise and parking complaints.

These categories could be investigated to determine whether case complexity, additional process steps, dependencies, or specialized resources contribute to longer resolution times.

### 9.3 Investigate Agency Level Performance Differences

The variation in median resolution time across agencies suggests that performance should be evaluated in the context of each agency's responsibilities and case types.

Agencies with longer median resolution times could be examined for workflow bottlenecks, case complexity, external dependencies, or differences in closure procedures.

### 9.4 Avoid Using Request Volume Alone as a Performance Indicator

The analysis found only a weak relationship between request volume and median resolution time.

Request volume should therefore not be treated as a standalone explanation for slower resolution. Operational performance assessments should also consider factors such as problem type, agency responsibilities, case complexity, and other relevant operational characteristics.

### 9.5 Monitor Long Running Requests Separately

The substantial difference between median and average resolution time indicates that a relatively small number of long running requests have a large effect on the average.

Operational reporting could track median resolution time alongside aging or long-running cases to provide a representative view of typical resolution performance while also identifying cases that may require attention.

---

## 10. Project Documentation

* [SQL / SQLite workflow](sql/README.md)
* [Dataset documentation](data/README.md)
* [Tableau analysis and dashboards](tableau/README.md)

## 11. Project Structure

```text
nyc_311_operations_analysis/
├── README.md
├── sql/
│   ├── README.md
│   └── nyc_311_analysis.sql
├── data/
│   └── README.md
└── tableau/
    └── README.md
```

* `README.md` — Project overview, methodology, key findings, and recommendations.
* `sql/` — SQL scripts and documentation for data exploration, validation, and transformation.
* `data/` — Dataset source information and data workflow documentation.
* `tableau/` — Documentation for the Tableau analysis and dashboards.

The raw database, exported CSV, and Tableau workbook are not currently included in this repository.


## 12. Project Workflow

The project follows an **ELT (Extract, Load, Transform)** workflow, followed by visualization and reporting.

1. **Extract:** Obtain the NYC 311 service request data from NYC Open Data and filter it to requests created during 2025.
2. **Load:** Import the raw dataset into SQLite as `nyc_311_raw`.
3. **Explore and validate:** Use SQL to examine the data structure, check for missing values and duplicate IDs, validate dates, and investigate data quality issues.
4. **Transform:** Convert date and time strings into standardized datetime values, calculate resolution time in hours, flag invalid resolution records, and create `nyc_311_clean`.
5. **Export and connect:** Export the cleaned analytical dataset to CSV and load it into Tableau.
6. **Analyze and visualize:** Use Tableau to develop KPIs, explore request volume and resolution performance, examine relationships, and build interactive dashboards.
7. **Document and share:** Record the methodology, findings, and recommendations in GitHub.



## 13 Dataset Source

[NYC Open Data — 311 Service Requests from 2020 to Present](https://data.cityofnewyork.us/Social-Services/311-Service-Requests-from-2020-to-Present/erm2-nwe9/about_data)

