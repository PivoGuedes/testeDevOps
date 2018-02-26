 
/*
	Autor: Egler Vieira
	Data Criação: 13/11/2014

	Descrição: 
	
	Última alteração :
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InserePropostaEExtrato_HABITACIONAL_PREMIO
	Descrição: Procedimento que realiza a inserção de propostas no banco de dados.
		
	Parâmetros de entrada:
						
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InserePropostaEExtrato_HABITACIONAL_PREMIO] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HABITACIONAL_PREMIO_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[HABITACIONAL_PREMIO_TEMP];
--select * from [HABITACIONAL_PREMIO_TEMP]
CREATE TABLE [dbo].[HABITACIONAL_PREMIO_TEMP](
	[Codigo] [bigint]  NOT NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[NomeArquivo] [varchar](300) NOT NULL,
	[DataArquivo] [date] NULL,
	[NumeroProduto] [varchar](4) NULL,
	[TipoCredito] [char](2) NULL,
	[NumeroProposta] [varchar](20) NULL,
	[NumeroContrato] [varchar](20) NULL,
	[RendaPactuada] [varchar](10) NULL,
	[CodigoESCNEG] [varchar](10) NULL,
	[CodigoPV] [smallint] NULL,
	[CodigoUnoNum] [varchar](10) NULL,
	[CodigoUnoDv] [char](1) NULL,
	[NomeSegurado] [varchar](60) NULL,
	[DataNascimento] [date] NULL,
	[CPFCNPJ] [char](14) NULL,
	[DataContrato] [date] NULL,
	[DataInclusao] [date] NULL,
	[DataAmortizacao] [date] NULL,
	[PrazoVigencia] [smallint] NULL,
	[NumeroOrdemInclusao] [varchar](10) NULL,
	[NumeroRI] [varchar](5) NULL,
	[IDISMip] [tinyint] NULL,
	[ValorFinanciamento] [numeric](16, 2) NULL,
	[PremioMip] [numeric](16, 2) NULL,
	[IOFMip] [numeric](16, 2) NULL,
	[PremioMipAtrasado] [numeric](16, 2) NULL,
	[IOFMipAtrasado] [numeric](16, 2) NULL,
	[IDISInad] [tinyint] NULL,
	[PremioInad] [numeric](16, 2) NULL,
	[IOFInad] [numeric](16, 2) NULL,
	[PremioInadAtrasado] [numeric](16, 2) NULL,
	[IOFInadAtrasado] [numeric](16, 2) NULL,
	
	[IDISDfi] [tinyint] NULL,
	ISDfi  [numeric](16, 2) NULL,      -- Cobertura
	PremioDfi   [numeric](16, 2) NULL, -- Cobertura
	IOFDfi  [numeric](16, 2) NULL,     -- Cobertura
	PercentualResseguro   [numeric](16, 2) NULL,
	PremioDfiAtrasado   [numeric](16, 2) NULL,
	IOFDfiAtrasado   [numeric](16, 2) NULL,
	ValorIsRessMip  [numeric](16, 2) NULL,
	ValorPrRessMipMes  [numeric](16, 2) NULL,
	ValorPrRessMipAtrasado [numeric](16, 2) NULL,
	ValorIsRessDfi [numeric](16, 2) NULL,
	ValorPrRessDfiMes [numeric](16, 2) NULL,
	ValorPrRessDfiAtrasado [numeric](16, 2) NULL,
	[UF] [char](2) NULL,
	[Cidade] [varchar](25) NULL,
	[Bairro] [varchar](20) NULL,
	[Logradouro] [varchar](40) NULL,
	[Complemento] [varchar](25) NULL,
	[Numero] [varchar](5) NULL,
	[CEP] [varchar](10) NULL,
	[CodigoSeguradora] smallint default(1) NOT NULL,
	CodigoSubestipulante INT,
	[NumeroProposta_] as Substring(NumeroProposta,1,len(NumeroProposta)-1) + '_' PERSISTED
);



SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'HABITACIONAL_PREMIO'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
                
    SET @COMANDO =
    '  INSERT INTO dbo.HABITACIONAL_PREMIO_TEMP
       (        [Codigo],                                      
				[ControleVersao],                              
				[NomeArquivo],                                 
				[DataArquivo],                                 
				[NumeroProduto],
				[CodigoSubestipulante],                               
				[TipoCredito],                                 
				[NumeroProposta],                              
				[NumeroContrato],                              
				[RendaPactuada],                               
				[CodigoESCNEG],                                
				[CodigoPV],                                    
				[CodigoUnoNum],                                
				[CodigoUnoDv],                                 
				[NomeSegurado],                                
				[DataNascimento],                              
				[CPFCNPJ],                                     
				[DataContrato],                                
				[DataInclusao],                                
				[DataAmortizacao],                             
				[PrazoVigencia],                               
				[NumeroOrdemInclusao],                         
				[NumeroRI],                                    
				[IDISMip],                          
				[ValorFinanciamento],                          
				[PremioMip],                                   
				[IOFMip],                                      
				[PremioMipAtrasado],                           
				[IOFMipAtrasado],                              
				[IDISInad],                         
				[PremioInad],                                  
				[IOFInad],                                     
				[PremioInadAtrasado],                          
				[IOFInadAtrasado],       
					
				[IDISDfi],
				ISDfi,
				PremioDfi,
				IOFDfi,
				PremioDfiAtrasado,
				IOFDfiAtrasado,
				PercentualResseguro,
				ValorIsRessMip,
				ValorPrRessMipMes,
				ValorPrRessMipAtrasado,
				ValorIsRessDfi,
				ValorPrRessDfiMes,
				ValorPrRessDfiAtrasado,
				                     
				[UF],                                          
				[Cidade],                                      
				[Bairro],                                      
				[Logradouro],                                  
				[Complemento],                                 
				[Numero],                                      
				[CEP]
		)
       SELECT   [Codigo],                                      
				[ControleVersao],                              
				[NomeArquivo],                                 
				[DataArquivo],                                 
				[NumeroProduto],  
				[CodigoSubestipulante],                             
				[TipoCredito],                                 
				[NumeroProposta],                              
				[NumeroContrato],                              
				[RendaPactuada],                               
				[CodigoESCNEG],                                
				[CodigoPV],                                    
				[CodigoUnoNum],                                
				[CodigoUnoDv],                                 
				[NomeSegurado],                                
				[DataNascimento],                              
				[CPFCNPJ],                                     
				[DataContrato],                                
				[DataInclusao],                                
				[DataAmortizacao],                             
				[PrazoVigencia],                               
				[NumeroOrdemInclusao],                         
				[NumeroRI],                                    
				[IDISMip],                          
				[ValorFinanciamento],                          
				[PremioMip],                                   
				[IOFMip],                                      
				[PremioMipAtrasado],                           
				[IOFMipAtrasado],                              
				[IDISInad],                         
				[PremioInad],                                  
				[IOFInad],                                     
				[PremioInadAtrasado],                          
				[IOFInadAtrasado],    
						
				[IDISDfi],		  
				ISDfi,
				PremioDfi,
				IOFDfi,
				PremioDfiAtrasado,
				IOFDfiAtrasado,
				PercentualResseguro,
				ValorIsRessMip,
				ValorPrRessMipMes,
				ValorPrRessMipAtrasado,
				ValorIsRessDfi,
				ValorPrRessDfiMes,
				ValorPrRessDfiAtrasado,
		
				[UF],                                          
				[Cidade],                                      
				[Bairro],                                      
				[Logradouro],                                  
				[Complemento],                                 
				[Numero],                                      
				[CEP]                                        
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaFinanceiroHABITACIONAL_PREMIO]''''' + @PontoDeParada + ''''''') PRP
         '
EXEC (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.HABITACIONAL_PREMIO_TEMP PRP                    
     

--SELECT *
--FROM dbo.HABITACIONAL_PREMIO_TEMP PRP                    
     
/*********************************************************************************************************************/
                           
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN
--print @MaiorCodigo


	 /*Cria alguns índices para facilitar a busca*/  
	CREATE NONCLUSTERED INDEX idx_HABITACIONAL_PREMIO_TEMP_NumeroPropost ON [dbo].[HABITACIONAL_PREMIO_TEMP]
	( 
		NumeroProposta ASC,
		[DataArquivo] DESC
	)
	WITH (FILLFACTOR=100,MAXDOP=6);

	CREATE NONCLUSTERED INDEX idx_NCL_HABITACIONAL_PREMIO_TEMP_NumeroProduto ON [dbo].[HABITACIONAL_PREMIO_TEMP] 
	(
	[NumeroProduto]
	)
	WITH (FILLFACTOR=100,MAXDOP=6);

	CREATE NONCLUSTERED INDEX idx_HABITACIONAL_PREMIO_TEMP_CodigoPV	ON [dbo].[HABITACIONAL_PREMIO_TEMP]
	(
	[CodigoPV]
	)
	WITH (FILLFACTOR=100,MAXDOP=6);

	CREATE NONCLUSTERED INDEX idx_HABITACIONAL_PREMIO_TEMP_NumeroPropost_TipoEndereco ON [dbo].[HABITACIONAL_PREMIO_TEMP]
	( 
		NumeroProposta ASC,
		Logradouro ASC
	)
	WITH (FILLFACTOR=100,MAXDOP=6);

	CREATE CLUSTERED INDEX idx_CL_HABITACIONAL_PREMIO_TEMP_NumeroProposta_Seguradora ON [dbo].[HABITACIONAL_PREMIO_TEMP]
	( 
		NumeroProposta ASC,
		[CodigoSeguradora] ASC
	)
	WITH (FILLFACTOR=100,MAXDOP=6);

	CREATE NONCLUSTERED INDEX idx_NCL_HABITACIONAL_PREMIO_TEMP_CodigoSeguradora	ON [dbo].[HABITACIONAL_PREMIO_TEMP] 
	(
	[CodigoSeguradora]
	)
	INCLUDE ([NumeroProduto],[NumeroProposta],[NumeroProposta_])
	WITH (FILLFACTOR=100,MAXDOP=6);
	/***********************************************************************
		   Carregar as agencias desconhecidas
	***********************************************************************/

	/*INSERE PVs NÃO LOCALIZADOS*/
	;INSERT INTO Dados.Unidade(Codigo)
	SELECT DISTINCT CAD.CodigoPV
	FROM dbo.[HABITACIONAL_PREMIO_TEMP] CAD
	WHERE  CAD.CodigoPV IS NOT NULL 
	  AND NOT EXISTS (
					  SELECT     *
					  FROM  Dados.Unidade U
					  WHERE U.Codigo = CAD.CodigoPV)                                                                       
					  


	INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)
	SELECT DISTINCT U.ID, 
					'UNIDADE COM DADOS INCOMPLETOS' [Unidade], 
					-1 [CodigoNaFonte], 
					'PRPSASSE' [TipoDado], 
					MAX(EM.DataArquivo) [DataArquivo], 
					'PRPSASSE' [Arquivo]

	FROM dbo.[HABITACIONAL_PREMIO_TEMP] EM
	INNER JOIN Dados.Unidade U
	ON EM.CodigoPV = U.Codigo
	WHERE 
		NOT EXISTS (
					SELECT     *
					FROM Dados.UnidadeHistorico UH
					WHERE UH.IDUnidade = U.ID)    
	GROUP BY U.ID 
	--BEGIN TRAN
		      --     SELECT @@TRANCOUNT

	;MERGE INTO Dados.Produto AS T
	USING (
			SELECT DISTINCT EM.[NumeroProduto] [CodigoComercializado], '' [Descricao]
            FROM dbo.[HABITACIONAL_PREMIO_TEMP] EM
			WHERE EM.[NumeroProduto] IS NOT NULL
          ) X
         ON T.[CodigoComercializado] = X.[CodigoComercializado] 
       WHEN NOT MATCHED
		          THEN INSERT ([CodigoComercializado], Descricao)
		               VALUES (X.[CodigoComercializado], X.[Descricao]);


     /***********************************************************************
       Carrega os dados da Proposta
     ***********************************************************************/             
    ;MERGE INTO Dados.Proposta AS T
		USING (
		       SELECT *
			   FROM
			   (
				SELECT DISTINCT  
					   PRP.NumeroProposta                                                                                                
					 , PRP.[NumeroProposta_]
					 , SGD.ID [IDSeguradora]																					           
					 --, PRD.ID [IDProduto]																						
					 --, SIG.ID [IDProdutoSIGPF]																					           
					 --, pp.ID [IDPeriodicidadePagamento]																			
					 , PRP.DataContrato DataProposta																			           
					 , (ISNULL(PRP.PremioMip,0) + ISNULL([IOFMip],0) + ISNULL(PRP.PremioDfi,0) + ISNULL([IOFDfi],0)) ValorPagoSICOB												
					 , PRP.RendaPactuada																							                   
					 , U.ID [IDAgenciaVenda]																						                   
					 , PRP.DataArquivo																								--[CodigoPV],                         
					 , PRP.[NomeArquivo] TipoDado																					--[CodigoUnoNum],                     
					 , PRP.Codigo																									--[CodigoUnoDv],                      
					 , PRP.DataInclusao
					 , PRP.PrazoVigencia	
					 , PRP.DataContrato																											                     
					 , (ISNULL(PRP.PremioMip,0) + ISNULL([IOFMip],0) + ISNULL(PRP.PremioDfi,0) + ISNULL([IOFDfi],0)) [ValorPremioBrutoEmissao]																		                   
					 , (ISNULL(PRP.PremioMip,0) + ISNULL([IOFMip],0) + ISNULL(PRP.PremioDfi,0) + ISNULL([IOFDfi],0)) [ValorPremioTotal]																				                   
					 , (ISNULL(PRP.PremioMip,0) + ISNULL(PRP.PremioDfi,0)) [ValorPremioLiquidoEmissao]															          
					 , PRP.[DataInclusao] [DataAutenticacaoSICOB]															                  
					 , PRP.CodigoSubestipulante SubGrupo    																               
					 , ROW_NUMBER() OVER(PARTITION BY PRP.NumeroProposta ORDER BY  (ISNULL(PRP.PremioMip,0) + ISNULL([IOFMip],0) + ISNULL(PRP.[PremioInadAtrasado],0) + ISNULL([IOFInadAtrasado],0) + ISNULL([PremioInad],0) +ISNULL([IOFInad],0)) DESC, PRP.Codigo ASC) [RANK]	                 
								    
				FROM dbo.HABITACIONAL_PREMIO_TEMP PRP
				  INNER JOIN Dados.Seguradora SGD
				  ON SGD.Codigo = PRP.CodigoSeguradora
				  LEFT OUTER JOIN Dados.Unidade U
				  ON U.Codigo = PRP.CodigoPV

				  --LEFT OUTER JOIN Dados.SituacaoProposta SP
				  --ON SP.Sigla = PRP.SituacaoProposta
				 -- LEFT OUTER JOIN Dados.TipoMotivo TM
				 -- ON TM.Codigo = PRP.MotivoSituacao
				 -- LEFT OUTER JOIN Dados.SituacaoCobranca SB
				 -- ON SB.Sigla = PRP.SituacaoCobranca
				 -- LEFT OUTER JOIN Dados.Funcionario F
				 -- ON F.[Matricula] = PRP.[MatriculaVendedor]
				 -- AND F.IDEmpresa = 1
				) A
				WHERE A.RANK = 1
				  --AND A.NumeroProposta = 'PS003415800899601'
          ) AS X
    ON T.NumeroProposta IN (X.NumeroProposta, X.[NumeroProposta_])
   AND T.IDSeguradora = X.IDSeguradora 
    WHEN MATCHED
			    THEN UPDATE
				     SET 																				           
																			           
					--   IDPeriodicidadePagamento = COALESCE(T.[IDPeriodicidadePagamento], X.[IDPeriodicidadePagamento])																			
					   DataProposta	= CASE WHEN T.DataProposta IS NOT NULL AND T.DataProposta < X.DataProposta THEN T.DataProposta
					                       WHEN X.DataProposta IS NOT NULL AND X.DataProposta < T.DataProposta THEN X.DataProposta
										   ELSE COALESCE (X.DataProposta, T.DataProposta)
									  END
					 , Valor = COALESCE(T.Valor, X.ValorPagoSICOB)	 --ValorPagoSICOB												
					 --, PRP.RendaPactuada																							                   
					 , [IDAgenciaVenda]	= COALESCE(T.[IDAgenciaVenda], X.[IDAgenciaVenda])																						
					 , DataArquivo = COALESCE(T.DataArquivo, X.DataArquivo)																							                     
					 , TipoDado	= COALESCE(T.TipoDado, X.TipoDado)																					                                
					 --, PRP.Codigo																							                     
					 , DataInicioVigencia = COALESCE(CASE WHEN T.DataProposta IS NOT NULL AND T.DataProposta < X.DataProposta THEN T.DataProposta
														WHEN X.DataProposta IS NOT NULL AND X.DataProposta < T.DataProposta THEN X.DataProposta
														ELSE COALESCE (X.DataProposta, T.DataProposta)
													END, T.DataInicioVigencia)
					 , DataFimVigencia = COALESCE(DATEADD(mm, X.PrazoVigencia, CASE WHEN T.DataProposta IS NOT NULL AND T.DataProposta < X.DataProposta THEN T.DataProposta
																				WHEN X.DataProposta IS NOT NULL AND X.DataProposta < T.DataProposta THEN X.DataProposta
																				ELSE COALESCE (X.DataProposta, T.DataProposta)
																			END), T.DataFimVigencia)
					 , [ValorPremioBrutoEmissao] = COALESCE(T.[ValorPremioBrutoEmissao], X.[ValorPremioBrutoEmissao])																			                   
					 , [ValorPremioTotal] = COALESCE(T.[ValorPremioTotal], X.[ValorPremioTotal])																					                   
					 , [ValorPremioLiquidoEmissao]	= COALESCE(T.[ValorPremioLiquidoEmissao], X.[ValorPremioLiquidoEmissao])															          
					 , [DataAutenticacaoSICOB] = COALESCE(T.[DataAutenticacaoSICOB], X.[DataAutenticacaoSICOB])																                  
					 , SubGrupo = COALESCE(T.SubGrupo, X.SubGrupo)	  
					 , NumeroProposta = COALESCE(X.NumeroProposta, T.NumeroProposta) 						
    WHEN NOT MATCHED
			    THEN INSERT          
              (         NumeroProposta                                                                                                
					 , [IDSeguradora]																					           
					-- , [IDProduto]																						
					-- , [IDProdutoSIGPF]																					           
					-- , [IDPeriodicidadePagamento]																			
					 , DataProposta																			           
					 , Valor --ValorPagoSICOB												
					 --, PRP.DataFimVigencia = COALESCE(T.DataFimVigencia, DATEADD(mm, X.DataPrazoVigencia, X.DataInclusao))																							                   
					 , [IDAgenciaVenda]																						
					 , DataArquivo																						                     
					 , TipoDado																					                                
					 --, PRP.Codigo																						    
					 , [ValorPremioBrutoEmissao]																		                   
					 , [ValorPremioTotal]																				                   
					 , [ValorPremioLiquidoEmissao]															          
					 , [DataAutenticacaoSICOB]															                  
					 , SubGrupo    	
					 , DataInicioVigencia
					 , DataFimVigencia				 									       
             )
          VALUES (X.NumeroProposta                        
                 ,X.[IDSeguradora]						
				-- ,X.[IDProduto]							
                -- ,X.[IDProdutoSIGPF]						
                -- ,X.[IDPeriodicidadePagamento]			
                 ,X.DataProposta							
                 ,X.ValorPagoSICOB				
                 --, PRP.RendaPactuada					
                 ,X.[IDAgenciaVenda]						
                 ,X.DataArquivo						
                 ,X.TipoDado	
                 ,X.[ValorPremioBrutoEmissao]			      
                 ,X.[ValorPremioTotal]					
                 ,X.[ValorPremioLiquidoEmissao]			   
				 ,X.[DataAutenticacaoSICOB]		
				 ,X.SubGrupo	
				 ,X.DataInclusao
				 ,DATEADD(mm, X.PrazoVigencia, X.DataInclusao)	
				 )
		OPTION (querytraceon 9481 );            		 																									                     
				
		--Controle de migração de Produto
		--Adicionado em: 31/05/2015
		--Por: Egler Vieira
		-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		WITH CTE
		AS
		(
			SELECT DISTINCT PRP1.ID [IDProposta], /*PRP1.NumeroProposta, PRP.NumeroProposta, PRP.CodigoSeguradora, */ PRD.ID [IDProduto], PRP.DataArquivo [DataReferencia]
			FROM dbo.HABITACIONAL_PREMIO_TEMP PRP
				INNER JOIN Dados.Proposta PRP1
				ON PRP1.NumeroProposta IN (PRP.NumeroProposta, PRP.[NumeroProposta_])
				AND PRP1.IDSeguradora = PRP.CodigoSeguradora 
				INNER JOIN Dados.Produto PRD
				ON PRD.CodigoComercializado = PRP.NumeroProduto
				AND PRD.IDSeguradora = PRP.CodigoSeguradora
		)
		  --SELECT CTE.IDProposta, COALESCE(PP.IDProduto, CTE.IDProduto) IDProduto, COALESCE(PP.DataReferencia, CTE.DataReferencia) DataReferencia, ID   --ROW_NUMBER() OVER(PARTITION BY CTE.IDProposta,)
		  -- FROM CTE
		  -- OUTER APPLY (SELECT TOP 1 PP.DataReferencia, PP.IDProduto, ID
		  --              FROM Dados.PropostaProduto PP
				--		WHERE PP.IDProposta = CTE.IDProposta
				--		  AND PP.IDProduto = CTE.IDProduto
				--		  AND PP.DataReferencia <= CTE.DataReferencia
				--		  AND NOT EXISTS ( SELECT *
				--							FROM Dados.PropostaProduto PP1
				--							WHERE PP1.IDProposta = PP.IDProposta
				--							  AND PP1.IDProduto <> PP.IDProduto
				--							  AND PP1.DataReferencia > PP.DataReferencia AND PP1.DataReferencia < CTE.DataReferencia
				--		                  )
				--		ORDER BY PP.IDProposta ASC, DataReferencia ASC, PP.IDProduto
				--		) PP
				--		where cte.IDProposta IN( 51503719,52640634)
		MERGE INTO Dados.PropostaProduto T
		USING
		 (
		   SELECT CTE.IDProposta, COALESCE(PP.IDProduto, CTE.IDProduto) IDProduto, COALESCE(PP.DataReferencia, CTE.DataReferencia) DataReferencia, ID  --ROW_NUMBER() OVER(PARTITION BY CTE.IDProposta,)
		   FROM CTE
		   ---Verifica se existe algum registro mais antigo do mesmo produto para manter a data mais antiga
		   OUTER APPLY (SELECT TOP 1 PP.DataReferencia, PP.IDProduto, PP.ID
						FROM Dados.PropostaProduto PP
						WHERE PP.IDProposta = CTE.IDProposta
						  AND PP.IDProduto = CTE.IDProduto
						  AND PP.DataReferencia <= CTE.DataReferencia
						  --Caso haja um registro mais antigo e ao mesmo tempo exista um produto diferente no meio do caminho, mantêm o registro para inserção
						  AND NOT EXISTS ( SELECT *
											FROM Dados.PropostaProduto PP1
											WHERE PP1.IDProposta = PP.IDProposta
											  AND PP1.IDProduto <> PP.IDProduto
											  AND PP1.DataReferencia > PP.DataReferencia AND PP1.DataReferencia < CTE.DataReferencia
										  )
						ORDER BY PP.IDProposta ASC, DataReferencia ASC, PP.IDProduto
						) PP
		 ) S
		ON T.ID = ISNULL(S.ID,0)
		WHEN NOT MATCHED 
		THEN 
			 INSERT (IDProposta, IDProduto, DataReferencia)
			 VALUES (S.IDProposta, S.IDProduto, S.DataReferencia)
		WHEN MATCHED AND T.DataReferencia < S.DataReferencia
		THEN
			UPDATE SET DataReferencia = S.DataReferencia
	OPTION (querytraceon 9481 );  
		-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                 
		--Controle de atualização do Produto na proposta
		--Adicionado em: 31/05/2015
		--Por: Egler Vieira
		--Atualiza os dados de produto na proposta
		WITH CTE
		AS
		(
	  	 SELECT PRP1.ID IDProposta
			  , PP.IDProduto		
			  , PPA.IDProdutoAnterior											
			  , SIG.ID [IDProdutoSIGPF]																					           
			  , PR.ID [IDPeriodicidadePagamento]	
		 FROM dbo.HABITACIONAL_PREMIO_TEMP PRP
			INNER JOIN Dados.Proposta PRP1
			ON PRP1.NumeroProposta IN (PRP.NumeroProposta, PRP.[NumeroProposta_])
			AND PRP1.IDSeguradora = PRP.CodigoSeguradora 
			CROSS APPLY (SELECT TOP 1 ID, IDProduto
			             FROM Dados.PropostaProduto PP
						 WHERE PRP1.ID = PP.IDProposta
						 ORDER BY PP.IDProposta DESC, PP.DataReferencia DESC
						 ) PP					 
			INNER JOIN Dados.Produto PRD
			ON PRD.CodigoComercializado = PRP.[NumeroProduto]
			LEFT JOIN Dados.ProdutoSIGPF SIG
			ON SIG.ID = PRD.IDProdutoSIGPF
			LEFT OUTER JOIN Dados.PeriodoPagamento PR
			ON PR.ID = PRD.IDPeriodoPagamento 
			OUTER APPLY  (SELECT TOP 1 ID, IDProduto IDProdutoAnterior
			             FROM Dados.PropostaProduto PP1
						 WHERE PRP1.ID = PP1.IDProposta
						  AND PP.ID <> PP1.ID
						 ORDER BY PP1.IDProposta DESC, PP1.DataReferencia DESC
						 ) PPA	
			--WHERE PRP1.ID = 51503719
		)
		UPDATE Dados.Proposta SET IDProduto = COALESCE(CTE.IDProduto, PRP.IDProduto)
		                        , IDProdutoSIGPF = COALESCE(CTE.IDProdutoSIGPF, PRP.IDProdutoSIGPF)
								, IDPeriodicidadePagamento = COALESCE(CTE.IDPeriodicidadePagamento, PRP.IDPeriodicidadePagamento)
		FROM Dados.Proposta PRP
		  INNER JOIN CTE
		  ON CTE.IDProposta = PRP.ID			
	OPTION (querytraceon 9481 );  			
     -------------------------------------------------------------------------------------------------------------------------------           
     /***********************************************************************
       Carrega os dados do Cliente da proposta
     ***********************************************************************/                 
    ;MERGE INTO Dados.PropostaCliente AS T
		USING (
				SELECT *
				FROM
				(
				SELECT  DISTINCT
						    PRP1.ID [IDProposta]
						   -- Cliente
						  , [NomeSegurado] [Nome]
						  , [DataNascimento]
						  , [CPFCNPJ]
						  , 'Pessoa Física' TipoPessoa		     
						  , PRP.DataArquivo	--[CodigoPV],                         
					      , PRP.[NomeArquivo] TipoDado	            
						  , ROW_NUMBER() OVER(PARTITION BY PRP.NumeroProposta ORDER BY PRP.DataArquivo, PRP.Codigo DESC) [RANK]	  
				FROM dbo.HABITACIONAL_PREMIO_TEMP PRP
				  INNER JOIN Dados.Proposta PRP1
				  ON  PRP1.NumeroProposta IN (PRP.NumeroProposta, PRP.[NumeroProposta_])
				 AND PRP.CodigoSeguradora = PRP1.IDSeguradora
				) A
				WHERE [RANK] = 1
          ) AS X
    ON X.IDProposta = T.IDProposta
   AND X.CPFCNPJ = T.CPFCNPJ
       WHEN MATCHED
			    THEN UPDATE
		     SET CPFCNPJ = COALESCE(T.[CPFCNPJ], X.[CPFCNPJ])
               , Nome = COALESCE(X.[Nome], T.[Nome])
               , DataNascimento = COALESCE(X.[DataNascimento], T.[DataNascimento])
               , TipoPessoa  = COALESCE(X.[TipoPessoa ], T.[TipoPessoa])
               , TipoDado = COALESCE(X.[TipoDado], T.[TipoDado])
               , DataArquivo = COALESCE(X.[DataArquivo], T.[DataArquivo])	
    WHEN NOT MATCHED
			    THEN INSERT          
             (  
			    IDProposta
			  , CPFCNPJ
			  , Nome
			  , DataNascimento
			  , TipoPessoa
              , TipoDado, DataArquivo
			 )
          VALUES 
		      (
		          X.IDProposta        
                 ,X.CPFCNPJ           
                 ,X.Nome              
                 ,X.DataNascimento    
                 ,X.TipoPessoa 
                 ,X.TipoDado          
                 ,X.DataArquivo
              )
