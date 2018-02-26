
/*
	Autor: Egler Vieira
	Data Criação: 26/04/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereSINISTROHISTORICO
	Descrição: Procedimento que realiza a inserção dos SINISTROs no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InsereSINISTROHISTORICO] as
BEGIN TRY		
 
	    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 
   	    

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SINISTROHISTORICO_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[SINISTROHISTORICO_TEMP];

CREATE TABLE [dbo].[SINISTROHISTORICO_TEMP](
	[CODIGO] [bigint] NOT NULL,
	[ControleVersao] [decimal](16, 8) NOT NULL,
	[DataArquivo] [date] NOT NULL,
	[NomeArquivo] [varchar](100) NULL,
	[NumeroSinistro] [BIGINT] NOT NULL,
	[NumeroOcorrencia] [smallint] NOT NULL,
	[CodigoOperacao] [smallint] NULL,
	[DescricaoOperacao] [varchar](70) NULL,
	[ValorOperacao] [numeric](15, 2) NULL,
	[DataMovimentacaoContabil] [date] NOT NULL,
	[CodigoCobertura] [SMALLINT] NULL,
	[NomeFavorecido_Beneficiario] [varchar](140) NULL,
	[SituacaoSinistro] [SMALLINT] NULL,
	[DescricaoSituacao] [varchar](40) NULL,
	[NumeroSinistroMAPFRE] [BIGINT] NULL
)

 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_SINISTROHISTORICO_TEMP ON [dbo].[SINISTROHISTORICO_TEMP]
( 
  Codigo ASC
)         


SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'SINISTROHISTORICO'


--select @PontoDeParada = 20007037


/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[SINISTROHISTORICO_TEMP] 
                       ([CODIGO],                        
	                      [ControleVersao],              
	                      [DataArquivo],                 
	                      [NomeArquivo],                 
	                      [NumeroSinistro],              
	                      [NumeroOcorrencia],            
	                      [CodigoOperacao],              
	                      [DescricaoOperacao],           
	                      [ValorOperacao],               
	                      [DataMovimentacaoContabil],    
	                      [CodigoCobertura],             
	                      [NomeFavorecido_Beneficiario], 
	                      [SituacaoSinistro],            
	                      [DescricaoSituacao],           
	                      [NumeroSinistroMAPFRE])
                SELECT  DISTINCT
                      	[CODIGO],                        
	                      [ControleVersao],              
	                      [DataArquivo],                 
	                      [NomeArquivo],                 
	                      [NumeroSinistro],              
	                      [NumeroOcorrencia],            
	                      [CodigoOperacao],              
	                      [DescricaoOperacao],           
	                      [ValorOperacao],               
	                      [DataMovimentacaoContabil],    
	                      [CodigoCobertura],             
	                      [NomeFavorecido_Beneficiario], 
	                      [SituacaoSinistro],            
	                      [DescricaoSituacao],           
	                      [NumeroSinistroMAPFRE]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaSINISTROHISTORICO] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)     

                
SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM [dbo].[SINISTROHISTORICO_TEMP] PRP
                  
/*********************************************************************************************************************/

