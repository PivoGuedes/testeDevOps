
                
/*
	Autor: Egler Vieira
	Data Criação: 17/06/2013

	Descrição: 
	
	Última alteração :  
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Marketing.fn_RecuperaCertificadosVigentes_Previdencia
	Descrição: Procedimento que realiza a recuperação dos certificados de previdência VIGENTES.
		
	Parâmetros de entrada: DataApuracao -> Data de referência para apuração
	
					
	Retorno:

*******************************************************************************/ 
CREATE FUNCTION Marketing.fn_RecuperaCertificadosVigentes_Previdencia (@DataApuracao AS DATE)
RETURNS TABLE
AS
RETURN
SELECT 
       AV.CodigoProduto, AV.[Produto], AV.NumeroProposta 
     , AV.NumeroCertificado, AV.DataInicioVigencia, AV.DataFimVigencia, AV.DataInicioSituacao
     , AV.[SiglaSituacao], AV.[Situacao]--, TM.Codigo [CodigoMotivo], TM.Nome [Motivo]
     , AV.PrazoPercepcao, AV.PrazoDiferimento, AV.TipoContribuicao, AV.TipoAposentadoria
     , AV.IndicadorReservaInicial, AV.IndicadorSimulacao, AV.PercentualDesconto, AV.PercentualReversao
     , AV.CPFCNPJ, AV.Nome, AV.ValorContribuicao, AV.ValorReservaInicial
    
FROM Dados.fn_RecuperaCertificadosVigentes_Previdencia (@DataApuracao) AV
