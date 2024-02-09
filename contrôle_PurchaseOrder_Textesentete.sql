USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[contrôle_PurchaseOrder_Textesentete]    Script Date: 05.02.2024 8:43:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--sdbRollout_MM 
--sdbPILOT3_MM

CREATE VIEW [dbo].[contrôle_PurchaseOrder_Textesentete] AS
SELECT
    EBELN, -- Numéro de commande d'achat
    CASE
        WHEN EBELN IS NULL OR EBELN = '' THEN 'NOK Obligatoir'
        WHEN EBELN NOT IN (SELECT EBELN FROM PurchaseOrder_Entete) THEN 'NOK valeur hors liste'
        ELSE 'OK'
    END AS contrôle_EBELN,

    TDID, -- Identifiant de texte
    CASE
        WHEN TDID NOT IN (SELECT * FROM _TextID) THEN 'NOK valeur hors liste'
        WHEN LEN(TDID) > 250 THEN 'NOK Longueur'
		WHEN CONCAT(EBELN, TDID) IN (	SELECT	CONCAT(EBELN, TDID)
										FROM	PurchaseOrder_Textesentete
										GROUP BY CONCAT(EBELN, TDID)
										HAVING	COUNT(*)>1	) THEN 'NOK, valeur de (EBELN, TDID) en double'
        ELSE 'OK'
    END AS contrôle_TDID,

    TEXT, -- Texte de l'entête de la commande
    CASE
        WHEN LEN(TEXT) > 250 THEN 'NOK Longueur'
        ELSE 'OK'
    END AS contrôle_TEXT
FROM PurchaseOrder_Textesentete
GO


