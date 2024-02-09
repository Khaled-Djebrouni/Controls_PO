USE [sdbPILOT3_MM]
GO

/****** Object:  View [dbo].[Control_supplier_Errors]    Script Date: 09.02.2024 18:22:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[Control_supplier_Errors] AS
SELECT * FROM Control_supplier
WHERE
[Contrôle_LFA1.SPERR] LIKE '%NOK%'	OR
[Contrôle_LFA1.SPERM] LIKE '%NOK%'	OR
[Contrôle_SPERM] LIKE '%NOK%'
GO
