
/*
	Autor: Egler Vieira
	Data Criação: 02/05/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereProposta_PRESTAMISTA_TIPO6
	Descrição: Procedimento que realiza a inserção de propostas no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereProposta_PRESTAMISTA_TIPO6] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRESTAMISTA_TIPO6_TMP]') AND type in (N'U') /*ORDER BY NAME*/)
BEGIN
	DROP TABLE [dbo].[PRESTAMISTA_TIPO6_TMP];
	/*
		RAISERROR   (N'A tabela temporária [PRESTAMISTA_TIPO6_TMP] foi encontrada. Verifique se há um processo paralelo executando a função.',
    16, -- Severity.
    1 -- State.
    );
    */
END

CREATE TABLE [dbo].[PRESTAMISTA_TIPO6_TMP](

	[Codigo] [bigint] NOT NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[NomeArquivo] [varchar](100) NOT NULL,
	[DataArquivo] [date] NOT NULL,
	[NumeroProposta] [varchar](20) NULL,
	[NumeroPropostaTratado]    as Cast(dbo.fn_TrataNumeroPropostaZeroExtra(NumeroProposta) as   varchar(20)) PERSISTED,
	[OperacaoCredito] [varchar](30) NULL,
	[ContratoVinculado] [varchar](18) NULL,
	[Complemento] [varchar](30) NULL
);                        


 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_PRESTAMISTA_TIPO6_TMP_Codigo ON [dbo].[PRESTAMISTA_TIPO6_TMP]
( 
  Codigo ASC
)   

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Proposta_PRESTAMISTA_TIPO6'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
                
    SET @COMANDO =
    '  INSERT INTO dbo.PRESTAMISTA_TIPO6_TMP
        ( [Codigo],                                                     
	          [ControleVersao],                                             
	          [NomeArquivo],                                                
	          [DataArquivo],                                                
	          [NumeroProposta],
	          [OperacaoCredito],
	          [ContratoVinculado],
	          [Complemento] )
     SELECT [Codigo],                                                     
	          [ControleVersao],                                             
	          [NomeArquivo],                                                
	          [DataArquivo],                                                
	          [NumeroProposta],
	          [OperacaoCredito],
	          [ContratoVinculado],
	          [Complemento] 
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_PRESTAMISTA_TIPO6] ''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.PRESTAMISTA_TIPO6_TMP PRP                    

