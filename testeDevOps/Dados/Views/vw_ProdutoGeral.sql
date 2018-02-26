
/*
	Autor: Egler Vieira
	Data Criação: 14/07/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: Corporativo.[Dados].[vw_ProdutoGeral]
	Descrição: View que rastreia todas as atualização de todos os Produtos
		
	Parâmetros de entrada:
	
					
	Retorno:
*******************************************************************************/
CREATE VIEW [Dados].[vw_ProdutoGeral]
AS
SELECT PH.ID
      ,PRD.[ID] [IDProduto]
      ,[CodigoComercializado]
      ,[IDRamoPrincipal]
      ,[IDRamoSUSEP]
      ,[IDRamoPAR]
      ,[IDSeguradora]
	  ,PH.IDPeriodoContratacao
      ,PH.[Descricao]
      ,PH.[DataInicioComercializacao]
      ,PH.[DataFimComercializacao]
      ,PH.[DataInicio]
      ,PH.[DataFim]
      --,PH.[RunOff]
      ,PH.MetaASVEN
      ,PH.MetaAVCaixa
      ,PH.PercentualASVEN
      ,PH.PercentualCorretora
      ,PH.PercentualRepasse    
	  ,PH.IDProdutoSegmento  

  FROM [Dados].[Produto] PRD
LEFT JOIN [Dados].[ProdutoHistorico] PH
ON PRD.ID = PH.IDProduto
WHERE PRD.ID <> -1   

--SELECT * FROM [Dados].[vw_ProdutoGeral]
