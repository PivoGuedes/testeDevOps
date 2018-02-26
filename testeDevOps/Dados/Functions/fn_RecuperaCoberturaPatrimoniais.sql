
/*
	Autor: Gustavo Moreira
	Data Criação: 08/08/2013

	Descrição: 
	
	
	Última alteração : 
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.fn_RecuperaCoberturaPatrimoniais
	Descrição: Consulta que recupera cobertura dos contratos.
		
	Parâmetros de entrada: DataInicio -> Data de início da apuração;
						   DataFim -> Data de fim da apuração.
	
					
	Retorno:

*******************************************************************************/ 
CREATE FUNCTION [Dados].[fn_RecuperaCoberturaPatrimoniais](@DataInicio AS DATE, @DataFim AS DATE)

RETURNS TABLE
AS
RETURN

SELECT   CTO.NumeroContrato [NumeroApolice]
	   , PRP.NumeroProposta [NumeroProposta]
       , PRP.DataProposta [DataProposta]
       , EN.DataInicioVigencia [DataInicioVigencia]
       , EN.DataFimVigencia [DataFimVigencia]
       , PSIG.CodigoProduto [Codigo]
       , PSIG.Descricao [NomeProduto]
       , PC.Nome [NomeCliente]
       , PC.CPFCNPJ [CPFCNPJ]
       , PRPC.ValorImportanciaSegurada [ImpSegurada]
       , PRP.ValorPremioTotal [PremioTotal]
       , PRPC.ValorPremio [PremioCobertura]
       , COB.Codigo [CodigoCobertura]
       , COB.Nome [NomeCobertura]
      
FROM Dados.Proposta PRP

INNER JOIN Dados.PropostaCobertura PRPC
ON PRPC.IDProposta = PRP.ID
-------------------------------------------------------------------------------------------
INNER JOIN Dados.Cobertura COB
ON COB.ID = PRPC.IDCobertura
-------------------------------------------------------------------------------------------
INNER JOIN Dados.ProdutoSIGPF PSIG
ON PSIG.ID = PRP.IDProdutoSIGPF
-------------------------------------------------------------------------------------------
INNER JOIN Dados.Contrato CTO
ON CTO.ID = PRP.IDContrato
-------------------------------------------------------------------------------------------
INNER JOIN Dados.PropostaCliente PC
ON PC.IDProposta = PRP.ID
-------------------------------------------------------------------------------------------
INNER JOIN Dados.Endosso EN
ON EN.IDContrato = CTO.ID
-------------------------------------------------------------------------------------------
INNER JOIN Dados.Produto PRD
ON PRD.ID = EN.IDProduto
-------------------------------------------------------------------------------------------
WHERE PRP.DataProposta BETWEEN @DataInicio AND @DataFim



union 

SELECT 
         CTO.NumeroContrato [NumeroApolice]
	   , PRP.NumeroProposta [NumeroProposta]
       , PRP.DataProposta [DataProposta]
       , CTO.DataInicioVigencia [DataInicioVigencia]
       , CTO.DataFimVigencia [DataFimVigencia]
       , EN.CodigoComercializado [Codigo]
       , EN.Descricao [NomeProduto]
       , PC.Nome [NomeCliente]
       , PC.CPFCNPJ [CPFCNPJ]
       , EC.ImportanciaSegurada [ImpSegurada]
       , PRP.ValorPremioTotal [PremioTotal]
       , EC.ValorPremioLiquido [PremioCobertura]
       , COB.Codigo [CodigoCobertura]
       , COB.Nome [NomeCobertura]
FROM Dados.Contrato CTO
CROSS APPLY (select top 1 EN.ID, PRD.CodigoComercializado, PRD.Descricao, EN.ValorPremioLiquido, EN.ValorPremioTotal
			 from Dados.Endosso EN
			 INNER JOIN Dados.Produto PRD
			 ON PRD.ID = EN.IDProduto
			 where EN.IDContrato = CTO.ID
			 ORDER BY EN.ID DESC) EN
-------------------------------------------------------------------------------------------
INNER JOIN DADOS.EndossoCobertura EC
ON EC.IDEndosso = EN.ID
-------------------------------------------------------------------------------------------
INNER JOIN Dados.Cobertura COB
ON COB.ID = EC.IDCobertura
-------------------------------------------------------------------------------------------
INNER JOIN Dados.Proposta PRP
ON PRP.IDContrato = CTO.ID
-------------------------------------------------------------------------------------------
INNER JOIN Dados.PropostaCliente PC
ON PC.IDProposta = PRP.ID
-------------------------------------------------------------------------------------------

WHERE PRP.DataProposta BETWEEN @DataInicio AND @DataFim