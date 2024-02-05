USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[contrôle_PurchaseOrder_Imputations]    Script Date: 05.02.2024 8:36:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/* Auteur : DJEBROUNI Khaled */

CREATE VIEW [dbo].[contrôle_PurchaseOrder_Imputations] AS 
SELECT
    PO_I.EBELN, -- Numéro de commande d'achat
     PO_I.EBELP, -- Numéro de poste de commande d'achat
    CASE
        WHEN CONCAT(PO_I.EBELN, RIGHT('00000'+PO_I.EBELP,5))  NOT IN 
		(SELECT CONCAT(POP.EBELN, RIGHT('00000'+POP.EBELP,5)) FROM PurchaseOrder_Postes) 
		THEN 'NOK, valeur hors liste'
        
		WHEN LEN(PO_I.EBELP) > 5 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_EBELN_EBELP,

    ZEKKN, -- Numéro d'imputation
    CASE
        WHEN (ISNUMERIC(ZEKKN) <> 1 AND ZEKKN IS NOT NULL) THEN 'NOK, Pas Numérique'
        WHEN LEN(ZEKKN) > 2 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_ZEKKN,

    PO_I.MENGE, -- Quantité imputée
    CASE
        WHEN (ISNUMERIC(PO_I.MENGE) <> 1 AND PO_I.MENGE IS NOT NULL) THEN 'NOK, Pas Numérique'
        ELSE 'OK'
    END AS contrôle_MENGE,

    POP.KNTTP, -- Catégorie d'imputation
    PS_PSP_PNR, -- Numéro de projet / Numéro de poste

    CASE
        WHEN (PS_PSP_PNR IS NULL OR PS_PSP_PNR = '') AND POP.KNTTP = 'P' THEN 'NOK, Obligatoire'
        WHEN (ISNUMERIC(PS_PSP_PNR) <> 1 AND PS_PSP_PNR IS NOT NULL) THEN 'NOK, Pas Numérique'
        WHEN LEN(PS_PSP_PNR) > 8 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_PS_PSP_PNR,

    NPLNR, -- Numéro de réseau
    CASE
        WHEN ((NPLNR IS NULL OR NPLNR = '') AND POP.KNTTP = 'N') OR ((NPLNR IS NULL OR NPLNR = '') AND POP.KNTTP = 'P' AND (PS_PSP_PNR IS NULL OR PS_PSP_PNR = '')) THEN 'NOK, Obligatoire'
        WHEN LEN(NPLNR) > 12 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_NPLNR,

    VORNR, -- Numéro d'opération
    CASE
        WHEN (VORNR IS NULL OR VORNR = '') AND POP.KNTTP = 'N' THEN 'NOK, Obligatoire'
        WHEN LEN(VORNR) > 4 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_VORNR,

    ANLN1, -- Numéro d'Asset
    CASE
        WHEN (ANLN1 IS NULL OR ANLN1 = '') AND POP.KNTTP = 'A' THEN 'NOK, Obligatoire'
        WHEN LEN(ANLN1) > 12 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_ANLN1,

    AUFNR, -- Numéro d'ordre OT
    CASE
        WHEN (AUFNR IS NULL OR AUFNR = '') AND POP.KNTTP = 'F' THEN 'NOK, Obligatoire'
        WHEN LEN(AUFNR) > 12 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_AUFNR,

    KOSTL, -- Centre de coût
    CASE
        WHEN (KOSTL IS NULL OR KOSTL = '') AND POP.KNTTP = 'K' THEN 'NOK, Obligatoire'
        WHEN LEN(KOSTL) > 10 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_KOSTL

FROM PurchaseOrder_Imputations PO_I
LEFT JOIN PurchaseOrder_Postes POP 

ON CONCAT(PO_I.EBELN, RIGHT('00000'+PO_I.EBELP,5)) 
= CONCAT(POP.EBELN, RIGHT('00000'+POP.EBELP,5))

GO


