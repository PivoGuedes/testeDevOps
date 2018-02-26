CREATE PROCEDURE [Indicadores].[proc_ParcelaPagamentoPrestamista] @DataInicioEmissao date, @DataFimEmissao date
--RETURNS TABLE
AS

----	RETURN
--	WITH CTE
--	AS
--	(
--		SELECT PRP.ID IDProposta
--			 , PRP.NumeroProposta, C.NumeroCertificado, PRD.CodigoComercializado, PRP.IDFuncionario
--			 , PRP.DataArquivo DataEmissao, PRP.DataProposta, PRP.ValorPremioLiquidoEmissao
--			 , PRP.TipoDado, 'PS0'+ LEFT(PRP.NumeroProposta,6) + RIGHT(PRP.NumeroProposta,7) + '_' PS
--		--INTO #TMP
--		FROM Dados.Certificado C
--		INNER JOIN Dados.Proposta PRP
--		ON PRP.ID = C.IDProposta
--		INNER JOIN Dados.Produto PRD
--		ON PRD.ID = PRP.IDProduto
--		WHERE PRD.CodigoComercializado IN ('7705','7725')
--		AND PRP.DataArquivo BETWEEN @DataInicioEmissao AND @DataFimEmissao  --  '2016-01-01' and '2016-01-31'--
--		--and prp.numeroproposta = '012209770208830'
--		AND PRP.IDSeguradora = 1
--	)
--	SELECT CTE.IDProposta
--	, CTE.NumeroProposta, CTE.NumeroCertificado, CTE.CodigoComercializado, COALESCE(CTE.IDFuncionario, PRP.IDFuncionario) IDFuncionario, fu.Matricula Matricula
--	, CTE.DataEmissao, COALESCE(CTE.DataProposta, PRP.DataProposta) DataProposta, COALESCE(CTE.ValorPremioLiquidoEmissao, PRP.ValorPremioLiquidoEmissao) ValorPremioLiquidoEmissao
--	, CTE.TipoDado, CASE WHEN PRP.NumeroProposta IS NOT NULL THEN 1 ELSE 0 END SIAPIX
--	, PRP.NumeroProposta NumeroPropostaSIAPIX
--	, U.Codigo AS CodigoAgencia
--	FROM CTE
--	LEFT JOIN Dados.Proposta PRP
--	on  CTE.CodigoComercializado = '7705'
--	AND PRP.NumeroProposta LIKE CTE.PS
--	AND PRP.IDSeguradora = 1
--	LEFT JOIN Dados.Funcionario as fu
--	on fu.id = PRP.IDFuncionario
--	LEFT JOIN Dados.Unidade AS U
--	ON U.ID=PRP.IDAgenciaVenda 
--	WHERE  PRP.IDContrato<>5134234
--	OPTION(OPTIMIZE FOR UNKNOWN)


----exec [Indicadores].[proc_ParcelaPagamentoPrestamista] @DataInicioEmissao='2016-01-01', @DataFimEmissao='2016-12-31'


--GO

;with prp as (
SELECT  p.Id
FROM Dados.Contrato C
INNER JOIN Dados.Proposta p on p.IDContrato = C.ID
where NumeroContrato in('107700000011',
'103701139293',
'107700000013',
'107700000024',
'107700000027',
'103701139296')
and p.DataArquivo BETWEEN @DataInicioEmissao AND @DataFimEmissao
) select  p.ID IDProposta
			 , p.NumeroProposta, C.NumeroCertificado, pd.CodigoComercializado, p.IDFuncionario
			 , p.DataArquivo DataEmissao, p.DataProposta, p.Valor as ValorPremioLiquidoEmissao,
			 p.ID as IDProposta,P.NumeroProposta NumeroPropostaSIAPIX, 0 SIAPIX,
	p.IDFuncionario ,fu.Matricula Matricula
	
	, U.Codigo AS CodigoAgencia
from Dados.Proposta p 
inner join prp on prp.Id = p.Id
inner join  Dados.Produto pd on  pd.ID = p.IDProduto
left join  Dados.Certificado c on c.IDProposta = p.Id
LEFT JOIN Dados.Funcionario as fu
	on fu.id = p.IDFuncionario
	LEFT JOIN Dados.Unidade AS U
	ON U.ID=p.IDAgenciaVenda 
	where pd.CodigoComercializado IN ('7705','7725')
