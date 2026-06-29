# Sales Performance Analysis

A SQL-driven analysis of a retail  parts & accessories sales dataset, 
exploring revenue concentration across customer segments and geographic 
markets. Built using PostgreSQL for data validation and analysis, with 
findings visualized in Tableau.

## 🎯Objective

This project investigates two core business questions:

1. Which countries generate the most revenue, and what drives that 
   concentration?
2. How does customer spend break down across the customer base, and 
   what separates high-value customers from low-value ones?


## 📊Dashboard

![Dashboard Screenshot](screenshots/your_filename_here.png)

## 📑Dataset

A star-schema sales database consisting of:

| Table | Rows | Description |
|:------|-----:|:-------------|
| `dim_customers` | 18,484 | Customer demographic and identity data |
| `dim_products` | 295 | Product catalog (categories, subcategories, cost) |
| `fact_sales` | 60,398 | Transaction-level sales records (line-item grain) |

## ⚙️Tools

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-025E8C?style=for-the-badge)
![Tableau](https://img.shields.io/badge/Tableau-E97627?style=for-the-badge&logo=tableau&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)
![VS Code](https://img.shields.io/badge/VS_Code-007ACC?style=for-the-badge&logo=visualstudiocode&logoColor=white)

## ⌛Process

1. **Data Exploration** - Validated table structure, primary/foreign key 
   integrity, identified data quality issues (nulls, disguised missing 
   values, outliers), and confirmed the fact table's true grain. 
   See [`findings.md`](findings.md) for full details.
2. **Business Analysis** - Answered the two questions above using SQL 
   (aggregation, window functions for ranking and segmentation). 
   See [`insights.md`](insights.md) for full write-up.
3. **Visualization** - Built an interactive Tableau dashboard to present 
   the findings.

## Key Insights

- **Revenue is concentrated in 2 of 7 countries** (US: 31.2%, Australia: 
  30.9%) , but for different reasons. The US leads on customer volume; 
  Australia leads on higher average order value, driven by a higher mix 
  of premium product purchases.
- **The top third of customers (by spend) generate 87.5% of total 
  revenue** - driven almost entirely by order value (~65x higher than 
  the bottom third), not purchase frequency.

Full analysis: [`insights.md`](insights.md)


## Repository Structure

```
Sales-Analysis1/
├── 📁Data/
│   ├── gold.dim_customers.csv
│   ├── gold.dim_products.csv
│   └── gold.fact_sales.csv
├── 📁sql/
│   ├── DatabaseSetup.sql
│   ├── exploration.sql
│   └── analysis.sql
├── 🖼️screenshots/
│   └── dashboard screenshots
├── 📋readme.md
├── 🗒️findings.md
└── 🗒️insights.md
```