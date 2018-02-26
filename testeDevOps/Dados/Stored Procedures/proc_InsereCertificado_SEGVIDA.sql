
/*
	Autor: Egler Vieira
	Data Criação: 22/11/2012

	Descrição: 
	
	Penúltima alteração : 23/05/2013 

	Última alteração : 06/11/2013 
	Descrição: adicionando o update do LastValue


*/

/*******************************************************************************
	Nome: CONCILIACAO.Dados.proc_InsereCertificado_SEGVIDA
	Descrição: Procedimento que realiza a inserção dos Certificados (SEGVIDA) no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InsereCertificado_SEGVIDA] as
BEGIN TRY		
 
	    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 
   	    

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CERTIFICADO_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[CERTIFICADO_TEMP];

CREATE TABLE [dbo].[CERTIFICADO_TEMP](
	[Codigo] [bigint] NOT NULL,
	[ControleVersao] [numeric](16, 8) NULL,
	[NomeArquivo] [nvarchar](100) NOT NULL,
	[DataArquivo] [date] NULL,
	[CPF] [char](18) NULL,
	[Nome] [varchar](8000) NULL,
	[DataNascimento] [date] NULL,
	[IDSeguradora] [int] NOT NULL,
	[NumeroContrato] [varchar](8000) NULL,
	[NumeroCertificado] [varchar](20) NULL,
	[DataInicioVigencia] [date] NULL,
	[DataFimVigencia] [date] NULL,
	[ValorPremioTotal] [numeric](15, 2) NULL,
	[ValorPremioLiquido] [numeric](15, 2) NULL,
	[Agencia] [varchar](8000) NULL,
	[QuantidadeParcelas] [int] NULL,
	[NumeroSICOB] [varchar](8000) NULL,
	[CodigoSubestipulante] [varchar](8000) NULL,
	[MatriculaIndicador] [varchar](8000) NULL,
	[MatriculaIndicadorGerente] [varchar](8000) NULL,
	[MatriculaIndicadorSuperintendenteRegional] [varchar](8000) NULL,
	[MatriculaFuncionario] [varchar](8000) NULL,
	[CodigoMoedaSegurada] [varchar](8000) NULL,
	[CodigoMoedaPremio] [varchar](8000) NULL,
	[TipoBeneficio] [varchar](8000) NULL,
	[DataCancelamento] [date] NULL,
	[NumeroProposta] [varchar](8000) NULL,
	[CodigoPeriodoPagamento] [varchar](8000) NULL,
	[PeriodoPagamento] [varchar](10) NULL,
	[CodigoTipoSegurado] [smallint] NULL,
	[TipoSegurado] [varchar](16) NULL,
	
	[CodigoCliente] [varchar] (9) NULL,
	[EstadoCivil] [char] (1) NULL,
	[Endereco] [varchar](40) NULL,
	[Bairro] [varchar](20) NULL,
	[Cidade] [varchar](20) NULL,
	[SiglaUF] [varchar](16) NULL,
	[CEP] [varchar](9) NULL,
	[DDD] [varchar](4) NULL,
	[Telefone] [varchar](9) NULL, 
	[CodigoProduto][varchar](5) NULL, 
	 
	[RankCertificadoProposta] [bigint] NULL,
	[RankCertificado] [bigint] NULL
) 


 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_CERTIFICADO_TEMP ON [dbo].[CERTIFICADO_TEMP]
( 
  Codigo ASC
)         


SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'SEGVIDA'


--select @PontoDeParada = 20007037



--order by EM.Agencia
  /*                    
-----------------------------------------------------------------------------------------------------------------------
--Comando para inserir EVENTUAIS Agências que não existirem na tabela de Unidades e estiverem em registros da emissão
-----------------------------------------------------------------------------------------------------------------------
SET @COMANDO =
'BEGIN TRY	

  BEGIN TRANSACTION	
      
-----------------------------------------------------------------------------------------------------------------------
--Comando para inserir EVENTUAIS Periodicidades de Pagamento que não existirem na tabela de PeriodoPagamento e estiverem 
--em registros dos CERTIFICADOS -> SEGVIDA
-----------------------------------------------------------------------------------------------------------------------
SET @COMANDO =
'BEGIN TRY	

  BEGIN TRANSACTION	
  
  INSERT INTO Dados.PeriodoPagamento (Codigo, Descricao)
  SELECT DISTINCT EM.PeriodoPagamento, DescricaoPeriodoPagamento 
  FROM BASEPRIMARIA.dbo.SEGVIDA EM
  WHERE EM.Codigo > ' + @PontoDeParada + '
  AND NOT EXISTS (
                  SELECT     *
                  FROM         Dados.PeriodoPagamento TE
                  WHERE TE.Codigo = RIGHT(EM.PeriodoPagamento,2)) 
  AND EM.PeriodoPagamento <> ''''   
  
        IF (@@TRANCOUNT > 0)
        BEGIN
	        COMMIT TRANSACTION
        END
  		
    END TRY                
    BEGIN CATCH	
  			
      IF (@@TRANCOUNT > 0)
      BEGIN			
	      ROLLBACK TRANSACTION
      END
  		
      EXEC CleansingKit.dbo.proc_RethrowError	
     -- RETURN @@ERROR	
    END CATCH         
'    
EXEC (@COMANDO)     
-----------------------------------------------------------------------------------------------------------------------          
   */                           


/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
--DECLARE @PontoDeParada AS VARCHAR(400)
--set @pontodeparada = 16174888
--DECLARE @MaiorCodigo AS BIGINT
--DECLARE @ParmDefinition NVARCHAR(500)
--DECLARE @COMANDO AS NVARCHAR(max) 
SET @COMANDO = 'INSERT INTO [dbo].[CERTIFICADO_TEMP]
                SELECT *
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaSEGVIDA] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)     

                
SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM [dbo].[CERTIFICADO_TEMP] PRP
                  
/*********************************************************************************************************************/

WHILE @MaiorCodigo IS NOT NULL
BEGIN 
--    PRINT @MaiorCodigo
 
       
    
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir Apólices  - Que referenciam apólices dos CERTIFICADOS" não recebidas nos arquivos de EMISSAO
    -----------------------------------------------------------------------------------------------------------------------
	    
      ;MERGE INTO Dados.Contrato AS T
      USING	
       (SELECT 
               EM.[IDSeguradora] /*Caixa Seguros*/               
             , EM.[NumeroContrato]
             , MAX(EM.[DataArquivo]) [DataArquivo]
             , MAX(EM.NomeArquivo) [Arquivo]
        FROM [dbo].[CERTIFICADO_TEMP] EM
        WHERE EM.NumeroContrato IS NOT NULL
        GROUP BY EM.[NumeroContrato], EM.[IDSeguradora] 
       ) X
      ON T.[NumeroContrato] = X.[NumeroContrato]
     AND T.[IDSeguradora] = X.[IDSeguradora]
     WHEN NOT MATCHED
                THEN INSERT ([NumeroContrato], [IDSeguradora], [Arquivo], [DataArquivo])
                     VALUES (X.[NumeroContrato], X.[IDSeguradora], X.[Arquivo], X.[DataArquivo]);    
                     
    -----------------------------------------------------------------------------------------------------------------------
           
           
   -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir Tipo de Segurado  
    -----------------------------------------------------------------------------------------------------------------------
	    
      ;MERGE INTO Dados.TipoSeguradoCertificado AS T
      USING	
       (SELECT DISTINCT CodigoTipoSegurado, '' Descricao
        FROM [dbo].[CERTIFICADO_TEMP] EM
        WHERE EM.CodigoTipoSegurado IS NOT NULL
       ) X
      ON T.[Codigo] = X.[CodigoTipoSegurado]
     WHEN NOT MATCHED
                THEN INSERT (Codigo, Descricao)
                     VALUES ([CodigoTipoSegurado], Descricao);    
                         

    /*INSERE PVs NÃO LOCALIZADOS*/
    ;INSERT INTO Dados.Unidade(Codigo)
    SELECT DISTINCT EM.Agencia
    FROM [CERTIFICADO_TEMP] EM
    WHERE  EM.Agencia IS NOT NULL 
      AND not exists (
                      SELECT     *
                      FROM         Dados.Unidade U
                      WHERE U.Codigo = EM.Agencia)                  
                                                            

    INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)
    SELECT DISTINCT U.ID, 'UNIDADE COM DADOS INCOMPLETOS' [Unidade], -1 [CodigoNaFonte], 'SEGVIDA' [TipoDado], MAX(EM.DataArquivo) [DataArquivo], MAX([NomeArquivo]) [Arquivo]
    FROM [CERTIFICADO_TEMP] EM
    INNER JOIN Dados.Unidade U
    ON EM.Agencia = U.Codigo
    WHERE 
        not exists (
                    SELECT     *
                    FROM         Dados.UnidadeHistorico UH
                    WHERE UH.IDUnidade = U.ID)    
    GROUP BY U.ID 
                     
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir Produto
    -----------------------------------------------------------------------------------------------------------------------
	    
		    
      ;MERGE INTO Dados.Produto AS T
      USING	
       (SELECT DISTINCT CodigoProduto, '' Descricao
        FROM [dbo].[CERTIFICADO_TEMP] EM
        WHERE EM.CodigoProduto IS NOT NULL
       ) X
      ON isnull(T.CodigoComercializado,-1) = isnull(X.CodigoProduto,-1)
     WHEN NOT MATCHED
			THEN INSERT ([CodigoComercializado], Descricao)
		               VALUES (X.CodigoProduto, X.[Descricao]);  

	---============================================


    /*INSERE PROPOSTAS NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
    ;MERGE INTO Dados.Proposta AS T
      USING (SELECT CNT.ID [IDContrato], EM.[NumeroCertificado], 1 [IDSeguradora],PRD.ID [IDProduto]
                           , 'SEGVIDA' [TipoDado], MAX(EM.DataArquivo) [DataArquivo]
             FROM [CERTIFICADO_TEMP] EM
              INNER JOIN Dados.Contrato CNT
              ON CNT.NumeroContrato = EM.NumeroContrato

			  INNER JOIN Dados.Produto PRD
			  ON isnull(PRD.CodigoComercializado,-1) = isnull(EM.CodigoProduto,-1)

             WHERE EM.[NumeroCertificado] IS NOT NULL
              
             GROUP BY EM.[NumeroCertificado], CNT.ID,PRD.ID
            ) X
      ON T.NumeroProposta = X.[NumeroCertificado]
     AND T.IDSeguradora = X.IDSeguradora
     WHEN NOT MATCHED
            THEN INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
                 VALUES (X.[NumeroCertificado], X.[IDSeguradora], -1, X.IDProduto, 0, -1, 0, -1, X.TipoDado, X.DataArquivo)		               		               	               
     WHEN MATCHED	               
            THEN UPDATE SET T.IDContrato = X.IDContrato,
			
			 /*Atualiza o código do Produto & código do Produto Anterior com o código recebido no comissionamento
		   Diego - 24/04/2014*/
		        T.IDProduto = X.IDProduto,
				   T.IDProdutoAnterior = CASE  WHEN NOT (T.IDProduto IS NULL OR T.IDProduto = -1) AND T.IDProduto <> X.IDProduto THEN T.IDProduto
											   ELSE CASE WHEN T.IDProdutoAnterior IS NULL THEN NULL
											             ELSE T.IDProdutoAnterior
												    END
										 END    ;
                        

     /***********************************************************************
       Carrega os dados do Cliente da proposta
     ***********************************************************************/                 
    ;MERGE INTO Dados.PropostaCliente AS T
		USING (
        SELECT   
                  PRP.ID [IDProposta]
                 ,CRT.CPF [CPFCNPJ]
                 ,CRT.Nome              
                 ,CRT.DataNascimento 
                 ,RIGHT(CRT.DDD, 3) DDD  
                 ,CRT.Telefone   
                 ,CRT.EstadoCivil [IDEstadoCivil]        
                 ,'SEGVIDA' [TipoDado]           
                 ,CRT.DataArquivo
        FROM dbo.[CERTIFICADO_TEMP] CRT
          INNER JOIN Dados.Proposta PRP
          ON CRT.[NumeroCertificado] = PRP.NumeroProposta
         AND PRP.IDSeguradora = 1
         --and prp.id = 11308998
         WHERE [RankCertificadoProposta] = 1  
          AND [RankCertificado] = 1  
          ) AS X
    ON X.IDProposta = T.IDProposta
       WHEN MATCHED
			    THEN UPDATE
				     SET 
				 CPFCNPJ = COALESCE(X.[CPFCNPJ], T.[CPFCNPJ])
               , Nome = COALESCE(X.[Nome], T.[Nome])
               , DataNascimento = COALESCE(X.[DataNascimento], T.[DataNascimento])
               , IDEstadoCivil = COALESCE(X.[IDEstadoCivil], T.[IDEstadoCivil])
               , DDDFax= COALESCE(X.[DDD], T.[DDDFax])
               , TelefoneFax = COALESCE(X.[Telefone], T.[TelefoneFax])

               , TipoDado = COALESCE(X.[TipoDado], T.[TipoDado])
               , DataArquivo = COALESCE(X.[DataArquivo], T.[DataArquivo])	
    WHEN NOT MATCHED
			    THEN INSERT          
              ( IDProposta, CPFCNPJ, Nome, DataNascimento                                                                 
              , [IDEstadoCivil]        ,  DDDFax, TelefoneFax
              , TipoDado, DataArquivo)                                            
          VALUES (
                  X.IDProposta                                                   
                 ,X.CPFCNPJ                                                        
                 ,X.Nome                                                          
                 ,X.DataNascimento    
                 ,X.[IDEstadoCivil]           
                 ,X.[DDD]
                 ,X.[Telefone]                      
           
                 ,X.[TipoDado]       
                 ,X.[DataArquivo]  
                 );
                 
    /*Apaga a marcação LastValue das propostas recebidas para atualizar a última posição -> logo depois da inserção das Situações (abaixo)*/
    UPDATE Dados.PropostaEndereco SET LastValue = 0
   -- SELECT *
    FROM Dados.PropostaEndereco PS
    WHERE PS.IDProposta IN (SELECT PRP.ID
                            FROM dbo.[CERTIFICADO_TEMP] CRT
							  INNER JOIN Dados.Proposta PRP
							  ON CRT.[NumeroCertificado] = PRP.NumeroProposta
							 AND PRP.IDSeguradora = 1
							 WHERE [RankCertificadoProposta] = 1  
							  AND [RankCertificado] = 1  
                            )
           AND PS.LastValue = 1
                            

  /***********************************************************************
       Carrega os dados do Cliente da proposta
     ***********************************************************************/                 
    ;MERGE INTO Dados.PropostaEndereco AS T
		USING (
        SELECT   
                  PRP.ID [IDProposta]
                 ,99 [IDTipoEndereco]
                 ,CRT.Endereco        
                 ,CRT.Bairro              
                 ,CRT.Cidade       
                 ,CRT.SiglaUF  [UF]      
                 ,CRT.CEP    
                 , 0 LastValue
                 ,'SEGVIDA' [TipoDado]           
                 ,CRT.DataArquivo
				 
        FROM dbo.[CERTIFICADO_TEMP] CRT
          INNER JOIN Dados.Proposta PRP
          ON CRT.[NumeroCertificado] = PRP.NumeroProposta
         AND PRP.IDSeguradora = 1
         WHERE [RankCertificadoProposta] = 1  
          AND [RankCertificado] = 1 --and PRP.ID = 613889
          ) AS X
    ON  X.IDProposta = T.IDProposta
    AND X.[IDTipoEndereco] = T.[IDTipoEndereco]
    --AND X.[DataArquivo] >= T.[DataArquivo]
	AND X.Endereco = T.Endereco
       WHEN MATCHED  AND X.[DataArquivo] >= ISNULL(T.[DataArquivo], '0001-01-01')
			    THEN UPDATE
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
				 ,0
                 );     
				 

