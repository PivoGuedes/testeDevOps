
/*
	Autor: Egler Vieira
	Data Criação: 16/05/2013

	Descrição: 
	
	Última alteração : 
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereProposta_STAFPREV_TIPO1_TIPO2
	Descrição: Procedimento que realiza a inserção dos lançamentos de parcelas (TIPO 8) de propostas no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InsereProposta_STAFPREV_TIPO1_TIPO2] as 
BEGIN TRY	
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(4000) 


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STAFPREV_TP1_TP2_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[STAFPREV_TP1_TP2_TEMP];
	
	
CREATE TABLE [dbo].[STAFPREV_TP1_TP2_TEMP](
	[Codigo] [bigint] NOT NULL,
	[Arquivo] [varchar](30) NULL,
	[TipoDado] [varchar](30) NOT NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[NomeCompletoArquivo] [varchar](100) NULL,
	[DataArquivo] [date] NULL,
	[NumeroCertificado] [numeric](11, 0) NULL,
	[NumeroProposta] [numeric](14, 0) NULL,
	[SituacaoProposta] [varchar](3) NULL,
	[TipoMotivo] [varchar](3) NULL,
	[DataInicioSituacao] [date] NULL,
	--[SituacaoCobranca] [varchar](3) NULL,
	[ValorReservaCotas] [numeric](17, 2) NULL,
	[ValorRendaEstimada] [numeric](17, 2) NULL,
	[ValorContribuicao] [numeric](17, 2) NULL,
	[IndicadorQuota] [varchar](10) NULL,
	[DataInicioVigencia] [date] NULL,
	[DataFimVigencia] [date] NULL,
	NumeroCertificadoTratado AS Cast(dbo.fn_TrataNumeroPropostaZeroExtra(NumeroCertificado) as VARCHAR(20)) PERSISTED,
	NumeroPropostaTratado AS Cast(dbo.fn_TrataNumeroPropostaZeroExtra(NumeroProposta) as VARCHAR(20)) PERSISTED
) 


 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_STAFPREV_TP1_TP2_TEMP ON STAFPREV_TP1_TP2_TEMP
( 
  Codigo ASC
)         


SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Proposta_STAFPREV_TIPO1_TIPO2'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[STAFPREV_TP1_TP2_TEMP] 
                        (
                        	[Codigo],                                                      
                          [Arquivo],                                                     
                          [TipoDado],                                                    
                          [ControleVersao],                                              
                          [NomeCompletoArquivo],                                         
                          [DataArquivo],                                                 
                          [NumeroCertificado],                                           
                          [NumeroProposta],                                              
                          [SituacaoProposta],                                            
                          [TipoMotivo],                                                  
                          [DataInicioSituacao],                                          
                          --[SituacaoCobranca],                                            
                          [ValorReservaCotas],                                           
                          [ValorRendaEstimada],                                          
                          [ValorContribuicao],                                           
                          [IndicadorQuota],                                              
                          [DataInicioVigencia],                                          
                          [DataFimVigencia]    
                         )
                SELECT 
                  	[Codigo],                                                      
                    [Arquivo],                                                     
                    [TipoDado],                                                    
                    [ControleVersao],                                              
                    [NomeCompletoArquivo],                                         
                    [DataArquivo],                                                 
                    [NumeroCertificado],                                           
                    [NumeroProposta],                                              
                    [SituacaoProposta],                                            
                    [TipoMotivo],                                                  
                    [DataInicioSituacao],                                          
                    --[SituacaoCobranca],                                            
                    [ValorReservaCotas],                                           
                    [ValorRendaEstimada],                                          
                    [ValorContribuicao],                                           
                    [IndicadorQuota],                                              
                    [DataInicioVigencia],                                          
                    [DataFimVigencia]     
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_STAFPREV_TIPO1_TIPO2] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)
 

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM STAFPREV_TP1_TP2_TEMP PRP

                  
/*********************************************************************************************************************/
                  
SET @COMANDO = ''    

