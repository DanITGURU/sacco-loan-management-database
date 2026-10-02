/*
========================================================
SACCO LOAN MANAGEMENT DATABASE
Script: 06_CreateIndexes.sql
Purpose: Create indexes for query performance
========================================================
*/

USE SaccoLoanManagementDB;
GO

-- =====================================================
-- Members
-- =====================================================

CREATE INDEX IX_Members_BranchId
ON dbo.Members (BranchId);
GO


-- =====================================================
-- Loans
-- =====================================================

CREATE INDEX IX_Loans_MemberId
ON dbo.Loans (MemberId);
GO

CREATE INDEX IX_Loans_LoanProductId
ON dbo.Loans (LoanProductId);
GO

CREATE INDEX IX_Loans_DisbursedDate
ON dbo.Loans (DisbursedDate);
GO

CREATE INDEX IX_Loans_Status
ON dbo.Loans (Status);
GO


-- =====================================================
-- Loan Repayments
-- =====================================================

CREATE INDEX IX_LoanRepayments_LoanId
ON dbo.LoanRepayments (LoanId);
GO

CREATE INDEX IX_LoanRepayments_PaymentDate
ON dbo.LoanRepayments (PaymentDate);
GO


PRINT 'Database indexes created successfully.';
GO