
/*
	Autor: Egler Vieira
	Data Criação: 01/03/2013

	Descrição: 
	
	Última alteração :  

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_ExportaTabelasAuxiliaresFaturamento
	Descrição: Procedimento que realiza a atualização dos dados das tabelas auxiliares para 
	           o banco de faturamento para integração com o PROTHEUS.
		
	Parâmetros de entrada:
	
					
	Retorno:

*******************************************************************************/ 

CREATE PROCEDURE Dados.proc_ExportaTabelasAuxiliaresFaturamento
AS

/*Atualiza RAMO*/				
MERGE INTO Faturamento.Dados.Ramo AS T
		USING (SELECT ID
		        , Codigo
		        , Nome
		        , TipoRamo
				FROM Corporativo.Dados.Ramo   ) AS O
		ON T.ID = O.ID			
		WHEN MATCHED
			THEN UPDATE SET 
			      T.Codigo = O.Codigo,
			      T.TipoRamo = O.TipoRamo,
			      T.Nome = O.Nome
			    
		WHEN NOT MATCHED
			THEN INSERT (ID, Codigo, Nome, TipoRamo)
				VALUES (O.ID, O.Codigo, O.Nome, O.TipoRamo);
				

/*Atualiza RAMO PAR*/				
MERGE INTO Faturamento.Dados.RamoPAR AS T
		USING (SELECT ID
		        , Codigo
		        , Nome
		        , IDRamoMestre
				FROM Corporativo.Dados.RamoPAR   ) AS O
		ON T.ID = O.ID			
		WHEN MATCHED
			THEN UPDATE SET 
			      T.Codigo = O.Codigo,
			      T.Nome = O.Nome,
			      T.IDRamoMestre = O.IDRamoMestre
		WHEN NOT MATCHED
			THEN INSERT (ID, Codigo, Nome, IDRamoMestre)
				VALUES (O.ID, O.Codigo, O.Nome, O.IDRamoMestre);
				

/*Atualiza RamoSUSEP*/				
MERGE INTO Faturamento.Dados.RamoSUSEP AS T
		USING (SELECT ID
		        , Codigo
		        , Nome
		        , Grupo
				FROM Corporativo.Dados.RamoSUSEP   ) AS O
		ON T.ID = O.ID			
		WHEN MATCHED
			THEN UPDATE SET 
			      T.Codigo = O.Codigo,
			      T.Grupo = O.Grupo,
			      T.Nome = O.Nome
			    
		WHEN NOT MATCHED
			THEN INSERT (ID, Codigo, Nome, Grupo)
				VALUES (O.ID, O.Codigo, O.Nome, O.Grupo);
				
/*Atualiza Seguradora*/				
MERGE INTO Faturamento.Dados.Seguradora AS T
		USING (SELECT ID
		        , Codigo
		        , Nome
				FROM Corporativo.Dados.Seguradora   ) AS O
		ON T.ID = O.ID			
		WHEN MATCHED
			THEN UPDATE SET 
			      T.Codigo = O.Codigo,
			      T.Nome = O.Nome
			    
		WHEN NOT MATCHED
			THEN INSERT (ID, Codigo, Nome)
				VALUES (O.ID, O.Codigo, O.Nome);
				
				
				
