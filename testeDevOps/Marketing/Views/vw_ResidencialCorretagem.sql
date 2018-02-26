                
/*
	Autor: Gustavo Moreira
	Data Criação: 29/08/2013

	Descrição: 
	
	Última alteração :  
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Marketing.vw_ResidencialCorretagem
	Descrição: Procedimento que realiza a recuperação das apólices recebidas na comissão.
	
	
					
	Retorno:

*******************************************************************************/ 
create VIEW Marketing.vw_ResidencialCorretagem
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
and PRD.CodigoComercializado IN ('1402','1403','1404','1405','1406','1407','1408') --and cto.NumeroContrato = '1103100036855'

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
      ,[DataCalculo]
      ,[DataQuitacaoParcela]
	  , co.DataRecibo     
      
--order by CTO.NumeroContrato
