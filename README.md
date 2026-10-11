# Toy Sales Analytics Project

This project analyzes historical toy-company sales data to understand **what is being sold, when customers buy, who the most valuable customers are, and where sales are generated**.

The project combines:

- **Python/pandas** for cleaning, transformation, customer analysis, time-series analysis, and charts
- **SQLite** for reusable business queries and summary reporting
- **Power BI-style visual reporting** in PDF format
- A final written report describing the findings and recommendations

The repository is designed as a portfolio-style business analytics project. The raw transaction data is transformed into a more analysis-ready dataset, then explored from both Python and SQL.

---

## 1. Business questions

The analysis is intended to answer the following questions:

1. How much has the company sold, and what is the average order value?
2. Which product lines and product codes sell the most?
3. Which months and quarters have the strongest buying activity?
4. Which customers generate the most revenue or place the most orders?
5. How can customers be grouped by spending and purchase frequency?
6. What is the estimated customer lifetime value (CLTV)?
7. Which countries, cities, and territories contribute the most sales?
8. Which deal sizes and product categories are most common?

The results can be used to identify high-value customers, understand seasonal demand, compare territories, and support product and marketing decisions.

---

## 2. Repository contents

The files are numbered to show the intended project flow:

| File | Purpose |
| --- | --- |
| [`(1) Dataset.csv`](./%281%29%20Dataset.csv) | Original raw transaction-level dataset |
| [`(2) SQLite.sql`](./%282%29%20SQLite.sql) | SQL queries for operational and sales reporting |
| [`(3) Python.py`](./%283%29%20Python.py) | Python cleaning, analysis, feature engineering, and visualization script |
| [`(4) dataframe - from Python.csv`](./%284%29%20dataframe%20-%20from%20Python.csv) | Example/export of the cleaned dataset with derived customer fields |
| [`(5) Sales Visualization - PDF Power BI.pdf`](./%285%29%20Sales%20Visualization%20-%20PDF%20Power%20BI.pdf) | Dashboard-style visualization export |
| [`(6) Final_Report.pdf`](./%286%29%20Final_Report.pdf) | Written report containing the project analysis and conclusions |

The numbered files are documentation and workflow labels; they are not Python module names or database table names.

---

## 3. Data model

The raw file contains one row per **order line**, not one row per complete order. A single `ORDERNUMBER` can therefore appear on multiple rows.

### Main fields

| Field | Meaning |
| --- | --- |
| `ORDERNUMBER` | Identifier for a customer order/invoice |
| `QUANTITYORDERED` | Number of units on the order line |
| `ORDERLINENUMBER` | Position of the line within the order |
| `SALES` | Revenue for the order line |
| `ORDERDATE` | Date on which the order was placed |
| `STATUS` | Order status, such as `Shipped` |
| `QTR_ID`, `MONTH_ID`, `YEAR_ID` | Calendar period fields |
| `PRODUCTLINE` | Product category |
| `PRODUCTCODE` | Product-level identifier |
| `CUSTOMERNAME` | Customer or account name |
| `CITY`, `STATE`, `COUNTRY` | Customer location |
| `TERRITORY` | Sales territory |
| `DEALSIZE` | `Small`, `Medium`, or `Large` order-line classification |

The original dataset also contains contact, address, pricing, and MSRP fields. Several of these are removed by the Python preparation workflow because they are not required for the main analysis.

---

## 4. End-to-end workflow

The project follows this sequence:

```text
(1) Dataset.csv
        |
        +--> Python cleaning and feature engineering
        |        |
        |        +--> cleaned analysis DataFrame
        |        +--> charts and summary calculations
        |        +--> (4) dataframe - from Python.csv
        |
        +--> SQLite import
                 |
                 +--> (2) SQLite.sql business queries

Analysis results
        |
        +--> (5) Sales Visualization - PDF Power BI.pdf
        +--> (6) Final_Report.pdf
```

Python and SQL are complementary:

- Python is used for data preparation, customer-level calculations, and exploratory analysis.
- SQL is used for repeatable aggregations such as total sales, average order value, product performance, and country comparisons.
- The PDF files present the results for a non-technical audience.

---

## 5. Python workflow

The Python script in [`(3) Python.py`](./%283%29%20Python.py) performs the following steps.

### 5.1 Load the raw data

The script reads the sales CSV with `latin-1` encoding. The original script was created in Google Colab and currently points to a Google Drive path:

```python
df = pd.read_csv(
    '/content/drive/MyDrive/Final Project - DA Carerha /sales_data_sample.csv',
    encoding='latin-1'
)
```

For local execution, change this path to the local raw file:

```python
df = pd.read_csv(
    r'D:\Data analytics\Project_toy_sales\(1) Dataset.csv',
    encoding='latin-1'
)
```

Using a raw string (`r'...'`) avoids problems with backslashes in Windows paths.

### 5.2 Remove fields that are not used

The following columns are dropped:

```text
PRICEEACH, MSRP, PHONE, POSTALCODE, ADDRESSLINE1,
ADDRESSLINE2, CONTACTLASTNAME, CONTACTFIRSTNAME
```

These fields are either contact/address details or pricing fields that are not needed for the questions addressed by this project.

The `STATE` column is also removed later because it is incomplete for countries where state-level information is not consistently recorded.

### 5.3 Standardize data types

The script:

- converts `PRODUCTLINE` to a pandas string type
- removes the trailing `0:00` text from `ORDERDATE`
- converts `ORDERDATE` to a true datetime value using the format `%m/%d/%Y`

Correct date typing is required for customer lifespan calculations and time-based grouping.

### 5.4 Handle territory and product labels

The raw data uses `NA` for some North American records. The Python workflow replaces missing territory values with `North America`.

It also changes `Japan` to `APAC` so that Japan is analyzed consistently with the Asia-Pacific territory grouping.

Finally, it combines:

```text
Classic Cars + Vintage Cars -> Cars
```

This reduces the number of product-line categories and treats both car categories as one broader category in the Python analysis.

> The SQL file queries the original imported data. It does not automatically apply this Python-only product-line normalization. If SQL results must match the processed Python data exactly, import the processed export or reproduce the same transformations in SQL.

### 5.5 Explore the data

The script calculates descriptive statistics for:

- `QUANTITYORDERED`
- `SALES`

It also identifies:

- the highest-value order line
- the most common territory by order-line count
- the number of unique customers
- customer order frequency
- the most common deal sizes

### 5.6 Create customer segments

The script aggregates sales by `CUSTOMERNAME` and creates a spending segment:

- `High-value`: total customer spending greater than `100000`
- `Low-value`: total customer spending less than or equal to `100000`

It also calculates the number of distinct orders per customer and creates a frequency segment:

- `High-freq.`: more than `14` orders
- `Low-freq.`: `14` or fewer orders

These thresholds are project assumptions chosen from the observed distribution. They are not universal business rules and should be reviewed if the dataset or business context changes.

The following derived columns are added to the processed DataFrame:

| Derived column | Calculation |
| --- | --- |
| `Customer Value` | Spending-based segment |
| `Customer PO Freq.` | Number of distinct `ORDERNUMBER` values per customer |
| `Customer Frequency` | Frequency-based segment |
| `CLTV` | Estimated customer lifetime value |

### 5.7 Calculate CLTV

The script estimates CLTV from historical order behavior using:

```text
CLTV = Customer Value x Average Customer Lifespan
```

The calculation is implemented in stages:

1. Find the first and last `ORDERDATE` for each customer.
2. Convert each customer's active period from days to approximate months using `days // 30`.
3. Calculate the average observed customer lifespan across customers.
4. Calculate customer spending and an average number of purchases.
5. Multiply the resulting customer value by the average lifespan.
6. Add each customer's CLTV to every corresponding order-line row.

This is a historical estimate rather than a predictive retention model. It does not include discounting, gross margin, churn probability, acquisition cost, or future purchase forecasting.

### 5.8 Analyze time trends and product mix

The script groups sales and distinct orders by:

- month
- quarter
- year and month
- product line
- territory
- city and country

It creates visualizations for:

- monthly sales trends by year
- product-line sales share
- CLTV share by territory
- product-line quantity ordered over time

The script notes that 2005 is incomplete in the source data, so comparisons involving yearly totals should be interpreted carefully.

### 5.9 Export the processed data

At the end, the script writes the processed DataFrame to:

```python
df.to_csv('/content/drive/My Drive/df.csv', index=False)
```

For local execution, replace this with a repository path, for example:

```python
df.to_csv(
    r'D:\Data analytics\Project_toy_sales\(4) dataframe - from Python.csv',
    index=False
)
```

The checked-in processed CSV is an example/export of this workflow. Re-running the script may update it depending on the input path and any changes made to the analysis.

---

## 6. SQL workflow

The SQL queries in [`(2) SQLite.sql`](./%282%29%20SQLite.sql) expect a SQLite table named:

```text
sales_data_sample
```

The repository contains the CSV, not a pre-built SQLite database. Before running the queries, import [`(1) Dataset.csv`](./%281%29%20Dataset.csv) into SQLite and name the table `sales_data_sample`.

### Import with DB Browser for SQLite

1. Open DB Browser for SQLite.
2. Create a new SQLite database.
3. Choose **File > Import > Table from CSV file**.
4. Select `(1) Dataset.csv`.
5. Set the table name to `sales_data_sample`.
6. Confirm that the first row contains column names.
7. Import the table.
8. Open `(2) SQLite.sql` and run the statements.

### Import with the SQLite CLI

The exact commands depend on the SQLite installation, but the process is:

```sql
.mode csv
.headers on
.import "(1) Dataset.csv" sales_data_sample
```

If the table already exists, remove it first or import into a new database:

```sql
DROP TABLE IF EXISTS sales_data_sample;
```