OPTION (querytraceon 9481 );  
      /***********************************************************************/





	 /***********************************************************************
       Carrega os dados de Proposta Cobertura
     ***********************************************************************/                 
   	  /*Apaga a marcação LastValue da tabela PropostaCobertura para atualizar a 
		última posição das propostas recebidas. */

     /***********************************************************************/
	UPDATE Dados.PropostaCobertura SET LastValue = 0
	--SELECT PRP.NumeroProposta, PC.*
	FROM Dados.PropostaCobertura PC
		INNER JOIN Dados.Proposta PRP
		ON PC.IDProposta = PRP.ID
		AND PRP.IDSeguradora = 1
		INNER JOIN DBO.HABITACIONAL_PREMIO_TEMP CTT
				 ON PRP.NumeroProposta IN (CTT.NumeroProposta, CTT.[NumeroProposta_])
				  AND PRP.IDSeguradora = CTT.CodigoSeguradora  
		INNER JOIN Dados.Cobertura COB
		ON COB.ID = PC.IDCobertura
		
		--AND COB.Codigo = '6600'
		AND COB.IDRamo = 76
	WHERE PC.LastValue = 1			
OPTION (querytraceon 9481 );  
   

  /*************************************************************************************/
  /*Grava as coberturas*/
  /*************************************************************************************/ 
    ;MERGE INTO Dados.PropostaCobertura AS T
		USING (       
            SELECT *                                                                          
            FROM                                                                              
            (                       
			    /*Dano Físico ao Imóvel (Dfi)*/                                                         
				SELECT                                                                           
					  PRP.[Codigo]                                                   
					, PRP.[ControleVersao]   
					, PRP1.ID [IDProposta]           
					, PRP.NumeroProposta          
					, C.[IDCobertura]
					, TC.ID [IDTipoCobertura]
					, PRP.ISDfi [ValorImportanciaSegurada]
					, (ISNULL(PRP.PremioDfi,0) + ISNULL(IOFDfi,0)) [ValorPremio]
					, 0 LastValue
	     			, PRP.DataArquivo	--[CodigoPV],                         
					, PRP.[NomeArquivo] Arquivo	            
					, ROW_NUMBER() OVER(PARTITION BY PRP.NumeroProposta, PRP.DataArquivo ORDER BY PRP.DataArquivo, PRP.Codigo DESC) [RANK]	  
					, PRP.NumeroProposta_	  
				FROM dbo.HABITACIONAL_PREMIO_TEMP PRP
				  INNER JOIN Dados.Proposta PRP1
					ON PRP1.NumeroProposta IN (PRP.NumeroProposta, PRP.[NumeroProposta_])
					AND PRP1.IDSeguradora = PRP.CodigoSeguradora 
				  OUTER APPLY (SELECT TOP 1 ID [IDCobertura]
							   FROM Dados.Cobertura C
							   WHERE C.Codigo = '10000'
							   AND C.IDRamo = 76
							   ORDER BY ID ASC) C
				  LEFT JOIN Dados.TipoCobertura TC
				  ON TC.Descricao = 'Básica'
				WHERE PRP.ISDfi IS NOT NULL AND PRP.ISDfi > 0
				--AND  PRP.NumeroProposta  LIKE '%1102720060050%'
				UNION ALL
				/*Resseguro Dano Físico ao Imóvel (Ress Dfi)*/    
				SELECT                                                                                                                                                   
					  PRP.[Codigo]                                                   
					, PRP.[ControleVersao]   
					, PRP1.ID [IDProposta]           
					, PRP.NumeroProposta          
					, C.[IDCobertura]
					, TC.ID [IDTipoCobertura]
					, PRP.ValorIsRessDfi [ValorImportanciaSegurada]
					, Cast((ISNULL(PRP.ValorIsRessDfi,0)) AS decimal(16,2)) [ValorPremio]
					, 0 LastValue
	     
					, PRP.DataArquivo																								--[CodigoPV],                         
					, PRP.[NomeArquivo] Arquivo	            
					, ROW_NUMBER() OVER(PARTITION BY PRP.NumeroProposta, PRP.DataArquivo ORDER BY PRP.DataArquivo, PRP.Codigo DESC) [RANK]	  
					, PRP.NumeroProposta_  
				FROM dbo.HABITACIONAL_PREMIO_TEMP PRP
				  INNER JOIN Dados.Proposta PRP1
				ON PRP1.NumeroProposta IN (PRP.NumeroProposta, PRP.[NumeroProposta_])
				AND PRP1.IDSeguradora = PRP.CodigoSeguradora 
				  OUTER APPLY (SELECT TOP 1 ID [IDCobertura]
							   FROM Dados.Cobertura C
							   WHERE C.Codigo = '10001'
							   AND C.IDRamo = 76
							   ORDER BY ID ASC) C
				  LEFT JOIN Dados.TipoCobertura TC
				  ON TC.Descricao = 'Básica'
				WHERE PRP.ValorIsRessDfi IS NOT NULL AND PRP.ValorIsRessDfi > 0
				--AND  PRP.NumeroProposta  LIKE '%1102720060050%'
				UNION ALL
				/*Morte Invalidez Permanente (Mip)*/    
				SELECT                                                                           
					  PRP.[Codigo]                                                   
					, PRP.[ControleVersao]   
					, PRP1.ID [IDProposta]           
					, PRP.NumeroProposta          
					, C.[IDCobertura]
					, TC.ID [IDTipoCobertura]
					, PRP.[ValorFinanciamento] [ValorImportanciaSegurada] /*IS MIP*/
					, (ISNULL(PRP.PremioMip,0) + ISNULL(IOFMip,0)) [ValorPremio]
					, 0 LastValue
	     
					, PRP.DataArquivo																								--[CodigoPV],                         
					, PRP.[NomeArquivo] Arquivo	            
					, ROW_NUMBER() OVER(PARTITION BY PRP.NumeroProposta, PRP.DataArquivo ORDER BY PRP.DataArquivo, PRP.Codigo DESC) [RANK]	  
					, PRP.NumeroProposta_ 
				FROM dbo.HABITACIONAL_PREMIO_TEMP PRP
				  INNER JOIN Dados.Proposta PRP1
					ON PRP1.NumeroProposta IN (PRP.NumeroProposta, PRP.[NumeroProposta_])
					AND PRP1.IDSeguradora = PRP.CodigoSeguradora 
				  OUTER APPLY (SELECT TOP 1 ID [IDCobertura]
							   FROM Dados.Cobertura C
							   WHERE C.Codigo = '10002'
							   AND C.IDRamo = 76
							   ORDER BY ID ASC) C
				  LEFT JOIN Dados.TipoCobertura TC
				  ON TC.Descricao = 'Básica'
				WHERE PRP.[ValorFinanciamento] IS NOT NULL AND PRP.[ValorFinanciamento] > 0
				--AND  PRP.NumeroProposta  LIKE '%1102720060050%'
				UNION ALL
				/*Resseguro Morte Invalidez Permanente (Ress Mip)*/    
				SELECT                                                                           
					  PRP.[Codigo]                                                   
					, PRP.[ControleVersao]   
					, PRP1.ID [IDProposta]           
					, PRP.NumeroProposta          
					, C.[IDCobertura]
					, TC.ID [IDTipoCobertura]
					, PRP.[ValorIsRessMip] [ValorImportanciaSegurada] /*IS MIP*/
					, (ISNULL(PRP.ValorPrRessMipMes,0)) [ValorPremio]
					, 0 LastValue
	     
					, PRP.DataArquivo																								--[CodigoPV],                         
					, PRP.[NomeArquivo] Arquivo	            
					, ROW_NUMBER() OVER(PARTITION BY PRP.NumeroProposta, PRP.DataArquivo ORDER BY PRP.DataArquivo, PRP.Codigo DESC) [RANK]	  
					, PRP.NumeroProposta_ 
				FROM dbo.HABITACIONAL_PREMIO_TEMP PRP
				  INNER JOIN Dados.Proposta PRP1
					ON PRP1.NumeroProposta IN (PRP.NumeroProposta, PRP.[NumeroProposta_])
					AND PRP1.IDSeguradora = PRP.CodigoSeguradora 
				  OUTER APPLY (SELECT TOP 1 ID [IDCobertura]
							   FROM Dados.Cobertura C
							   WHERE C.Codigo = '10003'
							   AND C.IDRamo = 76
							   ORDER BY ID ASC) C
				  LEFT JOIN Dados.TipoCobertura TC
				  ON TC.Descricao = 'Básica'
				WHERE PRP.[ValorIsRessMip] IS NOT NULL AND PRP.[ValorIsRessMip] > 0
				--AND  PRP.NumeroProposta  LIKE '%1102720060050%'

			) A
			WHERE A.[RANK] = 1       
			--AND A.NUMEROPROPOSTA = 'HB001016101055554'
			--AND A.ValorPremio IS NOT NULL     
            
            /*LEFT JOIN Dados.Contrato CNT
            ON CNT.NumeroContrato = RTP5.[NumeroApoliceAnterior]              */
          ) AS X
    ON  T.[IDProposta] = X.[IDProposta]
    AND T.[IDCobertura] = X.[IDCobertura]
    AND T.[IDTipoCobertura] = X.[IDTipoCobertura]
	AND T.[DataArquivo] = X.DataArquivo
    WHEN MATCHED
			    THEN UPDATE
				     SET
				         [ValorImportanciaSegurada] = COALESCE(X.[ValorImportanciaSegurada], T.[ValorImportanciaSegurada])
				        ,[ValorPremio] = COALESCE(X.[ValorPremio], T.[ValorPremio]) 
				        ,[DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo]) 
				        ,[Arquivo] = COALESCE(X.[Arquivo], T.[Arquivo])
						,LastValue = X.LastValue
    WHEN NOT MATCHED  
			    THEN INSERT          
              (   [IDProposta]                      
                , [IDCobertura]  
                , [IDTipoCobertura]
                , [ValorImportanciaSegurada]
                , [ValorPremio] 
				, LastValue
                , [DataArquivo]    
                , [Arquivo]
                )
          VALUES (   
                  X.[IDProposta]                           
                , X.[IDCobertura]  
                , X.[IDTipoCobertura]
                , X.[ValorImportanciaSegurada]
                , X.[ValorPremio]  
				, X.LastValue
                , X.[DataArquivo]    
                , X.[Arquivo]
                )
