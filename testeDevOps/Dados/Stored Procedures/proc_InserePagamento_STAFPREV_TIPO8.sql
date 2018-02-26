
/*
	Autor: Egler Vieira
	Data Criação: 16/05/2013

	Descrição: 
	
	Última alteração : 
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InserePagamento_STAFPREV_TIPO8
	Descrição: Procedimento que realiza a inserção dos lançamentos de parcelas (TIPO 8) de propostas no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InserePagamento_STAFPREV_TIPO8] as 
BEGIN TRY	
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(4000) 


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STAFPREV_TP8_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[STAFPREV_TP8_TEMP];
	
	
CREATE TABLE [dbo].[STAFPREV_TP8_TEMP](
	[Codigo] [int] NOT NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[NomeArquivo] [nvarchar](100) NULL,
	[DataArquivo] [date] NULL,
	[NumeroProposta] [numeric](14, 0) NULL,
	[NumeroPropostaTratado] AS Cast(dbo.fn_TrataNumeroPropostaZeroExtra(NumeroProposta) as VARCHAR(20)) PERSISTED,
	[NumeroParcela] [int] NULL,
	[TipoLancamento] [smallint] NULL,
	[ValorNominalRenda] [numeric](13, 2) NULL,
	[ValorEstoqueRenda] [numeric](13, 2) NULL,
	[ValorNominalRisco] [numeric](13, 2) NULL,
	[ValorEstoqueRisco] [numeric](13, 2) NULL,
	[SituacaoProposta] [varchar](3) NULL,
	[TipoMotivo] [varchar](3) NULL,
	[DataInicioSituacao] [date] NULL,
	[TipoDado] varchar(30) NULL
) 


 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_STAFPREV_TP8_TEMP ON STAFPREV_TP8_TEMP
( 
  Codigo ASC
)         


SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Pagamento_STAFPREV_TIPO8'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[STAFPREV_TP8_TEMP] (
                            	[Codigo],              
	                            [ControleVersao],      
	                            [NomeArquivo],         
	                            [DataArquivo],         
	                            [NumeroProposta],      
	                            [NumeroParcela],       
	                            [TipoLancamento],      
	                            [ValorNominalRenda],   
	                            [ValorEstoqueRenda],   
	                            [ValorNominalRisco],   
	                            [ValorEstoqueRisco],   
	                            [SituacaoProposta],    
	                            [TipoMotivo],          
	                            [DataInicioSituacao],
	                            [TipoDado]   
                         )
                SELECT 
                  	[Codigo],              
	                  [ControleVersao],      
	                  [NomeArquivo],         
	                  [DataArquivo],         
	                  [NumeroProposta],      
	                  [NumeroParcela],       
	                  [TipoLancamento],      
	                  [ValorNominalRenda],   
	                  [ValorEstoqueRenda],   
	                  [ValorNominalRisco],   
	                  [ValorEstoqueRisco],   
	                  [SituacaoProposta],    
	                  [TipoMotivo],          
	                  [DataInicioSituacao],
	                  [TipoDado]   
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaPagamento_STAFPREV_TIPO8] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)
 

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM STAFPREV_TP8_TEMP PRP

                  
/*********************************************************************************************************************/
                  
SET @COMANDO = ''    

