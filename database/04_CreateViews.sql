/*
========================================================
SACCO LOAN MANAGEMENT DATABASE
Script: 04_CreateViews.sql
Purpose: Create reporting views
========================================================
*/

USE SaccoLoanManagementDB;
GO

-- =====================================================
-- Loan Portfolio View
-- =====================================================

CREATE OR ALTER VIEW dbo.vw_LoanPortfolio
AS
SELECT
    l.LoanId,
    m.MemberId,
    m.MemberNumber,
    m.FullName,
    m.PhoneNumber,

    b.BranchId,
    b.BranchCode,
    b.BranchName,

    lp.LoanProductId,
    lp.ProductCode,
    lp.Description AS LoanProduct,

    l.ApplicationDate,
    l.ApprovalDate,
    l.DisbursedDate,

    l.ApprovedAmount,
    l.DisbursedAmount,
    l.InterestRate,
    lp.RepaymentPeriodMonths,

    l.Status

FROM dbo.Loans l

INNER JOIN dbo.Members m
    ON l.MemberId = m.MemberId

INNER JOIN dbo.Branches b
    ON m.BranchId = b.BranchId

INNER JOIN dbo.LoanProducts lp
    ON l.LoanProductId = lp.LoanProductId;
GO


-- =====================================================
-- Loan Repayment Summary View
-- =====================================================

CREATE OR ALTER VIEW dbo.vw_LoanRepaymentSummary
AS
SELECT
    l.LoanId,
    m.MemberNumber,
    m.FullName,
    lp.ProductCode,
    lp.Description AS LoanProduct,

    l.ApprovedAmount,
    l.DisbursedAmount,

    COALESCE(SUM(r.Amount), 0) AS TotalRepaid,

    COALESCE(SUM(r.PrincipalAmount), 0) AS PrincipalRepaid,

    COALESCE(SUM(r.InterestAmount), 0) AS InterestRepaid,

    l.Status

FROM dbo.Loans l

INNER JOIN dbo.Members m
    ON l.MemberId = m.MemberId

INNER JOIN dbo.LoanProducts lp
    ON l.LoanProductId = lp.LoanProductId

LEFT JOIN dbo.LoanRepayments r
    ON l.LoanId = r.LoanId

GROUP BY
    l.LoanId,
    m.MemberNumber,
    m.FullName,
    lp.ProductCode,
    lp.Description,
    l.ApprovedAmount,
    l.DisbursedAmount,
    l.Status;
GO


PRINT 'Reporting views created successfully.';
GO