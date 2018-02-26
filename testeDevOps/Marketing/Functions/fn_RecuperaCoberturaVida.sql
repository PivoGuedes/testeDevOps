/*
	Autor: Gustavo Moreira
	Data Criação: 09/08/2013

	Descrição: 
	
	
	Última alteração : 
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Marketing.fn_RecuperaCoberturaVida
	Descrição: Consulta que recupera cobertura dos certificados.
		
	Parâmetros de entrada: DataInicio -> Data de início da apuração;
						   DataFim -> Data de fim da apuração.
	
					
	Retorno:

*******************************************************************************/ 
CREATE FUNCTION [Marketing].[fn_RecuperaCoberturaVida](@DataInicio AS DATE, @DataFim AS DATE)

RETURNS TABLE
AS
RETURN


SELECT		  NumeroCertificado
			, DataInicioVigencia
			, DataFimVigencia
			, CodigoSIGPF
			, NomeProdutoSIGPF
			, NomeCliente
			, CPF
			, ImportanciaSegurada
			, LimiteIndenizacao
			, ValorPremioLiquido
			, ValorPremioTotal
			, CodigoCobertura
			, NomeCobertura

FROM dados.fn_RecuperaCoberturaVida  (@DataInicio , @DataFim)
