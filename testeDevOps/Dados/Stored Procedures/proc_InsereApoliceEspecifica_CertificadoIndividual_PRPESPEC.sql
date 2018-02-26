
/*
	Autor: Diego Lima
	Data Criação: 18/11/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereApoliceEspecifica_CertificadoIndividual_PRPESPEC
	Descrição: Procedimento que realiza a inserção de certificados individuais no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InsereApoliceEspecifica_CertificadoIndividual_PRPESPEC] 
AS

BEGIN TRY	

DECLARE @PontoDeParada AS DATE
DECLARE @MaiorCodigo AS DATE
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CERTIFICADOINDIVIDUAL_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[CERTIFICADOINDIVIDUAL_TEMP];

CREATE TABLE [dbo].[CERTIFICADOINDIVIDUAL_TEMP] (
													[Codigo] [int] NOT NULL,
													[ControleVersao] [numeric](16, 8) NULL,
													[NomeArquivo] [varchar](100) NOT NULL,
													[DataArquivo] [date] NOT NULL,
													[NumeroProposta] [varchar](20) NULL,
													[NumeroFuncionario] [varchar](20) NULL,
													[CPFCNPJ] [varchar](18) NULL,
													[Nome] [varchar](140) NULL,
													[DataNascimento] [date] NULL,
													[Idade] [int] NULL,
													[CodigoSexo] [tinyint] NULL,
													[Sexo] [varchar](30) NULL,
													[CodigoEstadoCivil] [tinyint] NULL,
													[EstadoCivil] [varchar](30) NULL,
													[DDD] [varchar](3) NULL,
													[Telefone] [varchar](9) NULL,
													[Identidade] [varchar](17) NULL,
													[OrgaoExpedidor] [varchar](5) NULL,
													[UFOrgaoExpedidor] [varchar](2) NULL,
													[DataEmissaoRG] [date] NULL,
													[CodigoProfissao] [varchar](5) NULL,
													[NivelCargo] [varchar](60) NULL,
													[IndicadorRepresentante] [varchar](20) NULL,
													[IndicadorImpressaoDPS] [varchar](20) NULL,
													[Endereco] [varchar](100) NULL,
													[Bairro]   [varchar](80) NULL,
													[Cidade]   [varchar](80) NULL,
													[UF]  [varchar](2) NULL,
													[CEP]      [varchar](9) NULL,
													[ValorSalario] [numeric](19, 2) NULL,
													[QuantidadeSalario] [int] NULL,
													[ValorImportanciaSegurada] [numeric](19, 2) NULL,
													[ValorPremio] [numeric](19, 2) NULL,
													[NumeroCertificadoIndividual] [varchar](20) NULL,
													[DataInicioVigencia] [date] NULL,
													[DataFimVigencia] [date] NULL
);


 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_CERTIFICADOINDIVIDUAL_TEMP ON [dbo].[CERTIFICADOINDIVIDUAL_TEMP]
( 
  Codigo ASC
)   

CREATE NONCLUSTERED INDEX idx_CERTIFICADOINDIVIDUAL_TEMP_Proposta
ON [dbo].[CERTIFICADOINDIVIDUAL_TEMP] ([NumeroProposta])
INCLUDE ([NomeArquivo],[DataArquivo])
  

/* SELECIONA O ÚLTIMO PONTO DE PARADA */

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'CertificadoIndividual_PRPESPEC'

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
-- DECLARE @PontoDeParada DATE
-- set @PontoDeParada = '2011-05-10'
--DECLARE @MaiorCodigo AS DATE
--DECLARE @ParmDefinition NVARCHAR(500)
--DECLARE @COMANDO AS NVARCHAR(MAX) 

SET @ParmDefinition = N'@MaiorCodigo DATE OUTPUT';     

