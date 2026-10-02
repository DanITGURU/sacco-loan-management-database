/*
========================================================
SACCO LOAN MANAGEMENT DATABASE
Project: SaccoLoanManagementDB
Purpose: Database for managing SACCO members,
         loan products, loans and repayments.
========================================================
*/

IF DB_ID('SaccoLoanManagementDB') IS NULL
BEGIN
    CREATE DATABASE SaccoLoanManagementDB;
END;
GO

USE SaccoLoanManagementDB;
GO

PRINT 'SaccoLoanManagementDB database is ready.';
GO