WHILE @MaiorCodigo IS NOT NULL
BEGIN
--    PRINT @MaiorCodigo

    -----------------------------------------------------------------------------------------------------------------------
    --Comandos para carregas tabelas de domínio usadas no status
    -----------------------------------------------------------------------------------------------------------------------
     /*INSERE SITUAÇÕES DE PROPOSTA DESCONHECIDAS*/
    MERGE INTO  Dados.SituacaoProposta AS T
      USING (SELECT DISTINCT SituacaoProposta [Sigla], 'SITUAÇÃO DESCONHECIDA' SituacaoProposta
          FROM [STAFPREV_TP1_TP2_TEMP] PGTO 
          WHERE PGTO.SituacaoProposta IS NOT NULL     
            ) X
      ON T.Sigla = X.[Sigla]
     WHEN NOT MATCHED
	          THEN INSERT (Sigla, [Descricao])
	               VALUES (X.[Sigla], X.SituacaoProposta);  
	                           	               
	               
     /*INSERE TIPO MOTIVO DE PROPOSTA DESCONHECIDOS*/
    MERGE INTO  Dados.TipoMotivo AS T
      USING (SELECT DISTINCT [TipoMotivo] Codigo, 'TIPO MOTIVO DESCONHECIDO' [TipoMotivo]
          FROM [STAFPREV_TP1_TP2_TEMP] PGTO 
          WHERE PGTO.[TipoMotivo] IS NOT NULL     
            ) X
      ON T.Codigo = X.[Codigo]
     WHEN NOT MATCHED
	          THEN INSERT (Codigo, [Nome])
	               VALUES (X.Codigo, X.[TipoMotivo]);              	               	               
    -----------------------------------------------------------------------------------------------------------------------	               

	
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir propostas não recebidas nos arquivos PRPSASSE
    -----------------------------------------------------------------------------------------------------------------------

      MERGE INTO Dados.Proposta AS T
	      USING (SELECT PGTO.NumeroPropostaTratado, 4 [IDSeguradora], MAX(PGTO.[TipoDado]) [TipoDado], MAX(PGTO.DataArquivo) DataArquivo
            FROM [dbo].[STAFPREV_TP1_TP2_TEMP] PGTO
            WHERE PGTO.NumeroPropostaTratado IS NOT NULL
            GROUP BY PGTO.NumeroPropostaTratado
              ) X
        ON T.NumeroProposta= X.NumeroPropostaTratado
        AND T.IDSeguradora = X.IDSeguradora
       WHEN NOT MATCHED
		          THEN INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
		               VALUES (X.NumeroPropostaTratado, X.[IDSeguradora], -1, -1, -1, 0, -1, X.TipoDado, X.DataArquivo);		               

		-----------------------------------------------------------------------------------------------------------------------


    /*INSERE PROPOSTAS CLIENTE NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
    MERGE INTO Dados.PropostaCliente AS T
      USING (SELECT PRP.ID [IDProposta], 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' [NomeCliente], MAX(PGTO.[TipoDado]) [TipoDado], MAX(PGTO.[DataArquivo]) [DataArquivo]
          FROM [STAFPREV_TP1_TP2_TEMP] PGTO
          INNER JOIN Dados.Proposta PRP
          ON PRP.NumeroProposta = PGTO.NumeroPropostaTratado
          AND PRP.IDSeguradora = 4
          WHERE PGTO.NumeroPropostaTratado IS NOT NULL
          GROUP BY PRP.ID 
            ) X
      ON T.IDProposta = X.IDProposta
     WHEN NOT MATCHED
            THEN INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
                 VALUES (X.IDProposta, [TipoDado], X.[NomeCliente], X.[DataArquivo]);   
          
          

              
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os STATUS recebidos no arquivo STAFPREV - TIPO - 1 e TIPO - 2
    -----------------------------------------------------------------------------------------------------------------------		             
    WITH SRC
    AS
    (
    SELECT DISTINCT  
                     PRP.ID [IDProposta]
                   , ISNULL(PGTO.NumeroCertificadoTratado,'000000000000000') [NumeroCertificado]
                   , PGTO.NumeroPropostaTratado [NumeroProposta]  
                   , MIN(PGTO.DataInicioVigencia) DataInicioVigencia
                   , MAX(PGTO.DataFimVigencia) DataFimVigencia
                   , PGTO.ValorReservaCotas
                   , PGTO.ValorRendaEstimada 
                   , PGTO.ValorContribuicao
                   , PGTO.IndicadorQuota
                   , MIN(PGTO.DataInicioSituacao) DataInicioSituacao
                   --, STCOBR.ID [IDSituacaoCobranca]
                   , STPRP.ID [IDSituacaoProposta]
                   , TM.ID [IDMotivo]
                   , PGTO.TipoDado
                   , PGTO.DataArquivo
    FROM [dbo].[STAFPREV_TP1_TP2_TEMP] PGTO
      LEFT JOIN Dados.Proposta PRP
    ON   PRP.NumeroProposta = PGTO.NumeroPropostaTratado      
     AND PRP.IDSeguradora = 4
    LEFT OUTER JOIN Dados.TipoMotivo TM
    ON PGTO.[TipoMotivo] = TM.Codigo
    LEFT OUTER JOIN Dados.SituacaoProposta STPRP
    ON PGTO.SituacaoProposta = STPRP.Sigla    
    --LEFT OUTER JOIN Dados.SituacaoCobranca STCOBR
    --ON PGTO.SituacaoCobranca = STCOBR.Sigla  
    GROUP BY PRP.ID 
                   , PGTO.NumeroCertificadoTratado 
                   , PGTO.NumeroPropostaTratado 
                   --, PGTO.DataInicioVigencia
                   --, PGTO.DataFimVigencia
                   , PGTO.ValorReservaCotas
                   , PGTO.ValorRendaEstimada 
                   , PGTO.ValorContribuicao
                   , PGTO.IndicadorQuota
                   --, STCOBR.ID 
                   , STPRP.ID 
                   , TM.ID
                   , PGTO.TipoDado
                   , PGTO.DataArquivo
    )  
    
    /******************************************************************************************/               
    MERGE INTO Dados.PropostaPrevidenciaCertificado AS T
      USING (  
              SELECT [IDProposta]
                   , [NumeroCertificado]
                   , [NumeroProposta]  
                   , DataInicioVigencia
                   , DataFimVigencia
                   , ValorReservaCotas
                   , ValorRendaEstimada 
                   , ValorContribuicao
                   , IndicadorQuota
                   , DataInicioSituacao
                   --, [IDSituacaoCobranca]
                   , [IDSituacaoProposta]
                   , [IDMotivo]
                   , TipoDado
                   , DataArquivo
              FROM     
                   (SELECT *, ROW_NUMBER() OVER (PARTITION BY NumeroCertificado, [NumeroProposta], 
                       DataInicioVigencia, DataFimVigencia, [IDSituacaoProposta]
                          ORDER BY ValorReservaCotas DESC, ValorContribuicao DESC) [ORDEM]
                  FROM SRC ) SRC
              WHERE 1 = CASE WHEN SRC.IDSituacaoProposta = 5 and SRC.ORDEM = 1  THEN 1
                             WHEN SRC.IDSituacaoProposta = 5 and SRC.ORDEM <> 1 THEN 0
                             ELSE 1
                             END   
               AND SRC.[ORDEM] = 1
          ) AS X
    ON X.[IDProposta] = T.[IDProposta]   
   AND X.[NumeroCertificado] = T.[NumeroCertificado]
   AND ISNULL(X.IDSituacaoProposta, 255) = ISNULL(T.IDSituacaoProposta,255)
   AND 1 = CASE WHEN X.DataInicioSituacao IS NULL AND T.DataInicioSituacao IS NULL THEN 1
                WHEN X.DataInicioSituacao = T.DataInicioSituacao THEN 1
                ELSE 0
           END
   AND X.ValorReservaCotas = T.ValorReservaCotas
   AND X.ValorContribuicao = T.ValorContribuicao
   AND X.DataArquivo = T.DataArquivo
    WHEN MATCHED
			    THEN UPDATE
				     SET [DataInicioVigencia] = COALESCE(X.[DataInicioVigencia],T.[DataInicioVigencia])
				       , [DataFimVigencia] = COALESCE(X.[DataFimVigencia],T.[DataFimVigencia])
				       , [ValorReservaCotas] = COALESCE(X.[ValorReservaCotas], T.[ValorReservaCotas])
               , [ValorRendaEstimada] = COALESCE(X.[ValorRendaEstimada], T.[ValorRendaEstimada])
               , [ValorContribuicao] = COALESCE(X.[ValorContribuicao], T.[ValorContribuicao])
               , [IndicadorQuota] = COALESCE(X.[IndicadorQuota], T.[IndicadorQuota])

               --, [DataInicioSituacao] = X.[DataInicioSituacao]
               --, [IDSituacaoCobranca] = COALESCE(X.[IDSituacaoCobranca], T.[IDSituacaoCobranca])
               --, [IDSituacaoProposta] = COALESCE(X.[IDSituacaoProposta], T.[IDSituacaoProposta])
               , [IDMotivo] = COALESCE(X.[IDMotivo], T.[IDMotivo])
               , [TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])

    WHEN NOT MATCHED
			    THEN INSERT          
              (   [IDProposta]
                 ,[NumeroCertificado]
                 ,[DataInicioVigencia]
                 ,[DataFimVigencia]
                 ,[ValorReservaCotas]
                 ,[ValorRendaEstimada]
                 ,[ValorContribuicao]
                 ,[IndicadorQuota]
                 ,[DataInicioSituacao]
	               --,[IDSituacaoCobranca]   
	               ,[IDSituacaoProposta] 
                 ,[IDMotivo]
                 ,[TipoDado]
                 ,[DataArquivo] )
          VALUES (X.[IDProposta]
                 ,X.[NumeroCertificado]
                 ,X.[DataInicioVigencia]
                 ,X.[DataFimVigencia]
                 ,X.[ValorReservaCotas]
                 ,X.[ValorRendaEstimada]
                 ,X.[ValorContribuicao]
                 ,X.[IndicadorQuota]
                 ,X.[DataInicioSituacao]
	               --,X.[IDSituacaoCobranca]   
	               ,X.[IDSituacaoProposta] 
                 ,X.[IDMotivo]
                 ,X.[TipoDado]
                 ,X.[DataArquivo]             
                 ); 
          
  -----------------------------------------------------------------------------------------------------------------------	
  /*************************************************************************************/
  /*Atualização da Data Iniciom Fim de Vigência, ID da Situação da Proposta e ID Motivo da tabela Dados.Proposta*/
  /* Luan Moreno Medeiros Maciel - 16-10-2013*/
  /*************************************************************************************/

MERGE INTO Dados.Proposta AS [target]
USING
(
	SELECT *
	FROM
	(
	SELECT  ROW_NUMBER() OVER(PARTITION BY PPC.IDProposta ORDER BY PPC.DataArquivo DESC) AS RowNumberID,
			PPC.IDProposta,
			PPC.DataInicioVigencia,
			PPC.DataFimVigencia,
			PPC.IDSituacaoProposta,
			PPC.IDMotivo,
			P.DataArquivo
	FROM Dados.Proposta AS P
	INNER JOIN Dados.PropostaPrevidenciaCertificado AS PPC
	ON P.ID = PPC.IDProposta
	) AS T
	WHERE RowNumberID = 1

) AS [source]
ON [target].ID = [source].IDProposta 
WHEN MATCHED AND [target].DataArquivo >= [source].DataArquivo
	THEN UPDATE
		SET [DataInicioVigencia] = COALESCE([source].[DataInicioVigencia],[target].[DataInicioVigencia]),
			[DataFimVigencia] = COALESCE([source].[DataFimVigencia],[target].[DataFimVigencia]),
			[IDSituacaoProposta] = COALESCE([source].[IDSituacaoProposta],[target].[IDSituacaoProposta]),
			[DataArquivo] = COALESCE([source].[DataArquivo],[target].[DataArquivo]),
			[IDTipoMotivo] = COALESCE([source].[IDMotivo],[target].[IDTipoMotivo]);
  	           

			   /***************************************************************************************************************************/