### What the SQL queries return

The SQL file covers:

#### Dataset overview

- number of distinct invoices/orders
- number of unique customers
- number of product categories

#### Sales and product metrics

- total sales amount
- average order value, calculated after summing sales by order
- most frequently purchased product codes
- total quantity sold by product code
- most frequently purchased product lines
- total quantity sold by product line
- deal-size distribution
- yearly sales totals

#### Geographic analysis

- total sales by country
- highest-quantity product codes in California
- highest-quantity product lines in California
- territory-level quantity purchased for `Classic Cars`

Because the SQL queries use the original table, the SQL result for `Classic Cars` is intentionally based on the original category rather than the Python-normalized `Cars` category.

---

## 7. Running the project locally

### Python requirements

- Python 3.x
- pandas
- numpy
- matplotlib
- seaborn

Install the dependencies with:

```bash
pip install pandas numpy matplotlib seaborn
```

### Run the Python analysis

1. Open [`(3) Python.py`](./%283%29%20Python.py).
2. Change the input CSV path from the Google Drive path to the local `(1) Dataset.csv` path.
3. Change the output path from the Google Drive location to the local `(4) dataframe - from Python.csv` path, if you want to overwrite the checked-in export.
4. Run the script from the project directory:

```bash
python "(3) Python.py"
```

The script displays intermediate DataFrame information and charts interactively. The charts use `matplotlib` and `seaborn`, so run it in a desktop Python environment, Jupyter, or an IDE that supports graphical output.

### Run the SQL analysis

1. Import the raw CSV into SQLite as `sales_data_sample`.
2. Open [`(2) SQLite.sql`](./%282%29%20SQLite.sql) in DB Browser for SQLite or another SQLite-compatible client.
3. Execute the statements individually or as a script.
4. Review the returned summary tables and rankings.

### Review the reports

After running or reviewing the analysis, use:

- [`(5) Sales Visualization - PDF Power BI.pdf`](./%285%29%20Sales%20Visualization%20-%20PDF%20Power%20BI.pdf) for dashboard-style visuals
- [`(6) Final_Report.pdf`](./%286%29%20Final_Report.pdf) for the written interpretation of the results

---

## 8. Main findings represented in the project

The current analysis highlights the following patterns:

- **EMEA** is one of the strongest territories by transaction activity and estimated CLTV.
- **November** is the strongest month in the Python time-series analysis, followed by October.
- **Quarter 4** has the highest buying activity by both sales value and number of orders.
- Customer segmentation separates accounts that contribute materially different levels of revenue and order frequency.
- A small group of customers accounts for a large share of spending and large deals.
- Product-line mix and geographic concentration can be compared through both tabular results and charts.

These are descriptive findings from the available historical data. They should not be interpreted as causal conclusions without additional information such as marketing activity, inventory, margin, promotions, or customer acquisition cost.

---

## 9. Important assumptions and limitations

1. **The source data is historical.** Results describe the period represented in the CSV and may not reflect current business behavior.
2. **The 2005 data is incomplete.** Year-over-year comparisons involving 2005 can be misleading.
3. **Rows are order lines.** Row counts are not invoice counts. Use distinct `ORDERNUMBER` values when measuring orders.
4. **CLTV is an estimate.** The implementation uses observed lifespan and historical purchase behavior; it is not a predictive model.
5. **Segmentation thresholds are manually selected.** The `100000` spending threshold and `14`-order frequency threshold should be validated with business stakeholders.
6. **Territory labels are standardized only in Python.** SQL results use the labels as they appear in the imported raw table.
7. **Product-line normalization is not shared automatically.** Python combines `Classic Cars` and `Vintage Cars`; SQL does not.
8. **Missing state values are expected.** State-level analysis is not reliable for every country, which is why `STATE` is removed from the Python dataset.
9. **Revenue is not profit.** `SALES` is used as the main value measure; the project does not calculate margin or profitability.

---

## 10. Suggested improvements

For a production-ready version of this analysis, the next improvements would be:

- replace hard-coded paths with command-line arguments or a configuration file
- separate data cleaning, analysis, and visualization into reusable functions
- add automated validation for required columns and date parsing
- create a shared cleaned table so Python and SQL use identical category and territory rules
- compare revenue with profit margin, discounts, and cost data
- build a predictive CLTV or churn model
- add automated tests for customer metrics and aggregation logic
- save charts to a dedicated output directory instead of displaying them only interactively
- provide a `.db` file or import script for repeatable SQL setup

---

## Summary

This project demonstrates a complete analytics workflow:

1. Start with raw order-line data.
2. Clean and standardize the data in Python.
3. Create customer, frequency, and CLTV features.
4. Analyze sales by product, time, customer, and geography.
5. Query the source data with SQL for repeatable summaries.
6. Present the results in visual and written reports.

It can be used as a learning project, a portfolio example, or a starting point for a more robust business intelligence pipeline.
