USE [sdbPILOT3_MM]
GO

/****** Object:  StoredProcedure [dbo].[Correctdata_PurchaseOrder]    Script Date: 15.02.2024 15:29:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Correctdata_PurchaseOrder]
AS
BEGIN
	DECLARE @UPDATE_PO_P_Type NVARCHAR(MAX);
	DECLARE @UPDATE_LS_MATKL_NULL NVARCHAR(MAX);

	SET @UPDATE_PO_P_Type			= N'UPDATE PurchaseOrder_Postes
										SET MENGE = ''1'',
											MEINS = ''UO'',
											NETPR = NULL
										WHERE PSTYP = ''P'' AND
										(	MENGE <> ''1'' OR
											MEINS <> ''UO'' OR
											NETPR IS NOT NULL	) ;';

	SET @UPDATE_LS_MATKL_NULL = N'UPDATE PurchaseOrder_LignesServices
                                SET MATKL = NULL
                                WHERE CONCAT(EBELN, EBELP, MATKL) IN (	SELECT DISTINCT CONCAT(EBELN, EBELP, MATKL)
																		FROM
																		contrôle_PurchaseOrder_Lignesservices_erreur
																		WHERE contrôle_MATKL like ''%NOK%'' );';
    EXEC sp_executesql @UPDATE_PO_P_Type;
    EXEC sp_executesql @UPDATE_LS_MATKL_NULL;

	IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PurchaseOrder_LignesServices' AND COLUMN_NAME='FORMELNR')
	BEGIN
		ALTER TABLE PurchaseOrder_LignesServices ADD FORMELNR NVARCHAR(MAX);
	END;

	;WITH CTE AS (
    SELECT FORMELNR,
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS SequenceNumber
    FROM PurchaseOrder_LignesServices
	)
	UPDATE CTE
	SET FORMELNR = CAST(SequenceNumber AS NVARCHAR(MAX));

END
GO
