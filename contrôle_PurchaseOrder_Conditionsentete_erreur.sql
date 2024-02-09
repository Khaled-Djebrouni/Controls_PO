USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[contrôle_PurchaseOrder_Conditionsentete_erreur]    Script Date: 05.02.2024 8:33:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE view   [dbo].[contrôle_PurchaseOrder_Conditionsentete_erreur] as select * from contrôle_PurchaseOrder_Conditionsentete where
contrôle_EBELN like '%NOK%' OR
contrôle_KSCHL like '%NOK%' OR
contrôle_KBETR like '%NOK%'
GO


