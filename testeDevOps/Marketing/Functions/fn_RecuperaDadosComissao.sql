/*
	Autor: Gustavo Moreira
	Data Criação: 26/08/2013

	Descrição: 
	
	
	                                                                                  
*/

/*******************************************************************************
	Nome: CORPORATIVO.Marketing.fn_RecuperaDadosComissao
	Descrição: Procedimento que realiza a recuperação da tabela de comissionamento.
		
	Parâmetros de entrada: DataInício -> Data de referência para início da apuração
						   DataFim -> Data de referência para fim da apuração
	
					
	Retorno:

*******************************************************************************/ 
CREATE FUNCTION Marketing.fn_RecuperaDadosComissao(@DataInicio AS DATE, @DataFim AS DATE)
RETURNS TABLE
AS
RETURN

SELECT

	   IDRamo
      ,NomeRamo
      ,PercentualCorretagem
      ,ValorCorretagem
      ,ValorBase
      ,ValorComissaoPAR
      ,ValorRepasse
      ,DataCompetencia
      ,DataRecibo
      ,NumeroRecibo
      ,NumeroEndosso
      ,NumeroParcela
      ,DataCalculo
      ,DataQuitacaoParcela
      ,TipoCorretagem
      ,IDContrato
      ,NumeroApolice
      ,IDCertificado
      ,NumeroCertificado
      ,IDOperacao
      ,CodigoOperacao
      ,DescricaoOperacao
      ,IDProdutor
      ,CodigoProdutor
      ,NomeProdutor
      ,IDFilialFaturamento
      ,CodigoFilialFaturamento
      ,NomeFilialFaturamento
      ,CodigoSubgrupoRamoVida
      ,IDProduto
      ,CodigoComercializado
      ,NomeProduto
      ,IDUnidadeVenda
      ,CodigoUnidadeVenda
      ,IDProposta
      ,NumeroProposta
      ,IDCanalVendaPAR
      ,NomeCanalVendaPAR
    --,NumeroProposta
      ,CodigoProduto
      ,LancamentoManual
      ,Repasse
      ,Arquivo
      ,DataArquivo
      
FROM Dados.fn_RecuperaDadosComissao  (@DataInicio, @DataFim)
