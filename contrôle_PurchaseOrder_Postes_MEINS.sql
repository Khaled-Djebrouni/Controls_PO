USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[contrôle_PurchaseOrder_Postes_MEINS]    Script Date: 05.02.2024 8:40:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[contrôle_PurchaseOrder_Postes_MEINS] AS
SELECT
	EBELN,
	EBELP,
	SAP_CODE	as SAP_CODE,
	PO_P.MATNR	as code_article_legacy,
	TXZ01,
	MSEH3		as unite_sap,
    PO_P.MEINS	as unite_legacy,
    CASE
        WHEN PO_P.MATNR IS NULL AND PO_P.MEINS NOT IN (SELECT MSEH3 from dgSAP_SP1_100.dbo.T006A where SPRAS='F') 
				THEN 'NOK, valeur hors liste'
		WHEN PO_P.MATNR IS NOT NULL AND 
			 PSTYP IS NULL AND 
			 PO_P.MEINS NOT IN (SELECT MSEH3 from dgSAP_SP1_100.dbo.T006A where SPRAS='F') 
				THEN 'NOK, valeur hors liste'
        WHEN PO_P.MATNR IS NOT NULL AND 
			 PSTYP IS NULL AND 
			 PO_P.MEINS <> MSEH3 
				THEN 'NOK, Vérifier Unité de base de l''article'
		WHEN PSTYP='P' and PO_P.MEINS<>'UO' THEN 'NOK, MEINS = UO'
        ELSE 'OK'
    END AS contrôle_MEINS
    
FROM		PurchaseOrder_Postes PO_P
LEFT JOIN	sdbBackup_Material.dbo.BACKUP_External_Number NumTab
			ON (	ANCIEN_CODE=concat(PO_P.WERKS,'_',PO_P.MATNR)	OR	ANCIEN_CODE=PO_P.MATNR	)
LEFT JOIN	sdbPILOT3_MM.dbo.V_MATERIAL_SAP MatSap
			ON CONCAT('00000000', NumTab.SAP_CODE) = MatSap.MATNR
			AND MatSap.MATNR LIKE '%000000002%'

GO


