
/*
	Autor: Egler Vieira
	Data Criação: 03/07/2013

	Descrição: 
	
	Última alteração : 07/04/2013 - Gustavo Moreira
	Descrição: Inclusão da descrição do TipoPV
	
	
*/

/*******************************************************************************
	Nome: [Dados].[vw_Unidade]
	Descrição: View que rastreia a última atualização de todas as Unidades
		
	Parâmetros de entrada:
	
					
	Retorno:
*******************************************************************************/
CREATE VIEW [Dados].[vw_Unidade]
WITH SCHEMABINDING
AS
SELECT UH.[ID]
      ,U.ID [IDUnidade]
      ,U.[Codigo]
      ,UH.[Nome]
      ,UH.[IDTipoUnidade]
      ,TUU.Descricao [TipoUnidade]
      ,TPV.Descricao [DescricaoTipoPV]
      ,UH.[IDFilialPARCorretora]
      ,UH.[IDFilialFaturamento]
      ,UH.[IDUnidadeEscritorioNegocio]
      ,UH.[Endereco]
      ,UH.[Bairro]
      ,UH.[CEP]
      ,UH.[DDD]
      ,UH.[DataCriacao]
      ,UH.[DataExtincao]
      ,UH.[DataAutomacao]
      ,UH.[Praca]
      ,UH.[IDTipoPV]
      ,UH.[IDRetaguarda]
      ,UH.[AutenticarPV]
      ,UH.[Porte]
      ,UH.[Rota]
      ,UH.[Impressa]
      ,UH.[Responsavel]
      ,UH.[CodigoEnderecamento]
      ,UH.[SiglaUnidade]
      ,UH.[CanalVoz]
      ,UH.[JusticaFederal]
      ,UH.[DataFimOperacao]
      ,UH.[ClassePV]
      ,UH.[NomeMunicipio]
      ,UH.[UFMunicipio]
      ,UH.[Telefone1]
      ,UH.[TipoTelefone1]
      ,UH.[Telefone2]
      ,UH.[TipoTelefone2]
      ,UH.[Telefone3]
      ,UH.[TipoTelefone3]
      ,UH.[Telefone4]
      ,UH.[TipoTelefone4]
      ,UH.[Telefone5]
      ,UH.[TipoTelefone5]
      ,UH.[ASVEN]
      ,UH.[IBGE]
      ,UH.[MatriculaGestor]
      ,UH.[CodigoNaFonte]
      ,UH.[TipoDado]
      ,UH.[Arquivo]
      ,UH.[DataArquivo]
      , FPC.Nome [NomeFilialPARCorretora]
      , FF.Nome AS NomeFilialFaturamento
      , UENH.Codigo AS CodigoUnidadeSuperior
      , UENH.Nome AS NomeUnidadeSuperior
      , TUEN.Descricao [TipoUnidadeSuperior]
FROM Dados.Unidade U
OUTER APPLY (SELECT TOP 1  [ID],[IDUnidade],[Codigo],[Nome],[IDTipoUnidade],[IDFilialPARCorretora]
,[IDFilialFaturamento],[IDUnidadeEscritorioNegocio],[Endereco],[Bairro],[CEP]
,[DDD],[DataCriacao],[DataExtincao],[DataAutomacao],[Praca]
,[IDTipoPV],[IDRetaguarda],[AutenticarPV],[Porte],[Rota],[Impressa],[Responsavel]
,[CodigoEnderecamento],[SiglaUnidade],[CanalVoz],[JusticaFederal],[DataFimOperacao]
,[ClassePV],[NomeMunicipio],[UFMunicipio],[Telefone1] ,[TipoTelefone1]	 ,[Telefone2]
,[TipoTelefone2]									  ,[Telefone3]
,[TipoTelefone3]					,[Telefone4]
,[TipoTelefone4]				,[Telefone5]
,[TipoTelefone5]			,[ASVEN]
,[IBGE]					   ,[MatriculaGestor]
,[CodigoNaFonte]		  ,[TipoDado]
,[Arquivo]				  ,[DataArquivo]
             FROM Dados.UnidadeHistorico UH
             WHERE UH.IDUnidade = U.ID
             ORDER BY UH.IDUnidade, UH.DataArquivo DESC, UH.ID DESC) UH
  LEFT JOIN Dados.TipoUnidade TUU
  ON UH.IDTipoUnidade = TUU.ID
  LEFT JOIN Dados.FilialFaturamento FF 
  ON FF.ID = UH.IDFilialFaturamento
  LEFT JOIN Dados.FilialPARCorretora FPc 
  ON FPC.ID = UH.IDFilialPARCorretora   
  OUTER APPLY (SELECT TOP 1 UHEN.Codigo, UHEN.Nome, UHEN.IDTipoUnidade
               FROM Dados.UnidadeHistorico UHEN
               WHERE UHEN.IDUnidade = UH.IDUnidadeEscritorioNegocio
               ORDER BY UH.IDUnidade, UH.DataArquivo DESC, UH.ID DESC) UENH
  LEFT JOIN Dados.TipoUnidade TUEN
  ON UENH.IDTipoUnidade = TUEN.ID
  LEFT JOIN Dados.TipoPV TPV
  ON TPV.ID = UH.IDTipoPV

--SELECT * FROM [Dados].[vw_Unidade]



