/*
========================================================
SACCO LOAN MANAGEMENT DATABASE
Script: 02_CreateTables.sql
Purpose: Create core database tables
========================================================
*/

USE SaccoLoanManagementDB;
GO

-- =====================================================
-- 1. Branches
-- =====================================================

CREATE TABLE Branches
(
    BranchId UNIQUEIDENTIFIER NOT NULL
        CONSTRAINT PK_Branches PRIMARY KEY
        DEFAULT NEWID(),

    BranchCode VARCHAR(10) NOT NULL,

    BranchName VARCHAR(100) NOT NULL,

    CONSTRAINT UQ_Branches_BranchCode
        UNIQUE (BranchCode)
);
GO


-- =====================================================
-- 2. Members
-- =====================================================

CREATE TABLE Members
(
    MemberId UNIQUEIDENTIFIER NOT NULL
        CONSTRAINT PK_Members PRIMARY KEY
        DEFAULT NEWID(),

    MemberNumber VARCHAR(20) NOT NULL,

    FullName VARCHAR(150) NOT NULL,

    PhoneNumber VARCHAR(20) NULL,

    BranchId UNIQUEIDENTIFIER NOT NULL,

    DateJoined DATE NOT NULL,

    Status VARCHAR(20) NOT NULL
        CONSTRAINT DF_Members_Status DEFAULT 'Active',

    CONSTRAINT UQ_Members_MemberNumber
        UNIQUE (MemberNumber),

    CONSTRAINT FK_Members_Branches
        FOREIGN KEY (BranchId)
        REFERENCES Branches(BranchId),

    CONSTRAINT CK_Members_Status
        CHECK (Status IN ('Active', 'Inactive'))
);
GO


-- =====================================================
-- 3. Loan Products
-- =====================================================

CREATE TABLE LoanProducts
(
    LoanProductId UNIQUEIDENTIFIER NOT NULL
        CONSTRAINT PK_LoanProducts PRIMARY KEY
        DEFAULT NEWID(),

    ProductCode VARCHAR(20) NOT NULL,

    Description VARCHAR(100) NOT NULL,

    InterestRate DECIMAL(5,2) NOT NULL,

    MaximumAmount DECIMAL(18,2) NOT NULL,

    RepaymentPeriodMonths INT NOT NULL,

    CONSTRAINT UQ_LoanProducts_ProductCode
        UNIQUE (ProductCode),

    CONSTRAINT CK_LoanProducts_InterestRate
        CHECK (InterestRate >= 0),

    CONSTRAINT CK_LoanProducts_MaximumAmount
        CHECK (MaximumAmount > 0),

    CONSTRAINT CK_LoanProducts_RepaymentPeriod
        CHECK (RepaymentPeriodMonths > 0)
);
GO


-- =====================================================
-- 4. Loans
-- =====================================================

CREATE TABLE Loans
(
    LoanId UNIQUEIDENTIFIER NOT NULL
        CONSTRAINT PK_Loans PRIMARY KEY
        DEFAULT NEWID(),

    MemberId UNIQUEIDENTIFIER NOT NULL,

    LoanProductId UNIQUEIDENTIFIER NOT NULL,

    ApplicationDate DATE NOT NULL,

    ApprovalDate DATE NULL,

    DisbursedDate DATE NULL,

    ApprovedAmount DECIMAL(18,2) NOT NULL,

    DisbursedAmount DECIMAL(18,2) NULL,

    InterestRate DECIMAL(5,2) NOT NULL,

    Status VARCHAR(20) NOT NULL
        CONSTRAINT DF_Loans_Status DEFAULT 'Pending',

    CONSTRAINT FK_Loans_Members
        FOREIGN KEY (MemberId)
        REFERENCES Members(MemberId),

    CONSTRAINT FK_Loans_LoanProducts
        FOREIGN KEY (LoanProductId)
        REFERENCES LoanProducts(LoanProductId),

    CONSTRAINT CK_Loans_ApprovedAmount
        CHECK (ApprovedAmount > 0),

    CONSTRAINT CK_Loans_DisbursedAmount
        CHECK (DisbursedAmount IS NULL OR DisbursedAmount > 0),

    CONSTRAINT CK_Loans_InterestRate
        CHECK (InterestRate >= 0),

    CONSTRAINT CK_Loans_Status
        CHECK
        (
            Status IN
            (
                'Pending',
                'Approved',
                'Disbursed',
                'Completed',
                'Cancelled'
            )
        )
);
GO


-- =====================================================
-- 5. Loan Repayments
-- =====================================================

CREATE TABLE LoanRepayments
(
    RepaymentId UNIQUEIDENTIFIER NOT NULL
        CONSTRAINT PK_LoanRepayments PRIMARY KEY
        DEFAULT NEWID(),

    LoanId UNIQUEIDENTIFIER NOT NULL,

    PaymentDate DATE NOT NULL,

    Amount DECIMAL(18,2) NOT NULL,

    PrincipalAmount DECIMAL(18,2) NOT NULL,

    InterestAmount DECIMAL(18,2) NOT NULL,

    CONSTRAINT FK_LoanRepayments_Loans
        FOREIGN KEY (LoanId)
        REFERENCES Loans(LoanId),

    CONSTRAINT CK_LoanRepayments_Amount
        CHECK (Amount > 0),

    CONSTRAINT CK_LoanRepayments_Principal
        CHECK (PrincipalAmount >= 0),

    CONSTRAINT CK_LoanRepayments_Interest
        CHECK (InterestAmount >= 0),

    CONSTRAINT CK_LoanRepayments_Total
        CHECK (Amount = PrincipalAmount + InterestAmount)
);
GO

PRINT 'All SACCO loan management tables created successfully.';
GO