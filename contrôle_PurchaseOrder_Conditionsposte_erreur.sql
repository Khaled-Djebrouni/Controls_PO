USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[contrôle_PurchaseOrder_Conditionsposte_erreur]    Script Date: 05.02.2024 8:34:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE view   [dbo].[contrôle_PurchaseOrder_Conditionsposte_erreur] 
as select * from contrôle_PurchaseOrder_Conditionsposte where
contrôle_EBELN like '%NOK%' OR
contrôle_EBELN_EBELP like '%NOK%' OR
contrôle_KSCHL like '%NOK%' OR
contrôle_KBETR like '%NOK%'
GO