OPTION (querytraceon 9481 );  
  /*************************************************************************************/ 


 	/*Atualiza a marcação LastValue das propostas recebidas para atualizar a última posição*/
	/*************************************************************************************/  
    UPDATE Dados.PropostaCobertura SET LastValue = 1
    FROM Dados.PropostaCobertura PE
	INNER JOIN (
				SELECT ID, /*  PS.IDProposta, PS.IDCobertura*/ ROW_NUMBER() OVER (PARTITION BY PS.IDProposta, PS.IDCobertura ORDER BY PS.DataArquivo DESC, PS.ID DESC) [ORDEM]
				FROM Dados.PropostaCobertura PS
				WHERE PS.IDProposta IN (
										SELECT PRP1.ID
										FROM  dbo.HABITACIONAL_PREMIO_TEMP PRP
											  INNER JOIN Dados.Proposta PRP1
					                 			ON PRP1.NumeroProposta IN (PRP.NumeroProposta, PRP.[NumeroProposta_])
											   AND PRP1.IDSeguradora = PRP.CodigoSeguradora 
									   )
					) A
	 ON A.ID = PE.ID 
	 AND A.ORDEM = 1
OPTION (querytraceon 9481 );  
    /*************************************************************************************/ 
	      

    /*Apaga a marcação LastValue das propostas recebidas para atualizar a última posição -> logo depois da inserção das Situações (abaixo)*/
	/*Egler - Data: 23/09/2013 */
    UPDATE Dados.PropostaEndereco SET LastValue = 0
   -- SELECT *
    FROM Dados.PropostaEndereco PS
    WHERE PS.IDProposta IN (
	                        SELECT PRP1.ID
                            FROM dbo.HABITACIONAL_PREMIO_TEMP PRP
							  INNER JOIN Dados.Proposta PRP1
							  ON PRP1.NumeroProposta IN (PRP.NumeroProposta, PRP.[NumeroProposta_])
							 AND PRP1.IDSeguradora = PRP.CodigoSeguradora  
							 
							-- AND PRP_T.[DataArquivo] >= PS.[DataArquivo]
                           )
           AND PS.LastValue = 1
