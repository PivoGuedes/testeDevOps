
CREATE FUNCTION [Mailing].[fn_RecuperaPropostaConvertida_PARINDICA]()
RETURNS  TABLE
AS
RETURN
--DECLARE @DataAquivo DATE = GETDATE()

--SELECT *
--FROM Dados.AtendimentoPARIndica a			 
--order by a.id asc 
--WHERE a.DataArquivo >= DATEADD(dd, -90, @DataAquivo)


Select   CNT.NumeroContrato
       , P.NumeroProposta
	   , pc.Nome
	   , pc.CPFCNPJ
	   , p.DataProposta
	   , COALESCE(p.DataEmissao, PGTO.DataEfetivacao, PGTO.DataArquivo, CNT.DataEmissao) DataEmissao
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
			  
			 -- and a.DataArquivo >= DATEADD(dd, -20, Cast(GETDATE() AS DATE))
			 --and P.DataProposta >= DATEADD(dd, -20, Cast(GETDATE() AS DATE))
			 --and P.DataEmissao >= P.DataProposta
			  AND	(
							A.Arquivo LIKE '%D%_DEVOLUTIVA_AQPARINDICA%'
						--(A.Arquivo LIKE 'SSIS_%_RET__INDICACAO%'  OR A.Arquivo LIKE 'SSIS_PAR_VENDA__INDICACAO__%_KPN%')
						--OR
						--(NomeCampanha='INDICACAO') -- Devido a unificação dos arquivos de retorno da BGeK, o filtro utilizado deverá ser o nome da campanha --
						                           -- Data modificação: 2015-03-09
					)
             )