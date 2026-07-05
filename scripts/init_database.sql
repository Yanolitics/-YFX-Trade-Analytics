-- ====================================================================
-- Project: YFX Trading Analytics
-- Task: Data Warehouse Initialization (Medallion Architecture)
-- Developer: Yanolitics
-- Purpose: Sets up the initial environment, database, and isolated 
--          schemas (Bronze, Silver, Gold) for the data pipeline.
-- WARNING: Running this script drops the existing 'DataWarehouse' 
--          database and permanently deletes all data. Dev use only!
-- ====================================================================


USE master;
GO

-- Rebuild database if it exists to ensure a clean, reproducible setup
IF EXISTS (SELECT * FROM sys.databases WHERE name = N'TradingAnalytics')
BEGIN
    ALTER DATABASE TradingAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TradingAnalytics;
END
GO

CREATE DATABASE TradingAnalytics;
GO

USE TradingAnalytics;
GO

-- ─── CREATE MEDALLION SCHEMAS ────────────────────────────────────────

-- Bronze: Raw, untouched source data landing zone
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'bronze') EXEC('CREATE SCHEMA bronze;');
GO

-- Silver: Cleaned, standardized, and normalized data area
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'silver') EXEC('CREATE SCHEMA silver;');
GO

-- Gold: Business-ready dimensional models (Star Schema views)
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'gold') EXEC('CREATE SCHEMA gold;');
GO

-- ─── VERIFICATION ────────────────────────────────────────────────────

SELECT schema_id, name AS schema_name 
FROM sys.schemas 
WHERE name IN ('bronze', 'silver', 'gold');
GO
