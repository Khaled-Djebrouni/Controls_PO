USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[contrôle_PurchaseOrder_Lignesservices_erreur]    Script Date: 05.02.2024 8:38:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE   view   [dbo].[contrôle_PurchaseOrder_Lignesservices_erreur] as select * from contrôle_PurchaseOrder_Lignesservices where
--contrôle_EBELN like '%NOK%' OR
contrôle_EBELN_EBELP like '%NOK%' OR
contrôle_MATKL like '%NOK%' OR
contrôle_KTEXT1 like '%NOK%' OR
contrôle_MENGE like '%NOK%' OR
contrôle_MEINS like '%NOK%' OR
contrôle_NETWR like '%NOK%'
GO


