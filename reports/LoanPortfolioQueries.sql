/*
========================================================
SACCO LOAN MANAGEMENT DATABASE
File: LoanPortfolioQueries.sql
Purpose: Portfolio analysis and reporting queries
========================================================
*/

USE SaccoLoanManagementDB;
GO


-- =====================================================
-- 1. Complete Loan Portfolio
-- =====================================================

SELECT
    LoanId,
    MemberNumber,
    FullName,
    BranchName,
    LoanProduct,
    ApprovedAmount,
    DisbursedAmount,
    Status,
    DisbursedDate
FROM dbo.vw_LoanPortfolio
ORDER BY DisbursedDate DESC;
GO


-- =====================================================
-- 2. Total Loans and Amount by Branch
-- =====================================================

SELECT
    BranchCode,
    BranchName,

    COUNT(*) AS NumberOfLoans,

    SUM(ApprovedAmount) AS TotalApprovedAmount,

    SUM(DisbursedAmount) AS TotalDisbursedAmount

FROM dbo.vw_LoanPortfolio

GROUP BY
    BranchCode,
    BranchName

ORDER BY
    TotalDisbursedAmount DESC;
GO


-- =====================================================
-- 3. Portfolio by Loan Product
-- =====================================================

SELECT
    ProductCode,
    LoanProduct,

    COUNT(*) AS NumberOfLoans,

    SUM(ApprovedAmount) AS TotalApprovedAmount,

    SUM(DisbursedAmount) AS TotalDisbursedAmount

FROM dbo.vw_LoanPortfolio

GROUP BY
    ProductCode,
    LoanProduct

ORDER BY
    TotalDisbursedAmount DESC;
GO


-- =====================================================
-- 4. Outstanding Loan Balances
-- =====================================================

SELECT
    LoanId,
    MemberNumber,
    FullName,
    LoanProduct,
    ApprovedAmount,
    PrincipalRepaid,

    ApprovedAmount - PrincipalRepaid
        AS OutstandingPrincipal,

    Status

FROM dbo.vw_LoanRepaymentSummary

ORDER BY
    OutstandingPrincipal DESC;
GO


-- =====================================================
-- 5. Branch Portfolio Ranking
-- =====================================================

WITH BranchPortfolio AS
(
    SELECT
        BranchCode,
        BranchName,
        SUM(DisbursedAmount) AS TotalDisbursedAmount

    FROM dbo.vw_LoanPortfolio

    GROUP BY
        BranchCode,
        BranchName
)

SELECT
    BranchCode,
    BranchName,
    TotalDisbursedAmount,

    RANK() OVER
    (
        ORDER BY TotalDisbursedAmount DESC
    ) AS BranchRank

FROM BranchPortfolio

ORDER BY
    BranchRank;
GO


-- =====================================================
-- 6. Member Loan Ranking
-- =====================================================

WITH MemberPortfolio AS
(
    SELECT
        MemberNumber,
        FullName,
        SUM(DisbursedAmount) AS TotalDisbursedAmount

    FROM dbo.vw_LoanPortfolio

    GROUP BY
        MemberNumber,
        FullName
)

SELECT
    MemberNumber,
    FullName,
    TotalDisbursedAmount,

    RANK() OVER
    (
        ORDER BY TotalDisbursedAmount DESC
    ) AS MemberRank

FROM MemberPortfolio

ORDER BY
    MemberRank;
GO


-- =====================================================
-- 7. Monthly Loan Disbursement Analysis
-- =====================================================

SELECT
    YEAR(DisbursedDate) AS DisbursementYear,

    MONTH(DisbursedDate) AS DisbursementMonth,

    COUNT(*) AS NumberOfLoans,

    SUM(DisbursedAmount) AS TotalDisbursedAmount

FROM dbo.vw_LoanPortfolio

WHERE DisbursedDate IS NOT NULL

GROUP BY
    YEAR(DisbursedDate),
    MONTH(DisbursedDate)

ORDER BY
    DisbursementYear,
    DisbursementMonth;
GO