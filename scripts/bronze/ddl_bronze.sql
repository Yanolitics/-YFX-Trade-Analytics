-- ====================================================================
-- Project: YFX Trading Analytics
-- Task: Data Warehouse - Bronze Layer Ingestion (BankChurners)
-- Developer: Yanolitics
-- Purpose: Creates raw landing tables for CRM, CBS, and The Central Financial Ledger (CFL) CSV files.
-- WARNING: Running this script drops existing tables and permanently 
--          deletes all data within them. Dev use only!
-- ====================================================================

USE TradingAnalytics;
GO

-- ─── SECTION 1: TABLES ───────────────────────────────────────────

-- 1. Customer Info Table
IF OBJECT_ID('bronze.closed_trades', 'U') IS NOT NULL
    DROP TABLE bronze.closed_trades;
GO

CREATE TABLE bronze.closed_trades (
    Symbol VARCHAR(100) NULL,
    Type VARCHAR(100) NULL,
    Open_Date VARCHAR(100) NULL,
    OpenPrice VARCHAR(100) NULL,
    Closed_Date VARCHAR(100) NULL,
    ClosedPrice VARCHAR(100) NULL,
    TP VARCHAR(100) NULL,
    SL VARCHAR(100) NULL,
    Lots VARCHAR(100) NULL,
    Commission VARCHAR(100) NULL,
    Profit VARCHAR(100) NULL

);
GO 

-- ─── SECTION 2: VERIFICATION AUDIT ──────────────────────────────────

SELECT 
    s.name AS schema_name, 
    t.name AS table_name,
    t.create_date
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'bronze'
ORDER BY table_name;
GO
