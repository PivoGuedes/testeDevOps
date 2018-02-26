
/*
	Autor: Egler Vieira
	Data Criação: 17/04/2013

	Descrição: 
	
	Última alteração : 17/05/2013

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereBeneficiario_PRPSASSE
	Descrição: Procedimento que realiza a inserção dos BENEFICIARIOS (PRPSASSE) no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InsereBeneficiario_PRPSASSE] as
BEGIN TRY		
 
	    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 
   	    

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Beneficiario_PRPSASSE_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Beneficiario_PRPSASSE_TEMP];

CREATE TABLE [dbo].[Beneficiario_PRPSASSE_TEMP](
	[Codigo] [bigint] NOT NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[NomeArquivo] [varchar](80) NOT NULL,
	[DataArquivo] [date] NOT NULL,
	[TipoArquivo] [varchar](30) NULL,
	[NumeroProposta] [varchar](20) NULL,
	[NumeroPropostaTratado]  as Cast(dbo.fn_TrataNumeroPropostaZeroExtra(NumeroProposta) as   varchar(20)) PERSISTED,
	[NomeBeneficiario] [varchar](140) NOT NULL,
	[DataNascimentoBeneficiario] [date] NULL,
	[CPFCNPJBeneficiario] [varchar](18) NULL,
	[TipoPessoaBeneficiario] [varchar](30) NULL,
	[EstadoCivil] [tinyint] NULL,
	[EstadoCivilBeneficiario] [varchar](30) NULL,
	[Sexo] [tinyint] NULL,
	[DescricaoSexoBeneficiario] [varchar](20) NULL,
	[CodigoParentesco] [tinyint] NULL,
	[Parentesco] [varchar](30) NULL,
	[PercentualFGB] decimal(6,2) NULL,
	[PercentualPeculio] decimal(6,2) NULL,
	[PercentualPensao] decimal(6,2) NULL,
	[PercentualParticipacao] decimal(5,2) NULL,
	[QtdeTitulos] int NOT NULL
) 
 


 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_Beneficiario_PRPSASSE_TEMP ON [dbo].[Beneficiario_PRPSASSE_TEMP]
( 
  Codigo ASC
)         


--SELECT   @PontoDeParada = PontoParada
--FROM ControleDados.PontoParada
--WHERE NomeEntidade = 'Beneficiario_PRPSASSE'


--select @PontoDeParada = 20007037


/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[Beneficiario_PRPSASSE_TEMP] (
                      [Codigo],                                                 
	                    [ControleVersao],                                         
	                    [NomeArquivo],                                            
	                    [DataArquivo],        
	                    [TipoArquivo],                                    
	                    [NumeroProposta], 
	                    [NomeBeneficiario],                                       
	                    [DataNascimentoBeneficiario],                             
	                    [CPFCNPJBeneficiario],                                    
	                    [TipoPessoaBeneficiario],                                 
	                    [EstadoCivil],                                            
	                    [EstadoCivilBeneficiario],                                
	                    [Sexo],                                                   
	                    [DescricaoSexoBeneficiario],                              
	                    [CodigoParentesco],                                       
	                    [Parentesco],                                             
	                    [PercentualFGB], 
	                    [PercentualPeculio] ,
	                    [PercentualPensao] ,
	                    [PercentualParticipacao],
	                    [QtdeTitulos] 
	                    )  
                SELECT  
                      [Codigo],                                                 
	                    [ControleVersao],                                         
	                    [NomeArquivo],                                            
	                    [DataArquivo],        
	                    [TipoArquivo],                                    
	                    [NumeroProposta], 
	                    [NomeBeneficiario],                                       
	                    [DataNascimentoBeneficiario],                             
	                    [CPFCNPJBeneficiario],                                    
	                    [TipoPessoaBeneficiario],                                 
	                    [EstadoCivil],                                            
	                    [EstadoCivilBeneficiario],                                
	                    [Sexo],                                                   
	                    [DescricaoSexoBeneficiario],                              
	                    [CodigoParentesco],                                       
	                    [Parentesco],                                             
	                    [PercentualFGB], 
	                    [PercentualPeculio] ,
	                    [PercentualPensao] ,
	                    [PercentualParticipacao],
	                    [QtdeTitulos] 
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaBeneficiario_PRPSASSE] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)     

                
SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM [dbo].[Beneficiario_PRPSASSE_TEMP] PRP
                  
/*********************************************************************************************************************/

