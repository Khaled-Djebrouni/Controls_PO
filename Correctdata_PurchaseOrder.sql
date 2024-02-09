USE [sdbPILOT3_MM]
GO

/****** Object:  StoredProcedure [dbo].[Correctdata_PurchaseOrder]    Script Date: 09.02.2024 19:13:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Correctdata_PurchaseOrder]
AS
BEGIN
	DECLARE @UPDATE_PO_P_Type NVARCHAR(MAX)
	DECLARE @UPDATE_LS_MATKL_NULL NVARCHAR(MAX)

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
	PRINT @UPDATE_PO_P_Type;
	PRINT @UPDATE_LS_MATKL_NULL;
    EXEC sp_executesql @UPDATE_PO_P_Type
    EXEC sp_executesql @UPDATE_LS_MATKL_NULL
	
END
GO