/*Atualiza PRODUTO*/				
MERGE INTO Faturamento.Dados.Produto AS T
		USING (SELECT ID
		        , CodigoComercializado
		        , IDRamoPrincipal
		        , IDRamoSUSEP
	          , IDRamoPAR
		        , Descricao
		        , DataInicioComercializacao
		        , DataFimComercializacao
		        , IDSeguradora
				FROM Corporativo.Dados.Produto   ) AS O
		ON T.ID = O.ID			
		WHEN MATCHED
			THEN UPDATE SET 
			      T.CodigoComercializado = O.CodigoComercializado,
			      T.IDRamoPrincipal = O.IDRamoPrincipal,
			      T.IDRamoSUSEP = O.IDRamoSUSEP,
			      T.IDRamoPAR = O.IDRamoPAR,
			      T.Descricao = O.Descricao,
			      T.DataInicioComercializacao = O.DataInicioComercializacao,
			      T.DataFimComercializacao = O.DataFimComercializacao,
			      T.IDSeguradora = O.IDSeguradora
		WHEN NOT MATCHED
			THEN INSERT (ID, CodigoComercializado, IDRamoPrincipal, IDRamoSUSEP, IDRamoPAR, Descricao, DataInicioComercializacao, DataFimComercializacao, IDSeguradora)
				VALUES (O.ID, O.CodigoComercializado, O.IDRamoPrincipal, O.IDRamoSUSEP, o.IDRamoPAR, o.Descricao, DataInicioComercializacao, DataFimComercializacao, IDSeguradora);				
				
				


/*Atualiza PRODUTO RAMO*/				
MERGE INTO Faturamento.Dados.ProdutoRamo AS T
		USING (SELECT IDProduto
		        , IDRamo
				FROM Corporativo.Dados.ProdutoRamo   ) AS O
		ON T.IDProduto = O.IDProduto			
       AND T.IDRamo = O.IDRamo
		WHEN NOT MATCHED
			THEN INSERT (IDProduto, IDRamo)
				VALUES (O.IDProduto, O.IDRamo);	
		
				
/*Atualiza CanalVendaPAR*/				
MERGE INTO Faturamento.Dados.CanalVendaPAR AS T
		USING (SELECT  C.ID
		             , C.IDCanalMestre
		             , C.Nome
				FROM Corporativo.Dados.CanalVendaPAR C) AS O
		ON T.ID = O.ID			
		WHEN MATCHED
			THEN UPDATE SET 
			      T.IDCanalMestre = O.IDCanalMestre,
			      T.Nome = O.Nome			    
		WHEN NOT MATCHED
			THEN INSERT (ID, IDCanalMestre, Nome)
				VALUES (O.ID, O.IDCanalMestre, O.Nome);
				
				
		
/*Atualiza FilialFaturamento*/				
MERGE INTO Faturamento.Dados.FilialFaturamento AS T
		USING (SELECT  C.ID
		             , C.Codigo
		             , C.Nome
		             , C.Cidade
		             , C.RetemIR
		             , C.BaseISS
		             , IBGE
				FROM Corporativo.Dados.FilialFaturamento C) AS O
		ON T.ID = O.ID			
		WHEN MATCHED
			THEN UPDATE SET 
			      T.Codigo = O.Codigo,
			      T.Nome = O.Nome,
			      T.Cidade = O.Cidade,
			      T.RetemIR = O.RetemIR,
			      T.BaseISS = O.BaseISS,
			      T.IBGE = O.IBGE			    
		WHEN NOT MATCHED
			THEN INSERT (ID, Codigo, Nome, Cidade, RetemIR, BaseISS, IBGE)
				VALUES (O.ID, O.Codigo, O.Nome, O.Cidade, O.RetemIR, O.BaseISS, O.IBGE);
				
				
	
		
/*Atualiza FilialFaturamento*/				
MERGE INTO Faturamento.Dados.FilialFaturamento AS T
		USING (SELECT  C.ID
		             , C.Codigo
		             , C.Nome
		             , C.Cidade
		             , C.RetemIR
		             , C.BaseISS
		             , IBGE
				FROM Corporativo.Dados.FilialFaturamento C) AS O
		ON T.ID = O.ID			
		WHEN MATCHED
			THEN UPDATE SET 
			      T.Codigo = O.Codigo,
			      T.Nome = O.Nome,
			      T.Cidade = O.Cidade,
			      T.RetemIR = O.RetemIR,
			      T.BaseISS = O.BaseISS,
			      T.IBGE = O.IBGE			    
		WHEN NOT MATCHED
			THEN INSERT (ID, Codigo, Nome, Cidade, RetemIR, BaseISS, IBGE)
				VALUES (O.ID, O.Codigo, O.Nome, O.Cidade, O.RetemIR, O.BaseISS, O.IBGE);								
				
				