WHILE @MaiorCodigo IS NOT NULL
BEGIN 
--    PRINT @MaiorCodigo
 
 
      /*INSERE PROPOSTAS NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
      ;MERGE INTO Dados.Proposta AS T
	      USING (SELECT  EM.[NumeroPropostaTratado],1 [IDSeguradora]
	                           , MAX(TipoArquivo) [TipoDado], MAX(DataArquivo) [DataArquivo]
               FROM [Beneficiario_PRPSASSE_TEMP] EM
               WHERE EM.NumeroPropostaTratado IS NOT NULL
               GROUP BY EM.[NumeroPropostaTratado]
              ) X
        ON T.NumeroProposta = X.NumeroPropostaTratado
       AND T.IDSeguradora = X.IDSeguradora
       WHEN NOT MATCHED
              THEN INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
                   VALUES (X.[NumeroPropostaTratado], X.[IDSeguradora], -1, -1, 0, -1, 0, -1, X.TipoDado, X.DataArquivo);		               		               		               
		               
   
      /*INSERE PROPOSTAS CLIENTE NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
      ;MERGE INTO Dados.PropostaCliente AS T
	      USING (SELECT  PRP.ID [IDProposta], 1 [IDSeguradora], 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' [NomeCliente], MAX(TipoArquivo) [TipoDado], MAX(EM.[DataArquivo]) [DataArquivo]
            FROM [Beneficiario_PRPSASSE_TEMP] EM
            INNER JOIN Dados.Proposta PRP
            ON PRP.NumeroProposta = EM.NumeroPropostaTratado
            AND PRP.IDSeguradora = 1
            WHERE EM.NumeroPropostaTratado IS NOT NULL
            GROUP BY PRP.ID
              ) X
        ON T.IDProposta = X.IDProposta
       WHEN NOT MATCHED
		          THEN INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
		               VALUES (X.IDProposta, X.TipoDado, X.[NomeCliente], X.[DataArquivo]);
		               
   /***********************************************************************
     Carregar os Parentescos
   ***********************************************************************/
     ;MERGE INTO Dados.Parentesco AS T
      USING (SELECT DISTINCT EM.CodigoParentesco, '' [Descricao] 
             FROM [Beneficiario_PRPSASSE_TEMP] EM
             WHERE EM.CodigoParentesco IS NOT NULL
            ) X
       ON T.[ID] = X.CodigoParentesco 
     WHEN NOT MATCHED
	          THEN INSERT ( ID, Descricao)
	               VALUES ( X.CodigoParentesco, X.[Descricao]);
   /***********************************************************************/                         
		               
		               		       
	/***********************************************************************
     Carregar os EstadoCivil
   ***********************************************************************/
     ;MERGE INTO Dados.EstadoCivil AS T
      USING (SELECT DISTINCT EM.EstadoCivil, '' [Descricao] 
             FROM [Beneficiario_PRPSASSE_TEMP] EM
             WHERE EM.CodigoParentesco IS NOT NULL
            ) X
       ON T.[ID] = X.EstadoCivil 
     WHEN NOT MATCHED
	          THEN INSERT ( ID, Descricao)
	               VALUES ( X.EstadoCivil, X.[Descricao]);
   /***********************************************************************/   
   		               		          
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os Beneficiários dos certificados recebidos no arquivo PRPSASSE infoVariavel TP4
    -----------------------------------------------------------------------------------------------------------------------		               
   	MERGE INTO Dados.PropostaBeneficiario AS T
		USING (             

              SELECT
                  PRP.ID [IDProposta],  
                  MAX(A.[Arquivo]) [Arquivo],
                  MAX(A.[DataArquivo]) [DataArquivo],
                  A.NumeroProposta,
                  A.[Nome],
                  A.[DataNascimento],
                  A.[CPFCNPJ],
                  A.[IDEstadoCivil],
                  A.[IDSexo],
                  A.[IDParentesco],
                  SUM(A.[PercentualFGB]) [PercentualFGB],
                  SUM(A.[PercentualPeculio]) [PercentualPeculio],
                  SUM(A.[PercentualPensao]) [PercentualPensao],
                  SUM(A.[PercentualParticipacao]) [PercentualParticipacao],
                  SUM(A.[QuantidadeTitulos]) [QuantidadeTitulos] 
              FROM
              (
              SELECT 	
                  BEN.Codigo,       
                  BEN.[NomeArquivo] [Arquivo],
                  BEN.[DataArquivo],
                  BEN.NumeroProposta,
                  BEN.[NomeBeneficiario] [Nome],
                  BEN.[DataNascimentoBeneficiario] [DataNascimento],
                  BEN.[CPFCNPJBeneficiario] [CPFCNPJ],
                  --[TipoPessoaBeneficiario],
                  BEN.[EstadoCivil] [IDEstadoCivil],
                  BEN.[Sexo] [IDSexo],
                  BEN.CodigoParentesco [IDParentesco],
                  --ISNULL(BEN.[Parentesco], '') [Parentesco],
                  BEN.[PercentualFGB] [PercentualFGB],
                  BEN.[PercentualPeculio] [PercentualPeculio],
                  BEN.[PercentualPensao] [PercentualPensao] ,
                  BEN.[PercentualParticipacao] [PercentualParticipacao],
                  BEN.[QtdeTitulos] [QuantidadeTitulos],
                  ROW_NUMBER() OVER(PARTITION BY /*BEN.Codigo,*/ NumeroProposta, [NomeBeneficiario], ISNULL([Parentesco], '') ORDER BY Codigo DESC) [ORDER]
              FROM [Beneficiario_PRPSASSE_TEMP] BEN
              --WHERE NumeroPropostaTratado = '057399110209035'
              WHERE NomeBeneficiario is not null /*IS NULL*/
              ) A
               LEFT JOIN Dados.Proposta PRP
               ON PRP.NumeroProposta = A.NumeroProposta
              AND PRP.IDSeguradora = 1
              WHERE A.[ORDER] = 1
              GROUP BY PRP.[ID],  
                  --A.[Arquivo],
                  --A.[DataArquivo],
                  A.NumeroProposta,
                  A.[Nome],
                  A.[DataNascimento],
                  A.[CPFCNPJ],
                  A.[IDEstadoCivil],
                  A.[IDSexo],
                  A.[IDParentesco]
			) AS O
		ON  T.IDProposta = O.IDProposta
    AND T.Nome = O.Nome
    AND T.[IDParentesco] = O.[IDParentesco]
		WHEN MATCHED
			THEN UPDATE 
				SET --T.Parentesco = COALESCE(O.Parentesco, T.Parentesco)
				    T.PercentualFGB = O.PercentualFGB /*+ T.PercentualFGB*/ --COALESCE(O.PercentualFGB, T.PercentualFGB)
				   ,T.PercentualPeculio = O.PercentualPeculio /*+ T.PercentualPeculio*/ --COALESCE(O.PercentualPeculio, T.PercentualPeculio)
				   ,T.PercentualPensao = O.PercentualPensao /*+ T.PercentualPensao*/ --COALESCE(O.PercentualPensao, T.PercentualPensao)
           ,T.PercentualParticipacao = O.PercentualParticipacao /*+ T.PercentualParticipacao*/ --COALESCE(O.PercentualParticipacao, T.PercentualParticipacao)
					 ,T.QuantidadeTitulos = O.QuantidadeTitulos /*+ T.QuantidadeTitulos*/ --COALESCE(O.QuantidadeTitulos, T.QuantidadeTitulos) 
					 					 
					 ,T.CPFCNPJ = COALESCE(O.CPFCNPJ, T.CPFCNPJ)
					 ,T.DataNascimento = COALESCE(O.DataNascimento, T.DataNascimento)
					 ,T.IDEstadoCivil = COALESCE(O.IDEstadoCivil, T.IDEstadoCivil)
					 ,T.IDSexo = COALESCE(O.IDSexo, T.IDSexo)
					 ,T.DataArquivo = COALESCE(O.DataArquivo, T.DataArquivo)
					 ,T.Arquivo = COALESCE(O.Arquivo, T.Arquivo)
		WHEN NOT MATCHED
			THEN INSERT (IDProposta, Nome, CPFCNPJ, DataNascimento, IDSexo, IDEstadoCivil, [IDParentesco]
			           , PercentualFGB, PercentualPeculio, PercentualPensao, PercentualParticipacao
			           , QuantidadeTitulos, DataArquivo, Arquivo)
				VALUES (O.IDProposta, O.Nome, O.CPFCNPJ, O.DataNascimento, O.IDSexo, O.IDEstadoCivil, O.[IDParentesco]
				        , O.PercentualFGB, O.PercentualPeculio, O.PercentualPensao, O.PercentualParticipacao
				        , O.QuantidadeTitulos, O.DataArquivo, O.Arquivo);
    -----------------------------------------------------------------------------------------------------------------------				
				
    
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Beneficiario_PRPSASSE'
  /*************************************************************************************/
  
 /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[Beneficiario_PRPSASSE_TEMP] 
    
  /*********************************************************************************************************************/               
  /*Recupeara maior Código do retorno*/
  /*********************************************************************************************************************/

  SET @COMANDO = 'INSERT INTO [dbo].[Beneficiario_PRPSASSE_TEMP] (
                      [Codigo],                                                 
	                    [ControleVersao],                                         
	                    [NomeArquivo],                                            
	                    [DataArquivo],        
	                    [TipoArquivo],                                    
	                    [NumeroProposta], 
	                    [NomeBeneficiario],                                       
	                    [DataNascimentoBeneficiario],                             
	                    [CPFCNPJBeneficiario],                                    
	                    [TipoPessoaBeneficiario],                                 
	                    [EstadoCivil],                                            
	                    [EstadoCivilBeneficiario],                                
	                    [Sexo],                                                   
	                    [DescricaoSexoBeneficiario],                              
	                    [CodigoParentesco],                                       
	                    [Parentesco],                                             
	                    [PercentualFGB], 
	                    [PercentualPeculio] ,
	                    [PercentualPensao] ,
	                    [PercentualParticipacao],
	                    [QtdeTitulos] 
	                        )
                  SELECT  
                      [Codigo],                                                 
	                    [ControleVersao],                                         
	                    [NomeArquivo],                                            
	                    [DataArquivo],        
	                    [TipoArquivo],                                    
	                    [NumeroProposta], 
	                    [NomeBeneficiario],                                       
	                    [DataNascimentoBeneficiario],                             
	                    [CPFCNPJBeneficiario],                                    
	                    [TipoPessoaBeneficiario],                                 
	                    [EstadoCivil],                                            
	                    [EstadoCivilBeneficiario],                                
	                    [Sexo],                                                   
	                    [DescricaoSexoBeneficiario],                              
	                    [CodigoParentesco],                                       
	                    [Parentesco],                                             
	                    [PercentualFGB], 
	                    [PercentualPeculio] ,
	                    [PercentualPensao] ,
	                    [PercentualParticipacao],
	                    [QtdeTitulos] 
                  FROM OPENQUERY ([OBERON], 
                  ''EXEC [Fenae].[Corporativo].[proc_RecuperaBeneficiario_PRPSASSE] ''''' + @PontoDeParada + ''''''') PRP'

  EXEC (@COMANDO)         

                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM [dbo].[Beneficiario_PRPSASSE_TEMP] PRP
                    
  /*********************************************************************************************************************/
  
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Beneficiario_PRPSASSE_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Beneficiario_PRPSASSE_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH
