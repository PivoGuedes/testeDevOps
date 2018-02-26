/*
	Autor: Gustavo Moreira
	Data Criação: 26/08/2013

	Descrição: 
	
	
	                                                                                  
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.fn_RecuperaDadosComissao
	Descrição: Procedimento que realiza a recuperação da tabela de comissionamento.
		
	Parâmetros de entrada: DataInício -> Data de referência para início da apuração
						   DataFim -> Data de referência para fim da apuração
	
					
	Retorno:

*******************************************************************************/ 
--CREATE FUNCTION Dados.fn_RecuperaDadosComissao(@DataInicio AS DATE, @DataFim AS DATE)
CREATE FUNCTION [Dados].[fn_RecuperaDadosComissao](@DataInicio AS DATE, @DataFim AS DATE)
RETURNS TABLE
AS
RETURN


SELECT
       CO.[IDRamo]
      ,RA.Nome [NomeRamo]
      ,CO.[PercentualCorretagem]
      ,CO.[ValorCorretagem]
      ,CO.[ValorBase]
      ,CO.[ValorComissaoPAR]
      ,CO.[ValorRepasse]
      ,CO.[DataCompetencia]
      ,CO.[DataRecibo]
      ,CO.[NumeroRecibo]
      ,CO.[NumeroEndosso]
      ,CO.[NumeroParcela]
      ,CO.[DataCalculo]
      ,CO.[DataQuitacaoParcela]
      ,CO.[TipoCorretagem]
      ,CO.[IDContrato]
      ,CTO.NumeroContrato [NumeroApolice]
      ,CO.[IDCertificado]
      ,CE.NumeroCertificado
      ,CO.[IDOperacao]
      ,OP.Codigo [CodigoOperacao]
      ,OP.Descricao [DescricaoOperacao]
      ,CO.[IDProdutor]
      ,PR.Codigo [CodigoProdutor]
      ,PR.Nome [NomeProdutor]
      ,CO.[IDFilialFaturamento]
      ,FF.Codigo [CodigoFilialFaturamento]
      ,FF.Nome [NomeFilialFaturamento]
      ,CO.[CodigoSubgrupoRamoVida]
      ,CO.[IDProduto]
      ,PRD.CodigoComercializado
      ,PRD.Descricao [NomeProduto]
      ,CO.[IDUnidadeVenda]
      ,UN.Codigo [CodigoUnidadeVenda]
      ,CO.[IDProposta]
      ,PRP.NumeroProposta
      ,CO.[IDCanalVendaPAR]
      ,CVP.Nome [NomeCanalVendaPAR]
      --,CO.[NumeroProposta]
      ,CO.[CodigoProduto]
      ,CO.[LancamentoManual]
      ,CO.[Repasse]
      ,CO.[Arquivo]
      ,CO.[DataArquivo]
  FROM [Corporativo].[Dados].[Comissao] CO
  
  
LEFT JOIN Dados.Ramo RA
ON RA.ID = CO.IDRamo

LEFT JOIN Dados.Contrato CTO
ON CTO.ID = CO.IDContrato

LEFT JOIN Dados.Certificado CE
ON CE.ID = CO.IDCERTIFICADO

LEFT JOIN DADOS.ComissaoOperacao OP
ON OP.ID = CO.IDOperacao

LEFT JOIN Dados.Produtor PR
ON PR.ID = CO.IDProdutor

LEFT JOIN Dados.FilialFaturamento FF
ON FF.ID = CO.IDFilialFaturamento

LEFT JOIN Dados.Produto PRD
ON PRD.ID = CO.IDProduto

LEFT JOIN Dados.Unidade UN
ON UN.ID = CO.IDUnidadeVenda

LEFT JOIN Dados.Proposta PRP
ON PRP.ID = CO.IDProposta

LEFT JOIN Dados.CanalVendaPar CVP
ON CVP.ID = CO.IDCanalVendaPAR

WHERE CO.IDEmpresa = 3 AND CO.DataArquivo BETWEEN @DataInicio AND @DataFim