WHILE @MaiorCodigo IS NOT NULL
BEGIN
--    PRINT @MaiorCodigo
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir propostas não recebidas nos arquivos PRPSASSE
    -----------------------------------------------------------------------------------------------------------------------

      MERGE INTO Dados.Proposta AS T
	      USING (SELECT PGTO.NumeroPropostaTratado, 4 [IDSeguradora], MAX(PGTO.[TipoDado]) [TipoDado], MAX(PGTO.DataArquivo) DataArquivo
            FROM [dbo].[STAFPREV_TP8_TEMP] PGTO
            WHERE PGTO.NumeroPropostaTratado IS NOT NULL
            GROUP BY PGTO.NumeroPropostaTratado
              ) X
        ON T.NumeroProposta= X.NumeroPropostaTratado
        AND T.IDSeguradora = X.IDSeguradora
       WHEN NOT MATCHED
		          THEN INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
		               VALUES (X.NumeroPropostaTratado, X.[IDSeguradora], -1, -1, 0, -1, 0, -1, X.TipoDado, X.DataArquivo);
		-----------------------------------------------------------------------------------------------------------------------

	/*INSERE TIPO MOTIVO DE PROPOSTA DESCONHECIDOS*/
    MERGE INTO  Dados.TipoMotivo AS T
      USING ( SELECT DISTINCT [TipoMotivo] Codigo, 'TIPO MOTIVO DESCONHECIDO' [TipoMotivo]
			  FROM [STAFPREV_TP8_TEMP] PGTO 
			  WHERE PGTO.[TipoMotivo] IS NOT NULL     
            ) X
      ON T.Codigo = X.[Codigo]
     WHEN NOT MATCHED
	          THEN INSERT (Codigo, [Nome])
	               VALUES (X.Codigo, X.[TipoMotivo]);    

	/*INSERE TIPO MOTIVO DE PROPOSTA DESCONHECIDOS*/
    MERGE INTO  Dados.TipoMotivo AS T
      USING ( SELECT DISTINCT [TipoLancamento] Codigo, 'TIPO MOTIVO DESCONHECIDO' [TipoMotivo]
			  FROM [STAFPREV_TP8_TEMP] PGTO 
			  WHERE PGTO.[TipoLancamento] IS NOT NULL     
            ) X
      ON T.Codigo = X.[Codigo]
     WHEN NOT MATCHED
	          THEN INSERT (Codigo, [Nome])
	               VALUES (X.Codigo, X.[TipoMotivo]); 

	    -----------------------------------------------------------------------------------------------------------------------
    --Comandos para carregas tabelas de domínio usadas no status
    -----------------------------------------------------------------------------------------------------------------------
     /*INSERE SITUAÇÕES DE PROPOSTA DESCONHECIDAS*/
    MERGE INTO  Dados.SituacaoProposta AS T
      USING (SELECT DISTINCT SituacaoProposta [Sigla], 'SITUAÇÃO DESCONHECIDA' SituacaoProposta
          FROM [STAFPREV_TP8_TEMP] PGTO 
          WHERE PGTO.SituacaoProposta IS NOT NULL     
            ) X
      ON T.Sigla = X.[Sigla]
     WHEN NOT MATCHED
	          THEN INSERT (Sigla, [Descricao])
	               VALUES (X.[Sigla], X.SituacaoProposta);  

    /*INSERE PROPOSTAS CLIENTE NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
    MERGE INTO Dados.PropostaCliente AS T
      USING (SELECT PRP.ID [IDProposta], 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' [NomeCliente], MAX(PGTO.[TipoDado]) [TipoDado], MAX(PGTO.[DataArquivo]) [DataArquivo]
          FROM [STAFPREV_TP8_TEMP] PGTO
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
    --Comando para inserir os pagamentos recebidos no arquivo STAFPREV - TIPO - 8
    -----------------------------------------------------------------------------------------------------------------------		             
    MERGE INTO Dados.PrevidenciaExtrato AS T
		USING (
        SELECT 
               PRP.ID [IDProposta], isnull(TM.ID,-1) [IDMotivo], TM1.ID [IDMotivoSituacao], STPRP.ID [IDSituacaoProposta], PGTO.NumeroParcela
             , PGTO.[ValorNominalRenda], PGTO.[ValorEstoqueRenda], PGTO.[ValorNominalRisco], PGTO.[ValorEstoqueRisco]
             , MAX(PGTO.[Codigo]) [Codigo], MAX(PGTO.TipoDado) TipoDado, PGTO.[DataInicioSituacao], /*0 [EfetivacaoPgtoEstimadoPelaEmissao]*/
             /*, NULL [SinalLancamento], 0 [ExpectativaDeReceita],*/  MAX(PGTO.[NomeArquivo]) [Arquivo], MAX(PGTO.DataArquivo) DataArquivo
        FROM [dbo].[STAFPREV_TP8_TEMP] PGTO
          INNER JOIN Dados.Proposta PRP
          ON PGTO.NumeroPropostaTratado = PRP.NumeroProposta
          AND /*PGTO.IDSeguradora*/ 4 = PRP.IDSeguradora
          /*LEFT OUTER JOIN Dados.SituacaoProposta STPRP
          ON PGTO.SituacaoProposta = STPRP.Sigla  */
          LEFT OUTER JOIN Dados.TipoMotivo TM
          ON PGTO.[TipoLancamento] = TM.Codigo
          LEFT OUTER JOIN Dados.SituacaoProposta STPRP
          ON PGTO.SituacaoProposta = STPRP.Sigla          
          LEFT OUTER JOIN Dados.TipoMotivo TM1
          ON CASE WHEN ISNUMERIC(PGTO.TipoMotivo) = 0 THEN NULL
             ELSE PGTO.TipoMotivo END = TM1.Codigo
	      GROUP BY 
	             PRP.ID,  TM.ID,  TM1.ID, STPRP.ID, PGTO.NumeroParcela
             , PGTO.[ValorNominalRenda], PGTO.[ValorEstoqueRenda], PGTO.[ValorNominalRisco], PGTO.[ValorEstoqueRisco]
             , PGTO.[DataInicioSituacao] /*0 [EfetivacaoPgtoEstimadoPelaEmissao]*/
             /*, NULL [SinalLancamento], 0 [ExpectativaDeReceita],*/ 
        --WHERE [RANK] = 1
          ) AS X
    ON X.[IDProposta] = T.[IDProposta]   
   AND X.[IDMotivo] = T.[IDMotivo]
   AND X.[NumeroParcela] = T.[NumeroParcela]
	 AND X.[DataArquivo] = T.[DataArquivo]
	 AND X.[ValorNominalRisco] = T.[ValorNominalRisco]
	 AND X.[ValorEstoqueRisco] = T.[ValorEstoqueRisco]
	 AND X.[ValorNominalRenda] = T.[ValorNominalRenda]
	 AND X.[ValorEstoqueRenda] = T.[ValorEstoqueRenda]	 
    WHEN MATCHED
			    THEN UPDATE
				     SET [IDSituacaoProposta] = COALESCE(X.[IDSituacaoProposta],T.[IDSituacaoProposta])
				       , [IDMotivoSituacao] = COALESCE(X.[IDMotivoSituacao],T.[IDMotivoSituacao])
				       , [ValorNominalRenda] = COALESCE(X.[ValorNominalRenda], T.[ValorNominalRenda])
               , [ValorEstoqueRenda] = COALESCE(X.[ValorEstoqueRenda], T.[ValorEstoqueRenda])
               --, [ValorNominalRisco] = COALESCE(X.[ValorNominalRisco], T.[ValorNominalRisco])
               --, [ValorEstoqueRisco] = COALESCE(X.[ValorEstoqueRisco], T.[ValorEstoqueRisco])

               , [DataInicioSituacao] = X.[DataInicioSituacao]
               , [CodigoNaFonte] = COALESCE(X.[Codigo], T.[CodigoNaFonte])
               , [TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
               --, [EfetivacaoPgtoEstimadoPelaEmissao] = COALESCE(X.[EfetivacaoPgtoEstimadoPelaEmissao], T.[EfetivacaoPgtoEstimadoPelaEmissao])
               --, [SinalLancamento] = COALESCE(X.[SinalLancamento], T.[SinalLancamento])
               --, [ExpectativaDeReceita] = COALESCE(X.[ExpectativaDeReceita], T.[ExpectativaDeReceita])
               , [Arquivo] = COALESCE(X.[Arquivo], T.[Arquivo])
    WHEN NOT MATCHED
			    THEN INSERT          
              ([IDProposta],  [IDMotivo], [IDMotivoSituacao], [IDSituacaoProposta], [DataInicioSituacao]
             , [NumeroParcela], [DataArquivo], [ValorNominalRenda], [ValorEstoqueRenda], [ValorNominalRisco], [ValorEstoqueRisco] 
             , [CodigoNaFonte], [TipoDado]
             /*, [EfetivacaoPgtoEstimadoPelaEmissao], [SinalLancamento]
             , [ExpectativaDeReceita]*/, [Arquivo])
          VALUES (X.[IDProposta]
                 ,X.[IDMotivo]
                 ,X.[IDMotivoSituacao]
                 ,X.[IDSituacaoProposta]
                 ,X.[DataInicioSituacao]
                 ,X.[NumeroParcela]
                 ,X.[DataArquivo]
                 ,X.[ValorNominalRenda]
                 ,X.[ValorEstoqueRenda]
	               ,X.[ValorNominalRisco]   
	               ,X.[ValorEstoqueRisco] 
                 ,X.[Codigo]
                 ,X.[TipoDado]
                 --,X.[EfetivacaoPgtoEstimadoPelaEmissao]
                 --,X.[SinalLancamento]
                 --,X.[ExpectativaDeReceita]
                 ,X.[Arquivo]               
                 ); 
          
  -----------------------------------------------------------------------------------------------------------------------		           
  
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Pagamento_STAFPREV_TIPO8'
  /*************************************************************************************/
  
  
  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[STAFPREV_TP8_TEMP] 
  
  /*********************************************************************************************************************/

  SET @COMANDO = 'INSERT INTO [dbo].[STAFPREV_TP8_TEMP] (
                            	  [Codigo],              
	                              [ControleVersao],      
	                              [NomeArquivo],         
	                              [DataArquivo],         
	                              [NumeroProposta],      
	                              [NumeroParcela],       
	                              [TipoLancamento],      
	                              [ValorNominalRenda],   
	                              [ValorEstoqueRenda],   
	                              [ValorNominalRisco],   
	                              [ValorEstoqueRisco],   
	                              [SituacaoProposta],    
	                              [TipoMotivo],          
	                              [DataInicioSituacao],
	                              [TipoDado]   
                           )
                  SELECT 
                  	  [Codigo],              
	                    [ControleVersao],      
	                    [NomeArquivo],         
	                    [DataArquivo],         
	                    [NumeroProposta],      
	                    [NumeroParcela],       
	                    [TipoLancamento],      
	                    [ValorNominalRenda],   
	                    [ValorEstoqueRenda],   
	                    [ValorNominalRisco],   
	                    [ValorEstoqueRisco],   
	                    [SituacaoProposta],    
	                    [TipoMotivo],          
	                    [DataInicioSituacao],
	                    [TipoDado]   
                  FROM OPENQUERY ([OBERON], 
                  ''EXEC [Fenae].[Corporativo].[proc_RecuperaPagamento_STAFPREV_TIPO8] ''''' + @PontoDeParada + ''''''') PRP'

  EXEC (@COMANDO)
   
                
                
   SELECT @MaiorCodigo= MAX(PRP.Codigo)
   FROM dbo.STAFPREV_TP8_TEMP PRP
  /*********************************************************************************************************************/

  /*********************************************************************************************************************/
  
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STAFPREV_TP8_TEMP]') AND type in (N'U'))
	DROP TABLE [dbo].[STAFPREV_TP8_TEMP];
	
END TRY                
BEGIN CATCH
  	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
 
END CATCH




