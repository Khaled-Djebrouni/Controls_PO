USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[contrôle_PurchaseOrder_Conditionsentete]    Script Date: 05.02.2024 8:28:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[contrôle_PurchaseOrder_Conditionsentete] AS
SELECT
    EBELN, -- Numéro de commande d'achat
    CASE
        WHEN EBELN IS NULL OR EBELN = '' THEN 'NOK Obligatoire'
        WHEN EBELN NOT IN (SELECT EBELN FROM PurchaseOrder_Entete) THEN 'NOK valeur hors liste'
        ELSE 'OK'
    END AS contrôle_EBELN,

    KSCHL, -- Type de condition
    CASE
	    WHEN KSCHL IS NULL OR KSCHL='' then 'NOK Valeur Obligatoire'
        WHEN KSCHL NOT IN (SELECT DISTINCT KSCHL FROM dgSAP_SP1_100.dbo.T685) THEN 'NOK valeur hors liste'
		WHEN CONCAT(EBELN, KSCHL) IN (	SELECT DISTINCT	CONCAT(EBELN, KSCHL)
										FROM	PurchaseOrder_Conditionsentete
										GROUP BY CONCAT(EBELN, KSCHL)
										HAVING	COUNT(*)>1	) THEN 'NOK, valeur de (EBELN, KSCHL) en double'
        WHEN LEN(KSCHL) > 4 THEN 'NOK Longueur'
        ELSE 'OK'
    END AS contrôle_KSCHL,

    KBETR, -- Montant de la condition
    CASE
	    WHEN KBETR IS NULL OR KBETR='' then 'NOK Valeur Obligatoire'
        WHEN (ISNUMERIC(REPLACE(KBETR,'.',',')) <> 1 AND KBETR IS NOT NULL) THEN 'NOK Pas Numérique'
        ELSE 'OK'
    END AS contrôle_KBETR
FROM PurchaseOrder_Conditionsentete
GO


