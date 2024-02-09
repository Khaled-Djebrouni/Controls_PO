USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[contrôle_PurchaseOrder_Lignesservices]    Script Date: 05.02.2024 8:38:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--sdbRollout_MM 
--sdbPILOT3_MM

CREATE VIEW [dbo].[contrôle_PurchaseOrder_Lignesservices] AS 
SELECT
    EBELN, -- Numéro de commande d'achat
 
    EBELP, -- Numéro de poste de commande d'achat
    CASE
        WHEN CONCAT(EBELN, RIGHT('00000'+EBELP,5)) NOT IN (SELECT CONCAT(EBELN, RIGHT('00000'+EBELP,5)) FROM PurchaseOrder_Postes) 
		
		THEN 'NOK, La combinaison(EBELN, EBELP) n''existe pas dans les postes '
        WHEN (ISNUMERIC(EBELP) <> 1 AND EBELP IS NOT NULL) THEN 'NOK,  Pas Numérique'
        
        ELSE 'OK'
    END AS contrôle_EBELN_EBELP,

    MATKL, -- Groupe de matériel
    CASE
        WHEN	MATKL IS NOT NULL AND 
				MATKL NOT IN (	SELECT	MATKL	FROM	dgSAP_SP1_100.dbo.T023 ) 
				THEN 'NOK, MATKL n''existe pas dans la liste Field Rule Material Group'
        WHEN LEN(MATKL) > 9 THEN 'NOK,  Longueur'
        ELSE 'OK'
    END AS contrôle_MATKL,

    KTEXT1, -- Description de l'article
    CASE
        WHEN LEN(KTEXT1) > 40 THEN 'NOK,  Longueur'
        ELSE 'OK'
    END AS contrôle_KTEXT1,

    MENGE, -- Quantité commandée
    CASE
        WHEN (ISNUMERIC(MENGE) <> 1 AND MENGE IS NOT NULL) THEN 'NOK, la format de MENGE n''est pas numérique'
             ELSE 'OK'
    END AS contrôle_MENGE,

    MEINS, -- Unité de mesure
    CASE
        WHEN MEINS NOT IN (SELECT MSEH3 from dgSAP_SP1_100.dbo.T006A where SPRAS='F')  THEN 'NOK, Verifier liste de valeur'
        WHEN LEN(MEINS) > 3 THEN 'NOK,  Longueur'
        ELSE 'OK'
    END AS contrôle_MEINS,

    NETWR, -- Montant net
    CASE
        WHEN (ISNUMERIC(NETWR) <> 1 AND NETWR IS NOT NULL) THEN 'NOK, la format de MENGE n''est pas numérique'
        ELSE 'OK'
    END AS contrôle_NETWR
FROM PurchaseOrder_Lignesservices
GO


