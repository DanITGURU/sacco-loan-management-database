/*
========================================================
SACCO LOAN MANAGEMENT DATABASE
Script: 05_CreateStoredProcedures.sql
Purpose: Create reusable reporting procedures
========================================================
*/

USE SaccoLoanManagementDB;
GO

-- =====================================================
-- 1. Loan Portfolio Report
-- =====================================================

CREATE OR ALTER PROCEDURE dbo.sp_LoanPortfolioReport
(
    @StartDate DATE,
    @EndDate DATE,
    @BranchCode VARCHAR(10) = NULL,
    @LoanProductCode VARCHAR(20) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH LoanData AS
    (
        SELECT
            lp.LoanId,
            lp.MemberNumber,
            lp.FullName,
            lp.BranchCode,
            lp.BranchName,
            lp.ProductCode,
            lp.LoanProduct,
            lp.ApplicationDate,
            lp.ApprovalDate,
            lp.DisbursedDate,
            lp.ApprovedAmount,
            lp.DisbursedAmount,
            lp.InterestRate,
            lp.Status,

            COALESCE(rs.TotalRepaid, 0) AS TotalRepaid,
            COALESCE(rs.PrincipalRepaid, 0) AS PrincipalRepaid,
            COALESCE(rs.InterestRepaid, 0) AS InterestRepaid

        FROM dbo.vw_LoanPortfolio lp

        LEFT JOIN dbo.vw_LoanRepaymentSummary rs
            ON lp.LoanId = rs.LoanId

        WHERE lp.DisbursedDate >= @StartDate
          AND lp.DisbursedDate < DATEADD(DAY, 1, @EndDate)

          AND
          (
              @BranchCode IS NULL
              OR lp.BranchCode = @BranchCode
          )

          AND
          (
              @LoanProductCode IS NULL
              OR lp.ProductCode = @LoanProductCode
          )
    )

    SELECT
        LoanId,
        MemberNumber,
        FullName,
        BranchCode,
        BranchName,
        ProductCode,
        LoanProduct,
        ApplicationDate,
        ApprovalDate,
        DisbursedDate,
        ApprovedAmount,
        DisbursedAmount,
        TotalRepaid,
        PrincipalRepaid,
        InterestRepaid,

        DisbursedAmount - PrincipalRepaid
            AS OutstandingPrincipal,

        InterestRate,
        Status

    FROM LoanData

    ORDER BY
        DisbursedDate,
        FullName;
END;
GO


-- =====================================================
-- 2. Loan Product Portfolio Summary
-- =====================================================

CREATE OR ALTER PROCEDURE dbo.sp_LoanProductSummary
(
    @StartDate DATE,
    @EndDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ProductCode,
        LoanProduct,

        COUNT(*) AS NumberOfLoans,

        SUM(ApprovedAmount) AS TotalApprovedAmount,

        SUM(DisbursedAmount) AS TotalDisbursedAmount,

        SUM(TotalRepaid) AS TotalRepaid,

        SUM(OutstandingPrincipal) AS OutstandingPrincipal

    FROM
    (
        SELECT
            lp.ProductCode,
            lp.LoanProduct,
            lp.ApprovedAmount,
            lp.DisbursedAmount,
            COALESCE(rs.TotalRepaid, 0) AS TotalRepaid,

            lp.DisbursedAmount
                - COALESCE(rs.PrincipalRepaid, 0)
                AS OutstandingPrincipal

        FROM dbo.vw_LoanPortfolio lp

        LEFT JOIN dbo.vw_LoanRepaymentSummary rs
            ON lp.LoanId = rs.LoanId

        WHERE lp.DisbursedDate >= @StartDate
          AND lp.DisbursedDate < DATEADD(DAY, 1, @EndDate)
    ) LoanSummary

    GROUP BY
        ProductCode,
        LoanProduct

    ORDER BY
        TotalDisbursedAmount DESC;
END;
GO


-- =====================================================
-- 3. Member Loan Frequency and Cumulative Amount
-- =====================================================

CREATE OR ALTER PROCEDURE dbo.sp_MemberLoanFrequencyCumulative
(
    @StartDate DATE,
    @EndDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH MemberLoans AS
    (
        SELECT
            MemberNumber,
            FullName,
            LoanProduct,
            LoanId,
            DisbursedDate,
            ApprovedAmount,

            ROW_NUMBER() OVER
            (
                PARTITION BY MemberNumber, LoanProduct
                ORDER BY DisbursedDate, LoanId
            ) AS LoanFrequency,

            SUM(ApprovedAmount) OVER
            (
                PARTITION BY MemberNumber, LoanProduct
                ORDER BY DisbursedDate, LoanId
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS CumulativeApprovedAmount

        FROM dbo.vw_LoanPortfolio

        WHERE DisbursedDate >= @StartDate
          AND DisbursedDate < DATEADD(DAY, 1, @EndDate)
    )

    SELECT
        MemberNumber,
        FullName,
        LoanProduct,
        LoanId,
        DisbursedDate,
        ApprovedAmount,
        LoanFrequency,
        CumulativeApprovedAmount

    FROM MemberLoans

    ORDER BY
        MemberNumber,
        LoanProduct,
        DisbursedDate;
END;
GO


PRINT 'Stored procedures created successfully.';
GO