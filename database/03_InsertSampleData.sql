/*
========================================================
SACCO LOAN MANAGEMENT DATABASE
Script: 03_InsertSampleData.sql
Purpose: Insert fictional sample data
========================================================
*/

USE SaccoLoanManagementDB;
GO

-- =====================================================
-- Branches
-- =====================================================

DECLARE @NairobiBranch UNIQUEIDENTIFIER = NEWID();
DECLARE @KisumuBranch UNIQUEIDENTIFIER = NEWID();
DECLARE @EldoretBranch UNIQUEIDENTIFIER = NEWID();
DECLARE @KakamegaBranch UNIQUEIDENTIFIER = NEWID();

INSERT INTO Branches
(
    BranchId,
    BranchCode,
    BranchName
)
VALUES
(@NairobiBranch, 'NBO', 'Nairobi Branch'),
(@KisumuBranch, 'KSM', 'Kisumu Branch'),
(@EldoretBranch, 'ELD', 'Eldoret Branch'),
(@KakamegaBranch, 'KAK', 'Kakamega Branch');


-- =====================================================
-- Members
-- =====================================================

DECLARE @Brian UNIQUEIDENTIFIER = NEWID();
DECLARE @Grace UNIQUEIDENTIFIER = NEWID();
DECLARE @Kevin UNIQUEIDENTIFIER = NEWID();
DECLARE @Mercy UNIQUEIDENTIFIER = NEWID();
DECLARE @David UNIQUEIDENTIFIER = NEWID();

INSERT INTO Members
(
    MemberId,
    MemberNumber,
    FullName,
    PhoneNumber,
    BranchId,
    DateJoined,
    Status
)
VALUES
(
    @Brian,
    'MEM001',
    'Brian Otieno',
    '0712345678',
    @NairobiBranch,
    '2023-02-15',
    'Active'
),
(
    @Grace,
    'MEM002',
    'Grace Wanjiku',
    '0723456789',
    @NairobiBranch,
    '2022-08-10',
    'Active'
),
(
    @Kevin,
    'MEM003',
    'Kevin Kiptoo',
    '0734567890',
    @EldoretBranch,
    '2024-01-20',
    'Active'
),
(
    @Mercy,
    'MEM004',
    'Mercy Achieng',
    '0745678901',
    @KisumuBranch,
    '2021-11-05',
    'Active'
),
(
    @David,
    'MEM005',
    'David Mwangi',
    '0756789012',
    @KakamegaBranch,
    '2023-06-18',
    'Active'
);


-- =====================================================
-- Loan Products
-- =====================================================

DECLARE @DevelopmentLoan UNIQUEIDENTIFIER = NEWID();
DECLARE @EmergencyLoan UNIQUEIDENTIFIER = NEWID();
DECLARE @BusinessLoan UNIQUEIDENTIFIER = NEWID();
DECLARE @SchoolFeesLoan UNIQUEIDENTIFIER = NEWID();

INSERT INTO LoanProducts
(
    LoanProductId,
    ProductCode,
    Description,
    InterestRate,
    MaximumAmount,
    RepaymentPeriodMonths
)
VALUES
(
    @DevelopmentLoan,
    'DEV',
    'Development Loan',
    12.00,
    1000000.00,
    60
),
(
    @EmergencyLoan,
    'EMG',
    'Emergency Loan',
    10.00,
    300000.00,
    24
),
(
    @BusinessLoan,
    'BUS',
    'Business Loan',
    14.00,
    1500000.00,
    72
),
(
    @SchoolFeesLoan,
    'SCH',
    'School Fees Loan',
    9.00,
    500000.00,
    36
);


-- =====================================================
-- Loans
-- =====================================================

DECLARE @Loan1 UNIQUEIDENTIFIER = NEWID();
DECLARE @Loan2 UNIQUEIDENTIFIER = NEWID();
DECLARE @Loan3 UNIQUEIDENTIFIER = NEWID();
DECLARE @Loan4 UNIQUEIDENTIFIER = NEWID();
DECLARE @Loan5 UNIQUEIDENTIFIER = NEWID();
DECLARE @Loan6 UNIQUEIDENTIFIER = NEWID();

INSERT INTO Loans
(
    LoanId,
    MemberId,
    LoanProductId,
    ApplicationDate,
    ApprovalDate,
    DisbursedDate,
    ApprovedAmount,
    DisbursedAmount,
    InterestRate,
    Status
)
VALUES
(
    @Loan1,
    @Brian,
    @DevelopmentLoan,
    '2025-01-10',
    '2025-01-15',
    '2025-01-17',
    450000.00,
    450000.00,
    12.00,
    'Disbursed'
),
(
    @Loan2,
    @Grace,
    @BusinessLoan,
    '2025-02-05',
    '2025-02-10',
    '2025-02-12',
    800000.00,
    800000.00,
    14.00,
    'Disbursed'
),
(
    @Loan3,
    @Kevin,
    @EmergencyLoan,
    '2025-03-01',
    '2025-03-02',
    '2025-03-03',
    150000.00,
    150000.00,
    10.00,
    'Completed'
),
(
    @Loan4,
    @Mercy,
    @SchoolFeesLoan,
    '2025-04-12',
    '2025-04-15',
    '2025-04-16',
    250000.00,
    250000.00,
    9.00,
    'Disbursed'
),
(
    @Loan5,
    @David,
    @DevelopmentLoan,
    '2025-05-20',
    '2025-05-25',
    '2025-05-27',
    600000.00,
    600000.00,
    12.00,
    'Disbursed'
),
(
    @Loan6,
    @Brian,
    @EmergencyLoan,
    '2025-07-01',
    '2025-07-02',
    '2025-07-03',
    100000.00,
    100000.00,
    10.00,
    'Completed'
);


-- =====================================================
-- Loan Repayments
-- =====================================================

INSERT INTO LoanRepayments
(
    LoanId,
    PaymentDate,
    Amount,
    PrincipalAmount,
    InterestAmount
)
VALUES
(@Loan1, '2025-02-17', 50000.00, 45000.00, 5000.00),
(@Loan1, '2025-03-17', 50000.00, 45000.00, 5000.00),
(@Loan1, '2025-04-17', 50000.00, 46000.00, 4000.00),

(@Loan2, '2025-03-12', 90000.00, 80000.00, 10000.00),
(@Loan2, '2025-04-12', 90000.00, 81000.00, 9000.00),

(@Loan3, '2025-04-03', 50000.00, 45000.00, 5000.00),
(@Loan3, '2025-05-03', 50000.00, 47000.00, 3000.00),
(@Loan3, '2025-06-03', 50000.00, 48000.00, 2000.00),

(@Loan4, '2025-05-16', 40000.00, 37000.00, 3000.00),
(@Loan4, '2025-06-16', 40000.00, 37000.00, 3000.00),

(@Loan5, '2025-06-27', 70000.00, 62000.00, 8000.00),
(@Loan5, '2025-07-27', 70000.00, 63000.00, 7000.00),

(@Loan6, '2025-08-03', 35000.00, 32000.00, 3000.00),
(@Loan6, '2025-09-03', 35000.00, 33000.00, 2000.00),
(@Loan6, '2025-10-03', 30000.00, 29000.00, 1000.00);

PRINT 'sample SACCO data inserted successfully.';
GO