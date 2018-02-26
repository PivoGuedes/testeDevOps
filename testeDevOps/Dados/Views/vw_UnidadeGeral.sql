
/*
	Autor: Egler Vieira
	Data Criação: 03/07/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: Corporativo.[Dados].[vw_UnidadeGeral]
	Descrição: View que rastreia todas as atualização de todas as Unidades
		
	Parâmetros de entrada:
	
					
	Retorno:
*******************************************************************************/
CREATE VIEW [Dados].[vw_UnidadeGeral]
AS
SELECT UH.[ID]
      ,UH.[IDUnidade]
      ,U.[Codigo]
      ,UH.[Nome]
      ,UH.[IDTipoUnidade]
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
FROM Dados.Unidade U
LEFT JOIN  Dados.UnidadeHistorico UH
ON UH.IDUnidade = U.ID
