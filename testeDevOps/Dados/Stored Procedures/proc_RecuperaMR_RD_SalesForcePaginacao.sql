CREATE PROCEDURE [Dados].[proc_RecuperaMR_RD_SalesForcePaginacao] 	@NumeroPagina bigINT,@QuantidadeRegistros bigint

AS
SET @NumeroPagina  -= 1
--PRINT @NumeroPagina

--SET @cpf = '004.996.271-05'
--SET @cpf = '832.737.941-00'
--SET @cpf = '024.082.171-80'
--SET STATISTICS IO on

--SET @cpf = '004.996.271-05'
--SET @cpf = '832.737.941-00'
--SET @cpf = '024.082.171-80'
;WITH autom AS (
SELECT  
p.NumeroProposta, p.DataProposta,p.DataInicioVigencia,COALESCE(c.DataFimVigencia,p.DataFimVigencia) AS DataFimVigencia,
		c.NumeroContrato,COALESCE(pr.ValorPrimeiraParcela+((pr.QuantidadeParcelas-1)*pr.ValorDemaisParcelas),c.ValorPremioTotal) ValorPremioTotal,pd.CodigoComercializado,p.ValorPremioBrutoEmissao,
		pd.Descricao,coalesce(p.IDProduto,e.idproduto) IDproduto,c.ID,p.id AS idproposta,c.QuantidadeParcelas,c.DataEmissao,pen.Endereco + ' ' + pen.bairro + ' ' + pen.Cidade + ' ' + pen.UF AS Identificacao
		--,c.ValorPremioTotal
		--,e.QuantidadeParcelas,COALESCE(pa.ValorPrimeiraParcela,pg.ValorPrimeiraParcela) AS ValorPrimeiraParcela,
		----e.ValorPremioTotal-pa.ValorPrimeiraParcela AS ValorParcelas,
		--pg2.ValorDemaisParcelas
		----p.ValorPremioBrutoEmissao,pg.ValorPrimeiraParcela,pg2.*,p.id,*
FROM dados.contrato c
INNER JOIN dados.endosso e ON e.idcontrato = c.ID
INNER JOIN Dados.PropostaEndereco pen ON pen.idproposta = c.IDProposta AND pen.LastValue = 1 AND pen.idtipoendereco = 1
LEFT JOIN  dados.proposta p  ON c.IDProposta = p.ID 
left JOIN Dados.PropostaCliente pc 
ON pc.IDProposta = p.ID
left JOIN dados.propostaresidencial pr ON pr.IDProposta = p.ID
LEFT JOIN dados.produto pd ON pd.id = p.IDProduto
LEFT JOIN dados.ProdutoSIGPF pf ON pf.ID = p.IDProdutoSIGPF
LEFT join dados.produtosigpf pf2 ON pf2.id = pd.idprodutosigpf
LEFT JOIN dados.produto pe ON pe.id = e.IDProduto
LEFT join dados.produtosigpf pfe ON pfe.id = pe.idprodutosigpf
WHERE ((pf.CodigoProduto IN ('71', '72', '10', '50', 'MC') )
		OR (pf2.codigoproduto IN ('71', '72', '10', '50', 'MC') )
		OR (pfe.codigoproduto IN ('71', '72', '10', '50', 'MC') )
		)
--LEFT JOIN Dados.pagamento pac ON pac.IDProposta = p.ID
--and pc.CPFCNPJ = @cpf
 --AND c.numerocontrato = '1201402201562'
)
SELECT a.NumeroProposta,a.DataProposta,a.DataInicioVigencia,a.DataFimVigencia,
	a.NumeroContrato,COALESCE(e.ValorPremioTotal,a.ValorPremioTotal,a.ValorPremioBrutoEmissao)AS ValorPremioTotal,--,e.ValorPremioTotal,
	a.CodigoComercializado AS CodigoProduto,a.Descricao AS NomeProduto,COALESCE(a.QuantidadeParcelas,e.QuantidadeParcelas) AS QuantidadeParcelas,
	ISNULL(pg.ValorPrimeiraParcela,pg2.ValorDemaisParcelas) AS ValorPrimeiraParcela,pg2.ValorDemaisParcelas,a.idproposta,a.DataEmissao,Identificacao
	--INTO #mrtemp
 FROM autom a
OUTER APPLY (SELECT  TOP 1 e.ValorPremiototal,E.ID ,e.QuantidadeParcelas,e.NumeroEndosso FROM Dados.Endosso e WHERE e.IDContrato = a.ID AND e.IDProduto = a.IDProduto AND 0 = ISNULL(e.NumeroEndosso,0) ) e
OUTER APPLY (SELECT TOP 1 pg.Valor AS ValorPrimeiraParcela FROM Dados.Pagamento pg where pg.IDProposta = a.IDproposta AND pg.NumeroParcela = 1 AND  e.NumeroEndosso = ISNULL(pg.numeroendosso,0)  ) pg
OUTER APPLY (SELECT TOP 1 pg2.Valor AS ValorDemaisParcelas FROM Dados.Pagamento pg2 where pg2.IDProposta = a.IDproposta AND pg2.NumeroParcela > 1) pg2
--LEFT JOIN Dados.Endosso e ON e.IDProposta = p.ID 
--LEFT JOIN Dados.Endosso e2 ON e2.IDContrato = c.ID

order by IDProposta
OFFSET @NumeroPagina * @QuantidadeRegistros ROWS
FETCH  NEXT @QuantidadeRegistros ROWS only
 


 