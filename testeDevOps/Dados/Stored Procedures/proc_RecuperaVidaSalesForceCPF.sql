CREATE PROCEDURE [Dados].[proc_RecuperaVidaSalesForceCPF] 	@cpf VARCHAR(14)

AS
--SET @cpf = '004.996.271-05'
--SET @cpf = '832.737.941-00'
--SET @cpf = '024.082.171-80'
;WITH autom AS (
SELECT  
p.NumeroProposta, p.DataProposta,COALESCE(ct.DataInicioVigencia, p.DataInicioVigencia) DataInicioVigencia,COALESCE(c.DataFimVigencia,p.DataFimVigencia,ct.DataFimVigencia) AS DataFimVigencia,
		COALESCE(c.NumeroContrato,ct.numerocertificado) NumeroContrato,c.ValorPremioTotal,pd.CodigoComercializado,p.ValorPremioBrutoEmissao,ct.[ValorPremioBruto],
		pd.Descricao,IDProduto,c.ID,p.id AS idproposta,c.QuantidadeParcelas,c.DataEmissao,pc.CPFCNPJ,ct.NumeroCertificado Identificacao,p.tipodado,
		pf.CodigoProduto--,c.ValorPremioTotal
		--,e.QuantidadeParcelas,COALESCE(pa.ValorPrimeiraParcela,pg.ValorPrimeiraParcela) AS ValorPrimeiraParcela,
		----e.ValorPremioTotal-pa.ValorPrimeiraParcela AS ValorParcelas,
		--pg2.ValorDemaisParcelas
		----p.ValorPremioBrutoEmissao,pg.ValorPrimeiraParcela,pg2.*,p.id,*
FROM dados.proposta p
INNER JOIN Dados.PropostaCliente pc 
ON pc.IDProposta = p.ID
INNER JOIN dados.certificado ct ON ct.IDProposta = p.ID
LEFT JOIN dados.produto pd ON pd.id = p.IDProduto
LEFT JOIN dados.ProdutoSIGPF pf ON pf.ID = p.IDProdutoSIGPF
left JOIN dados.contrato c ON c.IDProposta = p.ID


WHERE  
--pf.CodigoProduto in ( '09' ,'BS', '06' ) 
--	       pf.CodigoProduto = '48' --and
--				     --- Via SigPF do produto
--				    --PProd.IDProdutoSIGPF in (59,60,4,8,10,47,11,32,33,45)  -- Vida sem bilhetes   -- 22-4-2015 Iara
------LEFT JOIN Dados.pagamento pac ON pac.IDProposta = p.ID
----and 
--AND 
pc.CPFCNPJ =  @cpf --'008.294.361-38'--@cpf
--AND c.numerocontrato = '1103100546261'
)
SELECT a.NumeroProposta,coalesce(a.DataProposta,a.DataInicioVigencia ) DataProposta,a.DataInicioVigencia,a.DataFimVigencia,
	a.NumeroContrato,COALESCE(e.ValorPremioTotal,a.ValorPremioTotal,a.ValorPremioBrutoEmissao,ValorPremioBruto)AS ValorPremioTotal,--,e.ValorPremioTotal,
	a.CodigoComercializado AS CodigoProduto,a.Descricao AS NomeProduto,COALESCE(a.QuantidadeParcelas,e.QuantidadeParcelas) AS QuantidadeParcelas,
	ISNULL(pg.ValorPrimeiraParcela,pg2.ValorDemaisParcelas) AS ValorPrimeiraParcela,pg2.ValorDemaisParcelas,a.idproposta,a.DataEmissao,CPFCNPJ,Identificacao,tipodado,
	'VIDA' AS TipoDeProduto
	--into #autotemp
 FROM autom a
OUTER APPLY (SELECT  TOP 1 e.ValorPremiototal,E.ID ,e.QuantidadeParcelas,e.NumeroEndosso FROM Dados.Endosso e WHERE e.IDContrato = a.ID AND e.IDProduto = a.IDProduto AND 0 = ISNULL(e.NumeroEndosso,0) ) e
OUTER APPLY (SELECT TOP 1 pg.Valor AS ValorPrimeiraParcela FROM Dados.Pagamento pg where pg.IDProposta = a.IDproposta AND pg.NumeroParcela = 1 AND  e.NumeroEndosso = ISNULL(pg.numeroendosso,0)  ) pg
OUTER APPLY (SELECT TOP 1 pg2.Valor AS ValorDemaisParcelas FROM Dados.Pagamento pg2 where pg2.IDProposta = a.IDproposta AND pg2.NumeroParcela > 1) pg2
--LEFT JOIN Dados.Endosso e ON e.IDProposta = p.ID 
--LEFT JOIN Dados.Endosso e2 ON e2.IDContrato = c.ID

order by dataproposta,datainiciovigencia
