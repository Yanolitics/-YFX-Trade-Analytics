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
    ID VARCHAR(100),
    Symbol VARCHAR(50),
    OpenTime VARCHAR(50),  -- Imported as string first to avoid date-format errors
    Volume DECIMAL(18,4),
    Side VARCHAR(10),
    CloseTime VARCHAR(50),
    OpenPrice DECIMAL(18,5),
    ClosePrice DECIMAL(18,5),
    StopLoss DECIMAL(18,5),
    TakeProfit DECIMAL(18,5),
    Swap DECIMAL(18,2),
    Commission DECIMAL(18,2),
    Profit DECIMAL(18,2),
    Reason VARCHAR(50)
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