OPTION (querytraceon 9481 );  
		  -- AND PS.IDProposta = 12585836

		   --TODO --ARRUMAR PARA GARANTIR QUE SEMPRE HAVERÁ UM REGISTRO COM LASTVALUE = 1 
    

	--SET NOCOUNT ON ;                       
     /***********************************************************************
       Carrega os dados do Cliente da proposta
     ***********************************************************************/                 
    ;MERGE INTO Dados.PropostaEndereco AS T
		USING (
				SELECT 
					 A. [IDProposta]
					,A.[IDTipoEndereco]
					,A.[Endereco]        
					,A.Bairro              
					,A.Cidade       
					,A.[UF]      
					,A.CEP    


					--,(CASE WHEN  ROW_NUMBER() OVER (PARTITION BY A.IDProposta, A.IDTipoEndereco ORDER BY A.DataArquivo DESC) = 1 /*OR PE.Endereco IS NOT NULL*/ THEN 1
					--						ELSE 0
					--	END) LastValue
					, 0 LastValue
					, A.[TipoDado]           
					, A.DataArquivo	
					
				FROM
				(
					SELECT   
						 PRP1.ID [IDProposta]
						,2 [IDTipoEndereco] --Correspondecia
						,PRP.Logradouro [Endereco]       
						,PRP.Bairro Bairro             
						,PRP.Cidade Cidade       
						,PRP.[UF]       
						,PRP.CEP CEP   
						--CASE WHEN  
						,'PREMIO - EF0310B' [TipoDado]           
						,PRP.DataArquivo DataArquivo
						,ROW_NUMBER() OVER (PARTITION BY PRP1.ID /*IDProposta*/, PRP.Logradouro ORDER BY PRP.DataArquivo DESC) NUMERADOR	   								
					FROM dbo.HABITACIONAL_PREMIO_TEMP PRP
						INNER JOIN Dados.Proposta PRP1
						ON PRP1.NumeroProposta IN (PRP.NumeroProposta, PRP.[NumeroProposta_])
				       AND PRP1.IDSeguradora = PRP.CodigoSeguradora  
			        WHERE
					 PRP.Logradouro IS NOT NULL

					-- AND PRP.ID = 12585836
				) A 	
				WHERE [NUMERADOR] = 1--PRP_T.NumeroProposta = 012984710001812			

          ) AS X
    ON  X.IDProposta = T.IDProposta
    AND X.[IDTipoEndereco] = T.[IDTipoEndereco]
    --AND X.[DataArquivo] >= T.[DataArquivo]
	AND X.[Endereco] = T.[Endereco]
       WHEN MATCHED AND X.[DataArquivo] >= T.[DataArquivo] THEN  
		      UPDATE
				SET 
                 Endereco = COALESCE(X.[Endereco], T.[Endereco])
               , Bairro = COALESCE(X.[Bairro], T.[Bairro])
               , Cidade = COALESCE(X.[Cidade], T.[Cidade])
               , UF = COALESCE(X.[UF], T.[UF])
               , CEP = COALESCE(X.[CEP], T.[CEP])
               , TipoDado = COALESCE(X.[TipoDado], T.[TipoDado])
			   , DataArquivo = X.DataArquivo
			   , LastValue = X.LastValue
    WHEN NOT MATCHED
			    THEN INSERT          
              ( IDProposta, IDTipoEndereco, Endereco, Bairro                                                                
              , Cidade, UF, CEP, TipoDado, DataArquivo, LastValue)                                            
          VALUES (
                  X.[IDProposta]   
                 ,X.[IDTipoEndereco]                                                
                 ,X.[Endereco]  
                 ,X.[Bairro]   
                 ,X.[Cidade]      
                 ,X.[UF] 
                 ,X.[CEP]            
                 ,X.[TipoDado]       
                 ,X.[DataArquivo]
				 ,X.LastValue   
                 )
