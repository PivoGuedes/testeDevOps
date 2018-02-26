
/*
	Autor: Gustavo Moreira
	Data Criação: 08/08/2013

	Descrição: 
	
	
	Última alteração : 
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Marketing.fn_RecuperaCoberturaPatrimoniais
	Descrição: Consulta que recupera cobertura dos contratos.
		
	Parâmetros de entrada: DataInicio -> Data de início da apuração;
						   DataFim -> Data de fim da apuração.
	
					
	Retorno:

*******************************************************************************/ 
CREATE FUNCTION [Marketing].[fn_RecuperaCoberturaPatrimoniais](@DataInicio AS DATE, @DataFim AS DATE)

RETURNS TABLE
AS
RETURN

SELECT   [NumeroApolice]
	   , [NumeroProposta]
       , [DataProposta]
       , [DataInicioVigencia]
       , [DataFimVigencia]
       , [Codigo]
       , [NomeProduto]
       , [NomeCliente]
       , [CPFCNPJ]
       , [ImpSegurada]
       , [PremioTotal]
       , [PremioCobertura]
       , [CodigoCobertura]
       , [NomeCobertura]
       
FROM Dados.fn_RecuperaCoberturaPatrimoniais (@DataInicio, @DataFim) 
