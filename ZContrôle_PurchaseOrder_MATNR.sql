USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[ZContrôle_PurchaseOrder_MATNR]    Script Date: 05.02.2024 8:44:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[ZContrôle_PurchaseOrder_MATNR] AS
SELECT
    PO.EBELN, -- Numéro de commande d'achat
    PO.EBELP, -- Numéro de poste de commande d'achat
	PSTYP,
	KNTTP,
    PO.MATNR, -- Numéro de matériel (peut être NULL)
    CASE
		WHEN PO.MATNR IS NOT NULL  THEN
			CASE 
				WHEN EXISTS (SELECT 1 FROM sdbBackup_Material.dbo.BACKUP_External_Number B WHERE B.ANCIEN_CODE = concat(PO.WERKS,'_',PO.MATNR) AND B.MTART = 'ZAPP') THEN
					CASE
						WHEN PSTYP IS NULL THEN
							CASE
								WHEN KNTTP IS NULL THEN 'OK'
								ELSE 'NOK, Article ZAPP avec KNTTP non vide'
							END
						ELSE 'NOK, Article ZAPP avec PSTYP non vide'
					END
				WHEN EXISTS (SELECT 1 FROM sdbBackup_Material.dbo.BACKUP_External_Number B WHERE B.ANCIEN_CODE = PO.MATNR AND B.MTART = 'ZNST') THEN
					CASE
						WHEN PSTYP IS NULL THEN
							CASE
								WHEN KNTTP IS NULL THEN 'NOK, Imputation obligatoire'
								WHEN KNTTP IN ('K', 'P', 'F', 'U') THEN 'OK'
								WHEN KNTTP = 'A' THEN 'NOK, Fiche Asset'
								ELSE 'NOK, Valeur inattendu'
							END
						ELSE 'NOK, Article ZNST avec PSTYP non vide'
					END
				ELSE 'NOK, article ni ZAPP ni ZNST'
			END
		WHEN PO.MATNR IS NULL  THEN
			CASE 
				WHEN PSTYP = 'P' THEN
							CASE
								WHEN KNTTP IN ('K', 'P', 'F', 'U') THEN 'OK'
								ELSE 'NOK, vérifier imputation'
							END
				ELSE 'NOK, Vérifier PSTYP et MATNR'
			END
    END AS contrôle_MATNR
FROM PurchaseOrder_Postes PO
GO


