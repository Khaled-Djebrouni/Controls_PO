USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[POThatCanBeLoad]    Script Date: 09.02.2024 18:57:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[POThatCanBeLoad] AS
SELECT EBELN FROM PurchaseOrder_entete
EXCEPT
(SELECT EBELN FROM contrôle_PurchaseOrder_Entete_erreur
UNION
SELECT EBELN FROM contrôle_PurchaseOrder_Textesentete_erreur
UNION
SELECT EBELN FROM contrôle_PurchaseOrder_Textesentete_erreur
UNION
SELECT EBELN FROM contrôle_PurchaseOrder_Conditionsentete_erreur
UNION
SELECT EBELN FROM Zcontrôle_PurchaseOrder_Postes_erreur
UNION
SELECT EBELN FROM contrôle_PurchaseOrder_Conditionsposte_erreur
UNION
SELECT EBELN FROM contrôle_PurchaseOrder_Lignesservices_erreur)
GO