OPTION (querytraceon 9481 );  
		
	/*Atualiza a marcação LastValue das propostas recebidas para atualizar a última posição*/
    UPDATE Dados.PropostaEndereco SET LastValue = 1
    FROM Dados.PropostaEndereco PE
	INNER JOIN (
				SELECT ID,  ROW_NUMBER() OVER (PARTITION BY PS.IDProposta, PS.IDTipoEndereco ORDER BY PS.DataArquivo DESC, PS.ID DESC) [ORDEM]
				FROM Dados.PropostaEndereco PS
				WHERE PS.IDProposta IN (
										SELECT PRP.ID
										FROM dbo.HABITACIONAL_PREMIO_TEMP RTP6
										  INNER JOIN Dados.Proposta PRP
										   ON PRP.NumeroProposta IN (RTP6.NumeroProposta, RTP6.[NumeroProposta_])
										  AND PRP.IDSeguradora = RTP6.CodigoSeguradora  
									   )
					) A
	 ON A.ID = PE.ID 
	 AND A.ORDEM = 1		
OPTION (querytraceon 9481 );  	

	 --SELECT *
	 --delete FROM Dados.PropostaFinanceiro 
	 --WHERE IDProposta = 50811637 AND NumeroContratoVinculado = '3415800899601' and dataarquivo = '2014-06-30'
  /*************************************************************************************/
  /*Chama a PROC que roda a importação registro a registro dos detalhes do HABITACIONAL*/
  /*************************************************************************************/ 
    ;MERGE INTO Dados.PropostaFinanceiro AS T
		USING (       
            SELECT *
            FROM
            (
				SELECT 
				   RTP6.[Codigo]                                                     
				,  RTP6.[ControleVersao]                                             
				,  RTP6.[NomeArquivo] [Arquivo]                                                
				,  RTP6.[DataArquivo]                           
				,  PRP.ID [IDProposta]                    
				,  RTP6.[NumeroProposta] [NumeroProposta]                                            
				,  RTP6.[NumeroContrato] [NumeroContratoVinculado]  
				,  NULL Complemento                                           
				,  TipoCredito [IDTipoCredito]

			  	, [NumeroRI]          
				, [IDISMip]
				, [ValorFinanciamento]
				, [DataContrato]
				--, DataContrato DataProposta
				, [DataInclusao]
				, [PrazoVigencia]
				, [NumeroOrdemInclusao]
				, [RendaPactuada]
				, [CodigoESCNEG] 

				, ROW_NUMBER() OVER(PARTITION BY PRP.ID, NumeroContrato ORDER BY RTP6.[DataArquivo] , RTP6.[Codigo] DESC)  [ORDER]
				FROM [dbo].HABITACIONAL_PREMIO_TEMP  RTP6
				  LEFT JOIN Dados.Proposta PRP
				   ON PRP.NumeroProposta IN (RTP6.NumeroProposta, RTP6.[NumeroProposta_])
				  AND PRP.IDSeguradora = RTP6.CodigoSeguradora  
            ) A
            WHERE A.[ORDER] = 1
			--AND A.IDProposta = 50811637
			--and a.numerocontratovinculado = '3415800899601'

            /*LEFT JOIN Dados.Contrato CNT
            ON CNT.NumeroContrato = RTP5.[NumeroApoliceAnterior]              */
          ) AS X
    ON  X.[IDProposta] = T.[IDProposta]
    AND X.[NumeroContratoVinculado] = T.[NumeroContratoVinculado]
    WHEN MATCHED
			    THEN UPDATE       
				     SET          --'3415800899601'
						  [IDTipoCredito] = COALESCE(X.[IDTipoCredito], T.[IDTipoCredito])
						, [NumeroContratoVinculado] = COALESCE(X.[NumeroContratoVinculado], T.[NumeroContratoVinculado])
						, [Complemento] = COALESCE(X.[Complemento], T.[Complemento])
						 
						, [NumeroRI] = COALESCE(X.[NumeroRI], T.[NumeroRI])         
						, [IDISMip] = COALESCE(X.[IDISMip], T.[IDISMip])
						, [ValorFinanciamento] = COALESCE(X.[ValorFinanciamento], T.[ValorFinanciamento])
						, [DataContrato] = CASE WHEN T.[DataContrato] IS NOT NULL AND T.[DataContrato] < X.[DataContrato] THEN T.[DataContrato]
											    WHEN X.[DataContrato] IS NOT NULL AND X.[DataContrato] < T.[DataContrato] THEN X.[DataContrato]
											    ELSE COALESCE (X.[DataContrato], T.[DataContrato])
										   END
					--	, [DataInclusao] = COALESCE(X.[DataInclusao], T.[DataInclusao])
						, [PrazoVigencia] = COALESCE(X.[PrazoVigencia], T.[PrazoVigencia])
						, [NumeroOrdemInclusao] = COALESCE(X.[NumeroOrdemInclusao], T.[NumeroOrdemInclusao])
						, [RendaPactuada] = COALESCE(X.[RendaPactuada], T.[RendaPactuada])
						
						, [CodigoESCNEG] = COALESCE(X.[CodigoESCNEG], T.[CodigoESCNEG])
						 
						, [DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo])
						, [Arquivo] = COALESCE(X.[Arquivo], T.[Arquivo])	
    WHEN NOT MATCHED  
			    THEN INSERT          
              (   [IDProposta]                      
                , [IDTipoCredito]
                , [NumeroContratoVinculado]
                , [Complemento]   			    
				, [NumeroRI]          
				, [IDISMip]
				, [ValorFinanciamento]
				, [DataContrato]
				, [DataInclusao]
				, [PrazoVigencia]
				, [NumeroOrdemInclusao]
				, [RendaPactuada]				 
				, [CodigoESCNEG] 

              --, [NumeroProdutoAVGestao]
				, [DataArquivo]
				, [Arquivo])
          VALUES (   
                  X.[IDProposta] 
                , X.[IDTipoCredito]                                                                
                , X.[NumeroContratoVinculado]			                                         
                , X.[Complemento] 						                             
									                      
				, X.[NumeroRI]          				                        
				, X.[IDISMip]			    
				, X.[ValorFinanciamento]				                                           
				, X.[DataContrato]						  
				, X.[DataInclusao]						 
				, X.[PrazoVigencia]						          
				, X.[NumeroOrdemInclusao]				 
				, X.[RendaPactuada]		 
				, X.[CodigoESCNEG] 						 
														 
				, X.[DataArquivo]						 
				, X.[Arquivo]							 
            )