/*Apaga a marcação LastValue das propostas recebidas para atualizar a última posição -> logo depois da inserção das Situações (abaixo)*/
    UPDATE Dados.PropostaSituacao SET LastValue = 0
   -- SELECT *
    FROM Dados.PropostaSituacao PS
    WHERE PS.IDProposta IN (SELECT PRP.ID
                            FROM Dados.Proposta PRP                      
                            INNER JOIN  [dbo].[STAFPREV_TP1_TP2_TEMP] PGTO
                                   ON PGTO.NumeroPropostaTratado = PRP.NumeroProposta
                                  AND PRP.IDSeguradora  = 4
								 
                                  --AND PS.DataInicioSituacao < PGTO.DataArquivo
                            --WHERE PRP.ID = PS.IDProposta
                            )
      AND PS.LastValue = 1	            

    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os Status recebidos no arquivo STASASSE - TIPO - 1
    -----------------------------------------------------------------------------------------------------------------------		             
    MERGE INTO Dados.PropostaSituacao AS T
		USING (
        SELECT 
               PRP.ID [IDProposta], TM.ID [IDMotivo], STPRP.ID [IDSituacaoProposta]
             , PGTO.DataArquivo [DataInicioSituacao], MAX(PGTO.DataArquivo) DataArquivo
             , 'Situacao - Tipo - 1' TipoDado --, PGTO.[Codigo]
        FROM [dbo].[STAFPREV_TP1_TP2_TEMP] PGTO
          INNER JOIN Dados.Proposta PRP
          ON PGTO.NumeroPropostaTratado = PRP.NumeroProposta
          AND PRP.IDSeguradora = 4
          /*LEFT OUTER JOIN Dados.SituacaoProposta STPRP
          ON PGTO.SituacaoProposta = STPRP.Sigla  */
          INNER JOIN Dados.TipoMotivo TM
          ON PGTO.TipoMotivo = TM.Codigo
          INNER JOIN Dados.SituacaoProposta STPRP
          ON PGTO.SituacaoProposta = STPRP.Sigla          
--WHERE PRP.ID =         9027754 /*TODO - FAZER UM PIVOT E ALIMENTAR MAIS UMA COLUNA DE MOTIVO QUANDO FOR NO MESMO DIA*/
        GROUP BY PRP.ID, TM.ID, STPRP.ID
               , PGTO.DataArquivo	   
          ) AS X
    ON X.[IDProposta] = T.[IDProposta]   
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
                 ); 
                 	   --SELECT * FROM dbo.PRPFPREV_TEMP PGTO

    /*Atualiza a marcação LastValue das propostas recebidas buscando o último Status*/
    UPDATE Dados.PropostaSituacao SET LastValue = 1
   -- SELECT *
	FROM Dados.PropostaSituacao	PS
	INNER JOIN 
			(SELECT  PS1.ID, ROW_NUMBER() OVER (PARTITION BY PS1.IDProposta ORDER BY  COALESCE(PRP.DataSituacao, PGTO.DataArquivo) DESC, PS1.ID DESC) ORDEM
                 FROM Dados.PropostaSituacao PS1
				 INNER JOIN Dados.Proposta PRP
				 ON PS1.IDProposta = PRP.ID                      
				 INNER JOIN dbo.[STAFPREV_TP1_TP2_TEMP] PGTO
				 ON PGTO.NumeroPropostaTratado = PRP.NumeroProposta
                 AND PRP.IDSeguradora = 4
				 -- where numeropropostatratado='069999035279871'
             ) A  
	 ON A.ID = PS.ID 
	 AND A.ORDEM = 1	         
						
						/***************************************************************************************************************************/

  
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Proposta_STAFPREV_TIPO1_TIPO2'
  /*************************************************************************************/
  
  
  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[STAFPREV_TP1_TP2_TEMP] 
  
  /*********************************************************************************************************************/

  SET @COMANDO = 'INSERT INTO [dbo].[STAFPREV_TP1_TP2_TEMP] 
                        (
                            	[Codigo],                                                      
	                            [Arquivo],                                                     
	                            [TipoDado],                                                    
	                            [ControleVersao],                                              
	                            [NomeCompletoArquivo],                                         
	                            [DataArquivo],                                                 
	                            [NumeroCertificado],                                           
	                            [NumeroProposta],                                              
	                            [SituacaoProposta],                                            
	                            [TipoMotivo],                                                  
	                            [DataInicioSituacao],                                          
	                            --[SituacaoCobranca],                                            
	                            [ValorReservaCotas],                                           
	                            [ValorRendaEstimada],                                          
	                            [ValorContribuicao],                                           
	                            [IndicadorQuota],                                              
	                            [DataInicioVigencia],                                          
	                            [DataFimVigencia]    
                         )
                SELECT 
                  	[Codigo],                                                      
                    [Arquivo],                                                     
                    [TipoDado],                                                    
                    [ControleVersao],                                              
                    [NomeCompletoArquivo],                                         
                    [DataArquivo],                                                 
                    [NumeroCertificado],                                           
                    [NumeroProposta],                                              
                    [SituacaoProposta],                                            
                    [TipoMotivo],                                                  
                    [DataInicioSituacao],                                          
                    --[SituacaoCobranca],                                            
                    [ValorReservaCotas],                                           
                    [ValorRendaEstimada],                                          
                    [ValorContribuicao],                                           
                    [IndicadorQuota],                                              
                    [DataInicioVigencia],                                          
                    [DataFimVigencia]     
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_STAFPREV_TIPO1_TIPO2] ''''' + @PontoDeParada + ''''''') PRP'

  EXEC (@COMANDO)

   
                
                
   SELECT @MaiorCodigo= MAX(PRP.Codigo)
   FROM dbo.STAFPREV_TP1_TP2_TEMP PRP
  /*********************************************************************************************************************/

  /*********************************************************************************************************************/
  
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STAFPREV_TP1_TP2_TEMP]') AND type in (N'U'))
	DROP TABLE [dbo].[STAFPREV_TP1_TP2_TEMP];
	
END TRY                
BEGIN CATCH
  	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
 
END CATCH