/*********************************************************************************************************************/
                  
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN
--print @MaiorCodigo

  
  /*INSERE TIPOS DE OPERAÇÕES DE CRÉDITO*/
  ;MERGE INTO Dados.OperacaoCredito AS T
  USING	
  (
  SELECT DISTINCT
        RTP6.[OperacaoCredito]
  FROM [dbo].[PRESTAMISTA_TIPO6_TMP] RTP6
  WHERE RTP6.[OperacaoCredito] IS NOT NULL
  ) X
  ON T.[Descricao] = X.[OperacaoCredito]
  WHEN NOT MATCHED
          THEN INSERT ([Descricao])
               VALUES (X.[OperacaoCredito]);  
               
      
   
  /*INSERE PROPOSTAS NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
  ;MERGE INTO Dados.Proposta AS T
    USING (SELECT DISTINCT RTP6.[NumeroPropostaTratado], 1 [IDSeguradora], RTP6.[NomeArquivo], RTP6.[DataArquivo]
        FROM [dbo].[PRESTAMISTA_TIPO6_TMP] RTP6
        WHERE RTP6.NumeroPropostaTratado IS NOT NULL
          ) X
    ON T.NumeroProposta = X.NumeroPropostaTratado
   AND T.IDSeguradora = X.IDSeguradora
   WHEN NOT MATCHED
          THEN INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
               VALUES (X.[NumeroPropostaTratado], X.[IDSeguradora], -1, -1, -1, 0, -1, 'PRP-PRESTAMISTA', X.DataArquivo);               
               
               
  /*INSERE PROPOSTAS CLIENTE NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
  ;MERGE INTO Dados.PropostaCliente AS T
    USING (SELECT PRP.ID [IDProposta], 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' [NomeCliente], 'PRPSASSE-TP6' [TipoDado], MAX(RTP6.[DataArquivo]) [DataArquivo]
        FROM [PRESTAMISTA_TIPO6_TMP] RTP6
        INNER JOIN Dados.Proposta PRP
        ON PRP.NumeroProposta = RTP6.NumeroProposta
        AND PRP.IDSeguradora = 1
        WHERE RTP6.NumeroProposta IS NOT NULL
        GROUP BY PRP.ID 
          ) X
    ON T.IDProposta = X.IDProposta
   WHEN NOT MATCHED
          THEN INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
               VALUES (X.IDProposta, [TipoDado], X.[NomeCliente], X.[DataArquivo])               
		               
  /*************************************************************************************/
  /*Chama a PROC que roda a importação registro a registro dos detalhes do RESIDENTIAL TP6 (PRPSASSE)*/
  /*************************************************************************************/ 
    ;MERGE INTO Dados.PropostaFinanceiro AS T
		USING (       
            SELECT *
            FROM
            (
            SELECT 
              RTP6.[Codigo],                                                     
              RTP6.[ControleVersao],                                             
              RTP6.[NomeArquivo] [Arquivo],                                                
              RTP6.[DataArquivo],                           
              PRP.ID [IDProposta],                     
              RTP6.[NumeroPropostaTratado] [NumeroProposta],                                             
              RTP6.[ContratoVinculado] [NumeroContratoVinculado],   
              RTP6.Complemento,                                            
              OC.ID [IDOperacaoCredito],
              
              ROW_NUMBER() OVER(PARTITION BY PRP.ID, [ContratoVinculado], RTP6.[DataArquivo] ORDER BY RTP6.[Codigo] DESC)  [ORDER]
            FROM [dbo].[PRESTAMISTA_TIPO6_TMP]  RTP6
              LEFT JOIN Dados.Proposta PRP
              ON PRP.NumeroProposta = RTP6.NumeroPropostaTratado
              LEFT JOIN Dados.OperacaoCredito OC
              ON OC.Descricao = RTP6.OperacaoCredito
            ) A
            WHERE A.[ORDER] = 1
            /*LEFT JOIN Dados.Contrato CNT
            ON CNT.NumeroContrato = RTP5.[NumeroApoliceAnterior]              */
          ) AS X
    ON  X.[IDProposta] = T.[IDProposta]
    AND X.[NumeroContratoVinculado] = T.[NumeroContratoVinculado]
    AND X.[DataArquivo] = T.[DataArquivo]
    WHEN MATCHED
			    THEN UPDATE
				     SET
				         [Complemento] = COALESCE(X.[Complemento], T.[Complemento])

    WHEN NOT MATCHED  
			    THEN INSERT          
              (   [IDProposta]                      
                , [IDOperacaoCredito]  
                , [NumeroContratoVinculado]
                , [Complemento]     
                
                --, [NumeroProdutoAVGestao]
                , [DataArquivo]
                , [Arquivo])
          VALUES (   
                  X.[IDProposta]                  
          
                , X.[IDOperacaoCredito]  
                , X.[NumeroContratoVinculado]
                , X.[Complemento]
                    
                --, X.[NumeroProdutoAVGestao]
                , X.[DataArquivo]
                , X.[Arquivo]
                ); 
  /*************************************************************************************/ 


  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Proposta_PRESTAMISTA_TIPO6'
  /*************************************************************************************/
  
    
                  
  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[PRESTAMISTA_TIPO6_TMP]        
  /*********************************************************************************************************************/
                
     SET @COMANDO =
    '  INSERT INTO dbo.PRESTAMISTA_TIPO6_TMP
        ( [Codigo],                                                     
	          [ControleVersao],                                             
	          [NomeArquivo],                                                
	          [DataArquivo],                                                
	          [NumeroProposta],
	          [OperacaoCredito],
	          [ContratoVinculado],
	          [Complemento] )
     SELECT [Codigo],                                                     
	          [ControleVersao],                                             
	          [NomeArquivo],                                                
	          [DataArquivo],                                                
	          [NumeroProposta],
	          [OperacaoCredito],
	          [ContratoVinculado],
	          [Complemento] 
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_PRESTAMISTA_TIPO6] ''''' + @PontoDeParada + ''''''') PRP
         '
         
  exec (@COMANDO)  

                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM dbo.PRESTAMISTA_TIPO6_TMP PRP    

  
                    
  /*********************************************************************************************************************/

                    
  /*********************************************************************************************************************/
  
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRESTAMISTA_TIPO6_TMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PRESTAMISTA_TIPO6_TMP];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH                                      

--EXEC [Dados].[proc_InsereProposta_PRESTAMISTA_TIPO6] 

