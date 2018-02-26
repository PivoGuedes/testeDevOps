

/*
	Autor: Egler Vieira
	Data Criação: 17/06/2013

	Descrição: 
	
	Última alteração :  
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.fn_RecuperaCertificadosVigentes_Previdencia
	Descrição: Procedimento que realiza a recuperação dos certificados de previdência VIGENTES.
		
	Parâmetros de entrada: DataApuracao -> Data de referência para apuração
	
					
	Retorno:

*******************************************************************************/ 
CREATE FUNCTION Dados.fn_RecuperaCertificadosVigentes_Previdencia (@DataApuracao AS DATE)
RETURNS TABLE
AS
RETURN
SELECT 
      --TOP 20 PERCENT    
       PSG.CodigoProduto, PSG.Descricao [Produto], PRP.ID, PRP.NumeroProposta
     , PPC.NumeroCertificado, PPC.DataInicioVigencia, PPC.DataFimVigencia, PPC.DataInicioSituacao
     , SP.Sigla [SiglaSituacao], SP.Descricao [Situacao], SPE.Sigla [SiglaSituacao-EXTRATO], SPE.Descricao [Situacao-EXTRATO], PE.DataArquivo--, TM.Codigo [CodigoMotivo], TM.Nome [Motivo]
     , PREV.PrazoPercepcao, PREV.PrazoDiferimento, PREV.TipoContribuicao, PREV.TipoAposentadoria
     , PREV.IndicadorReservaInicial, PREV.IndicadorSimulacao, PREV.PercentualDesconto, PREV.PercentualReversao
     , PC.CPFCNPJ, PC.Nome, PREV.ValorContribuicao, PREV.ValorReservaInicial
FROM  Dados.Proposta PRP
CROSS APPLY (SELECT TOP 1 *
             FROM Dados.PropostaPrevidenciaCertificado PPC
             WHERE PPC.IDProposta = PRP.ID
             AND   PPC.IDSituacaoProposta NOT IN (5, 24) /*CAN e EXP - QUE NÃO ESTEJA CANCELADO*/
             ORDER BY 	[IDProposta] ASC,
	                      [NumeroCertificado] ASC,
	                      [DataInicioSituacao] ASC,
	                      [DataArquivo] DESC,
	                      [IDSituacaoProposta] ASC,
	                      [ValorReservaCotas] ASC,
	                      [ValorContribuicao] ASC	) PPC
OUTER APPLY (SELECT TOP 1 *
             FROM Dados.PrevidenciaExtrato PE
             WHERE PE.IDProposta = PRP.ID
             AND PE.NumeroParcela > 1200
             AND PE.DataArquivo <= @DataApuracao
             ORDER BY	[IDProposta] DESC,
	                    [DataArquivo] DESC,
	                    [IDMotivo] ASC) PE
LEFT JOIN Dados.ProdutoSIGPF PSG
ON PSG.ID = PRP.IDProdutoSIGPF	                      
OUTER APPLY (SELECT TOP 1 *
             FROM Dados.PropostaPrevidencia PREV
             WHERE PREV.IDProposta = PRP.ID
             ORDER BY IDProposta, DataArquivo DESC
             ) PREV
OUTER APPLY (SELECT TOP 1 *
 	           FROM Dados.PropostaCliente PC
 	           WHERE PC.IDProposta = PRP.ID
 	           ORDER BY ID DESC) PC           
LEFT JOIN Dados.SituacaoProposta SP
ON SP.ID = PPC.IDSituacaoProposta	                      
LEFT JOIN Dados.SituacaoProposta SPE
ON SPE.ID = PE.IDSituacaoProposta	 
--LEFT JOIN Dados.TipoMotivo TM
--ON TM.ID = PPC.IDMotivo
WHERE PPC.DataFimVigencia >= @DataApuracao
--AND PE.IDSituacaoProposta NOT IN (5, 24) /*CAN e EXP -QUE NÃO ESTEJA CANCELADO*/
--AND IDProdutoSIGPF IS NOT NULL
--AND prp.ID = 12695314

/*

SELECT *
FROM Dados.Proposta 
WHERE ID = 12695314

SELECT * 
FROM Dados.PropostaCliente PC
WHERE IDProposta = 12695314


SELECT * 
FROM Dados.PropostaBeneficiario PC
WHERE IDProposta = 12695314
*/