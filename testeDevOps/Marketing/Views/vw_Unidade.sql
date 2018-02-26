



/*
	Autor: Gustavo Moreira
	Data Criação: 07/01/2013

	Descrição:
	
	Última alteração : Inclusão do campo [DescricaoTipoPV] - Gustavo Moreira
	Data: 07/04/2013

*/

/*******************************************************************************
	Nome: Corporativo.[Marketing].[vw_Unidade]
	Descrição: View que disponibiliza no esquema Marketing as informações recuperadas da
View [Dados].[vw_Unidade]
		
	Parâmetros de entrada:
	
					
	Retorno:
*******************************************************************************/
CREATE VIEW [Marketing].[vw_Unidade]
AS
SELECT      Codigo, 
			Nome, 
			TipoUnidade,
			DescricaoTipoPV,
			Endereco, 
			Bairro, 
			CEP, 
			DDD, 
			DataCriacao, 
			DataExtincao, 
			DataAutomacao, 
			Praca, 
			AutenticarPV, 
			Porte, 
			Rota, 
			Impressa,
			Responsavel, 
			CodigoEnderecamento, 
			SiglaUnidade, 
			CanalVoz, 
			JusticaFederal, 
			DataFimOperacao, 
			ClassePV, 
			NomeMunicipio, 
			UFMunicipio, 
			Telefone1,
			TipoTelefone1, 
			Telefone2, 
			TipoTelefone2, 
			Telefone3, 
			TipoTelefone3, 
			Telefone4, 
			TipoTelefone4, 
			Telefone5, 
			TipoTelefone5, 
			ASVEN, 
			IBGE,
			MatriculaGestor, 
			CodigoNaFonte, 
			TipoDado, 
			Arquivo, 
			DataArquivo, 
			NomeFilialPARCorretora, 
			NomeFilialFaturamento, 
			CodigoUnidadeSuperior,
			NomeUnidadeSuperior, 
			TipoUnidadeSuperior

FROM         Dados.vw_Unidade


--SELECT * FROM [Marketing].[vw_Unidade]

