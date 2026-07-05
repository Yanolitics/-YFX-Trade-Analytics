
-- ====================================================================
-- Project: YFX Trading Analytics
-- Task: Data Warehouse - Bronze Ingestion Pipeline (Full Load)
-- Developer: Yanolitics
-- Purpose: Bulk load raw data from CRM, CBS, and The Central Financial Ledger (CFL) CSV files source.
-- Strategy: Truncate & Insert (As per design architecture)
-- WARNING: Truncates all destination tables before importing data.
-- ====================================================================

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME;
    BEGIN TRY
        SET NOCOUNT ON; -- Prevents internal row-count messages from cluttering your custom log

        PRINT '======================================================================';
        PRINT '                    LOADING BRONZE LAYER PIPELINE                     ';
        PRINT '======================================================================';
    
        -- ─── SECTION 1: INGESTION ───────────────────────────────────────
        PRINT '';
        PRINT '----------------------------------------------------------------------';
        PRINT ' SECTION 1: INGESTION';
        PRINT '----------------------------------------------------------------------';

        -- 1. Ingest CRM Profiles
        SET @start_time = GETDATE();
        PRINT '>> Truncating and Ingesting: bronze.closed_trades';
        TRUNCATE TABLE bronze.closed_trades;
        BULK INSERT bronze.closed_trades
        FROM 'C:\DATASETS\MatchTrader\closed_trades.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            FORMAT = 'CSV',
            TABLOCK
        );
        PRINT '>> SUCCESS: bronze.closed_trades loaded.';
        PRINT '----------------------------------------------------------------------';
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: '+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds';
        PRINT '----------------------------------------------------------------------';


        -- ─── SECTION 2: VERIFICATION AUDIT ──────────────────────────────────
        PRINT '';
        PRINT '----------------------------------------------------------------------';
        PRINT ' SECTION 2: VERIFICATION AUDIT';
        PRINT '----------------------------------------------------------------------';
    
        SELECT 'bronze.closed_trades' AS table_name, COUNT(*) AS total_rows_loaded FROM bronze.closed_trades
  
        PRINT '';
        PRINT '======================================================================';
        PRINT '               BRONZE LAYER LOAD COMPLETED SUCCESSFULLY               ';
        PRINT '======================================================================';
    END TRY
    BEGIN CATCH
        PRINT '======================================================================';
        PRINT '              ERROR OCCURRED DURING LOADING BRONZE LAYER              ';
        PRINT '======================================================================';
        PRINT CONCAT('Error Message  : ', ERROR_MESSAGE());
        PRINT CONCAT('Error Number   : ', ERROR_NUMBER());
        PRINT CONCAT('Error Severity : ', ERROR_SEVERITY());
        PRINT CONCAT('Error State    : ', ERROR_STATE());
        PRINT '======================================================================';
    END CATCH
END;
GO
GO