WHILE @MaiorCodigo IS NOT NULL
BEGIN 
--    PRINT @MaiorCodigo
 
   
      /***********************************************************************
      Carregar as COBERTURAS dos sinistros
      ***********************************************************************/
      ;MERGE INTO Dados.Cobertura AS T
      USING (SELECT DISTINCT ST.CodigoCobertura, '' [Nome]
             FROM [SINISTROHISTORICO_TEMP] ST
             WHERE ST.CodigoCobertura IS NOT NULL
            ) X
       ON T.[Codigo] = X.[CodigoCobertura] 
      WHEN NOT MATCHED
            THEN INSERT (Codigo, Nome)
                 VALUES (X.[CodigoCobertura], X.[Nome]);                
     /***********************************************************************/   
                                                      
   
      /***********************************************************************
      Carregar OPERACAO dos sinistros
      ***********************************************************************/
      ;MERGE INTO Dados.SinistroOperacao AS T
      USING (SELECT DISTINCT  ST.CodigoOperacao, UPPER(REPLACE(REPLACE(ST.DescricaoOperacao, '??', 'ÇÃ'),'?', 'Á')) DescricaoOperacao
             FROM [SINISTROHISTORICO_TEMP] ST
             WHERE ST.CodigoOperacao IS NOT NULL
            ) X
       ON T.ID = X.CodigoOperacao 
      WHEN NOT MATCHED
            THEN INSERT (ID, Descricao)
                 VALUES (X.CodigoOperacao, X.DescricaoOperacao); 
     /***********************************************************************/


     /***********************************************************************
       Carregar as COBERTURAS
     ***********************************************************************/
       ;MERGE INTO Dados.Cobertura AS T
        USING (SELECT DISTINCT COB.CodigoCobertura, '' [Nome] 
               FROM [SINISTROHISTORICO_TEMP] COB
               WHERE COB.CodigoCobertura IS NOT NULL
              ) X
         ON T.[Codigo] = X.CodigoCobertura 
       WHEN NOT MATCHED
	            THEN INSERT (Codigo, Nome)
	                 VALUES (X.[CodigoCobertura], X.[Nome]);
     /***********************************************************************/   


     /***********************************************************************
     Carregar SITUACAO DE SINISTRO dos sinistros
     ***********************************************************************/
   /*  ;MERGE INTO Dados.SituacaoSinistro AS T
     USING (SELECT DISTINCT  ST.[SituacaoSinistro] [CodigoSituacao], DescricaoSituacao [Situacao]
            FROM [SINISTROHISTORICO_TEMP] ST
            WHERE ST.[SituacaoSinistro] IS NOT NULL
           ) X
      ON T.ID = X.[CodigoSituacao] 
     WHEN NOT MATCHED
           THEN INSERT (ID, Descricao)
                VALUES (X.[CodigoSituacao], X.[Situacao]);    */
    /***********************************************************************/ 
 
 
    /***********************************************************************/ 
    /*INSERE CONTRATOR NÃO LOCALIZADOS*/
    /***********************************************************************/ 
   /* ;MERGE INTO Dados.Contrato AS T
    USING	
    (
    SELECT DISTINCT
         1 [IDSeguradora] /*Caixa Seguros*/               
       , S.[NumeroApolice]
       , 'CLIENTE DESCONHECIDO - APÓLICE NÃO RECEBIDA' [NomeCliente]
       , MAX(S.[DataArquivo]) [DataArquivo]
       , MAX(S.NomeArquivo) [Arquivo]
    FROM [SINISTROHISTORICO_TEMP] s
    WHERE S.NumeroApolice IS NOT NULL
    --AND NOT EXISTS (SELECT * FROM Dados.Contrato C WHERE c.NumeroContrato = s.numeroapolice)
    GROUP BY S.[NumeroApolice]
    ) X
    ON T.[NumeroContrato] = X.[NumeroApolice]
    AND T.[IDSeguradora] = X.[IDSeguradora]
    WHEN NOT MATCHED
          THEN INSERT ([NumeroContrato], [IDSeguradora], [NomeCliente], [Arquivo], [DataArquivo])
               VALUES (X.[NumeroApolice], X.[IDSeguradora], X.[NomeCliente], X.[Arquivo], X.[DataArquivo]); */  
    /***********************************************************************/ 
 		        

    
    /****************************************************************************************************************/
    /*INSERE CERTIFICADOS NÃO LOCALIZADOS*/	
    /****************************************************************************************************************/
   /* ;MERGE INTO Dados.Certificado AS T
    USING (             
            SELECT DISTINCT
                   CNT.ID [IDContrato], COALESCE(S.NumeroCertificado_VG_AP, S.NumeroBilhete) [NumeroCertificadoTratado], 1 [IDSeguradora]
                 , 'CLIENTE DESCONHECIDO - CERTIFICADO NÃO RECEBIDO' [NomeCliente]
                 , MAX(S.[DataArquivo]) [DataArquivo], MAX(S.NomeArquivo) [Arquivo]
            FROM [SINISTROHISTORICO_TEMP] S
              INNER JOIN Dados.Contrato CNT
              ON CNT.NumeroContrato = S.NumeroApolice
            WHERE COALESCE(S.NumeroCertificado_VG_AP, S.NumeroBilhete) IS NOT NULL   
            GROUP BY CNT.ID, COALESCE(S.NumeroCertificado_VG_AP, S.NumeroBilhete)
          ) AS X
    ON  X.[NumeroCertificadoTratado] = T.[NumeroCertificado]
    AND X.[IDSeguradora] = T.[IDSeguradora]
    WHEN NOT MATCHED  
      THEN INSERT          
          (   
              [NumeroCertificado]
            , [NomeCliente]  
            , [IDSeguradora]
            , [IDContrato]
            , [DataArquivo]
            , [Arquivo])
      VALUES (   
              X.[NumeroCertificadoTratado]
            , X.[NomeCliente]
            , X.[IDSeguradora]
            , X.[IDContrato]
            , X.[DataArquivo]
            , X.[Arquivo]);  */
     /****************************************************************************************************************/       
 		  		      
 		          
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os históricos do sinistros recebidos no arquivo SINHIST
    -----------------------------------------------------------------------------------------------------------------------		               
   	MERGE INTO Dados.SinistroHistorico AS T
		USING (
		       SELECT *
		       FROM
		       (
			     SELECT 
             ST.[NomeArquivo] [Arquivo],
             ST.[DataArquivo],
                  
             S.ID [IDSinistro],
             ST.NumeroOcorrencia,
             ST.CodigoOperacao IDOperacao,
             ST.ValorOperacao,
             ST.DataMovimentacaoContabil,
             COB.ID [IDCobertura],
             ST.NomeFavorecido_Beneficiario,
             ST.SituacaoSinistro [IDSituacaoSinistro],
             ST.DescricaoSituacao [DescricaoSituacaoSinistro],
             ST.NumeroSinistroMAPFRE,
             ROW_NUMBER() OVER(PARTITION BY ST.NumeroSinistro, ST.NumeroOcorrencia/*, ST.[DataArquivo]*/ ORDER BY ST.Codigo DESC)  [ORDER]
           FROM SINISTROHISTORICO_TEMP ST
           INNER JOIN Dados.Sinistro S
           ON S.NumeroSinistro = ST.NumeroSinistro 
           LEFT JOIN Dados.Cobertura COB            
           ON COB.Codigo = ST.CodigoCobertura                 
           ) A
           WHERE A.[ORDER] = 1
			) AS O
		ON  T.IDSinistro = O.IDSinistro
    AND T.[NumeroOcorrencia] = O.[NumeroOcorrencia]
    --AND T.DataArquivo = O.DataArquivo
	      
		WHEN MATCHED
			THEN UPDATE 
				SET T.IDSinistroOperacao = COALESCE(O.IDOperacao, T.IDSinistroOperacao)
				   ,T.ValorOperacao = COALESCE(O.ValorOperacao, T.ValorOperacao)
				   ,T.DataMovimentoContabil = COALESCE(O.DataMovimentacaoContabil, T.DataMovimentoContabil)
				   ,T.IDCobertura = COALESCE(O.IDCobertura, T.IDCobertura)
           ,T.NomeBeneficiario = COALESCE(O.NomeFavorecido_Beneficiario, T.NomeBeneficiario)
					 ,T.[IDSituacaoSinistro] = COALESCE(O.[IDSituacaoSinistro], T.[IDSituacaoSinistro])					 
					 ,T.[DescricaoSituacaoSinistro] = COALESCE(O.[DescricaoSituacaoSinistro], T.[DescricaoSituacaoSinistro])
					 ,T.NumeroSinistroMAPFRE = COALESCE(O.NumeroSinistroMAPFRE, T.NumeroSinistroMAPFRE)
		 
					 ,T.DataArquivo = COALESCE(O.DataArquivo, T.DataArquivo)	
					 ,T.Arquivo = COALESCE(O.Arquivo, T.Arquivo)
		WHEN NOT MATCHED
			THEN INSERT (
			             IDSinistro,
			             NumeroOcorrencia,
                   IDSinistroOperacao,
                   ValorOperacao,
                   DataMovimentoContabil,
                   IDCobertura,
                   NomeBeneficiario,
                   [IDSituacaoSinistro],                    
                   [DescricaoSituacaoSinistro],                   
                   NumeroSinistroMAPFRE,                        
                   DataArquivo,                 
                   Arquivo)
				VALUES (O.IDSinistro, O.NumeroOcorrencia, O.IDOperacao, O.ValorOperacao, O.DataMovimentacaoContabil
				      , O.IDCobertura, O.NomeFavorecido_Beneficiario, O.[IDSituacaoSinistro], O.[DescricaoSituacaoSinistro]
				      , O.NumeroSinistroMAPFRE, O.DataArquivo, O.Arquivo);
    -----------------------------------------------------------------------------------------------------------------------				
				                                                             
             
    
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'SINISTROHISTORICO'
  /*************************************************************************************/
  
 /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[SINISTROHISTORICO_TEMP] 
    
  /*********************************************************************************************************************/               
  /*Recupeara maior Código do retorno*/
  /*********************************************************************************************************************/

  SET @COMANDO = 'INSERT INTO [dbo].[SINISTROHISTORICO_TEMP] 
                       ([CODIGO],                        
	                      [ControleVersao],              
	                      [DataArquivo],                 
	                      [NomeArquivo],                 
	                      [NumeroSinistro],              
	                      [NumeroOcorrencia],            
	                      [CodigoOperacao],              
	                      [DescricaoOperacao],           
	                      [ValorOperacao],               
	                      [DataMovimentacaoContabil],    
	                      [CodigoCobertura],             
	                      [NomeFavorecido_Beneficiario], 
	                      [SituacaoSinistro],            
	                      [DescricaoSituacao],           
	                      [NumeroSinistroMAPFRE])
                SELECT  DISTINCT
                      	[CODIGO],                        
	                      [ControleVersao],              
	                      [DataArquivo],                 
	                      [NomeArquivo],                 
	                      [NumeroSinistro],              
	                      [NumeroOcorrencia],            
	                      [CodigoOperacao],              
	                      [DescricaoOperacao],           
	                      [ValorOperacao],               
	                      [DataMovimentacaoContabil],    
	                      [CodigoCobertura],             
	                      [NomeFavorecido_Beneficiario], 
	                      [SituacaoSinistro],            
	                      [DescricaoSituacao],           
	                      [NumeroSinistroMAPFRE]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaSINISTROHISTORICO] ''''' + @PontoDeParada + ''''''') PRP'

  EXEC (@COMANDO)              

                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM [dbo].[SINISTROHISTORICO_TEMP] PRP
                    
  /*********************************************************************************************************************/
  
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SINISTROHISTORICO_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[SINISTROHISTORICO_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH
