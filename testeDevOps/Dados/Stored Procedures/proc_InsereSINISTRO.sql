
/*
	Autor: Egler Vieira
	Data Criação: 24/04/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereSINISTRO
	Descrição: Procedimento que realiza a inserção dos SINISTROs no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InsereSINISTRO] as
BEGIN TRY		
 
	    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 
   	    

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SINISTRO_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[SINISTRO_TEMP];

CREATE TABLE [dbo].[SINISTRO_TEMP](
	[CODIGO] [int] NOT NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[DataArquivo] [date] NULL,
	[NomeArquivo] [varchar](100) NULL,
	[NumeroSinistro] [numeric](13, 0) NULL,
	[CodigoFonte] [smallint] NULL,
	[NumeroProtocolo] [int] NULL,
	[NumeroApolice] varchar(20) NULL,
	[NumeroItem] [int] NULL,
	[NumeroCertificado_VG_AP] [varchar](20) NULL,
	[NumeroBilhete] [varchar](20) NULL,
	[NumeroEndosso] [int] NULL,
	[CodigoRamo] [smallint] NULL,
	[CodigoNatureza] [smallint] NULL,
	[DataAviso] [date] NULL,
	[DataSinistro] [date] NULL,
	[Situacao] [smallint] NULL,
	[Causa] [varchar](40) NULL,
	[NumeroSinistroMAPFRE] [bigint] NULL,
	[NumeroContratoResidencial] [varchar](30) NULL,
	[NomeBeneficiario] [varchar](40) NULL,
	[CodigoFilial] [smallint] NULL,
	[NomeFilial] [varchar](40) NULL,
	[CPFCNPJ] [varchar](18) NULL,
	[Cidade] [varchar](40) NULL,
	[UF] [varchar](2) NULL,
	[CodigoNaturezaHabitacional] [tinyint] NULL,
	[NomeNaturezaHabitacional] [varchar](40) NULL,
	[PercentualParticipacao] [decimal](5,2) NULL
)  

 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_SINISTRO_TEMP ON [dbo].[SINISTRO_TEMP]
( 
  Codigo ASC
)         


SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'SINISTRO'


--select @PontoDeParada = 20007037


/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[SINISTRO_TEMP] 
                       ([CODIGO],                        
                        [ControleVersao],                
                        [DataArquivo],                   
                        [NomeArquivo],                   
                        [NumeroSinistro],                
                        [CodigoFonte],                   
                        [NumeroProtocolo],               
                        [NumeroApolice],                 
                        [NumeroItem],                    
                        [NumeroCertificado_VG_AP],       
                        [NumeroBilhete],                 
                        [NumeroEndosso],                 
                        [CodigoRamo],                    
                        [CodigoNatureza],                
                        [DataAviso],                     
                        [DataSinistro],                  
                        [Situacao],                      
                        [Causa],                         
                        [NumeroSinistroMAPFRE],          
                        [NumeroContratoResidencial],     
                        [NomeBeneficiario],              
                        [CodigoFilial],                  
                        [NomeFilial],                    
                        [CPFCNPJ],                       
                        [Cidade],                        
                        [UF],                            
                        [CodigoNaturezaHabitacional],    
                        [NomeNaturezaHabitacional],      
                        [PercentualParticipacao])
                SELECT  DISTINCT
                      	[CODIGO],                        
                        [ControleVersao],                
                        [DataArquivo],                   
                        [NomeArquivo],                   
                        [NumeroSinistro],                
                        [CodigoFonte],                   
                        [NumeroProtocolo],               
                        [NumeroApolice],                 
                        [NumeroItem],                    
                        [NumeroCertificado_VG_AP],       
                        [NumeroBilhete],                 
                        [NumeroEndosso],                 
                        [CodigoRamo],                    
                        [CodigoNatureza],                
                        [DataAviso],                     
                        [DataSinistro],                  
                        [Situacao],                      
                        [Causa],                         
                        [NumeroSinistroMAPFRE],          
                        [NumeroContratoResidencial],     
                        [NomeBeneficiario],              
                        [CodigoFilial],                  
                        [NomeFilial],                    
                        [CPFCNPJ],                       
                        [Cidade],                        
                        [UF],                            
                        [CodigoNaturezaHabitacional],    
                        [NomeNaturezaHabitacional],      
                        [PercentualParticipacao]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaSINISTRO] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)     

                
SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM [dbo].[SINISTRO_TEMP] PRP
                  
/*********************************************************************************************************************/

