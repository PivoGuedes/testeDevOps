
CREATE VIEW [CalculoComissao].[vw_PagamentoPrestamistaAIC]
AS
WITH CTE
AS
(
SELECT  PE.ID
      , Cnt.NumeroContrato
      , COALESCE(PP.NumeroProposta, P.NumeroProposta) NumeroProposta
      --, CNT.NumeroContrato
      , PRD.CodigoComercializado [CodigoProduto]
      /*, PRD.Descricao,*/ 
	  ,--SUM(
	    Cast(   CASE WHEN PGTOm.IDTipoMovimento = 2 OR  PE.PremioCancelado IS NOT NULL OR PEm.PremioCancelado IS NOT NULL THEN  ABS(COALESCE(cleansingkit.dbo.fn_decimalNull(PGTO.ValorPremioLiquido), cleansingkit.dbo.fn_decimalNull(PE.PremioCancelado), cleansingkit.dbo.fn_decimalNull(PEm.PremioCancelado))) * -1 
                WHEN PGTOm.IDTipoMovimento IN (1,3) OR PE.PremioMip  IS NOT NULL OR PEm.PremioMip  IS NOT NULL THEN   ABS(COALESCE(cleansingkit.dbo.fn_decimalNull(PGTO.ValorPremioLiquido), cleansingkit.dbo.fn_decimalNull(PE.PremioMIP), cleansingkit.dbo.fn_decimalNull(PEm.PremioMip))) 
           ELSE 0
           END as decimal(16,2)) [PremioLiquido]
	  , NULL PremioLiquidoAtrasado 
     -- , PGTO.NumeroEndosso
	 -- , PGTO.NumeroParcela
	 -- , PGTO.NumeroTitulo
	  --, PGTO.DataEndosso
	--  ,PGTO.ValorPremioLiquido,PE.PremioCancelado, PEm.PremioCancelado
	  , COALESCE(PGTO.DataEfetivacao, PE.DataArquivo) DataEfetivacao

	  
        
FROM Dados.Proposta P
LEFT JOIN Dados.Contrato CNT
ON P.IDContrato = CNT.ID
--OUTER APPLY(SELECT PP.NumeroOrdemInclusao    
--            FROM Dados.PropostaPrestamista PP
--			WHERE  P.ID = PP.IDProposta
--		   ) PP
OUTER APPLY(
            SELECT PP.IDProduto, PP.NumeroProposta 
			FROM Dados.Proposta PP
			WHERE PP.ID = P.IDPropostaM
		   ) PP
LEFT JOIN Dados.Produto PRD
ON PRD.ID = CASE WHEN P.IDProduto IS NULL OR P.IDProduto = -1 THEN PP.IDProduto ELSE P.IDProduto END
OUTER APPLY(
            SELECT PGTO.IDTipoMovimento,   CASE WHEN IDMotivo = 73 /*cancelamento*/THEN ABS(PGTO.Valor) * -1 
													   ELSE ABS(PGTO.Valor)
													   END ValorPremioLiquido
													   --, ValorPremioLiquido
			     , PGTO.NumeroEndosso, PGTO.NumeroTitulo
				 , PGTO.NumeroParcela, PGTO.DataEfetivacao 
		    FROM Dados.Pagamento PGTO
			WHERE PGTO.IDProposta = P.IDPropostaM
		   ) PGTOm
OUTER APPLY(SELECT PE.PremioMip, PE.PremioInad, PE.PremioCancelado
            FROM Dados.FinanceiroExtrato PE
            WHERE PE.IDProposta = P.IDPropostaM
			) PEm
OUTER APPLY(
            SELECT PGTO.IDTipoMovimento,    CASE WHEN IDMotivo = 73 /*cancelamento*/THEN ABS(PGTO.Valor) * -1 
													   ELSE ABS(PGTO.Valor)
													   END ValorPremioLiquido
													    --ValorPremioLiquido
			     , PGTO.NumeroEndosso, PGTO.NumeroTitulo
				 , PGTO.NumeroParcela, PGTO.DataEfetivacao 
			FROM Dados.Pagamento PGTO
			WHERE PGTO.IDProposta = P.ID
		   ) PGTO
OUTER APPLY(SELECT ID, PE.PremioMip, PE.PremioInad
                 , PE.PremioCancelado, PE.DataArquivo
            FROM Dados.FinanceiroExtrato PE
            WHERE PE.IDProposta = P.ID
			) PE
WHERE  P.IDPropostaM IS NOT NULL
  AND CNT.ID NOT in (
                       SELECT ID
					   FROM Dados.Contrato C
					   WHERE C.NumeroContrato IN ('107700000022','107700000023','107700000038') 
					  )
UNION

SELECT PGTO.ID
     , CNT.NumeroContrato
     , P.NumeroProposta
     , PRD.CodigoComercializado [CodigoProduto]


	 , CASE WHEN IDMotivo = 73 THEN ABS(P.ValorPremioLiquidoEmissao) * -1 ELSE ABS(P.ValorPremioLiquidoEmissao) END PremioLiquido
--	 , CASE WHEN IDMotivo = 73 THEN ABS(PGTO.Valor) * -1 ELSE ABS(PGTO.Valor) END PremioLiquido  --Alterado em 4/12/2016
--	 , CASE WHEN IDMotivo = 73 THEN ABS(PGTO.Valor) * -1 ELSE ABS(PGTO.Valor) END PremioLiquido
	 , NULL PremioLiquidoAtrasado
	 , PGTO.DataArquivo
FROM Dados.Proposta P WITH(NOLOCK)

INNER JOIN Dados.Pagamento PGTO WITH(NOLOCK)
ON PGTO.IDProposta = P.ID
INNER JOIN Dados.Produto PRD
ON PRD.ID = P.IDProduto
LEFT JOIN Dados.Contrato CNT
ON P.IDContrato = CNT.ID
WHERE P.NumeroProposta NOT LIKE 'PS%'
AND NOT EXISTS (SELECT *
                FROM Dados.Proposta P1
				WHERE P1.IDPropostaM = P.ID)
AND PRD.IDRamoPAR IN (34, 47, 4)
AND CNT.ID NOT in (
                    SELECT ID
					FROM Dados.Contrato C
					WHERE C.NumeroContrato IN ('107700000022','107700000023','107700000038') 
					)
AND (CASE WHEN PRD.CodigoComercializado = '9313' AND PGTO.DataArquivo < '2014-06-09' THEN 0
          ELSE 1
	 END) = 1
AND PRD.CodigoComercializado NOT IN ('9306')



--INNER JOIN Dados.PropostaPrestamista PP WITH(NOLOCK)
--ON PP.IDProposta = P.ID

--  and p.NumeroProposta = 'PS005555529623249'
--AND (
--     PE.PremioMip IS NOT NULL
--	 OR 
--	 PE.PremioCancelado IS NOT NULL
--    )
)
SELECT * 
FROM CTE
WHERE DataEfetivacao >= '2014-01-01'