OPTION (querytraceon 9481 );  											  
     
	--delete FROM Dados.PropostaCliente  where idproposta in (select idproposta from dados.PropostaFinanceiro where arquivo not like '%MJUNMOV%' AND  arquivo not like '%MVPROP%')
  /*************************************************************************************/ 

  /*TODO: ADICIONAR A INSERÇÃO NA TABELA DE EXTRATO*/
  /*************************************************************************************/
  /*Chama a PROC que roda a importação registro a registro do "EXTRATO" do HABITACIONAL*/
  /*************************************************************************************/ 

    ;MERGE INTO Dados.FinanceiroExtrato AS T
		USING (       
            SELECT *
            FROM
            (
				SELECT 
				  PRP.ID [IDProposta]     
				, PRD.ID IDProduto 
				, RTP6.[IDISMip]
				, RTP6.[PremioMip]     
				, RTP6.[IOFMip]         
				, RTP6.[PremioMipAtrasado]   
				, RTP6.[IOFMipAtrasado]      
				, RTP6.[IDISInad]                      
				, RTP6.[PremioInad]          
				, RTP6.[IOFInad]             
				, RTP6.[PremioInadAtrasado]  
				, RTP6.[IOFInadAtrasado]     
				, RTP6.[DataInclusao]
				, RTP6.[NumeroOrdemInclusao]
				, RTP6.[IDISDfi]
                , RTP6.PremioDfi
				, RTP6.IOFDfi
				, RTP6.PremioDfiAtrasado         
				, RTP6.IOFDfiAtrasado         
				   
				, RTP6.PercentualResseguro        --RESSEGURO	
				, RTP6.ValorPrRessMipMes         --RESSEGURO
				, RTP6.ValorPrRessMipAtrasado    --RESSEGURO
				, RTP6.ValorPrRessDfiMes         --RESSEGURO
				, RTP6.ValorPrRessDfiAtrasado    --RESSEGURO

				, RTP6.[DataAmortizacao]    
				, RTP6.[DataArquivo]		
 				, RTP6.[NomeArquivo] [Arquivo]		

				, ROW_NUMBER() OVER(PARTITION BY PRP.ID, NumeroContrato, NumeroProduto, RTP6.[DataArquivo] ORDER BY RTP6.[Codigo] DESC)  [ORDER]
				FROM [dbo].HABITACIONAL_PREMIO_TEMP  RTP6
				  INNER JOIN Dados.Proposta PRP
				   ON PRP.NumeroProposta IN (RTP6.NumeroProposta, RTP6.[NumeroProposta_])
				  AND PRP.IDSeguradora = RTP6.CodigoSeguradora 
				  INNER JOIN Dados.Produto PRD
				  ON PRD.CodigoComercializado = RTP6.NumeroProduto
            ) A
            WHERE A.[ORDER] = 1
            /*LEFT JOIN Dados.Contrato CNT
            ON CNT.NumeroContrato = RTP5.[NumeroApoliceAnterior]              */
          ) AS X
    ON  X.[IDProposta] = T.[IDProposta]
    AND X.[DataArquivo] = T.[DataArquivo]
	AND X.[IDProduto] = T.[IDProduto]
    WHEN MATCHED
			THEN UPDATE
				    SET          
					  [PremioMip] = COALESCE(X.[PremioMip], T.[PremioMip])
					, [IOFMip] = COALESCE(X.[IOFMip], T.[IOFMip])
					, [PremioMipAtrasado] = COALESCE(X.[PremioMipAtrasado], T.[PremioMipAtrasado])						 
					, [IOFMipAtrasado] = COALESCE(X.[IOFMipAtrasado], T.[IOFMipAtrasado])         

					, [IDISMip] =  COALESCE(X.[IDISMip], T.[IDISMip])        
					, [IDISDfi] =  COALESCE(X.[IDISDfi], T.[IDISDfi])   
					, [IDISInad] = COALESCE(X.[IDISInad], T.[IDISInad])

					, [PremioInad] = COALESCE(X.[PremioInad], T.[PremioInad])
					, [IOFInad] = COALESCE(X.[IOFInad], T.[IOFInad])
					, [PremioInadAtrasado] = COALESCE(X.[PremioInadAtrasado], T.[PremioInadAtrasado])
					, [IOFInadAtrasado] = COALESCE(X.[IOFInadAtrasado], T.[IOFInadAtrasado])
					, [DataInclusao] = COALESCE(X.[DataInclusao], T.[DataInclusao])
					, [NumeroOrdemInclusao] = COALESCE(X.[NumeroOrdemInclusao], T.[NumeroOrdemInclusao])
					, PercentualResseguro = COALESCE(X.PercentualResseguro, T.PercentualResseguro)
					, PremioDfiAtrasado = COALESCE(X.PremioDfiAtrasado, T.PremioDfiAtrasado) 
					, IOFDfiAtrasado = COALESCE(X.IOFDfiAtrasado, T.IOFDfiAtrasado)
					, PremioDfi = COALESCE(X.PremioDfi, T.PremioDfi)
					, IOFDfi = COALESCE(X.IOFDfi, T.IOFDfi)
					, ValorPrRessMipMes  = COALESCE(X.ValorPrRessMipMes, T.ValorPrRessMipMes)
					, ValorPrRessMipAtrasado = COALESCE(X.ValorPrRessMipAtrasado, T.ValorPrRessMipAtrasado)
					, ValorPrRessDfiMes = COALESCE(X.ValorPrRessDfiMes, T.ValorPrRessDfiMes) 
					, ValorPrRessDfiAtrasado = COALESCE(X.ValorPrRessDfiAtrasado, T.ValorPrRessDfiAtrasado)
					, [DataAmortizacao] = COALESCE(X.[DataAmortizacao], T.[DataAmortizacao])	
					, [DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo])
					, [Arquivo] = COALESCE(X.[Arquivo], T.[Arquivo])		
    WHEN NOT MATCHED  
			    THEN INSERT          
              (   
			      [IDProposta]  
				, [IDProduto]
                , [PremioMip]
                , [IOFMip]
                , [PremioMipAtrasado]     
				, [IOFMipAtrasado]        
				
				, [IDISMip]        
				, [IDISDfi]        
				, [IDISInad]  
				 
				, [PremioInad]            
				, [IOFInad]               
				, [PremioInadAtrasado]    
				, [IOFInadAtrasado]    
				, PercentualResseguro
				, PremioDfiAtrasado 
				, IOFDfiAtrasado 
				, PremioDfi 
				, IOFDfi 
				, ValorPrRessMipMes  
				, ValorPrRessMipAtrasado	
				, ValorPrRessDfiMes  
				, ValorPrRessDfiAtrasado				 
				, [DataAmortizacao]    
				, [DataArquivo]			
				, [Arquivo]		 
				, [DataInclusao]
				, [NumeroOrdemInclusao]
               )
          VALUES (   
		          X.[IDProposta]
				, X.[IDProduto]
		  		, X.[PremioMip]
				, X.[IOFMip]
				, X.[PremioMipAtrasado]                
				, X.[IOFMipAtrasado]                   
				 
				, X.[IDISMip]        
				, X.[IDISDfi]                
				, X.[IDISInad]  
				            
				, X.[PremioInad]                       
				, X.[IOFInad]                          
				, X.[PremioInadAtrasado]               
				, X.[IOFInadAtrasado]  
				, X.PercentualResseguro   
				, X.PremioDfiAtrasado 
				, X.IOFDfiAtrasado 
				, X.PremioDfi 
				, X.IOFDfi 
				, X.ValorPrRessMipMes  
				, X.ValorPrRessMipAtrasado				
				, X.ValorPrRessDfiMes  
				, X.ValorPrRessDfiAtrasado				   				     
				, X.[DataAmortizacao]    
				, X.[DataArquivo]						 
				, X.[Arquivo]		
				, X.[DataInclusao] 
				, X.[NumeroOrdemInclusao]
            )
