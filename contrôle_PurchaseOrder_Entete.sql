USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[contrôle_PurchaseOrder_Entete]    Script Date: 05.02.2024 8:35:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--sdbRollout_MM 
--sdbPILOT3_MM

CREATE VIEW [dbo].[contrôle_PurchaseOrder_Entete] AS 
SELECT
    EBELN, -- Numéro de commande d'achat
    CASE
        WHEN EBELN IS NULL OR EBELN = '' THEN 'NOK, Obligatoire'
		WHEN EBELN NOT IN ( SELECT EBELN FROM PurchaseOrder_Postes) THEN 'NOK, commande n’a pas de postes'
        ELSE 'OK'
    END AS contrôle_EBELN,

    UNSEZ, -- Numéro de contrat-cadre
    CASE
        WHEN UNSEZ IS NULL OR UNSEZ = '' THEN 'NOK, Obligatoire'
        WHEN LEN(UNSEZ) > 12 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_UNSEZ,

    IHREZ, -- Numéro de commande client
    CASE
        WHEN LEN(IHREZ) > 12 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_IHREZ,

    BSART, -- Type de document d'achat
    CASE
        WHEN BSART IS NULL OR BSART = '' THEN 'NOK, Obligatoire'
        WHEN BSART NOT IN (	SELECT BSART FROM dgSAP_SP1_100.dbo.T161 ) THEN 'NOK, valeur hors liste'
        WHEN LEN(BSART) > 4 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_BSART,

	PO.LIFNR, -- Numéro de fournisseur
    CASE
        WHEN PO.LIFNR IS NULL OR PO.LIFNR = '' THEN 'NOK, Obligatoire'
        WHEN Sup.LIFNR IS NULL THEN 'NOK, ce fournisseur n''a pas été créé'
        WHEN Sup2.LIFNR IS NULL THEN 'NOK, ce fournisseur n''a pas été extexionné'
        ELSE 'OK'
    END AS contrôle_LIFNR,

    PO.BUKRS, -- Code de la société
    CASE
        WHEN PO.BUKRS IS NULL OR PO.BUKRS = '' THEN 'NOK, Obligatoire'
        WHEN PO.BUKRS NOT IN (	SELECT BUKRS FROM dgSAP_SP1_100.dbo.T001	) THEN 'NOK, valeur hors liste'
        WHEN LEN(PO.BUKRS) > 4 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_BUKRS,

    EKORG, -- Organisation d'achat
    CASE
        WHEN EKORG IS NULL OR EKORG = '' THEN 'NOK, Obligatoire'
        WHEN EKORG NOT IN ( SELECT * FROM _PurchasingOrganization ) THEN 'NOK, valeur hors liste'
        WHEN LEN(EKORG) > 4 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_EKORG,

    EKGRP, -- Groupe d'acheteurs
    CASE
        WHEN EKGRP IS NULL OR EKGRP = '' THEN 'NOK, Obligatoire'
        WHEN EKGRP NOT IN (	SELECT EKGRP FROM dgSAP_SP1_100.dbo.T024	) THEN 'NOK, valeur hors liste'
        WHEN LEN(EKGRP) > 3 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_EKGRP,

    ZTERM, -- Conditions de paiement
    CASE
        WHEN ZTERM NOT IN (	SELECT * FROM _PaymentTerms	) THEN 'NOK, valeur hors liste'
        WHEN LEN(ZTERM) > 4 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_ZTERM,

    WAERS, -- Devise
    CASE
        WHEN WAERS NOT IN (	SELECT Devise FROM _FieldRuleCurrencyList	) THEN 'NOK, valeur hors liste'
        WHEN LEN(WAERS) > 5 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_WAERS,

    DATE_CONTRAT, -- Date du contrat
	CASE 
        WHEN WAERS <> 'DZD' THEN --Obligatoire si devise différente de DZD
            CASE
                WHEN DATE_CONTRAT IS NULL OR DATE_CONTRAT = '' THEN 'NOK, Obligatoire si devise différente de DZD'
                WHEN ISDATE(Substring(DATE_CONTRAT, 7, 4) +Substring(DATE_CONTRAT, 4, 2)+ Substring(DATE_CONTRAT, 1, 2)) <> 1 THEN 'NOK, Format Date Non DD.MM.YYYY'
				ELSE 'OK'
            END
        WHEN DATE_CONTRAT IS NULL OR DATE_CONTRAT = '' THEN 'OK'
		WHEN ISDATE(Substring(DATE_CONTRAT, 7, 4) +Substring(DATE_CONTRAT, 4, 2)+ Substring(DATE_CONTRAT, 1, 2)) <> 1 THEN 'NOK, Format Date Non DD.MM.YYYY'
		ELSE 'OK'
    END AS contrôle_DATE_CONTRAT,
   

    WKURS, -- Taux de change
    CASE
        WHEN ((WKURS IS NULL OR WKURS = '') AND WAERS <> 'DZD') THEN 'NOK, Obligatoire'
        WHEN (ISNUMERIC(WKURS) <> 1 AND WKURS IS NOT NULL) THEN 'NOK, Pas Numérique'
        ELSE 'OK'
    END AS contrôle_WKURS,

    INCO1, -- Incoterm 1
    CASE
        WHEN WAERS IS NOT NULL AND WAERS <> 'DZD' AND INCO1 IS NULL 
		and EBELN in (select EBELN  from PurchaseContract_Postes where (PSTYP IS NULL and KNTTP IS NULL)
		or (PSTYP IS NULL and KNTTP='K' ))
		THEN 'NOK Obligatoire'
	    WHEN INCO1 NOT IN (	SELECT INCO1 FROM dgSAP_SP1_100.dbo.TINC	) THEN 'NOK, valeur hors liste'
        WHEN LEN(INCO1) > 3 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_INCO1,

    INCO2_L, -- Incoterm 2 (Long)
    CASE
        WHEN WAERS IS NOT NULL AND WAERS <> 'DZD' AND INCO2_L IS NULL 
		and EBELN in (	select EBELN  from PurchaseOrder_Postes where (PSTYP IS NULL and KNTTP IS NULL)
		or (PSTYP IS NULL and KNTTP='K'))
		THEN 'NOK Obligatoire'
        WHEN LEN(INCO2_L) > 70 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_INCO2_L,

    RETPC, -- Remise en %
    CASE
        WHEN (ISNUMERIC(RETPC) <> 1 AND RETPC IS NOT NULL) THEN 'NOK, Pas Numérique'
        ELSE 'OK'
    END AS contrôle_RETPC,

    DPPCT, -- Paiement anticipé en %
    CASE
        WHEN (ISNUMERIC(DPPCT) <> 1 AND DPPCT IS NOT NULL) THEN 'NOK, Pas Numérique'
        ELSE 'OK'
    END AS contrôle_DPPCT,

    DPAMT, -- Montant du paiement anticipé
    CASE
        WHEN (ISNUMERIC(DPAMT) <> 1 AND DPAMT IS NOT NULL) THEN 'NOK, Pas Numérique'
         ELSE 'OK'
    END AS contrôle_DPAMT,

    DPDAT, -- Date du paiement anticipé
	CASE 
        WHEN DPDAT IS NULL OR DPDAT = '' THEN 'OK'
		WHEN ISDATE(Substring(DPDAT, 7, 4) +Substring(DPDAT, 4, 2)+ Substring(DPDAT, 1, 2)) <> 1 THEN 'NOK, Format Date Non DD.MM.YYYY'
		ELSE 'OK'
    END AS contrôle_DPDAT
FROM (PurchaseOrder_Entete PO
LEFT JOIN suppliers Sup
	ON ( PO.LIFNR = Sup.LIFNR OR RIGHT('0000000000' + PO.LIFNR, 10) = Sup.LIFNR ))
LEFT JOIN suppliers Sup2
	ON ( PO.LIFNR = Sup2.LIFNR OR RIGHT('0000000000' + PO.LIFNR, 10) = Sup2.LIFNR )
	AND (Sup2.BUKRS = PO.BUKRS)
GO


