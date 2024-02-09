USE [sdbPILOT3_MM]
GO

/****** Object:  StoredProcedure [dbo].[DeleteLoadedPurchaseOrder]    Script Date: 09.02.2024 19:17:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[DeleteLoadedPurchaseOrder]
AS
BEGIN
    DECLARE @TableName	NVARCHAR(100);
    DECLARE @SqlQuery	NVARCHAR(MAX);

    DECLARE table_cursor CURSOR FOR
    SELECT	name
    FROM	purchaseOrder_sheets;

    OPEN table_cursor;
    FETCH NEXT FROM table_cursor INTO @TableName;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @SqlQuery = N'DELETE FROM ' + @TableName + ' WHERE EBELN IN (	SELECT		TabNum.EBELN_Legacy AS ''EBELN''
																			FROM		PurchaseOrder_Numerotation TabNum
																			LEFT JOIN	dgSAP_SP1_100.dbo.EKKO SP1_100
																			ON			TabNum.EBELN = SP1_100.EBELN
																			WHERE		TabNum.BUKRS = ( SELECT [Value] FROM _Context WHERE [Key] = ''BUKRS'')
																			AND			SP1_100.EBELN IS NOT NULL);';

		EXEC sp_executesql @SqlQuery;

        FETCH NEXT FROM table_cursor INTO @TableName;
    END;

    CLOSE table_cursor;
    DEALLOCATE table_cursor;
END;

GO