WHILE @MaiorCodigo IS NOT NULL
BEGIN 
--    PRINT @MaiorCodigo
 
   
      /***********************************************************************
      Carregar os RAMOS dos sinistros
      ***********************************************************************/
      ;MERGE INTO Dados.Ramo AS T
      USING (SELECT DISTINCT ST.CodigoRamo, '' [Nome]
             FROM [SINISTRO_TEMP] ST
             WHERE ST.CodigoRamo IS NOT NULL
            ) X
       ON T.[Codigo] = X.[CodigoRamo] 
      WHEN NOT MATCHED
            THEN INSERT (Codigo, Nome)
                 VALUES (X.[CodigoRamo], X.[Nome]);
     /***********************************************************************/   
                                                      
   
      /***********************************************************************
      Carregar NATUREZA HABITACIONAL dos sinistros
      ***********************************************************************/
      ;MERGE INTO Dados.NaturezaHabitacional AS T
      USING (SELECT DISTINCT  ST.CodigoNaturezaHabitacional, ST.NomeNaturezaHabitacional
             FROM [SINISTRO_TEMP] ST
             WHERE ST.CodigoNaturezaHabitacional IS NOT NULL
            ) X
       ON T.ID = X.CodigoNaturezaHabitacional 
      WHEN NOT MATCHED
            THEN INSERT (ID, Descricao)
                 VALUES (X.CodigoNaturezaHabitacional, X.NomeNaturezaHabitacional); 
     /***********************************************************************/


      /***********************************************************************
      Carregar FILIAL DE SINISTRO dos sinistros
      ***********************************************************************/
      ;MERGE INTO Dados.FilialSinistro AS T
      USING (SELECT DISTINCT  ST.CodigoFilial, ST.NomeFilial
             FROM [SINISTRO_TEMP] ST
             WHERE ST.CodigoFilial IS NOT NULL
            ) X
       ON T.Codigo = X.CodigoFilial 
      WHEN NOT MATCHED
            THEN INSERT (Codigo, Nome)
                 VALUES (X.CodigoFilial, X.NomeFilial); 
     /***********************************************************************/


      /***********************************************************************
      Carregar CAUSA DE SINISTRO dos sinistros
      ***********************************************************************/
      ;MERGE INTO Dados.SinistroCausa AS T
      USING (SELECT DISTINCT  ST.[Causa]
             FROM [SINISTRO_TEMP] ST
             WHERE ST.[Causa] IS NOT NULL
            ) X
       ON T.Descricao = X.[Causa] 
      WHEN NOT MATCHED
            THEN INSERT (Descricao)
                 VALUES (X.[Causa]); 
     /***********************************************************************/
             
    
     /***********************************************************************
     Carregar SITUACAO DE SINISTRO dos sinistros
     ***********************************************************************/
     ;MERGE INTO Dados.SituacaoSinistro AS T
     USING (SELECT DISTINCT  ST.Situacao [CodigoSituacao], '' [Situacao]
            FROM [SINISTRO_TEMP] ST
            WHERE ST.[Situacao] IS NOT NULL
           ) X
      ON T.ID = X.[CodigoSituacao] 
     WHEN NOT MATCHED
           THEN INSERT (ID, Descricao)
                VALUES (X.[CodigoSituacao], X.[Situacao]); 
    /***********************************************************************/ 
 
 
    /***********************************************************************/ 
    /*INSERE CONTRATOS NÃO LOCALIZADOS*/
    /***********************************************************************/ 
    ;MERGE INTO Dados.Contrato AS T
    USING	
    (
    SELECT DISTINCT
         1 [IDSeguradora] /*Caixa Seguros*/               
       , Cast(S.[NumeroApolice] as varchar(20)) [NumeroApolice]
	   , [NumeroBilhete]
       , MAX(S.[DataArquivo]) [DataArquivo]
       , MAX(S.NomeArquivo) [Arquivo]
    FROM [SINISTRO_TEMP] s
    WHERE S.NumeroApolice IS NOT NULL
    --AND NOT EXISTS (SELECT * FROM Dados.Contrato C WHERE c.NumeroContrato = s.numeroapolice)
    GROUP BY S.[NumeroApolice], [NumeroBilhete]
    ) X
    ON T.[NumeroContrato] = X.[NumeroApolice]
    AND T.[IDSeguradora] = X.[IDSeguradora]
    WHEN NOT MATCHED
          THEN INSERT ([NumeroContrato], [NumeroBilhete], [IDSeguradora], [Arquivo], [DataArquivo])
               VALUES (X.[NumeroApolice], [NumeroBilhete], X.[IDSeguradora], X.[Arquivo], X.[DataArquivo])   
	WHEN MATCHED
        THEN UPDATE  SET
		 [NumeroBilhete] = X.[NumeroBilhete];   
    /***********************************************************************/ 
 		        

    
    /****************************************************************************************************************/
    /*INSERE CERTIFICADOS NÃO LOCALIZADOS*/	
    /****************************************************************************************************************/
    ;MERGE INTO Dados.Certificado AS T
    USING (             
            SELECT DISTINCT
                   CNT.ID [IDContrato], S.NumeroCertificado_VG_AP [NumeroCertificadoTratado], 1 [IDSeguradora]
                 , 'CLIENTE DESCONHECIDO - CERTIFICADO NÃO RECEBIDO' [NomeCliente]
                 , MAX(S.[DataArquivo]) [DataArquivo], MAX(S.NomeArquivo) [Arquivo]
            FROM [SINISTRO_TEMP] S
                 INNER JOIN Dados.Contrato CNT
              ON CNT.NumeroContrato = CAst(S.NumeroApolice as varchar(20))
            WHERE S.NumeroCertificado_VG_AP IS NOT NULL   
            GROUP BY CNT.ID, S.NumeroCertificado_VG_AP
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
            , X.[Arquivo]); 
    /****************************************************************************************************************/       
 		  		      
 		          
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os sinistros recebidos no arquivo SINISTRO
    -----------------------------------------------------------------------------------------------------------------------		               
   	MERGE INTO Dados.Sinistro AS T
		USING (
		       SELECT *
		       FROM
		       (
			     SELECT 
             ST.[NomeArquivo] [Arquivo],
	           ST.[DataArquivo],
      	          
             ST.NumeroSinistro,
             ST.CodigoFonte,
             ST.NumeroProtocolo,
             ST.NumeroApolice,
             CNT.ID [IDContrato],
             ST.NumeroItem,
             ST.NumeroEndosso,
             C.ID [IDCertificado],
             R.ID [IDRamo],
             SC.ID [IDSinistroCausa],
             SS.ID [IDSituacaoSinistro],
             ST.[CodigoNatureza],
             ST.DataAviso,
             ST.DataSinistro,
             FS.ID [IDFilialSinistro],
             ST.NumeroSinistroMAPFRE,
             ST.NumeroContratoResidencial,
             ST.NomeBeneficiario,
             ST.CPFCNPJ [CPFCNPJBeneficiario],
             ST.Cidade [CidadeBeneficiario],
             ST.UF [UFBeneficiario],
             NH.ID [IDNaturezaHabitacional] ,
             ST.PercentualParticipacao,
             ROW_NUMBER() OVER(PARTITION BY ST.NumeroSinistro, ST.NumeroProtocolo, ST.[DataArquivo] ORDER BY ST.Codigo DESC)  [ORDER]
          FROM [SINISTRO_TEMP] ST
              LEFT JOIN Dados.FilialSinistro FS
              ON ST.CodigoFilial = FS.Codigo
              LEFT JOIN Dados.Ramo R
              ON R.Codigo = ST.CodigoRamo
              LEFT JOIN Dados.SinistroCausa SC
              ON SC.Descricao = ST.Causa
              LEFT JOIN Dados.SituacaoSinistro SS
              ON SS.ID = ST.Situacao
              LEFT JOIN Dados.NaturezaHabitacional NH
              ON NH.ID = ST.CodigoNaturezaHabitacional
              LEFT JOIN Dados.Contrato CNT
              ON CNT.NumeroContrato = ST.NumeroApolice
              LEFT JOIN Dados.Certificado C
              ON C.NumeroCertificado = ST.NumeroCertificado_VG_AP
           ) A
           WHERE A.[ORDER] = 1
			) AS O
		ON  T.NumeroSinistro = O.NumeroSinistro
    AND T.NumeroProtocolo = O.NumeroProtocolo
    AND T.DataArquivo = O.DataArquivo
		WHEN MATCHED
			THEN UPDATE 
				SET T.NumeroSinistro = COALESCE(O.NumeroSinistro, T.NumeroSinistro)
				   ,T.NumeroProtocolo = COALESCE(O.NumeroProtocolo, T.NumeroProtocolo)
				   ,T.IDContrato = COALESCE(O.IDContrato, T.IDContrato)
				   ,T.NumeroItem = COALESCE(O.NumeroItem, T.NumeroItem)
           ,T.IDCertificado = COALESCE(O.IDCertificado, T.IDCertificado)
					 ,T.NumeroEndosso = COALESCE(O.NumeroEndosso, T.NumeroEndosso)
					 
					 ,T.IDRamo = COALESCE(O.IDRamo, T.IDRamo)
					 ,T.DataAviso = COALESCE(O.DataAviso, T.DataAviso)
					 ,T.DataSinistro = COALESCE(O.DataSinistro, T.DataSinistro)
					 ,T.IDNaturezaSinistro = COALESCE(O.[CodigoNatureza], T.IDNaturezaSinistro)
					 ,T.IDSituacaoSinistro = COALESCE(O.IDSituacaoSinistro, T.IDSituacaoSinistro)
					 ,T.[IDSinistroCausa] = COALESCE(O.[IDSinistroCausa], T.[IDSinistroCausa])
					 ,T.NumeroSinistroMAPFRE = COALESCE(O.NumeroSinistroMAPFRE, T.NumeroSinistroMAPFRE)
           ,T.NumeroContratoResidencial = COALESCE(O.NumeroContratoResidencial, T.NumeroContratoResidencial)					 
					 ,T.NomeBeneficiario = COALESCE(O.NomeBeneficiario, T.NomeBeneficiario)					 
					 ,T.CPFCNPJBeneficiario = COALESCE(O.CPFCNPJBeneficiario, T.CPFCNPJBeneficiario)					 
           ,T.PercentualParticipacao = COALESCE(O.PercentualParticipacao, T.PercentualParticipacao)					 
					 ,T.CidadeBeneficiario = COALESCE(O.CidadeBeneficiario, T.CidadeBeneficiario)					 
					 ,T.IDFilialSinistro = COALESCE(O.IDFilialSinistro, T.IDFilialSinistro)
					 ,T.IDNaturezaHabitacional = COALESCE(O.IDNaturezaHabitacional, T.IDNaturezaHabitacional)
           ,T.CodigoFonte = COALESCE(O.CodigoFonte, T.CodigoFonte)
					 ,T.Arquivo = COALESCE(O.Arquivo, T.Arquivo)
		WHEN NOT MATCHED
			THEN INSERT (
			             NumeroSinistro,
			             NumeroProtocolo,
                   --NumeroApolice,
                   [IDContrato],
                   NumeroItem,
                   [IDCertificado],
                   NumeroEndosso,
                   [IDRamo],
                   DataAviso,
                   DataSinistro,
                   IDNaturezaSinistro,
                   [IDSituacaoSinistro],
                   [IDSinistroCausa],
                   NumeroSinistroMAPFRE,
                   NumeroContratoResidencial,
                   NomeBeneficiario,
                   [CPFCNPJBeneficiario],
                   [PercentualParticipacao],
                   [CidadeBeneficiario],
                   [UFBeneficiario],                   
                   [IDFilialSinistro],                   
                   [IDNaturezaHabitacional] ,
                   CodigoFonte, 
                   DataArquivo,                 
                   Arquivo)
				VALUES (O.NumeroSinistro, O.NumeroProtocolo, O.[IDContrato], O.NumeroItem, O.[IDCertificado], O.NumeroEndosso, O.[IDRamo]
			        , O.DataAviso, O.DataSinistro, O.[CodigoNatureza], O.[IDSituacaoSinistro], O.[IDSinistroCausa], O.NumeroSinistroMAPFRE
			        , O.NumeroContratoResidencial, O.NomeBeneficiario, O.[CPFCNPJBeneficiario], O.[PercentualParticipacao], O.[CidadeBeneficiario]
			        , O.[UFBeneficiario], O.[IDFilialSinistro], O.[IDNaturezaHabitacional], O.CodigoFonte, O.DataArquivo, O.Arquivo);
    -----------------------------------------------------------------------------------------------------------------------				
				
    
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'SINISTRO'
  /*************************************************************************************/
  
 /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[SINISTRO_TEMP] 
    
  /*********************************************************************************************************************/               
  /*Recupeara maior Código do retorno*/
  /*********************************************************************************************************************/

  SET @COMANDO = 'INSERT INTO [dbo].[SINISTRO_TEMP] 
                       ([CODIGO],                        
                        [ControleVersao],                
                        [DataArquivo],                   
                        [NomeArquivo],                   
                        [NumeroSinistro],                
                        [CodigoFonte],                   
                        [NumeroProtocolo],               
                        [NumeroApolice],                 
                        [NumeroItem],                    
                        [NumeroCertificado_VG_AP],       
                        [NumeroBilhete],                 
                        [NumeroEndosso],                 
                        [CodigoRamo],                    
                        [CodigoNatureza],                
                        [DataAviso],                     
                        [DataSinistro],                  
                        [Situacao],                      
                        [Causa],                         
                        [NumeroSinistroMAPFRE],          
                        [NumeroContratoResidencial],     
                        [NomeBeneficiario],              
                        [CodigoFilial],                  
                        [NomeFilial],                    
                        [CPFCNPJ],                       
                        [Cidade],                        
                        [UF],                            
                        [CodigoNaturezaHabitacional],    
                        [NomeNaturezaHabitacional],      
                        [PercentualParticipacao])
                SELECT  DISTINCT
                      	[CODIGO],                        
                        [ControleVersao],                
                        [DataArquivo],                   
                        [NomeArquivo],                   
                        [NumeroSinistro],                
                        [CodigoFonte],                   
                        [NumeroProtocolo],               
                        [NumeroApolice],                 
                        [NumeroItem],                    
                        [NumeroCertificado_VG_AP],       
                        [NumeroBilhete],                 
                        [NumeroEndosso],                 
                        [CodigoRamo],                    
                        [CodigoNatureza],                
                        [DataAviso],                     
                        [DataSinistro],                  
                        [Situacao],                      
                        [Causa],                         
                        [NumeroSinistroMAPFRE],          
                        [NumeroContratoResidencial],     
                        [NomeBeneficiario],              
                        [CodigoFilial],                  
                        [NomeFilial],                    
                        [CPFCNPJ],                       
                        [Cidade],                        
                        [UF],                            
                        [CodigoNaturezaHabitacional],    
                        [NomeNaturezaHabitacional],      
                        [PercentualParticipacao]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaSINISTRO] ''''' + @PontoDeParada + ''''''') PRP'

  EXEC (@COMANDO)         

                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM [dbo].[SINISTRO_TEMP] PRP
                    
  /*********************************************************************************************************************/
  
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SINISTRO_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[SINISTRO_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH
