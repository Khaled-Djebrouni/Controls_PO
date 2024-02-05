USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[contrôle_PurchaseOrder_Postes_MEINS_erreur]    Script Date: 05.02.2024 8:40:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*	
	author = DJEBROUNI Khaled
*/
CREATE view   [dbo].[contrôle_PurchaseOrder_Postes_MEINS_erreur] as 
select * 
from contrôle_PurchaseOrder_Postes_MEINS 
where
contrôle_MEINS like '%NOK%'
GO


