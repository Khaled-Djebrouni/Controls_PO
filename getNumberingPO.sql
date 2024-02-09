USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[getNumberingPO]    Script Date: 09.02.2024 18:20:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[getNumberingPO] AS
SELECT	EBELN AS 'EBELN_legacy',
		CASE 
			WHEN (	SELECT * FROM MAX_EBELN_PO ) + ROW_NUMBER() OVER (ORDER BY EBELN) > CONVERT(DECIMAL(10,0), ( SELECT [Value] FROM _Context WHERE [Key] = 'POEnd' ))
			THEN NULL
			ELSE (	SELECT * FROM MAX_EBELN_PO	) + ROW_NUMBER() OVER (ORDER BY EBELN)
		END AS 'EBELN',
		BUKRS
FROM	(	SELECT	EBELN, BUKRS 
			FROM	PurchaseOrder_entete PO
			EXCEPT
			SELECT	EBELN_Legacy, BUKRS 
			FROM	PurchaseOrder_Numerotation 
			WHERE	BUKRS = ( SELECT [Value] FROM _Context WHERE [Key] = 'BUKRS' ) 
			AND		EBELN IS NOT NULL 
			AND		EBELN <> ''	) tab
GO