SET @COMANDO = 'SELECT @MaiorCodigo= EM.MaiorData
                FROM OPENQUERY ([OBERON], 
                '' SELECT MAX(AE.DataArquivo) [MaiorData]
                    FROM FENAE.dbo.PRPESPEC_ApoliceEspecifica_Tipo6 AE
                    WHERE  AE.TipoInformacao = 2 AND AE.DataArquivo >= ''''' + Cast(@PontoDeParada as varchar(10)) + ''''''') EM';

                
exec sp_executesql @COMANDO
                ,@ParmDefinition
                ,@MaiorCodigo = @MaiorCodigo OUTPUT;

--print @MaiorCodigo

 --   DECLARE @COMANDO AS NVARCHAR(MAX) 
	--DECLARE @PontoDeParada AS VARCHAR(400) SET @PONTODEPARADA = 0           


--SELECT @MaiorCodigo= MAX(PRP.Codigo)
--FROM dbo.[CERTIFICADOINDIVIDUAL_TEMP] PRP 

/*********************************************************************************************************************/

WHILE @PontoDeParada <= @MaiorCodigo
BEGIN 

SET @COMANDO = 'INSERT INTO [dbo].[CERTIFICADOINDIVIDUAL_TEMP]
           ([Codigo],[ControleVersao],[NomeArquivo],[DataArquivo],[NumeroProposta],[NumeroFuncionario]
			,[CPFCNPJ],[Nome],[DataNascimento],[Idade],[CodigoSexo],[Sexo],[CodigoEstadoCivil],[EstadoCivil]
			,[DDD],[Telefone],[Identidade],[OrgaoExpedidor],[UFOrgaoExpedidor],[DataEmissaoRG],[CodigoProfissao]
			,[NivelCargo],[IndicadorRepresentante],[IndicadorImpressaoDPS],[Endereco],[Bairro],[Cidade],[UF]
			,[CEP],[ValorSalario],[QuantidadeSalario],[ValorImportanciaSegurada],[ValorPremio]
			,[NumeroCertificadoIndividual],[DataInicioVigencia],[DataFimVigencia])

		   SELECT distinct [Codigo],[ControleVersao],[NomeArquivo],[DataArquivo],[NumeroProposta],[NumeroFuncionario]
			,[CPF],REPLACE([Nome],''?'',''_'') Nome,[DataNascimento],[Idade],[CodigoSexo],[Sexo],[CodigoEstadoCivil],[EstadoCivil]
			,[DDD],[Telefone],[RG],[OrgaoExpedidor],[UFOrgaoExpedidor],[DataEmissaoRG],[CodigoProfissao]
			,[NivelCargo],[IndicadorRepresentante],[IndicadorImpressaoDPS],[Endereco],[Bairro],[Cidade],[UF]
			,[CEP],[ValorSalario],[QuantidadeSalario],[ValorImportanciaSegurada],[ValorPremio]
			,[NumeroCertificadoIndividual],[DataInicioVigencia],[DataFimVigencia]
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaApoliceEspecifica_VidaSegurada_PRPESPEC] ''''' + Cast(@PontoDeParada as varchar(10)) + ''''''') PRP
         ';


exec sp_executesql @COMANDO
--end
/**************************************************************************************************
		INSERE PROPOSTAS NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA
**************************************************************************************************/

;MERGE INTO Dados.Proposta AS T
    USING (
			SELECT DISTINCT t.[NumeroProposta], 
							1 [IDSeguradora], 
							t.nomeArquivo [TipoDado], 
							t.[DataArquivo]
			FROM [dbo].[CERTIFICADOINDIVIDUAL_TEMP] T
			WHERE t.NumeroProposta IS NOT NULL 
			
          ) X
    ON T.NumeroProposta = X.NumeroProposta
   AND T.IDSeguradora = X.IDSeguradora
   WHEN NOT MATCHED
          THEN INSERT (NumeroProposta, 
						[IDSeguradora], 
						IDAgenciaVenda, 
						IDProduto, 
						IDCanalVendaPAR, 
						IDSituacaoProposta, 
						IDTipoMotivo, 
						TipoDado, 
						DataArquivo)
               VALUES (X.[NumeroProposta], X.[IDSeguradora], -1, -1, -1, 0, -1, X.TipoDado, X.DataArquivo);  

/***********************************************************************
    Carrega os dados do estado civil não cadastrados
***********************************************************************/

--select * from [Dados].[EstadoCivil]
;MERGE INTO [Dados].[EstadoCivil] T
	USING (SELECT DISTINCT t.CodigoEstadoCivil, T.EstadoCivil, '-' AS Descricao
			FROM [dbo].[CERTIFICADOINDIVIDUAL_TEMP] t
		    ) X
			ON T.ID = X.CodigoEstadoCivil
			WHEN NOT MATCHED
		          THEN INSERT (ID, Descricao)
		               VALUES (X.CodigoEstadoCivil, X.Descricao);

/***********************************************************************
    Carrega os dados de sexo do cliente não cadastrados
***********************************************************************/

;MERGE INTO [Dados].[Sexo] T
	USING (SELECT DISTINCT t.CodigoSexo,t.Sexo,'-' as descricao
			FROM [dbo].[CERTIFICADOINDIVIDUAL_TEMP] t
			) X
		ON T.ID = X.CodigoSexo
			WHEN NOT MATCHED
		          THEN INSERT (ID, Descricao)
		               VALUES (X.CodigoSexo, X.descricao);

/***********************************************************************
    Carrega os dados de Certificado Individual
***********************************************************************/

 --DECLARE @PontoDeParada DATE
-- set @PontoDeParada = '2011-05-10'
--IF @PontoDeParada < '2013-08-08'

--BEGIN
--SELECT PRP.NumeroProposta, A.* FROM Dados.CertificadoIndividual A
--INNER JOIN DADOS.Proposta PRP
--ON A.IDProposta = PRP.ID
--WHERE Nome like 'KATI_SCIA DA CUNHA SOUZA'

--SELECT * FROM [CERTIFICADOINDIVIDUAL_TEMP] 
--WHERE Nome like 'KATI_SCIA DA CUNHA SOUZA' 

;MERGE INTO [Dados].[CertificadoIndividual] T
	USING ( SELECT * FROM (
							SELECT DISTINCT p.ID as IDProposta
											,t.[NumeroProposta]
											,[CPFCNPJ]
											,[dbo].[remove_acento]([Nome]) as Nome
											,[DataNascimento]
											,[CodigoSexo] AS IDSexo
											,[Sexo]
											,[CodigoEstadoCivil] AS IDEstadoCivil
											,[EstadoCivil]
											,[NumeroCertificadoIndividual]
											,t.[DataInicioVigencia]
											,t.[DataFimVigencia]
											,[NomeArquivo] AS TipoDado
											,t.[DataArquivo]
											,ROW_NUMBER() OVER(PARTITION BY t.[NumeroProposta], t.[CPFCNPJ], [dbo].[remove_acento](T.[Nome]),t.DataNascimento ORDER BY t.DataArquivo DESC )  [ORDER]
											

										FROM [dbo].[CERTIFICADOINDIVIDUAL_TEMP] T

										INNER JOIN dados.Proposta p
										on p.NumeroProposta = t.NumeroProposta
										AND p.IDSeguradora = 1
										) A
										where A.[order] = 1 --and  CPFCNPJ in ('008.803.143-89')
		)X

	  ON X.IDProposta = T.IDProposta
	    --AND T.ID <> 2312145
		AND X.[CPFCNPJ] = T.[CPFCNPJ]
		--AND ISNULL(X.[Nome],'') = ISNULL(T.[Nome],'') 
		AND (
		     ISNULL(T.[Nome],'') LIKE ISNULL(X.[Nome],'')
		     OR
			 ISNULL(X.[Nome],'') LIKE ISNULL(T.[Nome],'') 
			 ) --##DID## BUSCAR O NOME CORRETO MESMO QUANDO HOUVER CARACTER BICHADO. -> LIKE COM '_'
		AND ISNULL(X.[DataNascimento],'0001-01-01') = ISNULL(T.[DataNascimento],'0001-01-01')	

	WHEN MATCHED  AND X.DataArquivo >= T.DataArquivo 	AND T.[NumeroCertificadoIndividual] IS NULL -- para atualizar o numero certificado apenas nos campos de numero certificado individual NULL
			THEN UPDATE
						SET
						[NumeroCertificadoIndividual] = COALESCE(X.[NumeroCertificadoIndividual], T.[NumeroCertificadoIndividual])
						,[DataInicioVigencia] = COALESCE(X.[DataInicioVigencia], T.[DataInicioVigencia])
						,[DataFimVigencia] = COALESCE(X.[DataFimVigencia], T.[DataFimVigencia])
						,[TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
						,[DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo])
						,[Nome] = CASE WHEN CHARINDEX('_', X.[Nome]) > 0 THEN  T.nome
													ELSE X.nome
													end

	WHEN NOT MATCHED
			THEN INSERT ([IDProposta]
						  ,[CPFCNPJ]
						  ,[Nome]
						  ,[DataNascimento]
						  ,[IDSexo]
						  ,[IDEstadoCivil]
						  ,[NumeroCertificadoIndividual]
						  ,[DataInicioVigencia]
						  ,[DataFimVigencia]
						  ,[TipoDado]
						  ,[DataArquivo])
				VALUES (X.[IDProposta],X.[CPFCNPJ], X.Nome,
				        X.[DataNascimento],X.[IDSexo],
						X.[IDEstadoCivil],X.[NumeroCertificadoIndividual],X.[DataInicioVigencia],
						X.[DataFimVigencia],X.[TipoDado],X.[DataArquivo]
						);

-------------------------------------------------------------------------------------------------
-- Aqui vai verificar se a proposta existe mais de um certificado individual
-----------------------------------------------------------------------------------------------

;MERGE INTO [Dados].[CertificadoIndividual] T
	USING ( SELECT * FROM (
							SELECT DISTINCT p.ID as IDProposta
											,t.[NumeroProposta]
											,[CPFCNPJ]
											,[dbo].[remove_acento]([Nome])[Nome]
											,[DataNascimento]
											,[CodigoSexo] AS IDSexo
											,[Sexo]
											,[CodigoEstadoCivil] AS IDEstadoCivil
											,[EstadoCivil]
											,[NumeroCertificadoIndividual]
											,t.[DataInicioVigencia]
											,t.[DataFimVigencia]
											,[NomeArquivo] AS TipoDado
											,t.[DataArquivo]
											,ROW_NUMBER() OVER(PARTITION BY t.[NumeroProposta],t.[NumeroCertificadoIndividual] ORDER BY t.DataArquivo DESC )  [ORDER]

										FROM [dbo].[CERTIFICADOINDIVIDUAL_TEMP] T

										INNER JOIN dados.Proposta p
										on p.NumeroProposta = t.NumeroProposta
										AND p.IDSeguradora = 1
										) A
										where A.[order] = 1
		)X

	  ON    ISNULL(X.IDProposta,-1) = ISNULL(T.IDProposta,-1)
		AND ISNULL(X.[NumeroCertificadoIndividual],'') = ISNULL(T.[NumeroCertificadoIndividual],'')
	
	WHEN MATCHED AND X.DataArquivo >= T.DataArquivo AND T.[NumeroCertificadoIndividual]  IS NOT NULL -- foi feito essa condição apenas numero de certificados individuais validos para o mesmo id proposta
			THEN UPDATE
						SET
						
						[NumeroCertificadoIndividual] = COALESCE(X.[NumeroCertificadoIndividual], T.[NumeroCertificadoIndividual])
						,[TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
						,[DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo])
						

	WHEN NOT MATCHED
			THEN INSERT ([IDProposta]
						  ,[CPFCNPJ]
						  ,[Nome]
						  ,[DataNascimento]
						  ,[IDSexo]
						  ,[IDEstadoCivil]
						  ,[NumeroCertificadoIndividual]
						  ,[DataInicioVigencia]
						  ,[DataFimVigencia]
						  ,[TipoDado]
						  ,[DataArquivo])
				VALUES (X.[IDProposta],X.[CPFCNPJ],X.[Nome],X.[DataNascimento],X.[IDSexo],
						X.[IDEstadoCivil],X.[NumeroCertificadoIndividual],X.[DataInicioVigencia],
						X.[DataFimVigencia],X.[TipoDado],X.[DataArquivo]
						);

/***********************************************************************
    Carrega os dados de Certificado Individual Historico
***********************************************************************/
     /***********************************************************************

/*Apaga a marcação do flag ativo dos certificados individuais historico recebidos para atualizar a última posição
-> logo depois da inserção dos certificados individuais*/

/*Diego Lima - Data: 10/10/2013 */

     ***********************************************************************/	  
UPDATE [Dados].[CertificadoIndividualHistorico] SET [FlagAtivo] = 0
    --SELECT *
    FROM [Dados].[CertificadoIndividualHistorico]  PS --(readuncommitted)
    WHERE PS.[IDCertificadoIndividual] IN (
											SELECT DISTINCT ci.ID
											FROM [dbo].[CERTIFICADOINDIVIDUAL_TEMP] T --(readuncommitted)
												INNER JOIN dados.Proposta p --(readuncommitted)
												ON p.NumeroProposta = t.NumeroProposta
													AND p.IDSeguradora = 1
												INNER JOIN [Dados].[CertificadoIndividual] CI --(readuncommitted)
												ON ci.IDProposta = p.ID
							-- AND T.[DataProposta] >= PS.[DataArquivo]
                           )
           AND PS.[FlagAtivo] = 1

 /***********************************************************************
       Carrega os dados de certificado individual historico
 ***********************************************************************/ 
 
;MERGE INTO  [Dados].[CertificadoIndividualHistorico] AS T
		USING (
				SELECT * 
					FROM (SELECT DISTINCT 
								 ci.ID AS IDCertificadoIndividual
								  ,t.[Identidade]
								  ,t.[OrgaoExpedidor]
								  ,t.[UFOrgaoExpedidor]
								  ,t.[DataEmissaoRG]
								  ,t.[DDD]
								  ,t.[Telefone]
								  ,t.[CodigoProfissao]
								  ,t.[NivelCargo]
								  ,t.[IndicadorRepresentante]
								  ,t.[IndicadorImpressaoDPS]
								  ,t.[Endereco]
								  ,t.[Bairro]
								  ,t.[Cidade]
								  ,t.[UF]
								  ,t.[CEP]
								  ,t.[ValorSalario]
								  ,t.[QuantidadeSalario]
								  ,t.[ValorImportanciaSegurada]
								  ,t.[ValorPremio]
								  ,t.NomeArquivo as TipoDado
								  ,t.[DataArquivo]
								  ,0 AS [FlagAtivo]
								  ,ROW_NUMBER() OVER (PARTITION BY ci.ID ORDER BY t.[DataArquivo] DESC) NUMERADOR
								  --into #teste

					FROM [dbo].[CERTIFICADOINDIVIDUAL_TEMP] T
						INNER JOIN dados.Proposta p
							ON p.NumeroProposta = t.NumeroProposta
								AND p.IDSeguradora = 1
						INNER JOIN [Dados].[CertificadoIndividual] CI
							ON ci.IDProposta = p.ID
								AND ISNULL(CI.[NumeroCertificadoIndividual],'') = ISNULL(T.[NumeroCertificadoIndividual],'')
								AND ISNULL(CI.[CPFCNPJ],'') = ISNULL(T.[CPFCNPJ],'')
								--AND ISNULL(CI.[Nome],'') = ISNULL(T.[Nome],'')
								--AND ISNULL(CI.[DataNascimento],'0001-01-01') = ISNULL(T.[DataNascimento],'0001-01-01')
					--where ci.id in (83900,113521) 
					) A
				WHERE a.NUMERADOR = 1
			)X

		ON X.IDCertificadoIndividual = T.IDCertificadoIndividual
		
		WHEN MATCHED AND X.[DataArquivo] >= T.[DataArquivo] 
			THEN UPDATE
				SET [Identidade] = COALESCE(X.[Identidade], T.[Identidade]) 
					,[OrgaoExpedidor] = COALESCE(X.[OrgaoExpedidor], T.[OrgaoExpedidor]) 
					,[UFOrgaoExpedidor] = COALESCE(X.[UFOrgaoExpedidor], T.[UFOrgaoExpedidor]) 
					,[DataEmissaoRG] = COALESCE(X.[DataEmissaoRG], T.[DataEmissaoRG]) 
					,[DDD] = COALESCE(X.[DDD], T.[DDD]) 
					,[Telefone] = COALESCE(X.[Telefone], T.[Telefone]) 
					,[CodigoProfissao] = COALESCE(X.[CodigoProfissao], T.[CodigoProfissao]) 
					,[NivelCargo] = COALESCE(X.[NivelCargo], T.[NivelCargo]) 
					,[IndicadorRepresentante] = COALESCE(X.[IndicadorRepresentante], T.[IndicadorRepresentante]) 
					,[IndicadorImpressaoDPS] = COALESCE(X.[IndicadorImpressaoDPS], T.[IndicadorImpressaoDPS]) 
					,[Endereco] = COALESCE(X.[Endereco], T.[Endereco]) 
					,[Bairro] = COALESCE(X.[Bairro], T.[Bairro]) 
					,[Cidade] = COALESCE(X.[Cidade], T.[Cidade]) 
					,[UF] = COALESCE(X.[UF], T.[UF]) 
					,[CEP] = COALESCE(X.[CEP], T.[CEP]) 
					,[ValorSalario] = COALESCE(X.[ValorSalario], T.[ValorSalario]) 
					,[QuantidadeSalario] = COALESCE(X.[QuantidadeSalario], T.[QuantidadeSalario]) 
					,[ValorImportanciaSegurada] = COALESCE(X.[ValorImportanciaSegurada], T.[ValorImportanciaSegurada]) 
					,[ValorPremio] = COALESCE(X.[ValorPremio], T.[ValorPremio]) 
					,[TipoDado] = X.[TipoDado] 
					,[DataArquivo] = X.[DataArquivo] 
					,[FlagAtivo] = X.[FlagAtivo]

		 WHEN NOT MATCHED
			    THEN INSERT ([IDCertificadoIndividual],[Identidade],[OrgaoExpedidor],[UFOrgaoExpedidor]
							  ,[DataEmissaoRG],[DDD],[Telefone],[CodigoProfissao],[NivelCargo],[IndicadorRepresentante]
							  ,[IndicadorImpressaoDPS],[Endereco],[Bairro],[Cidade],[UF],[CEP],[ValorSalario]
							  ,[QuantidadeSalario],[ValorImportanciaSegurada],[ValorPremio],[TipoDado],[DataArquivo]
							  ,[FlagAtivo])
					VALUES (X.[IDCertificadoIndividual], X.[Identidade],X.[OrgaoExpedidor],X.[UFOrgaoExpedidor]
							,X.[DataEmissaoRG],X.[DDD],X.[Telefone],X.[CodigoProfissao],X.[NivelCargo]
							,X.[IndicadorRepresentante],X.[IndicadorImpressaoDPS],X.[Endereco],X.[Bairro]
							,X.[Cidade],X.[UF],X.[CEP],X.[ValorSalario],X.[QuantidadeSalario],X.[ValorImportanciaSegurada]
							,X.[ValorPremio], X.[TipoDado],X.[DataArquivo],X.[FlagAtivo]);

/*Atualiza a marcação Flag ativo das certificados individuais recebidos para atualizar o certificado ativo*/
/*DIEGO - Data: 20/11/2013 */	

 UPDATE [Dados].[CertificadoIndividualHistorico] SET FlagAtivo = 1
    FROM [Dados].[CertificadoIndividualHistorico] PE --(readuncommitted)
	INNER JOIN (
				SELECT ID,  ROW_NUMBER() OVER (PARTITION BY PS.IDCertificadoIndividual ORDER BY PS.DataArquivo DESC) [ORDEM]
				FROM [Dados].[CertificadoIndividualHistorico] PS --(readuncommitted)
				WHERE PS.IDCertificadoIndividual IN (

										SELECT DISTINCT ci.ID AS IDCertificadoIndividual 
										FROM [dbo].[CERTIFICADOINDIVIDUAL_TEMP] T --(readuncommitted)
											INNER JOIN dados.Proposta p --(readuncommitted)
												ON p.NumeroProposta = t.NumeroProposta
													AND p.IDSeguradora = 1
											INNER JOIN [Dados].[CertificadoIndividual] CI --(readuncommitted)
												ON ci.IDProposta = p.ID
													AND ISNULL(CI.[NumeroCertificadoIndividual],'') = ISNULL(T.[NumeroCertificadoIndividual],'')
													AND ISNULL(CI.[CPFCNPJ],'') = ISNULL(T.[CPFCNPJ],'')
									   )
					) A
	 ON A.ID = PE.ID 
	 AND A.ORDEM = 1

    /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = DATEADD(DD, 1, @PontoDeParada)
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = Cast(@PontoDeParada as varchar(10))
  WHERE NomeEntidade = 'CertificadoIndividual_PRPESPEC'

   /*********************************************************************************************************************/
  --LIMPA A TABELA TEMPORARIA 
  TRUNCATE TABLE [dbo].[CERTIFICADOINDIVIDUAL_TEMP] 
  /*********************************************************************************************************************/
  
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CERTIFICADOINDIVIDUAL_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[CERTIFICADOINDIVIDUAL_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH

--EXEC [Dados].[proc_InserePremiacaoINSS_INDICADORES]


