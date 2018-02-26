CREATE FUNCTION [Dados].[fn_RecuperaFaturamento_Auditoria](@DataInicio AS DATE, @DataFim AS DATE, @IDEmpresa INT)
RETURNS TABLE
AS
RETURN
WITH CTE
AS
(
SELECT FF.ID IDFilialFaturamento, FF.Codigo [CodigoFilialFaturamento], FF.Nome [NomeFilialFaturamento],
       YEAR(C.DataCompetencia) [AnoCompetencia], MONTH(C.DataCompetencia) [MesCompetencia],
	   C.DataRecibo [DataRecibo],
	   C.CodigoComercializado, C.Produto, C.IDRamoPAR, R.Codigo [CodigoRamo], R.Nome [Ramo],
       SUM(C.ValorCorretagem) ValorCorretagem ,
	   SUM(C.ValorPremioLiquido) ValorPremioLiquido, SUM(C.ValorComissao) ValorComissaoPAR, SUM(C.ValorRepasse) ValorRepasse --PRD.IDRamoPAR--, RP.Codigo [RamoFilho], RP.Nome [RamoFilho]	   
--into  #TEMP_RECUPERAAUDITORIA 
FROM dados.fn_RecuperaPreviaPROTHEUS ('1900-01-01', '9999-12-31', @IDEmpresa) C 
LEFT JOIN Dados.FilialFaturamento FF WITH (NOLOCK)
ON C.IDFilialFaturamento = FF.ID
LEFT JOIN Dados.Produto PRD WITH (NOLOCK)
ON PRD.ID = C.IDProduto
LEFT JOIN Dados.Ramo R WITH (NOLOCK)
ON R.ID = C.IDRamo
WHERE C.DataRecibo BETWEEN @DataInicio AND @DataFim
GROUP BY FF.ID , FF.Codigo , FF.Nome ,
       YEAR(C.DataCompetencia) , MONTH(C.DataCompetencia) ,
	   C.DataRecibo , MONTH(C.DataRecibo) , C.IDRamoPAR, 
	   c.CodigoComercializado, c.Produto , R.Codigo , R.Nome
)
SELECT CTE.*, rp.id [IDRamoPAR - Mestre], rp.Codigo [CodigoRamoPAR - Mestre], rp.Nome [NomeRamoPAR - Mestre]
FROM CTE 
cross apply Dados.fn_RecuperaRamoPAR_Mestre (CTE.IDRamoPAR) rp
