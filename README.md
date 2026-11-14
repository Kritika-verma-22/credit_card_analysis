# 💳 Credit Card Customer Behaviour & Portfolio Analysis

## 📌 Project Overview

This project focuses on analysing credit card customer behaviour and portfolio performance using **MySQL**. The objective is to identify customer spending patterns, cash advance usage, credit limit distribution, payment behaviour, and other key business metrics.

The analysis is designed to transform raw customer data into meaningful business insights that can support better reporting, customer segmentation, and future predictive analytics.

## 🎯 Project Objectives

- Analyse overall credit card portfolio performance.
- Understand customer purchase behaviour and spending patterns.
- Identify cash advance usage trends.
- Segment customers based on purchase frequency and credit limits.
- Evaluate payment behaviour and balance distribution.
- Perform data quality checks, including missing values and duplicate records.
- Generate actionable insights through SQL-based analysis.

## 🛠️ Tools & Technologies

- **MySQL 8.0+** – Data querying and analysis
- **MySQL Workbench** – SQL development and query execution
- **Microsoft Excel / CSV** – Dataset handling
- **GitHub** – Project documentation and version control
- **Power BI** – Planned dashboard development and visualization

## 📂 Dataset Information

- Total Records: **8,950**
- Total Columns: **20**
- Primary Identifier: `customer_id`

The dataset contains customer demographics, credit limits, balances, purchase amounts, cash advances, payment details, transaction frequency, and account tenure.

*Note: The raw dataset is not included in this repository. The SQL script expects an existing cleaned table.*

## 🔍 SQL Analysis – 16 Business Queries

The project includes 16 analytical queries covering:

| No. | Analysis |
|---|---|
| 01 | Dataset Validation |
| 02 | Overall Portfolio KPIs |
| 03 | Purchase Activity Analysis |
| 04 | Cash Advance Behaviour |
| 05 | Purchase Type Analysis |
| 06 | Purchase Frequency Segmentation |
| 07 | Credit Limit Band Analysis |
| 08 | Balance-to-Credit-Limit Ratio |
| 09 | Full-Payment Frequency Analysis |
| 10 | Minimum-Payment Imputation Status |
| 11 | Customer Tenure Groups |
| 12 | Top 10 Customers by Purchase Amount |
| 13 | Top 10 Customers by Cash Advance |
| 14 | Missing Value Analysis |
| 15 | Duplicate Customer ID Check |
| 16 | Business Summary |

## 📊 Key Business Insights

Based on the analysed dataset:

- **8,950** total customer records were analysed.
- **6,906 customers (77.16%)** recorded purchase activity.
- **2,044 customers (22.84%)** had no recorded purchases.
- **4,322 customers (48.29%)** used cash advances.
- Average customer balance: **1,564.47**
- Average purchase amount: **1,003.20**
- Average payment amount: **1,733.14**

### Additional Observations

- Customers using cash advances had a higher average balance than customers who did not use cash advances.
- Customers with higher credit limits also showed higher average purchase amounts and balances.
- Customers with higher full-payment frequency showed lower average balances in the analysed dataset.

These observations describe patterns in the dataset and do not establish causal relationships.

## 📁 Repository Structure

```text
Credit-Card-Customer-Behaviour-Analysis/
│
├── README.md
│
├── Credit_Card_Customer_Behaviour_SQL_Project.sql
│
├── query_screenshots/
│   ├── Query_01.png
│   ├── Query_02.png
│   ├── ...
│   └── Query_16.png
│
└── query_results/
    ├── Query_01_output.csv
    ├── Query_02_output.csv
    ├── ...
    └── Query_16_output.csv
```

## ⚙️ How to Run the Project

1. Install MySQL 8.0 or later.
2. Create a database named `credit_card_project`.
3. Import the cleaned dataset into a table named `credit_card_customers_cleaned`.
4. Open the SQL project file in MySQL Workbench.
5. Execute the analytical queries.
6. Review the corresponding result sets and CSV outputs.

**Important:** The SQL script is designed for an existing cleaned table. It does not drop, truncate, or overwrite the table.

## 🚀 Future Scope

This project is planned as the foundation for a broader analytics system.

Future enhancements include:

- **Power BI:** Interactive dashboards and KPI visualization.
- **Python:** Exploratory Data Analysis and statistical analysis.
- **Machine Learning:** Customer segmentation, spending behaviour prediction, and predictive modelling.
- **AI Integration:** Natural-language business insights and an intelligent analytics assistant.

The objective is to build a unified analytical solution where each technology builds upon the same business problems and dataset.

## 👩‍💻 Author

**Kritika Verma**

Aspiring Data Analyst | SQL | Python | Power BI | Data Analytics

---

*This project is developed for learning, analytical exploration, and portfolio demonstration purposes.*
