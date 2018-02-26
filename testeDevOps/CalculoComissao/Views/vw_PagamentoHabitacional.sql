


CREATE VIEW [CalculoComissao].[vw_PagamentoHabitacional]
as
WITH CTE
AS
(
SELECT  --PF.ID,
       P.NumeroProposta NumeroProposta
      --, CNT.NumeroContrato
      , PRD.CodigoComercializado [CodigoProduto]
      /*, PRD.Descricao,*/ 
	  ,SUM(
	    --Cast( CASE WHEN  PE.PremioCancelado IS NOT NULL  THEN 0-- ABS(PE.PremioCancelado) * -1 
        --        WHEN PE.PremioMip IS NOT NULL THEN    
				                                      ISNULL(ABS(PE.PremioMip),0)
				                                    + ISNULL(ABS(PE.IOFMip) ,0)
													+ ISNULL(ABS(PE.PremioDfi) ,0)
													+ ISNULL(ABS(PE.IOFDfi) ,0)
         --  ELSE 0
         --  END as decimal(16,2))
		   ) [PremioLiquido] 
	  --,SUM(ABS(PE.PremioMipAtrasado)) PremioLiquidoAtrasado
	  --, PGTO.DataEndosso
	  --, PGTO.ValorPremioLiquido
	  , P.DataProposta [DataContrato]
	  , DATEDIFF(MM,P.DataProposta,PE.DataArquivo) [Parcela]
	  , PE.DataArquivo DataEfetivacao        
FROM Dados.Proposta P
--LEFT JOIN Dados.Contrato CNT
--ON PRP.IDContrato = CNT.ID
--OUTER APPLY(SELECT PP.NumeroOrdemInclusao    
--            FROM Dados.PropostaPrestamista PP
--			WHERE  P.ID = PP.IDProposta
--		   ) PP
INNER JOIN Dados.PropostaFinanceiro PF WITH(INDEX (IDX_NCL_PropostaFinanceiro_IDProposta))
ON PF.IDProposta = P.ID
INNER JOIN (
			SELECT IDProposta, PE.DataArquivo, SUM(PE.PremioMip) PremioMip, SUM(PE.IOFMip) IOFMip,  SUM(PE.PremioDfi) PremioDfi, SUM(PE.IOFDfi) IOFDfi, SUM(PE.PremioCancelado) PremioCancelado-- SUM(PE.PremioInad) PremioInad, SUM(PE.PremioMipAtrasado)  PremioMipAtrasado
			FROM Dados.[FinanceiroExtrato] PE
			--WHERE PE.DataArquivo = '2014-08-31'
			GROUP BY IDProposta, PE.DataArquivo
			) PE
ON PE.IDProposta = P.ID
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
AND (   PRD.IDProdutoSIGPF IN (81, 68) 
     or IDRamoPAR IN (46)  
    )
--and (prd.CodigoComercializado like '6' OR prd.CodigoComercializado LIKE '4%')
--AND P.NumeroProposta = 'HB008444407360477'--and p.idproduto in (63,64,89,90,92,93,255,256,328)
GROUP BY PE.DataArquivo,  P.NumeroProposta, PRD.CodigoComercializado, DataProposta--, PF.ID
)
SELECT * 
FROM CTE


