CREATE PROCEDURE [Relatorio].[proc_RecuperaRelatorioComissaoMR] (@DataInicial date, @DataFinal date)

AS

SELECT  
		CO.NumeroContrato [Apolice]
		, C.NumeroEndosso [Endosso]
		, C.NumeroRecibo
		, P.CodigoComercializado
		, P.Descricao [Produto]
		, C.DataRecibo
		, C.ValorBase
		, C.ValorComissaoPAR
		, C.NumeroParcela
		, E.Nome [Empresa]
FROM Dados.Comissao_Partitioned C
INNER JOIN Dados.Contrato CO
ON C.IDContrato = CO.ID
INNER JOIN Dados.Produto P
ON C.IDProduto = P.ID
LEFT JOIN Dados.Empresa E
ON C.IDEmpresa = E.ID
WHERE P.CodigoComercializado IN ('1804', '6700', '7114')
AND C.DataRecibo BETWEEN @DataInicial AND @DataFinal
GROUP BY
		CO.NumeroContrato
		, C.NumeroEndosso
		, C.NumeroRecibo
		, P.CodigoComercializado
		, P.Descricao
		, C.DataRecibo
		, C.ValorBase
		, C.ValorComissaoPAR
		, C.NumeroParcela
		, E.Nome
ORDER BY c.DataRecibo, co.NumeroContrato, c.NumeroRecibo, c.NumeroEndosso 