OPTION (querytraceon 9481 );   		
		  -- select * from dados.FinanceiroExtrato
		  --Extrato
           

-----------------------------------------------------------------------------------------------------
--Conjunto de instruções para realizar o tratamento das situações das propostas
-----------------------------------------------------------------------------------------------------


	/*Apaga a marcação LastValue das propostas recebidas para atualizar a última posição -> logo depois da inserção das Situações (abaixo)*/
    ;WITH CTE
	AS
	(
		SELECT PRP1.ID, PRP.DataArquivo, PRP.NumeroProposta_--, prp.PremioMipAtrasado, prp.IOFMipAtrasado, prp.PremioInadAtrasado, Prp.PremioInad, prp.PremioMip, prp1.valor
        FROM dbo.HABITACIONAL_PREMIO_TEMP PRP
		INNER JOIN Dados.Proposta PRP1
		ON PRP1.NumeroProposta IN (PRP.NumeroProposta, PRP.[NumeroProposta_])
		AND PRP1.IDSeguradora = PRP.CodigoSeguradora 
	)
	UPDATE Dados.PropostaSituacao SET LastValue = 0
    --SELECT *
    FROM Dados.PropostaSituacao PS
	INNER JOIN CTE 
	ON CTE.ID = PS.IDProposta 
	WHERE PS.DataInicioSituacao < CTE.DataArquivo	
	  AND PS.LastValue = 1
OPTION (querytraceon 9481 );  
               
--select *
--FROM dbo.PRESTAMISTA_PREMIO_TEMP PRP
--where codigo in (3004077,3001599,3004385)

