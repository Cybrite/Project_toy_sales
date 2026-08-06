# Toy Sales Analysis Project

This project analyzes a toy sales dataset to uncover customer behavior, sales trends, product performance, and regional patterns. The work combines Python-based data cleaning and analysis with SQL queries and a Power BI-style visualization output.

## Project Goal

The main objective is to understand:

- which products and product lines generate the most sales
- how sales vary by customer, region, and territory
- which months or quarters show stronger buying activity
- how customer value and lifetime value can be estimated
- which insights can be presented visually for business decision-making

## What the project includes

This workspace contains the following files:

- Dataset.csv — the main sales dataset used for analysis
- Python.py — Python script for data cleaning, transformation, exploratory analysis, feature engineering, and visualization
- SQLite.sql — SQL queries for summary statistics and customer / geography-based analysis
- dataframe - from Python.csv — exported processed data generated from the Python workflow
- Sales Visualization - PDF Power BI.pdf — a visualization export representing the final insights

## Dataset overview

The dataset contains transactional sales records for a toy company. Each row represents a sales order line and includes fields such as:

- ORDERNUMBER
- QUANTITYORDERED
- SALES
- ORDERDATE
- STATUS
- PRODUCTLINE
- PRODUCTCODE
- CUSTOMERNAME
- CITY
- STATE
- COUNTRY
- TERRITORY
- DEALSIZE
- YEAR_ID / MONTH_ID / QTR_ID

These columns allow the analysis of sales performance across products, customers, regions, and time periods.

## Analysis workflow

### 1. Data cleaning and preparation

The Python script performs several preparation steps:

- removes unnecessary columns
- converts date fields to proper datetime format
- fills missing territory values where needed
- standardizes product line labels such as Classic Cars and Vintage Cars into a unified category
- removes the STATE column because it is not consistently useful for the analysis

### 2. Exploratory data analysis

The script explores:

- basic descriptive statistics for sales and quantity
- the highest-value sales transaction
- territory distribution and customer concentration
- purchase frequency per customer
- the most common deal sizes

### 3. Customer segmentation and value metrics

The analysis creates useful business metrics such as:

- customer spending totals
- customer purchase frequency
- customer value segmentation (High-value vs Low-value)
- customer frequency segmentation (High-freq. vs Low-freq.)
- customer lifetime value (CLTV)

### 4. Trend analysis

The workflow also studies:

- monthly sales trends
- quarterly sales performance
- product-line sales percentages
- territory-based CLTV distribution
- quantity sold by product line over time

### 5. Export and visualization

The script generates:

- a cleaned/processed CSV export
- charts for sales trends, product mix, and territory-based insights

## SQL analysis

The SQL file contains queries to answer business questions such as:

- how many invoices, customers, and product categories exist
- total sales and average order value
- most frequently purchased items or product lines
- deal size breakdown
- yearly sales performance
- sales by country
- best-selling products in a specific state
- territory-level purchase patterns for specific product lines

## Key insights captured in the project

Based on the analysis logic included in the scripts, the project highlights:

- EMEA is one of the most active territories in terms of transaction volume
- the fourth quarter shows strong purchasing behavior
- November is one of the strongest months for sales
- customer segmentation helps identify high-value and high-frequency customers
- CLTV can be used to evaluate customer importance over time

## Requirements

To run the Python analysis locally, you need:

- Python 3.x
- pandas
- numpy
- matplotlib
- seaborn

Install them with:

```bash
pip install pandas numpy matplotlib seaborn
```

## How to run the Python analysis

1. Open the project folder.
2. Make sure the dataset file is available locally.
3. Update the file path in Python.py if necessary.
4. Run the script:

```bash
python "(3) Python.py"
```

> Note: The current Python script uses a Google Drive path from a Colab environment. If you are running it locally, replace that path with the local location of Dataset.csv.

## How to run the SQL analysis

You can open SQLite.sql in:

- DB Browser for SQLite
- SQLite CLI
- any SQL client that supports SQLite

Then execute the queries to inspect the data and summary statistics.

## Output files

The project produces or references these outputs:

- a cleaned CSV export from the Python workflow
- charts and visual summaries
- a PDF visualization package for reporting purposes

## Notes

This project is a business analytics example that demonstrates:

- data preparation
- exploratory analysis
- customer segmentation
- time-series analysis
- SQL-based reporting
- dashboard-style visualization concepts

It is well suited for learning, portfolio presentation, or as a baseline for more advanced BI/reporting work.
