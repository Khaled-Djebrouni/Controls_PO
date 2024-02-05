USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[contrôle_PurchaseOrder_Unités_de_mesures]    Script Date: 05.02.2024 8:44:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[contrôle_PurchaseOrder_Unités_de_mesures]
AS
select	EBELN, 
		EBELP, 
		MEINS_PO, 
		MSEH3 
from	(	select		EBELN, 
						EBELP, 
						MATNR, 
						SAP_CODE, 
						MEINS as MEINS_PO
			from		PurchaseOrder_Postes
			left join	sdbBackup_Material.dbo.BACKUP_External_Number legacy
			on			CONCAT(WERKS, '_', MATNR) = ANCIEN_CODE 
			where		MATNR is not null and 
						MEINS is not null		) res
inner join	V_MATERIAL_SAP
ON			concat('00000000', res.SAP_CODE) = V_MATERIAL_SAP.MATNR
WHERE		MEINS_PO <> MSEH3







--select * from sdbBackup_Material.dbo.BACKUP_External_Number
--select * from V_MATERIAL_SAP
GO


