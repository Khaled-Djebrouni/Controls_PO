USE [sdbPILOT3_MM]
GO

/****** Object:  StoredProcedure [dbo].[DeletePurchaseOrderRows]    Script Date: 09.02.2024 19:19:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[DeletePurchaseOrderRows]
    @EBELNLegacyList NVARCHAR(MAX)
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
        SET @SqlQuery = N'DELETE FROM ' + @TableName + ' WHERE EBELN IN (' + @EBELNLegacyList + ');';

		BEGIN TRY

			EXEC sp_executesql @SqlQuery;

		END TRY
		BEGIN CATCH

			print @SqlQuery;

		END CATCH;

        FETCH NEXT FROM table_cursor INTO @TableName;
    END;

    CLOSE table_cursor;
    DEALLOCATE table_cursor;
END;

GO
