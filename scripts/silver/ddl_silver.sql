WITH CTE_Symbol AS 
(
    SELECT
        CASE 
            WHEN Symbol LIKE '%.x' THEN LEFT(Symbol, LEN(Symbol) - 2)
            ELSE Symbol 
        END AS CleanedSymbol
    FROM bronze.closed_trades
)
SELECT DISTINCT
    CASE 
        WHEN UPPER(TRIM(cleanedsymbol)) IN ('JAP225','JP225') THEN 'JAP225'
        WHEN UPPER(TRIM(cleanedsymbol)) IN ('NAS100','NDX100') THEN 'NAS100'
        ELSE CleanedSymbol
    END AS Symbol
FROM CTE_symbol
