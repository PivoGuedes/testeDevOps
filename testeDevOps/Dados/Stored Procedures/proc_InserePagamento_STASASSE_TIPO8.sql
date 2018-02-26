
/*
	Autor: Egler Vieira
	Data Criação: 20/11/2012

	Descrição: 
	
	Última alteração : 28/01/2013 - Egler
	                   15/05/2013 - Egler

*/

/*******************************************************************************
	Nome: CONCILIACAO.Dados.proc_InserePagamento_STASASSE_TIPO8
	Descrição: Procedimento que realiza a inserção dos lançamentos de parcelas (TIPO 8) de propostas no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InserePagamento_STASASSE_TIPO8] as 
BEGIN TRY	
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(4000) 


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STASASSE_TP8_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[STASASSE_TP8_TEMP];
	
CREATE TABLE [dbo].[STASASSE_TP8_TEMP](
	[Codigo] [bigint] NOT NULL,
	[NumeroProposta] [varchar](20) NULL,
	[IDSeguradora] [int] NOT NULL,
	[TipoMotivo] [smallint] NULL,
  [TipoMotivo_TP1] [smallint] NULL,
  [SituacaoProposta] [varchar](3) NULL,
	[NumeroParcela] [int] NULL,
	[Valor] [numeric](13, 2) NULL,
	[TipoDado] [varchar](26) NULL,
	[DataEfetivacao] [date] NULL,
	[NomeArquivo] [varchar](100) NULL,
	[DataArquivo] [date] NULL
) 

 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_STASASSE_TP8_TEMP ON STASASSE_TP8_TEMP
( 
  Codigo ASC
)         
WITH(FILLFACTOR=100)

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Pagamento_STASASSE_TIPO8'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[STASASSE_TP8_TEMP] (
                            [Codigo],                                                         
                            [NumeroProposta],                                                 
                            [IDSeguradora],                                                   
                            [TipoMotivo],                                                     
                            [TipoMotivo_TP1],                                                 
                            [SituacaoProposta],
                            [NumeroParcela],                                                  
                            [Valor],                                                        
                            [TipoDado],                                                       
                            [DataEfetivacao],                                                 
                            [NomeArquivo],                                                    
                            [DataArquivo] 
                         )
                SELECT [CodigoNaFonte],                                                         
                      [NumeroProposta],                                                 
                      [IDSeguradora],                                                   
                      [TipoMotivo],                                                     
                      [TipoMotivo_TP1],                                                 
                      [SituacaoProposta],
                      [NumeroParcela],                                                  
                      [Valor],                                                        
                      [TipoDado],                                                       
                      [DataEfetivacao],                                                 
                      [NomeArquivo],                                                    
                      [DataArquivo] 
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaPagamento_STASASSE_TIPO8] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)
 

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM STASASSE_TP8_TEMP PRP

                  
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
          FROM [STASASSE_TP8_TEMP] PGTO 
          WHERE PGTO.SituacaoProposta IS NOT NULL     
            ) X
      ON T.Sigla = X.[Sigla]
     WHEN NOT MATCHED
	          THEN INSERT (Sigla, [Descricao])
	               VALUES (X.[Sigla], X.SituacaoProposta);  
	                           	               
	               
     /*INSERE TIPO MOTIVO DE PROPOSTA DESCONHECIDOS*/
    MERGE INTO  Dados.TipoMotivo AS T
      USING (SELECT DISTINCT [TipoMotivo] Codigo, 'TIPO MOTIVO DESCONHECIDO' [TipoMotivo]
          FROM [STASASSE_TP8_TEMP] PGTO 
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
	      USING (SELECT DISTINCT PGTO.NumeroProposta, PGTO.[IDSeguradora], PGTO.[TipoDado], PGTO.DataArquivo
            FROM [dbo].[STASASSE_TP8_TEMP] PGTO
            WHERE PGTO.NumeroProposta IS NOT NULL
              ) X
        ON T.NumeroProposta = X.NumeroProposta
        AND T.IDSeguradora = X.IDSeguradora
       WHEN NOT MATCHED
		          THEN INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
		               VALUES (X.NumeroProposta, X.[IDSeguradora], -1, -1, -1, 0, -1, X.TipoDado, X.DataArquivo);
		-----------------------------------------------------------------------------------------------------------------------


    /*INSERE PROPOSTAS CLIENTE NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
    MERGE INTO Dados.PropostaCliente AS T
      USING (SELECT PRP.ID [IDProposta], 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' [NomeCliente], PGTO.[TipoDado], MAX(PGTO.[DataArquivo]) [DataArquivo]
          FROM [STASASSE_TP8_TEMP] PGTO
          INNER JOIN Dados.Proposta PRP
          ON PRP.NumeroProposta = PGTO.NumeroProposta
          AND PRP.IDSeguradora = 1
          WHERE PGTO.NumeroProposta IS NOT NULL
          GROUP BY PRP.ID, PGTO.[TipoDado] 
            ) X
      ON T.IDProposta = X.IDProposta
     WHEN NOT MATCHED
            THEN INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
                 VALUES (X.IDProposta, [TipoDado], X.[NomeCliente], X.[DataArquivo]);   
                 
   --select * from dados.Proposta where id = 63973493
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os pagamentos recebidos no arquivo STASASSE - TIPO - 8
    -----------------------------------------------------------------------------------------------------------------------		             

    MERGE INTO Dados.Pagamento AS T
		USING (
        SELECT DISTINCT
               PRP.ID [IDProposta], TM.ID [IDMotivo], TM1.ID [IDMotivoSituacao], STPRP.ID [IDSituacaoProposta], CASE WHEN PGTO.NumeroParcela > 32767 THEN 32767 ELSE PGTO.NumeroParcela END NumeroParcela
             , PGTO.Valor, NULL ValorIOF, PGTO.DataEfetivacao, PGTO.DataArquivo
             , PGTO.[Codigo], PGTO.TipoDado, 0 [EfetivacaoPgtoEstimadoPelaEmissao]
             , NULL [SinalLancamento], 0 [ExpectativaDeReceita], PGTO.NomeArquivo [Arquivo]
        FROM [dbo].[STASASSE_TP8_TEMP] PGTO
          INNER JOIN Dados.Proposta PRP
          ON PGTO.NumeroProposta = PRP.NumeroProposta
          AND PGTO.IDSeguradora = PRP.IDSeguradora
          /*LEFT OUTER JOIN Dados.SituacaoProposta STPRP
          ON PGTO.SituacaoProposta = STPRP.Sigla  */
          LEFT OUTER JOIN Dados.TipoMotivo TM
          ON PGTO.TipoMotivo = TM.Codigo
          LEFT OUTER JOIN Dados.SituacaoProposta STPRP
          ON PGTO.SituacaoProposta = STPRP.Sigla          
          LEFT OUTER JOIN Dados.TipoMotivo TM1
          ON PGTO.TipoMotivo_TP1 = TM1.Codigo
	   
        --WHERE [RANK] = 1
          ) AS X
    ON X.[IDProposta] = T.[IDProposta]   
   AND X.[IDMotivo] = T.[IDMotivo]
   AND X.[NumeroParcela] = T.[NumeroParcela]
	 AND X.[DataArquivo] = T.[DataArquivo]
	 AND X.[Valor] = T.[Valor]
    WHEN MATCHED
			    THEN UPDATE
				     SET [IDSituacaoProposta] = COALESCE(X.[IDSituacaoProposta],T.[IDSituacaoProposta])
				       , [IDMotivoSituacao] = COALESCE(X.[IDMotivoSituacao],T.[IDMotivoSituacao])
				       , [Valor] = COALESCE(X.[Valor], T.[Valor])
               , [ValorIOF] = COALESCE(X.[ValorIOF], T.[ValorIOF])
               , [DataEfetivacao] = COALESCE(X.[DataEfetivacao], T.[DataEfetivacao])
               --, [DataArquivo] = X.[DataArquivo]
               , [CodigoNaFonte] = COALESCE(X.[Codigo], T.[CodigoNaFonte])
               , [TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
               , [EfetivacaoPgtoEstimadoPelaEmissao] = COALESCE(X.[EfetivacaoPgtoEstimadoPelaEmissao], T.[EfetivacaoPgtoEstimadoPelaEmissao])
               , [SinalLancamento] = COALESCE(X.[SinalLancamento], T.[SinalLancamento])
               , [ExpectativaDeReceita] = COALESCE(X.[ExpectativaDeReceita], T.[ExpectativaDeReceita])
               , [Arquivo] = COALESCE(X.[Arquivo], T.[Arquivo])
    WHEN NOT MATCHED
			    THEN INSERT          
              ([IDProposta],  [IDMotivo], [IDMotivoSituacao], [IDSituacaoProposta], [NumeroParcela]
             , [DataArquivo], [Valor], [ValorIOF]
             , [DataEfetivacao], [CodigoNaFonte], [TipoDado]
             , [EfetivacaoPgtoEstimadoPelaEmissao], [SinalLancamento]
             , [ExpectativaDeReceita], [Arquivo])
          VALUES (X.[IDProposta]
                 ,X.[IDMotivo]
                 ,X.[IDMotivoSituacao]
                 ,X.[IDSituacaoProposta]
                 ,X.[NumeroParcela]
                 ,X.[DataArquivo]
                 ,X.[Valor]
                 ,X.[ValorIOF]
                 ,X.[DataEfetivacao]
                 ,X.[Codigo]
                 ,X.[TipoDado]
                 ,X.[EfetivacaoPgtoEstimadoPelaEmissao]
                 ,X.[SinalLancamento]
                 ,X.[ExpectativaDeReceita]
                 ,X.[Arquivo]               
                 ); 
           
  -----------------------------------------------------------------------------------------------------------------------		           
  
  /*TODO - Atualizar saldo pago - Proposta e EMISSAO*/
  
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Pagamento_STASASSE_TIPO8'
  /*************************************************************************************/
  
  
  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[STASASSE_TP8_TEMP] 
  
  /*********************************************************************************************************************/
  SET @COMANDO = 'INSERT INTO [dbo].[STASASSE_TP8_TEMP] (
                              [Codigo],                                                         
                              [NumeroProposta],                                                 
                              [IDSeguradora],                                                   
                              [TipoMotivo],                                                     
                              [TipoMotivo_TP1],                                                 
                              [SituacaoProposta],
                              [NumeroParcela],                                                  
                              [Valor],                                                        
                              [TipoDado],                                                       
                              [DataEfetivacao],                                                 
                              [NomeArquivo],                                                    
                              [DataArquivo] 
                           )
                  SELECT [CodigoNaFonte],                                                         
                        [NumeroProposta],                                                 
                        [IDSeguradora],                                                   
                        [TipoMotivo],                                                     
                        [TipoMotivo_TP1],                                                 
                        [SituacaoProposta],
                        [NumeroParcela],                                                  
                        [Valor],                                                        
                        [TipoDado],                                                       
                        [DataEfetivacao],                                                 
                        [NomeArquivo],                                                    
                        [DataArquivo] 
                  FROM OPENQUERY ([OBERON], 
                  ''EXEC [Fenae].[Corporativo].[proc_RecuperaPagamento_STASASSE_TIPO8] ''''' + @PontoDeParada + ''''''') PRP'

  EXEC (@COMANDO)
   
                
                
   SELECT @MaiorCodigo= MAX(PRP.Codigo)
   FROM dbo.STASASSE_TP8_TEMP PRP
  /*********************************************************************************************************************/

  /*********************************************************************************************************************/
  
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STASASSE_TP8_TEMP]') AND type in (N'U'))
	DROP TABLE [dbo].[STASASSE_TP8_TEMP];
	
END TRY                
BEGIN CATCH
  	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
 
END CATCH




