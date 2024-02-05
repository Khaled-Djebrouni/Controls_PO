USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[contrôle_PurchaseOrder_Conditionsposte]    Script Date: 05.02.2024 8:34:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- sdbPILOT3_MM
-- sdbRollout_MM
CREATE VIEW [dbo].[contrôle_PurchaseOrder_Conditionsposte] AS
SELECT
    EBELN, -- Numéro de commande d'achat
	CASE WHEN EBELN IS NULL or EBELN='' THEN 'NOK Valeur Obligatoire' END AS contrôle_EBELN,
    EBELP, -- Numéro de poste de commande d'achat
    CASE
	    WHEN EBELP IS NULL or EBELP ='' THEN 'NOK Valeur Obligatoire'
        WHEN CONCAT(EBELN,RIGHT('00000'+EBELP,5)) NOT IN (SELECT CONCAT(EBELN,RIGHT('00000'+EBELP,5)) FROM PurchaseOrder_Postes) THEN 'NOK valeur hors liste'
        WHEN LEN(EBELP) > 5 THEN 'NOK Longueur'
        ELSE 'OK'
    END AS contrôle_EBELN_EBELP,

    KSCHL, -- Type de condition
    CASE
	    WHEN KSCHL IS NULL or KSCHL ='' THEN 'NOK Valeur Obligatoire'
        WHEN KSCHL NOT IN (SELECT DISTINCT KSCHL FROM dgSAP_SP1_100.dbo.T685) THEN 'NOK valeur hors liste'
        WHEN LEN(KSCHL) > 4 THEN 'NOK Longueur'
		WHEN CONCAT(EBELN, EBELP, KSCHL) IN (	SELECT DISTINCT	CONCAT(EBELN, EBELP, KSCHL)
												FROM	PurchaseOrder_Conditionsposte
												GROUP BY CONCAT(EBELN, EBELP, KSCHL)
												HAVING	COUNT(*)>1	) THEN 'NOK, valeur de (EBELN, KSCHL) en double'
        ELSE 'OK'
    END AS contrôle_KSCHL,

    KBETR, -- Montant de la condition
    CASE 
	    WHEN KBETR IS NULL or KBETR ='' THEN 'NOK Valeur Obligatoire'
        WHEN (ISNUMERIC(KBETR) <> 1 AND KBETR IS NOT NULL) THEN 'NOK Pas Numérique'
             ELSE 'OK'
    END AS contrôle_KBETR
FROM PurchaseOrder_Conditionsposte
GO


