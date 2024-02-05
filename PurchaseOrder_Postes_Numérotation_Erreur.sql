USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[contrôle_PurchaseOrder_Postes_Numérotation_Erreur]    Script Date: 05.02.2024 8:43:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*	
	author = DJEBROUNI Khaled
*/
CREATE view [dbo].[contrôle_PurchaseOrder_Postes_Numérotation_Erreur] as
select * from contrôle_PurchaseOrder_Postes_Numérotation
where Controle_Numéro_Poste like '%NOK%'
GO


