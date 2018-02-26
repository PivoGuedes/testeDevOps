
CREATE VIEW [Marketing].[vw_prev_BEMFAMILIA]
AS

SELECT
 PRP1.NumeroProposta
, PRP.NumeroCertificado
, PRP.DataEmissao
, PRP.DataInicio
, PRP.DataFim
, PRP.DataAprovacao
, PRP.DataVencimento
, PRP.DataPagamento
, PRP.ValorVenda
, PRP.ValorInicial
, FI.Descricao AS Filial
, ST.Descricao AS [Status]
, SBS.Descricao AS SubStatus
, B.Descricao AS Beneficio
, P.Descricao AS ProdutoDescricao
, P.Codigo AS ProdutoCodigo
, U.Codigo AS AgenciaCodigo
, FU.Matricula AS MatriculaIndicador
FROM Dados.Previdencia_BemFamilia AS PRP
		INNER JOIN Dados.Proposta PRP1
ON PRP.IDProposta = PRP1.id
AND PRP1.IDSeguradora = 4
INNER JOIN Dados.FilialPrevBemFamilia AS FI
ON FI.id=PRP.idFilial
INNER JOIN Dados.StatusPrevidenciaBemFamilia AS ST
ON ST.ID=PRP.IDStatus
INNER JOIN Dados.SubStatusPrevidenciaBemFamilia AS SBS
ON SBS.ID=PRP.[idSubStatus]
INNER JOIN Dados.BeneficioPrevBemFamilia AS B
ON B.ID=PRP.IDBeneficio
INNER JOIN Dados.ProdutoKIPREV AS P
ON P.ID=PRP.IDPRODUTO
INNER JOIN Dados.Unidade AS U
ON U.ID=PRP.IDAgencia
INNER JOIN Dados.Funcionario AS FU
ON FU.id=PRP.idindicador


