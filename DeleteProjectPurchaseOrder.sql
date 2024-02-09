USE [sdbPILOT3_MM]
GO

/****** Object:  StoredProcedure [dbo].[DeleteProjectPurchaseOrder]    Script Date: 09.02.2024 19:18:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[DeleteProjectPurchaseOrder]
AS
BEGIN
    DECLARE @TableName	NVARCHAR(100);
    DECLARE @SqlQuery	NVARCHAR(MAX);

    CREATE TABLE #TempEBELN (EBELN NVARCHAR(50));

    INSERT INTO #TempEBELN (EBELN)
    SELECT DISTINCT EBELN
    FROM PurchaseOrder_Postes
    WHERE KNTTP = 'P';

    DECLARE table_cursor CURSOR FOR
    SELECT    name
    FROM    purchaseOrder_sheets;

    OPEN table_cursor;
    FETCH NEXT FROM table_cursor INTO @TableName;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @SqlQuery = N'DELETE FROM ' + @TableName + ' WHERE EBELN IN (SELECT EBELN FROM #TempEBELN);';

        EXEC sp_executesql @SqlQuery;

        FETCH NEXT FROM table_cursor INTO @TableName;
    END;

    CLOSE table_cursor;
    DEALLOCATE table_cursor;

    DROP TABLE #TempEBELN;
END;

GO