/*Atualiza TIPO UNIDADE*/				
MERGE INTO Faturamento.Dados.TipoUnidade AS T
		USING (SELECT ID
		        , Descricao
				FROM Corporativo.Dados.TipoUnidade T  ) AS O
		ON T.ID = O.ID			
		WHEN MATCHED
			THEN UPDATE SET 
			      T.Descricao = O.Descricao
			    
		WHEN NOT MATCHED
			THEN INSERT (ID, Descricao)
				VALUES (O.ID, O.Descricao);				
				
				
				
				
/*Atualiza FILIAL PAR CORRETORA*/				
MERGE INTO Faturamento.Dados.FilialPARCorretora AS T
		USING (SELECT ID
		        , Nome
		        , Codigo
				FROM Corporativo.Dados.FilialPARCorretora T  ) AS O
		ON T.ID = O.ID			
		WHEN MATCHED
			THEN UPDATE SET 
			      T.Nome = O.Nome
			    , T.Codigo = O.Codigo
			    
		WHEN NOT MATCHED
			THEN INSERT (ID, Nome, Codigo)
				VALUES (O.ID, O.Nome, O.Codigo);				
				
											
								
/*Atualiza UNIDADE*/				
MERGE INTO Faturamento.Dados.Unidade AS T
		USING (SELECT IDUnidade [ID]
        , Codigo	
        , T.Nome 
        , T.IDFilialPARCorretora
        , T.IDFilialFaturamento
				, T.IDUnidadeEscritorioNegocio 			
				, T.IDTipoUnidade 
				, T.IDRetaguarda
				, T.IDTipoPV
				, T.UFMunicipio
				, T.Endereco
				, T.Bairro
				, T.NomeMunicipio
				, T.CEP 
				, T.DataCriacao
				, T.DataExtincao
				, T.DataAutomacao 
				, T.DataFimOperacao 
				, T.Praca 
				, T.AutenticarPV 
				, T.Porte
				, T.Rota
				, T.Impressa 
				, T.Responsavel 
				, T.CodigoEnderecamento
				, T.SiglaUnidade 
				, T.CanalVoz 
				, T.JusticaFederal 
				, T.ClassePV 
				, T.DDD 
				, T.Telefone1 
				, T.TipoTelefone1 
				, T.Telefone2 
				, T.TipoTelefone2
				, T.Telefone3 
				, T.TipoTelefone3 
				, T.Telefone4 
				, T.TipoTelefone4
				, T.Telefone5
				, T.TipoTelefone5
				, T.MatriculaGestor 
				, T.IBGE
				, T.ASVEN
				, T.CodigoNaFonte	
				, T.TipoDado 
				, T.Arquivo 
				, T.DataArquivo
				FROM Corporativo.Dados.vw_Unidade T  ) AS O
		ON T.ID = O.ID			
		WHEN MATCHED
			THEN UPDATE SET 
			    T.ID = O.ID
			  , T.Codigo = O.Codigo
			  , T.Nome = O.Nome
        , T.IDFilialPARCorretora = O.IDFilialPARCorretora
        , T.IDFilialFaturamento = O.IDFilialFaturamento
				, T.IDUnidadeEscritorioNegocio = O.IDUnidadeEscritorioNegocio
				, T.IDTipoUnidade = O.IDTipoUnidade
				, T.IDRetaguarda = O.IDRetaguarda
				, T.IDTipoPV = O.IDTipoPV
				, T.UFMunicipio = O.UFMunicipio
				, T.Endereco = O.Endereco
				, T.Bairro = O.Bairro
				, T.NomeMunicipio = O.NomeMunicipio
				, T.CEP = O.CEP
				, T.DataCriacao = O.DataCriacao
				, T.DataExtincao = O.DataExtincao
				, T.DataAutomacao = O.DataAutomacao
				, T.DataFimOperacao = O.DataFimOperacao
				, T.Praca = O.Praca
				, T.AutenticarPV = O.AutenticarPV
				, T.Porte = O.Porte
				, T.Rota = O.Rota
				, T.Impressa = O.Impressa
				, T.Responsavel = O.Responsavel
				, T.CodigoEnderecamento = O.CodigoEnderecamento
				, T.SiglaUnidade = O.SiglaUnidade
				, T.CanalVoz = O.CanalVoz
				, T.JusticaFederal = O.JusticaFederal
				, T.ClassePV = O.ClassePV
				, T.DDD = O.DDD
				, T.Telefone1 = O.Telefone1
				, T.TipoTelefone1 = O.TipoTelefone1 
				, T.Telefone2 = O.Telefone2
				, T.TipoTelefone2 = O.TipoTelefone2 
				, T.Telefone3 = O.Telefone3
				, T.TipoTelefone3 = O.TipoTelefone3 
				, T.Telefone4 = O.Telefone4
				, T.TipoTelefone4 = O.TipoTelefone4 
				, T.Telefone5 = O.Telefone5
				, T.TipoTelefone5 = O.TipoTelefone5 
				, T.MatriculaGestor = O.MatriculaGestor 
				, T.IBGE = O.IBGE
				, T.ASVEN = O.ASVEN
				, T.CodigoNaFonte	= O.CodigoNaFonte
				, T.TipoDado = O.TipoDado
				, T.Arquivo = O.Arquivo
				, T.DataArquivo = O.DataArquivo
		WHEN NOT MATCHED
			THEN INSERT (ID, IDTipoUnidade, IDUnidadeEscritorioNegocio, IDFilialFaturamento, IDFilialPARCorretora, IDTipoPV, IDRetaguarda, UFMunicipio, Codigo, CodigoNaFonte, Nome, Endereco
				, Bairro, CEP, DDD, DataCriacao, DataExtincao, DataAutomacao, Praca, AutenticarPV, Porte
				, Rota, Impressa, Responsavel, CodigoEnderecamento, SiglaUnidade, CanalVoz, JusticaFederal
				, DataFimOperacao, ClassePV, NomeMunicipio, Telefone1, TipoTelefone1, Telefone2
				, TipoTelefone2, Telefone3, TipoTelefone3, Telefone4, TipoTelefone4, Telefone5
				, TipoTelefone5, MatriculaGestor, IBGE, ASVEN, TipoDado, Arquivo, DataArquivo)
				VALUES (O.ID, O.IDTipoUnidade, O.IDUnidadeEscritorioNegocio, O.IDFilialFaturamento, O.IDFilialPARCorretora, O.IDTipoPV, O.IDRetaguarda, O.UFMunicipio, O.Codigo, o.CodigoNaFonte, O.Nome, O.Endereco
				, O.Bairro, O.CEP, O.DDD, O.DataCriacao, O.DataExtincao, O.DataAutomacao, O.Praca, O.AutenticarPV, O.Porte
				, O.Rota, O.Impressa, O.Responsavel, O.CodigoEnderecamento, O.SiglaUnidade, O.CanalVoz, O.JusticaFederal
				, O.DataFimOperacao, O.ClassePV, O.NomeMunicipio, O.Telefone1, O.TipoTelefone1, O.Telefone2, O.TipoTelefone2
				, O.Telefone3, O.TipoTelefone3, O.Telefone4, O.TipoTelefone4, O.Telefone5, O.TipoTelefone5, O.MatriculaGestor
				, O.IBGE, O.ASVEN, O.TipoDado, O.Arquivo, O.DataArquivo);	

--SELECT * FROM Faturamento.Dados.Unidade


GRANT EXECUTE ON [Dados].[proc_ExportaTabelasAuxiliaresFaturamento] TO [db_spExec]
