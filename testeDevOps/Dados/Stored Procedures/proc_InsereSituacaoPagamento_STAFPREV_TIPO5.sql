
create PROCEDURE [Dados].[proc_InsereSituacaoPagamento_STAFPREV_TIPO5] 
AS

BEGIN TRY		
	    
DECLARE @PontoDeParada AS VARCHAR(400) 
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SituacaoPagamento_STAFPREV_TIPO5_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[SituacaoPagamento_STAFPREV_TIPO5_TEMP];

CREATE TABLE [dbo].[SituacaoPagamento_STAFPREV_TIPO5_TEMP]
(
	[Codigo] [bigint] NOT NULL,
	[NumeroProposta] [varchar](20) NOT NULL,
	[SituacaoCobranca] [char](3) NULL,
	[DataInicioSituacao] [date] NULL,	
	[NomeArquivo] [varchar](100) NULL,
	[TipoDado] [varchar](20) NULL,
	[DataArquivo] [date] NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	IDProposta int,
	IDSituacaoCobranca tinyint
)


 /*Cria Índices*/  
CREATE CLUSTERED INDEX idx_SituacaoPagamento_STAFPREV_TEMP ON [dbo].[SituacaoPagamento_STAFPREV_TIPO5_TEMP] (Codigo ASC)  

CREATE NONCLUSTERED INDEX IDX_NumeroProposta_STAFPREV_TEMP  ON [dbo].[SituacaoPagamento_STAFPREV_TIPO5_TEMP] ([NumeroProposta],[SituacaoCobranca],[DataInicioSituacao], [DataArquivo] DESC, Codigo DESC)

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'SituacaoPagamento_STAFPREV_Tipo5'


/*********************************************************************************************************************/               
/*Recupera maior Código do retorno*/
/*********************************************************************************************************************/
--DECLARE @PontoDeParada AS VARCHAR(400) 
--set @PontoDeParada = 0
---DECLARE @MaiorCodigo AS BIGINT
--DECLARE @ParmDefinition NVARCHAR(500)
--DECLARE @COMANDO AS NVARCHAR(max)

SET @COMANDO = 'INSERT INTO [dbo].[SituacaoPagamento_STAFPREV_TIPO5_TEMP] 
				(      
					[Codigo]
					,[NumeroProposta]
					,[SituacaoCobranca]
					,[DataInicioSituacao]
					,[NomeArquivo]
					,[TipoDado]
					,[DataArquivo]
					,[ControleVersao]
				)  
                SELECT [Codigo]
						,[NumeroProposta]
						,[SituacaoCobranca]
						,[DataInicioSituacao]
						,[NomeArquivo]
						,[TipoDado]
						,[DataArquivo]
						,[ControleVersao]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaSituacaoPagamento_STAFPREV_TIPO5] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)     

SELECT @MaiorCodigo = MAX(PRP.Codigo)
FROM [dbo].[SituacaoPagamento_STAFPREV_TIPO5_TEMP] PRP

SET @COMANDO = ''     

WHILE @MaiorCodigo IS NOT NULL
BEGIN 

 /***********************************************************************
       Carregar as SITUAÇÕES de cobrança desconhecidas
 ***********************************************************************/

 ;MERGE INTO [Dados].[SituacaoCobranca] AS T
	  USING (
			   SELECT DISTINCT PRP.SituacaoCobranca [Sigla], '' [Descricao]
               FROM dbo.[SituacaoPagamento_STAFPREV_TIPO5_TEMP] PRP
               WHERE PRP.SituacaoCobranca IS NOT NULL
              ) X
         ON T.[Sigla] = X.[Sigla] 
       WHEN NOT MATCHED
		          THEN INSERT (Sigla, Descricao)
		               VALUES (X.[Sigla], X.[Descricao]);

--==================================

/*Comando de Inserção de Propostas não Recebidas nos Arquivos SituacaoPagamento_STASASSE_TIPO4*/

--===================================

