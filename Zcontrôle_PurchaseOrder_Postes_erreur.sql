USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[Zcontrôle_PurchaseOrder_Postes_erreur]    Script Date: 05.02.2024 8:47:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW   [dbo].[Zcontrôle_PurchaseOrder_Postes_erreur] as 
SELECT * 
FROM Zcontrôle_PurchaseOrder_Postes 
WHERE
contrôle_EBELN like '%NOK%' OR
contrôle_EBELP like '%NOK%' OR
--contrôle_NUM_CAS like '%NOK%' OR
contrôle_PSTYP like '%NOK%' OR
contrôle_KNTTP like '%NOK%' OR
contrôle_IMPOB like '%NOK%' OR
contrôle_MATNR like '%NOK%' OR
contrôle_MATNR like '%Véri%' OR
contrôle_IDNLF like '%NOK%' OR
contrôle_TXZ01 like '%NOK%' OR
contrôle_MENGE like '%NOK%' OR
contrôle_MEINS like '%NOK%' OR
contrôle_UMREZ like '%NOK%' OR
contrôle_LMEIN like '%NOK%' OR
contrôle_EINDT like '%NOK%' OR
contrôle_Compte_Legacy like '%NOK%' OR
contrôle_WERKS like '%NOK%' OR
contrôle_LGORT like '%NOK%' OR
contrôle_BEDNR like '%NOK%' OR
contrôle_NETPR like '%NOK%' OR
contrôle_PEINH like '%NOK%' OR
contrôle_KONNR like '%NOK%' OR
contrôle_KTPNR like '%NOK%' OR
contrôle_MWSKZ like '%NOK%' OR
contrôle_TEXT like '%NOK%' OR
contrôle_RETPC like '%NOK%' OR
contrôle_DPPCT like '%NOK%' OR
contrôle_DPAMT like '%NOK%' OR
contrôle_DPDAT like '%NOK%'
GO
