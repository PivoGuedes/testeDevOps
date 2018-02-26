








CREATE VIEW   [CalculoComissao].[vw_PagamentoAutoOld]
AS
SELECT * FROM (select  ValPositivo.IDPagamento AS IDPagamento,
			 COALESCE(NumeroProposta,Proposta2,'0') AS NumeroProposta,
			 NumeroContrato,
			 CodigoComercializado,
			 ValPositivo.ValorPremioLiquido - isnull(ValNegativo.ValorPremioLiquido,0) as ValorPremioLiquido,
			 ValPositivo.NumeroEndosso,
			 ValPositivo.NumeroParcela,
			 ValPositivo.NumeroTitulo,
			 y.DataEndosso,
			 ROW_NUMBER() OVER ( PARTITION BY IDPagamento order by NumeroProposta,NumeroParcela,DataEndosso desc) linha ,
			 ValPositivo.DataEfetivacao DataEfetivacao,
			 CodigoRamo from (SELECT  p.NumeroProposta,c.NumeroContrato,prp.Proposta2,x.*,coalesce(x.IDProposta,p.ID,prp.IDProposta) as IDPropostaJ 
		FROM 
			(SELECT  e.ID AS IDEndosso,e.IDContrato, e.IDProposta,e.NumeroEndosso,prd.CodigoComercializado,e.DataEmissao AS DataEndosso,rp.Codigo AS CodigoRamo
				FROM Dados.Produto PRD 
				INNER JOIN Dados.Endosso e  ON PRD.ID = e.IDProduto 
				CROSS APPLY [Dados].[fn_RecuperaRamoPAR_Mestre](PRD.IDRamoPAR) RP
				WHERE   RP.Codigo = '01' 
				--PRD.Descricao LIKE '%AUTO%' 
			) x 
		LEFT JOIN Dados.Contrato c ON x.IDContrato = c.ID
		LEFT JOIN Dados.Proposta p ON x.IDProposta = p.ID
		OUTER APPLY (SELECT TOP 1 NumeroProposta AS Proposta2,p2.ID as IDProposta FROM Dados.Proposta p2 WHERE IDContrato = c.ID) AS prp
	) y
--INNER JOIN Dados.Parcela pg ON pg.IDEndosso = y.IDEndosso AND pg.DataEmissao >= '2015-01-01'
--INNER JOIN Dados.Pagamento pm ON pm.IDProposta = y.IDPropostaJ and pm.SinalLancamento = '+'
cross apply (select pm.ValorPremioLiquido,pm.ID as IDPagamento,NumeroEndosso,NumeroParcela,NumeroTitulo,DataEfetivacao from Dados.Pagamento pm where pm.IDProposta = y.IDPropostaJ and pm.SinalLancamento = '+') ValPositivo
outer apply (select pm2.ValorPremioLiquido from Dados.Pagamento pm2 where pm2.IDProposta = y.IDPropostaJ and pm2.SinalLancamento = '-' and pm2.NumeroEndosso = ValPositivo.NumeroEndosso and pm2.NumeroTitulo = ValPositivo.NumeroTitulo and pm2.NumeroParcela = ValPositivo.NumeroParcela) ValNegativo
) X where linha = 1




