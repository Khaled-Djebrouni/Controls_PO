USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[contrôle_PurchaseOrder_Imputations_erreur]    Script Date: 05.02.2024 8:36:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





/*	
	author = DJEBROUNI Khaled
*/
CREATE view   [dbo].[contrôle_PurchaseOrder_Imputations_erreur] as select * from contrôle_PurchaseOrder_Imputations where
contrôle_EBELN_EBELP like '%NOK%' OR
contrôle_ZEKKN like '%NOK%' OR
contrôle_MENGE like '%NOK%' OR
contrôle_PS_PSP_PNR like '%NOK%' OR
contrôle_NPLNR like '%NOK%' OR
contrôle_VORNR like '%NOK%' OR
contrôle_ANLN1 like '%NOK%' OR
contrôle_AUFNR like '%NOK%' OR
contrôle_KOSTL like '%NOK%'
GO


