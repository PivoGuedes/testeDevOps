



CREATE VIEW [CalculoComissao].[vw_PagamentoMR]
AS
WITH CTE_PRD
AS
(
	SELECT prd.id [IDProduto], prd.CodigoComercializado,rp.Codigo AS CodigoRamo
	FROM Dados.Produto PRD 
	CROSS APPLY [Dados].[fn_RecuperaRamoPAR_Mestre](PRD.IDRamoPAR) RP
	WHERE   RP.Codigo IN ('03' ,'05')
)
,
CTE_CNT_PGTO
AS
(
	SELECT C.NumeroContrato, E.ID AS IDEndosso,e.IDContrato/*,c.CnpjCorretor1,c.CnpjCorretor2*/, e.IDProposta,e.NumeroEndosso,e.DataEmissao AS DataEndosso, pgto.*,coalesce(prp.Proposta2,p.NumeroProposta) NumeroProposta,CTE_PRD.CodigoComercializado,CTE_PRD.CodigoRamo,
	ISNULL(c.CodigoCorretor1,'042278473000103') AS CodigoCorretor1,ISNULL(c.CodigoCorretor2,'042278473000103') AS CodigoCorretor2,ISNULL(c.CNPJCorretor1,'042278473000103') as CNPJCorretor1,ISNULL(c.CNPJCorretor2,'042278473000103') as CNPJCorretor2
	FROM Dados.Endosso e
	    INNER JOIN  Dados.Contrato c
		ON E.IDContrato = C.ID
		INNER JOIN CTE_PRD
		ON CTE_PRD.[IDProduto] = E.IDProduto
		INNER JOIN Dados.Proposta p 
		ON e.IDProposta = p.ID
		CROSS APPLY (SELECT pm.ValorPremioLiquido,-- pm.ID AS IDPagamento,
							 NumeroParcela,
							 NumeroTitulo,
							 DataEfetivacao 
					  FROM Dados.Pagamento pm 
					  WHERE pm.IDProposta = E.IDProposta
					  AND PM.NumeroEndosso = E.NumeroEndosso
					       AND TipoDado = 'MR0009B'
					  ) PGTO
		OUTER APPLY (SELECT TOP 1 NumeroProposta AS Proposta2--,p2.ID AS IDProposta 
		             FROM Dados.Proposta p2
					 WHERE IDContrato = c.ID
					 order by p2.Id desc) AS prp
	WHERE CTE_PRD.IDProduto = E.IDProduto --AND c.ID = 21987189
	--and NumeroContrato  = '1201800579580'
--and	p.id= 55595411
)
SELECT *
FROM  CTE_CNT_PGTO
WHERE (CTE_CNT_PGTO.CodigoCorretor1 = '042278473000103' OR CTE_CNT_PGTO.CodigoCorretor2  ='042278473000103' or CTE_CNT_PGTO.CNPJCorretor1 = '042278473000103' OR CTE_CNT_PGTO.CNPJCorretor2  ='042278473000103')
--WHERE NumeroContrato = '1103100510240'


