USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[contrôle_PurchaseOrder_Postes_Numérotation]    Script Date: 05.02.2024 8:40:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[contrôle_PurchaseOrder_Postes_Numérotation] AS
SELECT
    EBELN, -- Numéro de commande d'achat
    EBElP, -- Numéro de poste de commande d'achat

    CASE
        WHEN ROW_NUMBER() OVER (PARTITION BY EBELN ORDER BY RIGHT('00000' + EBElP, 5) ASC) * 10 <> CAST(EBElP AS INT) 
		THEN 'NOK, Verifier Numéro Poste'
        ELSE 'OK'
    END AS Controle_Numéro_Poste
FROM PurchaseOrder_Postes
GO


