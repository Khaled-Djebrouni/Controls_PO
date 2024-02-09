USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[contrôle_PurchaseOrder_Textesentete_erreur]    Script Date: 05.02.2024 8:43:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*	
	author = DJEBROUNI Khaled
*/
CREATE view   [dbo].[contrôle_PurchaseOrder_Textesentete_erreur] as select * from contrôle_PurchaseOrder_Textesentete where
contrôle_EBELN like '%NOK%' OR
contrôle_TDID like '%NOK%' OR
contrôle_TEXT like '%NOK%'
GO


