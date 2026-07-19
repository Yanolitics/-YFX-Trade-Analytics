WITH CTE_closed_trades AS (
    SELECT
        CASE 
            WHEN Symbol LIKE '%.x' THEN LEFT(Symbol, LEN(Symbol) - 2)
            ELSE Symbol 
        END AS CleanedSymbol,
        LOWER(type) AS type,
        -- Shift the entire DATETIME back 4 hours for New York, then grab the Date
        TRY_CONVERT(DATE, DATEADD(hour, -4, Open_Date)) AS open_date, 
    
        -- CHANGED: Shifts back 4 hours and outputs strictly the hour and minute string ('19:55')
        FORMAT(DATEADD(hour, -4, Open_Date), 'HH:mm') AS open_time,
        OpenPrice,
                -- Shift the entire DATETIME back 4 hours for New York, then grab the Date
        TRY_CONVERT(DATE, DATEADD(hour, -4, Closed_Date)) AS closed_date, 
    
        -- CHANGED: Shifts back 4 hours and outputs strictly the hour and minute string ('19:55')
        FORMAT(DATEADD(hour, -4, Closed_Date), 'HH:mm') AS closed_time,
        ClosedPrice
    FROM bronze.closed_trades
)
SELECT
    CASE 
        WHEN UPPER(TRIM(CleanedSymbol)) IN ('JAP225','JP225') THEN 'JAP225'
        WHEN UPPER(TRIM(CleanedSymbol)) IN ('NAS100','NDX100') THEN 'NAS100'
        ELSE CleanedSymbol
    END AS symbol,
    LOWER(type) AS type,
    open_date,
    open_time,
    openprice,
    closed_date,
    closed_time,
    closedprice
FROM CTE_closed_trades;
