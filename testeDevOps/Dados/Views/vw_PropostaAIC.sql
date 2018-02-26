

CREATE VIEW [Dados].[vw_PropostaAIC] 
AS

SELECT 
	(CASE WHEN P.IDContrato IS NOT NULL THEN 1 ELSE 0 END) AS Emitido,
	PROD.CodigoComercializado AS CodigoProdutoProposta,
	PROD.Descricao AS DescricaoProdutoProposta, 
	PS.CodigoProduto AS CodigoProdutoSIGPF,
	PS.Descricao AS DescricaoProdutoSIGPF, 
	U.Codigo AS CodigoAgencia,
	CV.Nome AS CanalVenda,
	TP.Descricao AS TipoPagamento,
	TPC.Codigo AS TipoContribuicao,
	PA.DataVenda,
	PA.HoraVenda, 
	PA.Matricula,
	PA.ValorPremio,
	PA.ValorContribuicaoGravidez,
	PA.ValorAporteInicial,
	PA.ValorContribuicaoMensal,
	PA.ValorContribuicaoPPC,
	PA.ValorContribuicaoPeculio,
	--PA.SupRede,
	--PA.NomeConsultor,
	--PA.Asven,
	PA.SOData,
	PA.Mes,
	PA.MatriculaIndicador,
	PA.DataArquivo
FROM Dados.PropostaAIC AS PA
INNER JOIN Dados.Proposta AS P
ON PA.IDProposta=P.ID
INNER JOIN Dados.ProdutoSIGPF AS PS
ON PS.ID=PA.IDProdutoSIGPF
INNER JOIN Dados.Unidade AS U
ON U.ID=PA.IDUnidade
LEFT OUTER JOIN Dados.TipoPagamentoAIC AS TP
ON TP.ID=PA.IDTipoPagamento
LEFT OUTER JOIN Dados.CanalVenda AS CV
ON CV.ID=PA.IDCanalVenda
LEFT OUTER JOIN Dados.TipoContribuicao AS TPC
ON TPC.ID=PA.IDTipoContribuicao
LEFT OUTER JOIN Dados.Produto AS PROD
ON PROD.ID=P.IDProduto
