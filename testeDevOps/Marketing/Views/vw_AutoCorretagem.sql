

                
/*
	Autor: Gustavo Moreira
	Data Criação: 22/08/2013

	Descrição: 
	
	Última alteração :  
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Marketing.vw_AutoCorretagem
	Descrição: Procedimento que realiza a recuperação das apólices recebidas na comissão.
	
	
					
	Retorno:

*******************************************************************************/ 
CREATE VIEW [Marketing].[vw_AutoCorretagem]
AS
SELECT PRD.CodigoComercializado [CodigoProduto]
	  ,PRD.Descricao [NomeProduto]
	  ,PRP.NumeroProposta [NumeroProposta]
      ,CTO.NumeroContrato [NumeroApolice]
	  ,PercentualCorretagem
      ,sum([ValorCorretagem]) [ValorCorretagem]
      ,sum([ValorBase]) [ValorBase]
      ,co.NumeroRecibo
      ,OP.Codigo [CodigoOperacao]
      ,UN.Codigo [CodigoAgencia]
      ,[NumeroEndosso]
      ,[NumeroParcela]
	  ,[DataCompetencia]
      ,[DataCalculo]
      ,[DataQuitacaoParcela]
      ,co.DataRecibo  


FROM Dados.Comissao CO
INNER JOIN Dados.Produto PRD
ON PRD.ID = CO.IDProduto
INNER JOIN Dados.ComissaoOperacao OP
ON OP.ID = CO.IDOperacao
INNER JOIN Dados.Contrato CTO
ON CTO.ID = CO.IDContrato

left JOIN Dados.Proposta PRP
ON PRP.ID = CO.IDProposta
INNER JOIN Dados.Unidade UN
ON UN.ID = IDUnidadeVenda

WHERE co.DataQuitacaoParcela >= '20120501'
and PRD.CodigoComercializado IN ('3104','3105','3107','3120','3133','3136','3138','3142','3143'
,'3144','3145','3146','3147','3148','3149','3172','3173','3174'
,'3175','3176','3177','3178','3179','3180') --and cto.NumeroContrato = '1103100036855'

group by PRD.CodigoComercializado --[CodigoProduto]
	  ,PRD.Descricao --[NomeProduto]
	  ,PRP.NumeroProposta --[NumeroProposta]
      ,CTO.NumeroContrato --[NumeroApolice]
	  ,PercentualCorretagem
      ,co.NumeroRecibo
      ,OP.Codigo --[CodigoOperacao]
      ,UN.Codigo --[CodigoAgencia]
      ,[NumeroEndosso]
      ,[NumeroParcela]
	  ,[DataCompetencia]
      ,[DataCalculo]
      ,[DataQuitacaoParcela]
	  , co.DataRecibo     
      
--order by CTO.NumeroContrato
