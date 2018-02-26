

CREATE VIEW [Mailing].[vw_RecuperaPropostaConvertida_PARINDICA]
as
Select   CNT.NumeroContrato
       , P.NumeroProposta
	   , pc.Nome
	   , pc.CPFCNPJ
	   , p.DataProposta
	   , COALESCE(p.DataEmissao, PGTO.DataEfetivacao, PGTO.DataArquivo) DataEmissao
	   , p.ValorPremioTotal 
from 
 Dados.Contrato CNT
 inner join Dados.Proposta p 
ON P.IDContrato = CNT.ID
INNER join Dados.PropostaCliente pc
on pc.IDProposta = p.ID
OUTER APPLY (SELECT TOP 1 PGTO.DataEfetivacao, PGTO.DataArquivo
             FROM Dados.PagamentoEmissao PGTO
			 WHERE PGTO.IDProposta = P.ID 
			-- AND (PGTO.DataEfetivacao IS NOT NULL OR PGTO.DataArquivo IS NOT NULL)
			 ORDER BY DataArquivo ASC) PGTO
WHERE EXISTS (SELECT *
			  FROM Dados.Atendimento a			  
			  INNER JOIN Dados.AtendimentoClientePropostas [ACP]
			  ON [ACP].IDAtendimento = A.ID
			  WHERE p.ID = [ACP].IDProposta
			  and a.DataArquivo >= DATEADD(dd, -20, Cast(GETDATE() AS DATE))
			  -- AND (A.Arquivo LIKE 'SSIS_%_RET__INDICACAO%'  OR A.Arquivo LIKE 'SSIS_PAR_VENDA__INDICACAO__%_KPN%') '%_DEVOLUTIVA_AQPARINDICA%'
			  AND (A.Arquivo LIKE '%_DEVOLUTIVA_AQPARINDICA%') 
             )