MERGE INTO Dados.Proposta AS T
USING 
(
	SELECT distinct PGTO.NumeroProposta, 
		   4 [IDSeguradora], -- Aruumar PGTO.[IDSeguradora]
		   MIN(PGTO.NomeArquivo) [TipoDado], 
		   MIN(PGTO.DataArquivo) DataArquivo
    FROM [dbo].[SituacaoPagamento_STAFPREV_TIPO5_TEMP] PGTO
    WHERE PGTO.NumeroProposta IS NOT NULL
    GROUP BY PGTO.NumeroProposta--, PGTO.[IDSeguradora]
    ) X
ON    T.NumeroProposta = X.NumeroProposta
	AND T.IDSeguradora = X.IDSeguradora
WHEN NOT MATCHED THEN 
			 INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
               VALUES (X.[NumeroProposta], X.[IDSeguradora], -1, -1, 0, -1, 0, -1, X.TipoDado, X.DataArquivo);               



 UPDATE	 [SituacaoPagamento_STAFPREV_TIPO5_TEMP]  
 SET IDProposta = PRP.IDProposta, IDSituacaoCobranca = SC.IDSituacaoCobranca
 FROM [SituacaoPagamento_STAFPREV_TIPO5_TEMP] TEMP
 OUTER APPLY (SELECT ID IDProposta 
			  FROM Dados.Proposta PRP
			  WHERE TEMP.[NumeroProposta] = PRP.NumeroProposta
			    AND PRP.IDSeguradora = 4
		      )	 PRP
 OUTER APPLY (SELECT ID IDSituacaoCobranca 
			  FROM Dados.SituacaoCobranca SC
			  WHERE  SC.Sigla = TEMP.[SituacaoCobranca]
		      )	SC
							  
							                
--=============================
                                            
/*Comando de Inserção de Proposta de Clientes não Localizados - Por Número de Proposta*/

--=======================

MERGE INTO Dados.PropostaCliente AS T
USING 
(
	SELECT PGTO.[IDProposta], 
		   'Cliente Desconhecido - Proposta Não Recebida' AS [NomeCliente], 
		   MIN(PGTO.NomeArquivo) [TipoDado], 
		   MAX(PGTO.[DataArquivo]) [DataArquivo]
	FROM [dbo].[SituacaoPagamento_STAFPREV_TIPO5_TEMP] PGTO
	WHERE PGTO.NumeroProposta IS NOT NULL
	GROUP BY PGTO.[IDProposta]
) X
ON T.IDProposta = X.IDProposta
WHEN NOT MATCHED THEN 
	INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
    VALUES (X.IDProposta, [TipoDado], X.[NomeCliente], X.[DataArquivo]);   
          
		  
---------------------------------
-- Desmarcar o LastValue


 UPDATE Dados.[PropostaSituacaoPagamento] SET LastValue = 0
   -- SELECT *
    FROM Dados.[PropostaSituacaoPagamento] PS
    WHERE PS.IDProposta IN (
	                        SELECT t.IDProposta
                            FROM  [dbo].[SituacaoPagamento_STAFPREV_TIPO5_TEMP] t
								
                           )
           AND PS.LastValue = 1    


-----------------------------------------------------------------------------------------------------------------------

 /*Inserções de Dados - Proposta Situação Pagamento*/

 -----------------------------------------------------------------------------------------------------------------------

