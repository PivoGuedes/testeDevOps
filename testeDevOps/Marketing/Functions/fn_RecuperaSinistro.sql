/*
	Autor: Gustavo Moreira
	Data Criação: 07/08/2013

	Descrição: 
	
	
	Última alteração : 
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Marketing.fn_RecuperaSinistro
	Descrição: Procedimento que realiza a recuperação dos SINISTROS.
		
	Parâmetros de entrada: DataApuracao -> Data de referência para apuração
	
					
	Retorno:

*******************************************************************************/ 
CREATE FUNCTION Marketing.fn_RecuperaSinistro (@DataApuracao AS DATE)
RETURNS TABLE
AS
RETURN

--DECLARE @DataApuracao AS DATE = '20130701'

SELECT [DATA AVISO SINISTRO]
     , [DATA SINISTRO]
     , [NUMERO SINISTRO]
     , [NUMERO PROTOCOLO]
     , [NUMERO CONTRATO]
     , [NUMERO CERTIFICADO]
     , [NOMECLIENTE]
     , [CPFCNPJ]
     , [CODIGO RAMO]
     , [NOME RAMO]
     , [TIPO RAMO]
   /*, [SITUACAO SINISTRO]*/
     , [DESCRICAO SINISTRO]
FROM Dados.fn_RecuperaSinistro (@DataApuracao) 