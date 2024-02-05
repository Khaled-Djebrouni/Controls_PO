USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[contrôle_PurchaseOrder_Postes]    Script Date: 05.02.2024 8:39:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--sdbRollout_MM 
--sdbPILOT3_MM
CREATE VIEW [dbo].[contrôle_PurchaseOrder_Postes] AS 
SELECT
    EBELN, -- Numéro de commande d'achat
    CASE
        WHEN EBELN IS NULL OR EBELN = '' THEN 'NOK, Obligatoire'
        WHEN EBELN NOT IN (SELECT EBELN FROM PurchaseOrder_Entete) THEN 'NOK, PO n''existe pas dans l''entete'
		WHEN CONCAT(EBELN, RIGHT('00000'+EBELP,5)) IN ( SELECT CONCAT(EBELN, RIGHT('00000'+EBELP,5))
														FROM PurchaseOrder_Postes
														GROUP BY CONCAT(EBELN, RIGHT('00000'+EBELP,5))
														HAVING COUNT(*)>1	) THEN 'NOK, valeur de (EBELN, EBELP) en double'
        ELSE 'OK'
    END AS contrôle_EBELN,

    EBELP, -- Numéro de poste de commande d'achat
    CASE
        WHEN EBELP IS NULL OR EBELP = '' THEN 'NOK, Obligatoire'
        WHEN PSTYP = 'P' AND 
			 CONCAT(EBELN, RIGHT('00000'+CAST (EBELP as numeric),5)) NOT IN (
								SELECT	CONCAT(EBELN,RIGHT('00000'+CAST (EBELP as numeric),5)) 
								FROM	PurchaseOrder_Lignesservices) THEN 'NOK, Pas de lignes services'

		WHEN LEN(EBELP) > 5 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_EBELP,

    PSTYP, -- Type d'imputation
    CASE
        WHEN PSTYP NOT IN (SELECT * FROM _ItemCategory) THEN 'NOK, valeur hors liste'
        WHEN	LEN(PSTYP) > 1 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_PSTYP,

    KNTTP, -- Type d'imputation (peut être NULL)
    CASE
        WHEN LEN(KNTTP) > 1 THEN 'NOK, Longueur'
       	WHEN PSTYP IS NOT NULL and KNTTP IS NULL and PSTYP  <> 'A' THEN 'NOK, vérifier Type Imputation'
        ELSE 'OK'
    END AS contrôle_KNTTP,

    IMPOB, -- Imputation obligatoire (peut être NULL)
    CASE
        WHEN KNTTP IS NOT NULL AND IMPOB IS NULL THEN 'NOK,Objet Imputation Obligatoire'
		WHEN KNTTP = 'K'AND IMPOB NOT IN ( SELECT KOSTL FROM   dgSAP_SP1_100.dbo.CSKS ) THEN 'NOK, Centre de cout inexistant'
		WHEN KNTTP = 'P'AND IMPOB NOT IN ( SELECT POSID_EDIT FROM   dgSAP_SP1_100.dbo.PRPS ) THEN 'NOK, Verifier OTP'
		WHEN KNTTP = 'F'AND IMPOB NOT IN ( SELECT AUFNR FROM   dgSAP_SP1_100.dbo.AFIH ) THEN 'NOK, Verifier OT'
		WHEN KNTTP = 'A'AND IMPOB NOT IN ( SELECT ANLN1 FROM   dgSAP_SP1_100.dbo.ANLA ) THEN 'NOK, Verifier Asset'
	    ELSE 'OK'
    END AS contrôle_IMPOB,

    PO_P.MATNR, -- Numéro de matériel (peut être NULL)
    CASE
        WHEN	PSTYP IS NULL AND KNTTP IS NULL AND PO_P.MATNR IS NULL THEN 'NOK, Code Article Stk Obligatoire'
        WHEN	PSTYP IS NULL AND 
				KNTTP IS NULL AND 
				PO_P.MATNR IS NOT NULL AND 
				concat(PO_P.WERKS,'_',PO_P.MATNR) NOT IN (	SELECT	ANCIEN_CODE 
									FROM	sdbBackup_Material.dbo.BACKUP_External_Number
									WHERE MTART='ZAPP'	) THEN 'NOK, Article Stocké inexistant'

		WHEN	(PSTYP IS NOT NULL OR KNTTP IS NOT NULL ) AND 
				concat(PO_P.WERKS,'_',PO_P.MATNR)   IN (SELECT	ANCIEN_CODE 
								FROM	sdbBackup_Material.dbo.BACKUP_External_Number
								WHERE	MTART='ZAPP' ) THEN 'NOK, article stocké imputation doit etre vide '

		WHEN PSTYP IS NULL AND KNTTP='K' and PO_P.MATNR IS NULL then 'NOK, Renseigner Code Article Non stocké'
		WHEN	PSTYP IS NULL AND 
				KNTTP='K' AND 
				PO_P.MATNR IS NOT NULL AND 
				PO_P.MATNR  NOT IN	(	SELECT	ANCIEN_CODE
																FROM	sdbBackup_Material.dbo.BACKUP_External_Number
																WHERE	MTART='ZNST' ) THEN 'NOK, article Non Stocké Inexistant'
		WHEN KNTTP='A' and PO_P.MATNR IS NOT NULL then 'NOK, Fiche Asset'
		ELSE 'OK'
    END AS contrôle_MATNR,

    IDNLF, -- Numéro d'identification de la ligne (peut être NULL)
    CASE
        WHEN LEN(IDNLF) > 35 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_IDNLF,

    TXZ01, -- Description de l'article (peut être NULL)
    CASE
        WHEN (TXZ01 IS NULL OR TXZ01 = '') AND (PO_P.MATNR IS NULL OR PO_P.MATNR = '') THEN 'NOK, Obligatoire'
        WHEN (PO_P.MATNR IS NULL OR PO_P.MATNR = '') AND LEN(TXZ01) > 40 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_TXZ01,

    MENGE, -- Quantité commandée
    CASE
        WHEN MENGE IS NULL OR MENGE = '' THEN 'NOK, Obligatoire'
        WHEN (ISNUMERIC(MENGE) <> 1 AND MENGE IS NOT NULL) THEN 'NOK, Pas Numérique'
		WHEN PSTYP='P' and MENGE<> '1' THEN 'NOK, Servcie Qte =1'
        ELSE 'OK'
    END AS contrôle_MENGE,

    PO_P.MEINS, -- Unité de mesure de la quantité commandée
    CASE
        WHEN	PO_P.MATNR IS NULL AND 
				PO_P.MEINS NOT IN (SELECT MSEH3 from dgSAP_SP1_100.dbo.T006A where SPRAS='F')
				THEN 'NOK, valeur hors liste'
		WHEN PO_P.MATNR IS NOT NULL AND 
			 PSTYP IS NULL AND 
			 PO_P.MEINS NOT IN (SELECT MSEH3 from dgSAP_SP1_100.dbo.T006A where SPRAS='F')
			 THEN 'NOK,  valeur hors liste'
        -- Si code article, il faut vérifier si la même unité de mesure est utilisée (Préciser la table article)
        WHEN PO_P.MATNR IS NOT NULL AND 
			 PSTYP IS NULL AND 
			 PO_P.MEINS <> MSEH3
			 THEN 'NOK, Vérifier Unité de base de l''article'
		WHEN PSTYP='P' and PO_P.MEINS<>'UO' THEN 'NOK, MEINS = UO'
        ELSE 'OK'
    END AS contrôle_MEINS,
   
    UMREZ, -- Numérateur de l'unité de mesure de la quantité (peut être NULL)
    CASE
        WHEN LEN(UMREZ) > 250 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_UMREZ,

    LMEIN, -- Dénominateur de l'unité de mesure de la quantité (peut être NULL)
    CASE
        WHEN LMEIN NOT IN (SELECT MSEH3 from dgSAP_SP1_100.dbo.T006A where SPRAS='F') THEN 'NOK, valeur hors liste'
        WHEN LEN(LMEIN) > 250 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_LMEIN,

    EINDT, -- Date de livraison
    CASE
        WHEN EINDT IS NULL OR EINDT = '' THEN 'NOK, Obligatoire'
        WHEN ISDATE(Substring(EINDT, 7, 4) +Substring(EINDT, 4, 2)+ Substring(EINDT, 1, 2)) <> 1 THEN 'NOK, Format Date Non DD.MM.YYYY'
        ELSE 'OK'
    END AS contrôle_EINDT,

	[Column15] as Compte_Legacy,
	CASE 
		WHEN	PSTYP IS NOT NULL and 
				[Column15] IS NULL AND
				PO_P.MATKL IS NULL
				then 'NOK, Verifier Compte Legacy' 
		END 
	as contrôle_Compte_Legacy,
	PO_P.MATKL, -- Groupe de matériel (peut être NULL)
    CASE
       WHEN (PO_P.MATNR IS NULL OR PO_P.MATNR = '') AND PO_P.MATKL IS NOT NULL AND PO_P.MATKL NOT IN ( select MATKL from dgSAP_SP1_100.dbo.T023 ) THEN 'NOK, valeur hors liste'
        WHEN LEN(PO_P.MATKL) > 9 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_MATKL,

    WERKS, -- Usine
    CASE
        WHEN WERKS IS NULL OR WERKS = '' THEN 'NOK, Obligatoire'
        WHEN WERKS NOT IN (	SELECT WERKS FROM dgSAP_SP1_100.dbo.T001W	) THEN 'NOK, valeur hors liste'
        WHEN LEN(WERKS) > 4 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_WERKS,

    LGORT, -- Lieu de stockage (peut être NULL)
    CASE
        WHEN LEN(LGORT) > 4 THEN 'NOK, Longueur'
        WHEN PSTYP IS NULL and KNTTP IS NULL AND LGORT NOT IN (SELECT LGORT FROM dgSAP_SP1_100.dbo.T001L ) THEN 'NOK, Vérifier Storage Location'
        WHEN  KNTTP IS NOT NULL AND LGORT <> WERKS THEN  'NOK, Vérifier Storage Location'
		ELSE 'OK'
    END AS contrôle_LGORT,

    BEDNR, -- Numéro de commande de l'acheteur (peut être NULL)
    CASE
        WHEN LEN(BEDNR) > 10 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_BEDNR,

    NETPR, -- Prix net (peut être NULL)
    CASE
        WHEN (PSTYP <>'P' AND PSTYP <>'A') AND NETPR IS NULL OR NETPR = '' THEN 'NOK, Obligatoire'
        WHEN (ISNUMERIC(NETPR) <> 1 AND NETPR IS NOT NULL) THEN 'NOK, Pas Numérique'
        WHEN PSTYP ='P' and NETPR IS NOT NULL then 'NOK, NETPR doit etre vide'  
		ELSE 'OK'
    END AS contrôle_NETPR,

    PEINH, -- Quantité de base (peut être NULL)
    CASE
        WHEN (ISNUMERIC(PEINH) <> 1 AND PEINH IS NOT NULL) THEN 'NOK, Pas Numérique'
        ELSE 'OK'
    END AS contrôle_PEINH,

    KONNR, -- Numéro de contrat cadre
	CASE
        WHEN Len(KONNR) > 10 THEN 'NOK, Longueur dépasser 10'
        ELSE 'OK'
    END AS contrôle_KONNR,
 
    KTPNR, -- Numéro de commande de l'acheteur (peut être NULL)
    CASE
        WHEN (ISNUMERIC(KTPNR) <> 1 AND KTPNR IS NOT NULL) THEN 'NOK, Pas Numérique'
        WHEN LEN(KTPNR) > 5 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_KTPNR,

    MWSKZ, -- Taxe code (Obligatoire)
    CASE
        WHEN MWSKZ IS NULL OR MWSKZ = '' THEN 'NOK, Obligatoire'
        WHEN MWSKZ NOT IN (SELECT * FROM _TaxCode) THEN 'NOK, valeur hors liste'
        WHEN LEN(MWSKZ) > 2 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_MWSKZ,

    TEXT, -- Texte de poste (peut être NULL)
    CASE
        WHEN LEN(TEXT) > 250 THEN 'NOK, Longueur'
        ELSE 'OK'
    END AS contrôle_TEXT,

    RETPC, -- Pourcentage de réduction (peut être NULL)
    CASE
        WHEN (ISNUMERIC(RETPC) <> 1 AND RETPC IS NOT NULL) THEN 'NOK, Pas Numérique'
        ELSE 'OK'
    END AS contrôle_RETPC,

    DPPCT, -- Pourcentage de paiement (peut être NULL)
    CASE
        WHEN (ISNUMERIC(DPPCT) <> 1 AND DPPCT IS NOT NULL) THEN 'NOK, Pas Numérique'
        ELSE 'OK'
    END AS contrôle_DPPCT,

    DPAMT, -- Montant de paiement (peut être NULL)
    CASE
        WHEN (ISNUMERIC(DPAMT) <> 1 AND DPAMT IS NOT NULL) THEN 'NOK, Pas Numérique'
        ELSE 'OK'
    END AS contrôle_DPAMT,

    DPDAT, -- Date de paiement (peut être NULL)
	CASE 
        WHEN DPDAT IS NULL OR DPDAT = '' THEN 'OK'
		WHEN ISDATE(Substring(DPDAT, 7, 4) +Substring(DPDAT, 4, 2)+ Substring(DPDAT, 1, 2)) <> 1 THEN 'NOK, Format Date Non DD.MM.YYYY'
		ELSE 'OK'
    END AS contrôle_DPDAT
    
FROM		PurchaseOrder_Postes PO_P
LEFT JOIN	sdbBackup_Material.dbo.BACKUP_External_Number NumTab
			ON (	ANCIEN_CODE=concat(PO_P.WERKS,'_',PO_P.MATNR)	OR	ANCIEN_CODE=PO_P.MATNR)
LEFT JOIN	sdbPILOT3_MM.dbo.V_MATERIAL_SAP MatSap
			ON CONCAT('00000000', NumTab.SAP_CODE) = MatSap.MATNR
			AND MatSap.MATNR LIKE '%000000002%'
GO


