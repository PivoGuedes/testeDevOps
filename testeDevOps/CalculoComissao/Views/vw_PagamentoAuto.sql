



CREATE VIEW [CalculoComissao].[vw_PagamentoAuto]
AS
WITH CTE_PRD
AS
(
	SELECT prd.id [IDProduto], prd.CodigoComercializado,rp.Codigo AS CodigoRamo
	FROM Dados.Produto PRD 
	CROSS APPLY [Dados].[fn_RecuperaRamoPAR_Mestre](PRD.IDRamoPAR) RP
	WHERE   RP.Codigo = '01' 
)
,
CTE_CNT_PGTO
AS
(
	SELECT C.NumeroContrato, E.ID AS IDEndosso,e.IDContrato, e.IDProposta,e.NumeroEndosso,e.DataEmissao AS DataEndosso, pgto.*,p.NumeroProposta,CTE_PRD.CodigoComercializado,CTE_PRD.CodigoRamo
	FROM Dados.Endosso e
	    INNER JOIN  Dados.Contrato c
		ON E.IDContrato = C.ID
		INNER JOIN CTE_PRD
		ON CTE_PRD.[IDProduto] = E.IDProduto
		INNER JOIN Dados.Proposta p 
		ON e.IDProposta = p.ID
		CROSS APPLY (SELECT case when pm.SinalLancamento = '-' then  pm.ValorPremioLiquido*-1 else pm.ValorPremioLiquido end as ValorPremioLiquido ,-- pm.ID AS IDPagamento,
							 NumeroParcela,
							 NumeroTitulo,
							 DataEfetivacao 
					  FROM Dados.Pagamento pm 
					  WHERE pm.IDProposta = E.IDProposta
					  AND PM.NumeroEndosso = E.NumeroEndosso
					       AND TipoDado = 'AU0009B'
					  ) PGTO
		--OUTER APPLY (SELECT TOP 1 NumeroProposta AS Proposta2,p2.ID AS IDProposta 
		--             FROM Dados.Proposta p2
		--			 WHERE IDContrato = c.ID) AS prp
	WHERE CTE_PRD.IDProduto = E.IDProduto 
	and PGTO.ValorPremioLiquido <> 0
)
SELECT *
FROM  CTE_CNT_PGTO



