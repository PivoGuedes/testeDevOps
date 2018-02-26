CREATE FUNCTION CalculoComissao.fn_PagamentoPrestamista (@Data DATE)
RETURNS TABLE
AS

	RETURN
	WITH CTE
	AS
	(
		SELECT PRP.ID IDProposta
			 , PRP.NumeroProposta, C.NumeroCertificado, PRD.CodigoComercializado, PRP.IDFuncionario, PRP.IDSituacaoProposta
			 , PRP.DataArquivo DataEmissao, PRP.DataProposta, PRP.ValorPremioLiquidoEmissao
			 , PRP.TipoDado, 'PS0'+ LEFT(PRP.NumeroProposta,6) + RIGHT(PRP.NumeroProposta,7) + '_' PS
		--INTO #TMP
		FROM Dados.Certificado C
		INNER JOIN Dados.Proposta PRP
		ON PRP.ID = C.IDProposta
		INNER JOIN Dados.Produto PRD
		ON PRD.ID = PRP.IDProduto
		WHERE PRD.CodigoComercializado IN ('7705','7725')
		AND PRP.DataArquivo >= @Data
		--and prp.numeroproposta = '012209770208830'
		AND PRP.IDSeguradora = 1
	)
	SELECT CTE.IDProposta
	, CTE.NumeroProposta, CTE.NumeroCertificado, CTE.CodigoComercializado, COALESCE(CTE.IDFuncionario, PRP.IDFuncionario) IDFuncionario
	, CTE.DataEmissao, COALESCE(CTE.DataProposta, PRP.DataProposta) DataProposta, COALESCE(CTE.ValorPremioLiquidoEmissao, PRP.ValorPremioLiquidoEmissao) ValorPremioLiquidoEmissao
	, CTE.TipoDado, CASE WHEN PRP.NumeroProposta IS NOT NULL THEN 1 ELSE 0 END SIAPIX
	, PRP.NumeroProposta NumeroPropostaSIAPX, SP.Sigla [SiglaSituacao]
	FROM CTE
	LEFT JOIN Dados.Proposta PRP
	on  CTE.CodigoComercializado = '7705'
	AND PRP.NumeroProposta LIKE CTE.PS
	AND PRP.IDSeguradora = 1
	LEFT JOIN Dados.SituacaoProposta SP
	ON SP.ID = COALESCE(CTE.IDSituacaoProposta, PRP.IDSituacaoProposta) 
	--option(OPTIMIZE FOR UNKNOWN)