/*Atualiza a marcação LastValue das propostas recebidas para atualizar a última posição*/
/*DIEGO - Data: 18/10/2013 */		 
    UPDATE Dados.PropostaEndereco SET LastValue = 1
	--select *
    FROM Dados.PropostaEndereco PE
	INNER JOIN (
				SELECT ID,  ROW_NUMBER() OVER (PARTITION BY PS.IDProposta, PS.IDTipoEndereco ORDER BY PS.DataArquivo DESC) [ORDEM]
				FROM Dados.PropostaEndereco PS
				WHERE PS.IDProposta IN (
										SELECT PRP.ID
										FROM [dbo].[CERTIFICADO_TEMP] CT
										  INNER JOIN Dados.Proposta PRP
										  ON CT.[NumeroCertificado] = PRP.NumeroProposta
										 AND PRP.IDSeguradora = 1
									   )
					) A
	 ON A.ID = PE.ID 
	 AND A.ORDEM = 1	
    
		          
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os Certificados recebidos no arquivo SEGVIDA
    -----------------------------------------------------------------------------------------------------------------------		               
    ;MERGE INTO Dados.Certificado AS T
		USING (
        SELECT 
               CNT.ID [IDContrato], PRP.ID [IDProposta], SV.[NumeroCertificado], SV.[IDSeguradora]
             , SV.[NumeroSICOB], SV.[Nome] [NomeCliente], SV.[CPF], SV.[DataNascimento], UA.ID [IDAgencia]
             , SV.[MatriculaIndicador], SV.[MatriculaIndicadorGerente], SV.[MatriculaIndicadorSuperintendenteRegional] [MatriculaSuperintendenteRegional]
             , SV.[MatriculaFuncionario] [MatriculaFuncionarioCaixa], TS.ID [IDTipoSegurado]
             , SV.[DataInicioVigencia], SV.[DataFimVigencia], SV.[ValorPremioTotal], SV.[ValorPremioLiquido]
             , SV.[CodigoMoedaSegurada], SV.[CodigoMoedaPremio], SV.[TipoBeneficio],  SV.[DataArquivo], SV.[NomeArquivo] [Arquivo]
        FROM [dbo].[CERTIFICADO_TEMP] SV
          INNER JOIN Dados.Contrato CNT
          ON CNT.NumeroContrato = SV.NumeroContrato
          LEFT JOIN Dados.TipoSeguradoCertificado TS
          ON TS.Codigo = SV.CodigoTipoSegurado
          LEFT JOIN Dados.Unidade UA
          ON UA.Codigo = SV.Agencia 
          LEFT JOIN Dados.Proposta PRP
          ON SV.NumeroCertificado = PRP.NumeroProposta          
           AND SV.IDSeguradora = PRP.IDSeguradora   
        WHERE [RankCertificadoProposta] = 1  
          AND [RankCertificado] = 1  
          ) AS X
    ON  X.[NumeroCertificado] = T.[NumeroCertificado]
    AND X.[IDProposta] = T.[IDProposta]
    AND X.[IDSeguradora] = T.[IDSeguradora]
    WHEN MATCHED
	    THEN UPDATE
		     SET
			     [IDContrato] = COALESCE(X.[IDContrato], T.[IDContrato])
               , [IDProposta] = COALESCE(T.[IDProposta], X.[IDProposta])  --DEVE PREVALECER A PROPOSTA QUE JÁ ESTÁ NA TABELA CERTIFICADO POIS PODE SER ORIUNDA 
                                                                          --DO ARQUIVO STASASSE TP2. ESTE ARQUIVO FAZ A LIGAÇÃO COM OS PAGAMENTO VINDOS NO TP8 
                                                                          --ONDE HÁ A INDICAÇÃO DA PROPOSTA CORRETA MESMO QUE O NÚMERO DELA SEJA DIFERENTE DO NÚMERO DO CERTIFICADO
			   , [NumeroSICOB] = COALESCE(X.[NumeroSICOB], T.[NumeroSICOB])
			   , [CPF] = COALESCE(X.[CPF], T.[CPF])
			   , [NomeCliente] = COALESCE(X.[NomeCliente],T.[NomeCliente])
			   , [DataNascimento] = COALESCE(X.[DataNascimento],T.[DataNascimento])				       
			   , [IDAgencia] = COALESCE(X.[IDAgencia],T.[IDAgencia])               
               , [MatriculaIndicador] = COALESCE(X.[MatriculaIndicador], T.[MatriculaIndicador])
               , [MatriculaIndicadorGerente] = COALESCE(X.[MatriculaIndicadorGerente], T.[MatriculaIndicadorGerente])
               , [MatriculaSuperintendenteRegional] = COALESCE(X.[MatriculaSuperintendenteRegional],T.[MatriculaSuperintendenteRegional])
               , [MatriculaFuncionarioCaixa] = COALESCE(X.[MatriculaFuncionarioCaixa], T.[MatriculaFuncionarioCaixa])               
               , [IDTipoSegurado] = COALESCE(X.[IDTipoSegurado], T.[IDTipoSegurado])
               , [CodigoMoedaSegurada] = COALESCE(X.[CodigoMoedaSegurada], T.[CodigoMoedaSegurada])
               , [CodigoMoedaPremio] = COALESCE(X.[CodigoMoedaPremio], T.[CodigoMoedaPremio])
               , [TipoBeneficio] = COALESCE(X.[TipoBeneficio], T.[TipoBeneficio])
               , [DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo])               
               , [Arquivo] = COALESCE(X.[Arquivo], T.[Arquivo]) 
    WHEN NOT MATCHED  
			    THEN INSERT          
              (   
                  [NumeroCertificado]
                , [IDSeguradora]
                , [IDContrato]
                , [IDProposta]
                , [NumeroSICOB]
                , [CPF]
                , [NomeCliente]
                , [DataNascimento]
                , [IDAgencia]
                , [MatriculaIndicador]
                , [MatriculaIndicadorGerente]
                , [MatriculaSuperintendenteRegional]
                , [MatriculaFuncionarioCaixa] 
                , [IDTipoSegurado]
                , [CodigoMoedaSegurada]
                , [CodigoMoedaPremio]
                , [TipoBeneficio]
                , [DataArquivo]
                , [Arquivo])
          VALUES (   
                  X.[NumeroCertificado]
                , X.[IDSeguradora]
                , X.[IDContrato]
                , X.[IDProposta]
                , X.[NumeroSICOB]
                , X.[CPF]
                , X.[NomeCliente]
                , X.[DataNascimento]
                , X.[IDAgencia]
                , X.[MatriculaIndicador]
                , X.[MatriculaIndicadorGerente]
                , X.[MatriculaSuperintendenteRegional]
                , X.[MatriculaFuncionarioCaixa] 
                , X.[IDTipoSegurado]
                , X.[CodigoMoedaSegurada]
                , X.[CodigoMoedaPremio]
                , X.[TipoBeneficio]
                , X.[DataArquivo]
                , X.[Arquivo]);

    -----------------------------------------------------------------------------------------------------------------------      
         /*
         EXEC [Fenae].[Corporativo].[proc_RecuperaSEGVIDA] '0'
         
        SELECT 
               C.ID [IDCertificado]  
             , PP.ID [IDPeriodoPagamento],  SV.[NumeroProposta], SV.[CodigoSubEstipulante]
             , SV.[CodigoSubEstipulante], SV.[QuantidadeParcelas]
             , SV.[DataInicioVigencia], SV.[DataFimVigencia], SV.[ValorPremioTotal], SV.[ValorPremioLiquido]
             , SV.[DataCancelamento], SV.[DataArquivo], SV.[NomeArquivo] [Arquivo]
        FROM OPENQUERY ([OBERON], 
          'EXEC [Fenae].[Corporativo].[proc_RecuperaSEGVIDA] ''0''') SV
          left JOIN Dados.Certificado C
          ON C.NumeroCertificado = SV.NumeroCertificado
          AND C.IDSeguradora = SV.IDSeguradora
          LEFT JOIN Dados.PeriodoPagamento PP
          ON PP.Codigo = SV.CodigoPeriodoPagamento
        WHERE [RankCertificadoProposta] = 1  
          AND [RankCertificado] = 1  */
    
     -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir o Histórico dos Certificados recebidos no arquivo SEGVIDA
    -----------------------------------------------------------------------------------------------------------------------		               

	        
    ;MERGE INTO Dados.CertificadoHistorico AS T
		USING (
        SELECT 
               C.ID [IDCertificado]  
             , PP.ID [IDPeriodoPagamento],  SV.[NumeroProposta]
             , SV.[CodigoSubEstipulante], SV.[QuantidadeParcelas]
             , SV.[DataInicioVigencia], SV.[DataFimVigencia], SV.[ValorPremioTotal], SV.[ValorPremioLiquido]
             , SV.[DataCancelamento], SV.[DataArquivo], SV.[NomeArquivo] [Arquivo]
        FROM [dbo].[CERTIFICADO_TEMP] SV
          INNER JOIN Dados.Certificado C
          ON C.NumeroCertificado = SV.NumeroCertificado
          LEFT JOIN Dados.Proposta PRP
          ON   SV.NumeroCertificado = PRP.NumeroProposta          
           AND SV.IDSeguradora = PRP.IDSeguradora   
          AND C.IDSeguradora = SV.IDSeguradora
          LEFT JOIN Dados.PeriodoPagamento PP
          ON PP.Codigo = SV.CodigoPeriodoPagamento
        WHERE [RankCertificadoProposta] = 1  
          ) AS X
    ON  X.[IDCertificado] = T.[IDCertificado]
    AND X.[NumeroProposta] = T.[NumeroProposta]
    AND X.[DataArquivo] = T.[DataArquivo]
    WHEN MATCHED
			    THEN UPDATE
				     SET
                 [IDPeriodoPagamento] = COALESCE(X.[IDPeriodoPagamento], T.[IDPeriodoPagamento])
               , [NumeroProposta] = COALESCE(X.[NumeroProposta], T.[NumeroProposta])  
               , [CodigoSubEstipulante] = COALESCE(X.[CodigoSubEstipulante], T.[CodigoSubEstipulante])  
               , [QuantidadeParcelas] = COALESCE(X.[QuantidadeParcelas], T.[QuantidadeParcelas]) 
               , [DataInicioVigencia] = COALESCE(X.[DataInicioVigencia], T.[DataInicioVigencia])
               , [DataFimVigencia] = COALESCE(X.[DataFimVigencia], T.[DataFimVigencia])                
               , [ValorPremioTotal] = COALESCE(X.[ValorPremioTotal], T.[ValorPremioTotal])
               , [ValorPremioLiquido] = COALESCE(X.[ValorPremioLiquido], T.[ValorPremioLiquido])                               
               , [DataCancelamento] = COALESCE(X.[DataCancelamento], T.[DataCancelamento])               
               /*, [DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo]*/               
               , [Arquivo] = COALESCE(X.[Arquivo], T.[Arquivo])
    WHEN NOT MATCHED
			    THEN INSERT          
              (   
                  [IDCertificado]
                , [IDPeriodoPagamento] 
                , [NumeroProposta]                
                , [CodigoSubEstipulante]
                , [QuantidadeParcelas]
                , [DataInicioVigencia]
                , [DataFimVigencia]
                , [ValorPremioTotal]
                , [ValorPremioLiquido]
                , [DataCancelamento]
                , [DataArquivo]
                , [Arquivo])                                

          VALUES (   
                  X.[IDCertificado]
                , X.[IDPeriodoPagamento] 
                , X.[NumeroProposta]                
                , X.[CodigoSubEstipulante]
                , X.[QuantidadeParcelas]
                , X.[DataInicioVigencia]
                , X.[DataFimVigencia]
                , X.[ValorPremioTotal]
                , X.[ValorPremioLiquido]
                , X.[DataCancelamento]
                , X.[DataArquivo]
                , X.[Arquivo]);

     -----------------------------------------------------------------------------------------------------------------------
    --Comando para atualizar a vigência  e os valores com a última posição recebidas no arquivo SEGVIDA
    -----------------------------------------------------------------------------------------------------------------------		    

	;MERGE INTO Dados.Certificado AS T
		USING (
        SELECT 
               C.ID [IDCertificado]  
             , SV.[DataInicioVigencia], SV.[DataFimVigencia], SV.[ValorPremioTotal], SV.[ValorPremioLiquido]
             , MAX(SV.[DataCancelamento]) [DataCancelamento], MAX(SV.[DataArquivo]) [DataArquivo], MAX(SV.[NomeArquivo]) [Arquivo]
        FROM [dbo].[CERTIFICADO_TEMP] SV
          INNER JOIN Dados.Certificado C
          ON C.NumeroCertificado = SV.NumeroCertificado
          LEFT JOIN Dados.Proposta PRP
          ON   SV.NumeroCertificado = PRP.NumeroProposta          
           AND SV.IDSeguradora = PRP.IDSeguradora   
          AND C.IDSeguradora = SV.IDSeguradora
          LEFT JOIN Dados.PeriodoPagamento PP
          ON PP.Codigo = SV.CodigoPeriodoPagamento
        WHERE [RankCertificadoProposta] = 1  
		GROUP BY C.ID, SV.[DataInicioVigencia], SV.[DataFimVigencia], SV.[ValorPremioTotal], SV.[ValorPremioLiquido]
          ) AS X
    ON  X.[IDCertificado] = T.[ID] --IDCertificado
    AND X.[DataArquivo] >= T.[DataArquivo]
    WHEN MATCHED
	THEN UPDATE
			SET
                 [DataInicioVigencia] = COALESCE(X.[DataInicioVigencia], T.[DataInicioVigencia])
               , [DataFimVigencia] = COALESCE(X.[DataFimVigencia], T.[DataFimVigencia])                
               , [ValorPremioBruto] = COALESCE(X.[ValorPremioTotal], T.[ValorPremioBruto])
               , [ValorPremioLiquido] = COALESCE(X.[ValorPremioLiquido], T.[ValorPremioLiquido])                               
               , [DataCancelamento] = COALESCE(X.[DataCancelamento], T.[DataCancelamento])               
               , [DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo])               
               , [Arquivo] = COALESCE(X.[Arquivo], T.[Arquivo]);
   
    -----------------------------------------------------------------------------------------------------------------------   
    
    
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'SEGVIDA'
  /*************************************************************************************/
  
 /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[CERTIFICADO_TEMP] 
    
  /*********************************************************************************************************************/               
  /*Recupeara maior Código do retorno*/
  /*********************************************************************************************************************/

  SET @COMANDO = 'INSERT INTO [dbo].[CERTIFICADO_TEMP]
                  SELECT *
                  FROM OPENQUERY ([OBERON], 
                  ''EXEC [Fenae].[Corporativo].[proc_RecuperaSEGVIDA] ''''' + @PontoDeParada + ''''''') PRP'

  EXEC (@COMANDO)     

                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM [dbo].[CERTIFICADO_TEMP] PRP
                    
  /*********************************************************************************************************************/
  
END

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH


--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CERTIFICADO_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	--DROP TABLE [dbo].[CERTIFICADO_TEMP];