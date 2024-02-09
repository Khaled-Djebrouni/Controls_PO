USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[contrôle_PurchaseOrder_Entete_erreur]    Script Date: 05.02.2024 8:35:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/*	
	author = DJEBROUNI Khaled
*/

CREATE view   [dbo].[contrôle_PurchaseOrder_Entete_erreur] as select * from contrôle_PurchaseOrder_Entete where
contrôle_EBELN like '%NOK%' OR
contrôle_UNSEZ like '%NOK%' OR
contrôle_IHREZ like '%NOK%' OR
contrôle_BSART like '%NOK%' OR
contrôle_LIFNR like '%NOK%' OR
contrôle_BUKRS like '%NOK%' OR
contrôle_EKORG like '%NOK%' OR
contrôle_EKGRP like '%NOK%' OR
contrôle_ZTERM like '%NOK%' OR
contrôle_WAERS like '%NOK%' OR
contrôle_DATE_CONTRAT like '%NOK%' OR
contrôle_WKURS like '%NOK%' OR
contrôle_INCO1 like '%NOK%' OR
contrôle_INCO2_L like '%NOK%' OR
contrôle_RETPC like '%NOK%' OR
contrôle_DPPCT like '%NOK%' OR
contrôle_DPAMT like '%NOK%' OR
contrôle_DPDAT like '%NOK%'
GO