;MERGE INTO [Dados].[PropostaSituacaoPagamento] AS T
	USING 
		( SELECT * 
					FROM (

							SELECT DISTINCT [Codigo]
								  ,temp.IDProposta
								  ,temp.[NumeroProposta]
								  ,TEMP.IDSituacaoCobranca
								  ,[SituacaoCobranca]
								  ,[DataInicioSituacao]
								  ,[NomeArquivo]
								  ,temp.[TipoDado]
								  ,temp.[DataArquivo]
								  ,null as ParcelasPagas
								--  ,[ControleVersao]
								  ,ROW_NUMBER() OVER (PARTITION BY temp.[NumeroProposta],[SituacaoCobranca],[DataInicioSituacao] ORDER BY temp.[DataArquivo] DESC, Codigo DESC) [ORDER]   

							  FROM [dbo].[SituacaoPagamento_STAFPREV_TIPO5_TEMP] TEMP

							  ) A

					WHERE A.[ORDER]=1

		) X

		ON             T.IDProposta = X.IDProposta
			and ISNULL(T.IDSituacaoCobranca,0) = ISNULL(x.IDSituacaoCobranca,0)
			and ISNULL(T.[DataInicioSituacao],'0001-01-01') = ISNULL(X.[DataInicioSituacao],'0001-01-01')
			and ISNULL(T.[ParcelasPagas],-1) = ISNULL(X.ParcelasPagas,-1)
			and	T.NumeroTitulo IS NULL

	WHEN MATCHED THEN 
		UPDATE
			 SET
				--TotalDeParcelas = COALESCE(X.TotalDeParcelas, T.TotalDeParcelas), 
				NomeArquivo = COALESCE(X.NomeArquivo, T.NomeArquivo),
				DataArquivo = COALESCE(X.DataArquivo, T.DataArquivo),
				[CodigoNaFonte] = X.[Codigo]

	WHEN NOT MATCHED THEN 
	INSERT ([IDProposta],[IDSituacaoCobranca],[DataInicioSituacao]/*,[ParcelasPagas],[TotalDeParcelas]*/,[NomeArquivo],[DataArquivo],[CodigoNaFonte] )

	values (X.IDProposta,x.IDSituacaoCobranca,X.[DataInicioSituacao]/*,X.ParcelasPagas,X.TotalDeParcelas*/, x.[NomeArquivo],X.[DataArquivo],X.[Codigo]);

--==================================================	  
	/*Atualiza a marcação LastValue das propostas situação pagamento recebidas para atualizar a última posição*/
	/*Diego Lima - Data: 15/04/2014 */	
--=========================
		 
    UPDATE Dados.PropostaSituacaoPagamento SET LastValue = 1
	--select *
    FROM Dados.PropostaSituacaoPagamento PE
	INNER JOIN (
				SELECT ID,  ROW_NUMBER() OVER (PARTITION BY PS.IDProposta ORDER BY ps.DataArquivo DESC,PS.CodigoNaFonte DESC) [ORDEM]
				FROM Dados.PropostaSituacaoPagamento PS
				WHERE PS.IDProposta IN (
										SELECT t.IDProposta
										FROM [dbo].SituacaoPagamento_STAFPREV_TIPO5_TEMP t
											
									   )
					) A
	 ON A.ID = PE.ID 
	 AND A.ORDEM = 1 --and IDProposta = 2825704  
		                   
/*****************************************************************************************/
/*Atualização do Ponto de Parada, igualando-o ao Maior Código Trabalhado no comando acima*/
/*****************************************************************************************/
SET @PontoDeParada = @MaiorCodigo
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @MaiorCodigo
WHERE NomeEntidade = 'SituacaoPagamento_STAFPREV_Tipo5'

TRUNCATE TABLE [dbo].SituacaoPagamento_STAFPREV_TIPO5_TEMP

    
/*Recuperação do Maior Código do Retorno*/
SET @COMANDO = 'INSERT INTO [dbo].[SituacaoPagamento_STAFPREV_TIPO5_TEMP] 
				(      
					[Codigo]
					,[NumeroProposta]
					,[SituacaoCobranca]
					,[DataInicioSituacao]
					,[NomeArquivo]
					,[TipoDado]
					,[DataArquivo]
					,[ControleVersao]
				)  
                SELECT [Codigo]
						,[NumeroProposta]
						,[SituacaoCobranca]
						,[DataInicioSituacao]
						,[NomeArquivo]
						,[TipoDado]
						,[DataArquivo]
						,[ControleVersao]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaSituacaoPagamento_STAFPREV_TIPO5] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)  
--print '-----antes------'
--print @maiorcodigo

SELECT @MaiorCodigo = MAX(PRP.Codigo)
FROM [dbo].[SituacaoPagamento_STAFPREV_TIPO5_TEMP] PRP

--print '-----depois------'
--print @maiorcodigo                      
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SituacaoPagamento_STAFPREV_TIPO5_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[SituacaoPagamento_STAFPREV_TIPO5_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH