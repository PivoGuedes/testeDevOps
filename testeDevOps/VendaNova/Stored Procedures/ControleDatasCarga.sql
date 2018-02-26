
CREATE PROCEDURE [VendaNova].[ControleDatasCarga] AS

BEGIN

/* INSERE A DATA DE INICIO E FIM QUE SERÃO UTILIZADAS NO SCRIPT DO SSIS */
TRUNCATE TABLE [Corporativo].[VendaNova].[DefinicaoDataInicioFimCarga]
INSERT INTO [Corporativo].[VendaNova].[DefinicaoDataInicioFimCarga]
SELECT TOP 1
	 DIC.[DataInicioCarga]
	,DIC.[DataFimCarga]
FROM [DW].[STG_DM_VendaNova].[ControleDados].[DefinicaoDataInicioFimCarga] DIC
ORDER BY [IDDataCarga] DESC

END