--select *
--FROM dbo.PRESTAMISTA_PREMIO_TEMP PRP
--where codigo in (8672561)

   --------------------------------------------------------------------------------
   ;MERGE INTO Dados.PropostaSituacao T
     USING
	     ( 
		    SELECT *
            FROM
            (
				SELECT 
				   PRP.[Codigo]                                                     
				,  PRP.[ControleVersao]                                             
				,  REPLACE(PRP.[NomeArquivo],'SSIS_','') [Arquivo]                                                
				,  PRP.[DataArquivo]       
				,  PRP.[DataArquivo]  [DataInicioSituacao]                    
				,  PRP1.ID [IDProposta]                    
				,  CASE WHEN PremioMip > 0 and PremioMipAtrasado > 0 THEN 39 -- Situação Desconhecida
					  WHEN PremioMip > 0 and PremioMipAtrasado = 0 THEN 1 -- Emitida
					  WHEN PremioMipAtrasado < 0 and PremioMip = 0 THEN 5 -- Cancelada
					  WHEN PremioMip < 0 THEN 5 -- Cancelada
					  WHEN PremioMipAtrasado > 0 and PremioMip = 0 THEN 37 --Aguardando retorno CS
					  WHEN PremioMip = 0 AND PremioMipAtrasado = 0 AND PremioInad = 0 AND PremioInadAtrasado = 0 THEN 39 
					  WHEN PremioMipAtrasado < 0 and PremioMip <> 0 THEN 26 -- Não pago
				   END IDSituacaoProposta
				, -1 IDMotivo
                , 'FN311B' TipoDado 
				, ROW_NUMBER() OVER(PARTITION BY PRP1.ID, NumeroContrato, PRP.[DataArquivo] ORDER BY PRP.[DataArquivo] DESC, PRP.[Codigo] DESC)  [ORDER]
				, PRP.NumeroProposta_
				FROM dbo.HABITACIONAL_PREMIO_TEMP PRP
				  INNER JOIN Dados.Proposta PRP1
				 ON PRP1.NumeroProposta IN (PRP.NumeroProposta, PRP.[NumeroProposta_])
				  AND PRP1.IDSeguradora = PRP.CodigoSeguradora    
            ) A
            WHERE A.[ORDER] = 1
		--	and idsituacaoproposta is null
	      ) X
    ON  X.IDProposta = T.IDProposta
	AND X.[DataInicioSituacao] = T.[DataInicioSituacao]
    AND X.[IDSituacaoProposta] = T.[IDSituacaoProposta]
    AND ISNULL(X.[IDMotivo], -1) = ISNULL(T.[IDMotivo], -1)
	WHEN MATCHED
			    THEN UPDATE
				     SET [IDMotivo] = COALESCE(X.[IDMotivo],T.[IDMotivo])
					   , [DataArquivo] = X.[DataArquivo]
					   , [TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
    WHEN NOT MATCHED
			    THEN INSERT          
              ([IDProposta],  [IDMotivo], [IDSituacaoProposta] 
             , [DataArquivo], [DataInicioSituacao], [TipoDado]
             , LastValue             )
          VALUES (X.[IDProposta]
                 ,X.[IDMotivo]
                 ,X.[IDSituacaoProposta]
                 ,X.[DataArquivo]       
                 ,X.[DataInicioSituacao]    
                 ,X.[TipoDado]
                 ,0
                 )
OPTION (querytraceon 9481 );  
    ----------------------------------------------------------------------------------------------------
	WITH CTE 
    AS 
    (
      SELECT DISTINCT PRP1.ID [IDProposta], PRP.DataArquivo [DataSituacao], PRP.NumeroProposta_
	  FROM dbo.HABITACIONAL_PREMIO_TEMP PRP
		INNER JOIN Dados.Proposta PRP1
		ON PRP1.NumeroProposta IN (PRP.NumeroProposta, PRP.[NumeroProposta_])
		AND PRP1.IDSeguradora = PRP.CodigoSeguradora 
    ) 
	/*Atualiza a marcação LastValue das propostas recebidas buscando o último Status*/
    UPDATE Dados.PropostaSituacao SET LastValue = 1
    --SELECT *
	FROM  CTE
    CROSS APPLY (
                SELECT TOP 1 ID
                 FROM Dados.PropostaSituacao PS1
                 WHERE PS1.IDProposta =  CTE.IDProposta
                 AND ISNULL(PS1.DataInicioSituacao, '0001-01-01') >= ISNULL(CTE.DataSituacao, '0001-01-01') --Garante que a última situação seja a mais recente
                 ORDER BY [IDProposta] ASC,
	                        [DataInicioSituacao] DESC,
	                        [IDSituacaoProposta] 
                 ) LASTVALUE 
    INNER JOIN Dados.PropostaSituacao PS
    ON PS.ID = LASTVALUE.ID
OPTION (querytraceon 9481 );  


	 --##############################################################################
	 /*ATUALIZA A PROPOSTA COM O ÚLTIMO STATUS RECEBIDO
	 Autor: Egler Vieira
	 */   
	 --############################################################################## 
	;WITH CTE
	AS
	(
		SELECT PRP1.ID
		FROM dbo.HABITACIONAL_PREMIO_TEMP PRP
		INNER JOIN Dados.Proposta PRP1
		ON PRP1.NumeroProposta IN (PRP.NumeroProposta, PRP.[NumeroProposta_])
		AND PRP1.IDSeguradora = PRP.CodigoSeguradora  	
	)
	UPDATE Dados.Proposta SET IDSituacaoProposta = PS.IDSituacaoProposta, 
						   DataSituacao = PS.DataInicioSituacao, 
						   IDTipoMotivo = PS.IDMotivo
							   --,DataArquivo = PRP.DataArquivo   
	-- SELECT *
	FROM Dados.Proposta PRP
	INNER JOIN CTE 
	ON CTE.ID = PRP.ID
	INNER JOIN Dados.PropostaSituacao PS
	ON PS.IDProposta = PRP.ID   
OPTION (querytraceon 9481 );  

------------------------------------------------------------------------------------------------------


  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'HABITACIONAL_PREMIO'
  /*************************************************************************************/
  

  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[HABITACIONAL_PREMIO_TEMP]
  
  
	/*DROP dos índices criados para facilitar a busca*/  
	DROP INDEX idx_HABITACIONAL_PREMIO_TEMP_NumeroPropost_TipoEndereco ON [dbo].[HABITACIONAL_PREMIO_TEMP];

	DROP INDEX idx_HABITACIONAL_PREMIO_TEMP_NumeroPropost ON [dbo].[HABITACIONAL_PREMIO_TEMP];

	DROP INDEX idx_CL_HABITACIONAL_PREMIO_TEMP_NumeroProposta_Seguradora ON [dbo].[HABITACIONAL_PREMIO_TEMP];
	
	DROP INDEX idx_HABITACIONAL_PREMIO_TEMP_CodigoPV ON [dbo].[HABITACIONAL_PREMIO_TEMP];

	DROP INDEX idx_NCL_HABITACIONAL_PREMIO_TEMP_CodigoSeguradora ON [dbo].[HABITACIONAL_PREMIO_TEMP];

	DROP INDEX idx_NCL_HABITACIONAL_PREMIO_TEMP_NumeroProduto ON [dbo].[HABITACIONAL_PREMIO_TEMP];



  /*********************************************************************************************************************/
                
                           
   SET @COMANDO =
    '  INSERT INTO dbo.HABITACIONAL_PREMIO_TEMP
       (        [Codigo],                                      
				[ControleVersao],                              
				[NomeArquivo],                                 
				[DataArquivo],                                 
				[NumeroProduto],
				[CodigoSubestipulante],                               
				[TipoCredito],                                 
				[NumeroProposta],                              
				[NumeroContrato],                              
				[RendaPactuada],                               
				[CodigoESCNEG],                                
				[CodigoPV],                                    
				[CodigoUnoNum],                                
				[CodigoUnoDv],                                 
				[NomeSegurado],                                
				[DataNascimento],                              
				[CPFCNPJ],                                     
				[DataContrato],                                
				[DataInclusao],                                
				[DataAmortizacao],                             
				[PrazoVigencia],                               
				[NumeroOrdemInclusao],                         
				[NumeroRI],                                    
				[IDISMip],                          
				[ValorFinanciamento],                          
				[PremioMip],                                   
				[IOFMip],                                      
				[PremioMipAtrasado],                           
				[IOFMipAtrasado],                              
				[IDISInad],                         
				[PremioInad],                                  
				[IOFInad],                                     
				[PremioInadAtrasado],                          
				[IOFInadAtrasado],       
					
				[IDISDfi],
				ISDfi,
				PremioDfi,
				IOFDfi,
				PremioDfiAtrasado,
				IOFDfiAtrasado,
				PercentualResseguro,
				ValorIsRessMip,
				ValorPrRessMipMes,
				ValorPrRessMipAtrasado,
				ValorIsRessDfi,
				ValorPrRessDfiMes,
				ValorPrRessDfiAtrasado,
				                     
				[UF],                                          
				[Cidade],                                      
				[Bairro],                                      
				[Logradouro],                                  
				[Complemento],                                 
				[Numero],                                      
				[CEP]
		)
       SELECT   [Codigo],                                      
				[ControleVersao],                              
				[NomeArquivo],                                 
				[DataArquivo],                                 
				[NumeroProduto],  
				[CodigoSubestipulante],                             
				[TipoCredito],                                 
				[NumeroProposta],                              
				[NumeroContrato],                              
				[RendaPactuada],                               
				[CodigoESCNEG],                                
				[CodigoPV],                                    
				[CodigoUnoNum],                                
				[CodigoUnoDv],                                 
				[NomeSegurado],                                
				[DataNascimento],                              
				[CPFCNPJ],                                     
				[DataContrato],                                
				[DataInclusao],                                
				[DataAmortizacao],                             
				[PrazoVigencia],                               
				[NumeroOrdemInclusao],                         
				[NumeroRI],                                    
				[IDISMip],                          
				[ValorFinanciamento],                          
				[PremioMip],                                   
				[IOFMip],                                      
				[PremioMipAtrasado],                           
				[IOFMipAtrasado],                              
				[IDISInad],                         
				[PremioInad],                                  
				[IOFInad],                                     
				[PremioInadAtrasado],                          
				[IOFInadAtrasado],    
						
				[IDISDfi],		  
				ISDfi,
				PremioDfi,
				IOFDfi,
				PremioDfiAtrasado,
				IOFDfiAtrasado,
				PercentualResseguro,
				ValorIsRessMip,
				ValorPrRessMipMes,
				ValorPrRessMipAtrasado,
				ValorIsRessDfi,
				ValorPrRessDfiMes,
				ValorPrRessDfiAtrasado,
		
				[UF],                                          
				[Cidade],                                      
				[Bairro],                                      
				[Logradouro],                                  
				[Complemento],                                 
				[Numero],                                      
				[CEP]                                        
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaFinanceiroHABITACIONAL_PREMIO]''''' + @PontoDeParada + ''''''') PRP
         '
EXEC (@COMANDO)    
   
                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM dbo.HABITACIONAL_PREMIO_TEMP PRP    
                    
  /*********************************************************************************************************************/
                    
  /*********************************************************************************************************************/
  
END
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HABITACIONAL_PREMIO_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[HABITACIONAL_PREMIO_TEMP];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     




--EXEC [Dados].[proc_InserePropostaEExtrato_HABITACIONAL_PREMIO] 


