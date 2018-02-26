



CREATE VIEW [CalculoComissao].[vw_PagamentoPrestamistaSIAPXold]
AS
WITH CTE
AS
(
SELECT  PE.ID
      , CNT.NumeroContrato
	  , P.NumeroProposta NumeroProposta
      , PRD.CodigoComercializado [CodigoProduto]
      /*, PRD.Descricao,*/ 
	  ,--SUM(
	    Cast( CASE WHEN  PE.PremioCancelado IS NOT NULL  THEN  ABS(cleansingkit.dbo.fn_decimalNull(PE.PremioCancelado)) * -1 
                WHEN PE.PremioMip IS NOT NULL THEN   ABS(cleansingkit.dbo.fn_decimalNull(PE.PremioMip)) - ABS(cleansingkit.dbo.fn_decimalNull(PE.IOFMip)) 
           ELSE 0
           END as decimal(16,2)) [PremioLiquido] 
		   --,PE.PremioMip,PE.IOFMip
	  , ABS(PE.PremioMipAtrasado) PremioLiquidoAtrasado
	  --, PGTO.DataEndosso
	  --, PGTO.ValorPremioLiquido
	  , PE.DataArquivo as DataEfetivacao--, PF.DataInclusao DataEfetivacao        
FROM Dados.Proposta P
INNER JOIN Dados.PropostaFinanceiro PF
ON PF.IDProposta = P.ID
CROSS APPLY(SELECT PE.ID, PE.PremioMip,  PE.IOFMip, PE.PremioInad, PE.PremioCancelado, PE.PremioMipAtrasado, PE.DataArquivo
            FROM Dados.[FinanceiroExtrato] PE
            WHERE PE.IDProposta = P.ID
			) PE
LEFT JOIN Dados.Contrato CNT -- INCLUIDO EM 2015-05-19
ON P.IDContrato = CNT.ID
--OUTER APPLY(SELECT PP.NumeroOrdemInclusao    
--            FROM Dados.PropostaPrestamista PP
--			WHERE  P.ID = PP.IDProposta
--		   ) PP
LEFT JOIN Dados.Produto PRD
ON PRD.ID = P.IDProduto
WHERE  P.IDPropostaM IS NULL
AND NOT EXISTS (
				SELECT * 
				FROM Dados.Proposta PP
				WHERE PP.ID = P.IDPropostaM
			   ) 
AND EXISTS (
            SELECT *
            FROM DadOs.[PropostaFinanceiro] PP
			WHERE PP.IDProposta = P.ID
		   )
AND PRD.IDRamoPAR IN (34, 47, 4)
AND (CASE WHEN PRD.CodigoComercializado = '9313' AND PE.DataArquivo < '2014-06-09' THEN 0
          ELSE 1
	 END) = 1
AND PRD.CodigoComercializado NOT IN ('9306')
--and P.ID = 52242559
AND CASE WHEN p.IDProduto = 225 AND p.NumeroProposta like 'PS%' then 1
	WHEN p.IDProduto <> 225 AND p.NumeroProposta like 'PS%' then 0
	else 1
	end  = 1
--INSERIDO EM 2015-05-19
UNION

SELECT PGTO.ID
     , CNT.NumeroContrato
     , P.NumeroProposta
     , PRD.CodigoComercializado [CodigoProduto]
	 , CASE WHEN IDMotivo = 73 THEN ABS(PGTO.Valor) * -1 
	   ELSE ABS(PGTO.Valor)
	   END PremioLiquido
	 , NULL PremioLiquidoAtrasado
	 , PGTO.DataArquivo
FROM Dados.Proposta P WITH(NOLOCK)

INNER JOIN Dados.Pagamento PGTO WITH(NOLOCK)
ON PGTO.IDProposta = P.ID
INNER JOIN Dados.Produto PRD
ON PRD.ID = P.IDProduto
LEFT JOIN Dados.Contrato CNT
ON P.IDContrato = CNT.ID
WHERE PRD.IDRamoPAR IN (34, 47, 4)
AND CNT.ID  in (
                SELECT ID
				FROM Dados.Contrato C
				WHERE C.NumeroContrato IN ('107700000022','107700000023','107700000038') 
				)
				--and NumeroProposta LIKE '020167770002950'
)
SELECT * 
FROM CTE




