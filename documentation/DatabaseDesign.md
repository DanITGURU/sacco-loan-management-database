# SACCO Loan Management Database — Database Design

## 1. Overview

The SACCO Loan Management Database is a SQL Server relational database project designed to manage members, branches, loan products, loans, and loan repayments.

The project demonstrates practical database engineering concepts including relational database design, referential integrity, SQL querying, reporting views, stored procedures, window functions, and query-performance optimization.

## 2. Database Architecture

The database follows a relational model consisting of five core entities:

```text
Branches
    |
    +---- Members
              |
              +---- Loans
                       |
                       +---- Loan Products
                       |
                       +---- Loan Repayments
```

### Main Entities

| Table          | Purpose                                               |
| -------------- | ----------------------------------------------------- |
| Branches       | Stores SACCO branch information                       |
| Members        | Stores SACCO member information                       |
| LoanProducts   | Defines available loan products                       |
| Loans          | Stores loan applications, approvals and disbursements |
| LoanRepayments | Records loan repayment transactions                   |

## 3. Relationships

### Branches → Members

One branch can have many members.

```text
Branches (1) ---- (Many) Members
```

The relationship is implemented using:

```sql
Members.BranchId
    → Branches.BranchId
```

### Members → Loans

One member can have multiple loans.

```text
Members (1) ---- (Many) Loans
```

### Loan Products → Loans

One loan product can be used by multiple loans.

```text
LoanProducts (1) ---- (Many) Loans
```

### Loans → Loan Repayments

One loan can have multiple repayment transactions.

```text
Loans (1) ---- (Many) LoanRepayments
```

## 4. Data Integrity

The database uses several mechanisms to maintain data quality.

### Primary Keys

Every major entity has a unique identifier implemented using `UNIQUEIDENTIFIER`.

### Foreign Keys

Foreign keys enforce relationships between related entities.

### Unique Constraints

Unique constraints prevent duplicate:

* Branch codes
* Member numbers
* Loan product codes

### Check Constraints

Check constraints validate business rules such as:

* Loan amounts must be greater than zero.
* Interest rates cannot be negative.
* Repayment amounts must be positive.
* Loan statuses must use approved values.

### Default Constraints

Default values are used for fields such as member and loan status.

## 5. Reporting Layer

The project includes reusable SQL Server views.

### `vw_LoanPortfolio`

Provides a consolidated view of:

* Member information
* Branch information
* Loan information
* Loan product information
* Disbursement information
* Loan status

### `vw_LoanRepaymentSummary`

Provides:

* Total repayments
* Principal repaid
* Interest repaid
* Loan status
* Repayment summary by loan

## 6. Stored Procedures

The project includes parameterized stored procedures for reporting.

### `sp_LoanPortfolioReport`

Supports filtering by:

* Start date
* End date
* Branch
* Loan product

### `sp_LoanProductSummary`

Provides aggregated portfolio information by loan product.

### `sp_MemberLoanFrequencyCumulative`

Demonstrates advanced SQL analytical functionality using:

```sql
ROW_NUMBER() OVER(...)
```

and:

```sql
SUM(...) OVER(...)
```

These functions can be used to analyze loan frequency and cumulative approved amounts.

## 7. Performance Optimization

Indexes have been created based on common join and filtering columns.

Examples include:

```text
Members.BranchId
Loans.MemberId
Loans.LoanProductId
Loans.DisbursedDate
Loans.Status
LoanRepayments.LoanId
LoanRepayments.PaymentDate
```

The purpose is to improve query performance for common reporting and transactional operations.

## 8. SQL Techniques Demonstrated

This project demonstrates:

* Relational database design
* Primary and foreign keys
* Referential integrity
* Constraints
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
* Financial data handling using `DECIMAL`

## 9. Future Improvements

Potential future enhancements include:

1. User authentication and role management.
2. Loan approval workflow.
3. Automated interest calculation.
4. Loan amortization schedules.
5. Delinquency and overdue-loan analysis.
6. SQL Server Agent automation.
7. Database backup automation.
8. Power BI reporting dashboard.
9. Database CI/CD using GitHub Actions.
10. Liquibase or Flyway database migrations.
11. REST API integration.
12. Cloud database deployment.
