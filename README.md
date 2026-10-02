# SACCO Loan Management Database

A SQL Server relational database project for managing SACCO members, branches, loan products, loans, and loan repayments.

This project demonstrates practical database engineering and SQL development skills, including relational database design, data integrity, reporting, stored procedures, analytical SQL, and query optimization.

---

## Project Overview

The system models a simplified SACCO lending environment where:

* Members belong to SACCO branches.
* SACCOs offer multiple loan products.
* Members can apply for and receive loans.
* Loans are linked to specific loan products.
* Loan repayments are recorded against individual loans.
* Reporting views and stored procedures provide portfolio analysis.

The project uses fictional data for demonstration purposes.

---

## Technology Stack

| Technology        | Purpose                           |
| ----------------- | --------------------------------- |
| SQL Server        | Relational database               |
| T-SQL             | Database programming              |
| Git               | Version control                   |
| GitHub            | Source-code management            |
| SQL Views         | Reporting layer                   |
| Stored Procedures | Reusable business/reporting logic |
| Window Functions  | Analytical SQL                    |
| Indexes           | Query optimization                |

---

## Project Structure

```text
sacco-loan-management-database
│
├── README.md
│
├── database
│   ├── 01_CreateDatabase.sql
│   ├── 02_CreateTables.sql
│   ├── 03_InsertSampleData.sql
│   ├── 04_CreateViews.sql
│   ├── 05_CreateStoredProcedures.sql
│   └── 06_CreateIndexes.sql
│
├── reports
│   └── LoanPortfolioQueries.sql
│
└── documentation
    └── DatabaseDesign.md
```

---

## Database Architecture

```text
                    ┌──────────────┐
                    │   Branches   │
                    └──────┬───────┘
                           │
                           │ 1:M
                           ▼
                    ┌──────────────┐
                    │   Members    │
                    └──────┬───────┘
                           │
                           │ 1:M
                           ▼
                    ┌──────────────┐
                    │    Loans     │
                    └──────┬───────┘
                           │
                 ┌─────────┴─────────┐
                 │                   │
                 ▼                   ▼
        ┌─────────────────┐   ┌──────────────────┐
        │  LoanProducts   │   │ LoanRepayments   │
        └─────────────────┘   └──────────────────┘
```

---

## Core Database Tables

### Branches

Stores SACCO branch information.

### Members

Stores member details including:

* Member number
* Full name
* Phone number
* Branch
* Date joined
* Member status

### LoanProducts

Defines available loan products including:

* Product code
* Product description
* Interest rate
* Maximum loan amount
* Repayment period

### Loans

Stores:

* Loan application
* Approval
* Disbursement
* Approved amount
* Disbursed amount
* Interest rate
* Loan status

### LoanRepayments

Stores individual repayment transactions and separates:

* Principal amount
* Interest amount
* Total repayment

---

## Reporting Features

The project includes reusable reporting views.

### Loan Portfolio

`vw_LoanPortfolio`

Combines member, branch, loan, and loan-product information into a single reporting dataset.

### Repayment Summary

`vw_LoanRepaymentSummary`

Calculates:

* Total amount repaid
* Principal repaid
* Interest repaid

This can be used to determine outstanding loan balances.

---

## Stored Procedures

### Loan Portfolio Report

```sql
EXEC dbo.sp_LoanPortfolioReport
    @StartDate = '2025-01-01',
    @EndDate = '2025-12-31';
```

The procedure supports optional filtering by branch and loan product.

### Loan Product Summary

```sql
EXEC dbo.sp_LoanProductSummary
    @StartDate = '2025-01-01',
    @EndDate = '2025-12-31';
```

Provides loan counts and financial totals by loan product.

### Member Loan Frequency

```sql
EXEC dbo.sp_MemberLoanFrequencyCumulative
    @StartDate = '2025-01-01',
    @EndDate = '2025-12-31';
```

Uses SQL window functions to calculate loan frequency and cumulative approved amounts.

---

## SQL Concepts Demonstrated

This project demonstrates practical use of:

* Primary keys
* Foreign keys
* Unique constraints
* Check constraints
* Default constraints
* INNER JOIN
* LEFT JOIN
* GROUP BY
* Aggregate functions
* Common Table Expressions
* Window functions
* `ROW_NUMBER()`
* `RANK()`
* `SUM() OVER()`
* Parameterized stored procedures
* SQL views
* Indexing
* Financial calculations using `DECIMAL`

---

## Performance Optimization

Indexes have been created on frequently used relationship and reporting columns, including:

```text
Members.BranchId
Loans.MemberId
Loans.LoanProductId
Loans.DisbursedDate
Loans.Status
LoanRepayments.LoanId
LoanRepayments.PaymentDate
```

The indexes are intended to improve performance for common joins, filters, and reporting queries.

---

## Sample Analysis

The project supports analysis such as:

* Total loans by branch
* Total disbursements by loan product
* Outstanding principal
* Member loan frequency
* Cumulative loan amounts
* Monthly loan disbursement trends
* Branch portfolio ranking
* Member portfolio ranking

---

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/DanITGURU/sacco-loan-management-database.git
```

### 2. Open the SQL scripts

Use SQL Server Management Studio (SSMS) or another SQL Server-compatible environment.

### 3. Execute the scripts in order

```text
01_CreateDatabase.sql
02_CreateTables.sql
03_InsertSampleData.sql
04_CreateViews.sql
05_CreateStoredProcedures.sql
06_CreateIndexes.sql
```

### 4. Run the reporting queries

Open:

```text
reports/LoanPortfolioQueries.sql
```

and execute the queries against `SaccoLoanManagementDB`.

---

## Project Purpose

This project was created as a practical demonstration of SQL Server database development, reporting, data analysis, and database engineering practices.

It is designed to demonstrate the ability to move from:

```text
Business Requirements
        ↓
Database Design
        ↓
Data Modeling
        ↓
SQL Development
        ↓
Reporting
        ↓
Performance Optimization
```

---

## Future Enhancements

Planned improvements include:

* Power BI loan portfolio dashboard
* Loan amortization schedule
* Automated interest calculations
* Delinquency analysis
* Database backup automation
* Database CI/CD pipeline
* GitHub Actions
* Liquibase/Flyway migrations
* REST API integration
* Cloud database deployment

---

## Disclaimer

This project uses fictional SACCO, member, loan, and repayment data for educational and portfolio purposes.

No real customer or financial information is included.
