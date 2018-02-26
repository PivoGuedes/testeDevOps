
/*

	Autor: Gustavo Moreira
	Data Criação: 07/08/2013

	Descrição: 
		
	Última alteração : 
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.fn_RecuperaBeneficiario
	Descrição: Consulta que recupera propostas com beneficiários.
		
	Parâmetros de entrada: DataInicio -> Data de início da apuração;
						   DataFim -> Data de fim da apuração.
	
					
	Retorno:

*******************************************************************************/ 
CREATE FUNCTION [Marketing].[fn_RecuperaBeneficiario] (@DataInicio AS DATE, @DataFim AS DATE)
RETURNS TABLE
AS
RETURN

--DECLARE @DataInicio AS DATE = '20130701'
--DECLARE @DataFim AS DATE = '20130701'
SELECT 
		  [NUMERO CERTIFICADO]
		, [COD PRODUTO SIGPF]
		, [DESC PRODUTO]
		, [NOME CLIENTE]
		, [CPFCNPJ]
		, [DATA DA PROPOSTA]
		, [DATA INCLUSAO BENEFICIARIO]
		, [DATA EXCLUSAO BENEFICIARIO]
		, [NOME BENEFICIARIO]
		, [NUMERO DO BENEFICIARIO]
		, [PARENTESCO BENEFICIARIO]
		, [PERCENTUAL BENEFICIARIO]

FROM Dados.fn_RecuperaBeneficiario (@DataInicio, @DataFim) 