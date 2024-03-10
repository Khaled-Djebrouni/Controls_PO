USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[ZControl_PurchaseOrder_MATNR]    Script Date: 2024.03.10 14:28:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[ZControl_PurchaseOrder_MATNR] AS
SELECT
    PO.EBELN,
    PO.EBELP,
	PSTYP,
	KNTTP,
    PO.MATNR,
    CASE
		WHEN PO.MATNR IS NOT NULL  THEN -- cas de commande de fourniture
			CASE 
				WHEN EXISTS (SELECT 1 FROM sdbBackup_Material.dbo.BACKUP_External_Number B WHERE B.ANCIEN_CODE = concat(PO.WERKS,'_',PO.MATNR) AND B.MTART = 'ZAPP') THEN -- Type de fourniture ZAPP
					CASE
						WHEN PSTYP IS NULL THEN -- PSTYP doit être null pour les fournitures
							CASE
								WHEN KNTTP IS NULL THEN 'OK'	--l'imputation doit être vide pour ZAPP
								ELSE 'NOK, Article ZAPP avec KNTTP non vide'	-- article ZAPP avec imputation
							END
						ELSE 'NOK, Article ZAPP avec PSTYP non vide' -- pour ZAPP PSTYP doit être vide
					END
				WHEN EXISTS (SELECT 1 FROM sdbBackup_Material.dbo.BACKUP_External_Number B WHERE B.ANCIEN_CODE = PO.MATNR AND B.MTART = 'ZNST') THEN -- Type de fourniture ZNST
					CASE
						WHEN PSTYP IS NULL THEN -- PSTYP doit être null pour les fournitures
							CASE
								WHEN KNTTP IS NULL THEN 'NOK, Imputation obligatoire' --Imputation obligatoire pour ZNST
								WHEN KNTTP IN ('K', 'P', 'F', 'U') THEN 'OK'
								WHEN KNTTP = 'A' THEN 'NOK, Fiche Asset'
								ELSE 'NOK, Valeur inattendue'
							END
						ELSE 'NOK, Article ZNST avec PSTYP non vide' -- pour ZNST PSTYP doit être vide
					END
				ELSE 'NOK, article ni ZAPP ni ZNST'
			END
		WHEN PO.MATNR IS NULL  THEN -- Numéro d'article null (cas de service)
			CASE 
				WHEN PSTYP = 'P' THEN	-- PSTYP doit être P (service)
							CASE
								WHEN KNTTP IN ('K', 'P', 'F', 'U') THEN 'OK' -- Avec une immutation
								ELSE 'NOK, vérifier imputation'		-- service sans imputation
							END
				ELSE 'NOK, Vérifier PSTYP et MATNR' -- commande fourniture sans code article
			END
    END AS contrôle_MATNR
FROM PurchaseOrder_Postes PO
GO


