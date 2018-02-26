
CREATE PROCEDURE [Dados].[proc_InserePagamento_STAFCAP_Tipo2] 
AS 

BEGIN TRY	
--BEGIN TRANSACTION

DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(4000) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STAFCAP_TP2_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[STAFCAP_TP2_TEMP];
	
CREATE TABLE [dbo].[STAFCAP_TP2_TEMP](
		[Codigo] [bigint] NOT NULL,
		[NumeroProposta] [varchar](20) NOT NULL,
		[NumeroOrdemTitular] [smallint] NULL,
		[SerieTitulo] [char](2) NULL,
		[NumeroTitulo] [char](7) NULL,
		[DigitoNumeroTitulo] [char](1) NULL,
		[SituacaoTitulo] [char](3) NULL,
		[DataInicioSituacaoTitulo] [date] NULL,
		[DataPostagemTitulo] [date] NULL,
		[DataInicioVigencia] [date] NULL,
		[DataInicioSorteio] [date] NULL,
		[NumeroCombinacao] [int] NULL,
		[ValorTitulo] [numeric](17,2) NULL,
		[CodigoPlanoSUSEP] [int] NULL,
		[MotivoSituacaoTitulo] [int] NULL,
		[DataArquivo] [date] NULL,
		[NomeArquivo] [varchar](130) NULL,
		[IDSeguradora] smallint DEFAULT(3)
)

 /*Criação de Índices*/  
CREATE CLUSTERED INDEX idx_STASASSE_TP2_TEMP ON STAFCAP_TP2_TEMP 
(
	Codigo ASC
)         

CREATE NONCLUSTERED INDEX idxNCL_STASASSE_TP2_TEMP ON STAFCAP_TP2_TEMP
( 
  NumeroProposta ASC,
  IDSeguradora,
  [DataInicioSituacaoTitulo]
)      

CREATE NONCLUSTERED INDEX idxNCL_STASASSE_TP2_SituacaoTitulo_TEMP ON STAFCAP_TP2_TEMP
( 
  [SituacaoTitulo]
)     

CREATE NONCLUSTERED INDEX idxNCL_STASASSE_TP2_MotivoSituacaoTitulo_TEMP ON STAFCAP_TP2_TEMP
( 
  [MotivoSituacaoTitulo]
)     

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Pagamento_STAFCAP_TIPO2'

--	SELECT @PontoDeParada = 100

--DECLARE @PontoDeParada AS VARCHAR(400)
--set @PontoDeParada = 0
--DECLARE @MaiorCodigo AS BIGINT
--DECLARE @COMANDO AS NVARCHAR(4000) 
SET @COMANDO = 'INSERT INTO [dbo].[STAFCAP_TP2_TEMP] 
					(	
						[Codigo]
						  ,[NumeroProposta]
						  ,[NumeroOrdemTitular]
						  ,[SerieTitulo]
						  ,[NumeroTitulo]
						  ,[DigitoNumeroTitulo]
						  ,[SituacaoTitulo]
						  ,[DataInicioSituacaoTitulo]
						  ,[DataPostagemTitulo]
						  ,[DataInicioVigencia]
						  ,[DataInicioSorteio]
						  ,[NumeroCombinacao]
						  ,[ValorTitulo]
						  ,[CodigoPlanoSUSEP]
						  ,[MotivoSituacaoTitulo]
						  ,[NomeArquivo]
						  ,[DataArquivo]
                         )
                SELECT [Codigo]
						  ,[NumeroProposta]
						  ,[NumeroOrdemTitular]
						  ,[SerieTitulo]
						  ,[NumeroTitulo]
						  ,[DigitoNumeroTitulo]
						  ,[SituacaoTitulo]
						  ,[DataInicioSituacaoTitulo]
						  ,[DataPostagemTitulo]
						  ,[DataInicioVigencia]
						  ,[DataInicioSorteio]
						  ,[NumeroCombinacao]
						  ,[ValorTitulo]
						  ,[CodigoPlanoSUSEP]
						  ,[MotivoSituacaoTitulo]
						  ,[NomeArquivo]
						  ,[DataArquivo]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaPagamento_STAFCAP_TIPO2] ''''' + @PontoDeParada + ''''''') PRP
                '

EXEC (@COMANDO)
 
SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM STAFCAP_TP2_TEMP PRP

                  
SET @COMANDO = ''    

WHILE @MaiorCodigo IS NOT NULL
BEGIN

--    PRINT @MaiorCodigo


/*Inserção das Situações de Propostas Desconhecidas*/
MERGE INTO Dados.SituacaoProposta AS T
USING 
(
	SELECT DISTINCT [SituacaoTitulo] [Sigla], 
		   'Situação Desconhecida' AS SituacaoProposta
    FROM [STAFCAP_TP2_TEMP] PGTO 
    WHERE PGTO.[SituacaoTitulo] IS NOT NULL     
) X
ON T.Sigla = X.[Sigla]
WHEN NOT MATCHED THEN 
	INSERT (Sigla, [Descricao])
	VALUES (X.[Sigla], X.SituacaoProposta);  


/*Inserção dos Tipos de Motivos de Proposta Desconhecidos*/
MERGE INTO Dados.TipoMotivo AS T
USING 
(
	SELECT DISTINCT [MotivoSituacaoTitulo] AS Codigo, 
		   'Tipo Motivo Desconhecido' AS [TipoMotivo]
    FROM [STAFCAP_TP2_TEMP] PGTO 
    WHERE PGTO.[MotivoSituacaoTitulo] IS NOT NULL     
) X
ON T.Codigo = X.[Codigo]
WHEN NOT MATCHED THEN 
	INSERT (Codigo, [Nome])
	VALUES (X.Codigo, X.[TipoMotivo]);           


/*Comando de Inserção de Propostas não Recebidas nos Arquivos PRPFCAP*/
MERGE INTO Dados.Proposta AS T
USING 
(
	SELECT distinct PGTO.NumeroProposta, 
		    PGTO.[IDSeguradora],
		   MIN(PGTO.NomeArquivo) [TipoDado], 
		   MIN(PGTO.DataArquivo) DataArquivo
    FROM [dbo].[STAFCAP_TP2_TEMP] PGTO
    WHERE PGTO.NumeroProposta IS NOT NULL
    GROUP BY PGTO.NumeroProposta, PGTO.[IDSeguradora]
    ) X
ON T.NumeroProposta = X.NumeroProposta
	AND T.IDSeguradora = X.IDSeguradora
WHEN NOT MATCHED THEN 
			INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
    VALUES (X.[NumeroProposta], X.[IDSeguradora], -1, -1, 0, -1, 0, -1, X.TipoDado, X.DataArquivo);	

                                            
/*Comando de Inserção de Proposta de Clientes não Localizados - Por Número de Proposta*/
MERGE INTO Dados.PropostaCliente AS T
USING 
(
	SELECT PRP.ID AS [IDProposta], 
		   'Cliente Desconhecido - Proposta Não Recebida' AS [NomeCliente], 
		   MIN(PGTO.NomeArquivo) [TipoDado], 
		   MAX(PGTO.[DataArquivo]) [DataArquivo]
	FROM [STAFCAP_TP2_TEMP] PGTO
	INNER JOIN Dados.Proposta PRP
	ON PRP.NumeroProposta = PGTO.NumeroProposta
		AND PRP.IDSeguradora = PGTO.IDSeguradora
	WHERE PGTO.NumeroProposta IS NOT NULL
	GROUP BY PRP.ID
) X
ON T.IDProposta = X.IDProposta
WHEN NOT MATCHED THEN 
	INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
    VALUES (X.IDProposta, [TipoDado], X.[NomeCliente], X.[DataArquivo]);   
              

--------------------------------------------
/*Atualização dos Títulos de Capitalização*/
--------------------------------------------
MERGE INTO Dados.PropostaCapitalizacaoTitulo AS T
  USING 
	(SELECT * FROM (
				SELECT PRP.ID AS IDProposta,
					   [NumeroOrdemTitular],
					   [NumeroTitulo], --Não,
					   [SerieTitulo], --Não,
					   [DigitoNumeroTitulo],
					   [SituacaoTitulo],
					   SP.ID AS IDSituacaoTitulo,
					   [DataInicioSituacaoTitulo],
					   [DataPostagemTitulo],
					   P.[DataInicioVigencia],
					   [DataInicioSorteio],
					   [NumeroCombinacao],
					   [ValorTitulo],
					   [CodigoPlanoSUSEP],
					   [MotivoSituacaoTitulo],
					   tm.id as IDMotivoSituacaoTitulo,
						ROW_NUMBER() OVER(PARTITION BY p.NumeroTitulo, p.SerieTitulo, p.DigitoNumeroTitulo/*, p.DataInicioVigencia, p.SituacaoTitulo, p.[DataInicioSituacaoTitulo]*/ ORDER BY p.DataArquivo DESC, p.Codigo DESC) AS ID,
						p.DataArquivo,
						p.NomeArquivo AS [TipoArquivo]
				FROM [dbo].[STAFCAP_TP2_TEMP] P
				INNER JOIN Dados.Proposta PRP
				ON P.NumeroProposta = PRP.NumeroProposta
					AND  PRP.IDSeguradora = P.IDSeguradora
					
				INNER JOIN [Dados].[SituacaoProposta] SP
				ON SP.SIGLA = P.SITUACAOTITULO
				
				INNER JOIN [Dados].[TipoMotivo] TM
				ON TM.Codigo = p.MotivoSituacaoTitulo
				) a
	WHERE A.ID= 1
	) AS X
	ON 	
	    T.NumeroTitulo = X.NumeroTitulo
	and T.SerieTitulo = X.SerieTitulo
	and T.DigitoNumeroTitulo = x.DigitoNumeroTitulo
	---and T.IDProposta = X.IDProposta
	---and T.DataInicioVigencia = X.DataInicioVigencia
	---and T.[DataInicioSituacaoTitulo] = X.[DataInicioSituacaoTitulo]
	---and t.IDSituacaoTitulo = x.IDSituacaoTitulo

	--and t.[NumeroCombinacao] = x.[NumeroCombinacao]

	----SELECT COUNT(*),  NumeroTitulo	, SerieTitulo, DigitoNumeroTitulo
	----FROM Dados.PropostaCapitalizacaoTitulo PCT
	----GROUP BY   NumeroTitulo	, SerieTitulo, DigitoNumeroTitulo
	----HAVING COUNT(*) > 1

	----select *
	----from Dados.PropostaCapitalizacaoTitulo PCT
	----where numerotitulo= '0306670'
	----and serietitulo = '01'
	----and digitonumerotitulo = '8'

	WHEN MATCHED THEN 
		UPDATE
			SET [NumeroOrdemTitular] = COALESCE(X.[NumeroOrdemTitular],T.[NumeroOrdemTitular]),
				--[IDSituacaoTitulo] = COALESCE(X.[IDSituacaoTitulo],T.[IDSituacaoTitulo]),
				--[DataInicioSituacaoTitulo] = COALESCE(X.[DataInicioSituacaoTitulo],T.[DataInicioSituacaoTitulo]),
				[DataPostagemTitulo] = COALESCE(X.[DataPostagemTitulo],T.[DataPostagemTitulo]),
				[DataInicioVigencia] = COALESCE(X.[DataInicioVigencia],T.[DataInicioVigencia]),
				[DataInicioSorteio] = COALESCE(X.[DataInicioSorteio],T.[DataInicioSorteio]),
				[NumeroCombinacao] = COALESCE(X.[NumeroCombinacao],T.[NumeroCombinacao]),
				[ValorTitulo] = COALESCE(X.[ValorTitulo],T.[ValorTitulo]),
				[CodigoPlanoSUSEP] = COALESCE(X.[CodigoPlanoSUSEP],T.[CodigoPlanoSUSEP]),
				--[IDMotivoSituacaoTitulo] = COALESCE(X.[IDMotivoSituacaoTitulo],T.[IDMotivoSituacaoTitulo]),
				[TipoArquivo] = COALESCE(X.[TipoArquivo], T.[TipoArquivo]),
				[DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo])
            
	WHEN NOT MATCHED THEN 
		INSERT (idproposta,[NumeroOrdemTitular],[NumeroTitulo],[SerieTitulo],[DigitoNumeroTitulo],IDSituacaoTitulo,[DataInicioSituacaoTitulo],
				[DataPostagemTitulo],[DataInicioVigencia],[DataInicioSorteio],[NumeroCombinacao],[ValorTitulo],
				[CodigoPlanoSUSEP],[IDMotivoSituacaoTitulo],DataArquivo, TipoArquivo)
		VALUES ( X.IDProposta, x.[NumeroOrdemTitular],x.[NumeroTitulo],x.[SerieTitulo],x.[DigitoNumeroTitulo],x.IDSituacaoTitulo,x.[DataInicioSituacaoTitulo],
				x.[DataPostagemTitulo],x.[DataInicioVigencia],x.[DataInicioSorteio],x.[NumeroCombinacao],x.[ValorTitulo],
				x.[CodigoPlanoSUSEP],x.[IDMotivoSituacaoTitulo],X.[DataArquivo] ,X.[TipoArquivo]); 


	
     /***********************************************************************

/*Apaga a marcação LastValue do CapitalizacaoTituloSituacao recebidos para atualizar a última posição
-> logo depois da inserção de funcionarios*/

/*Diego Lima - Data: 25/02/2014 */

     ***********************************************************************/	  

UPDATE [Dados].[PropostaCapitalizacaoTituloSituacao] 
SET LastValue = 0
    --SELECT *
    FROM [Dados].[PropostaCapitalizacaoTituloSituacao]  pcts --(readuncommitted)
    WHERE pcts.[IDPropostaCapitalizacaoTitulo] IN (
													SELECT DISTINCT pct.ID
														FROM [dbo].[STAFCAP_TP2_TEMP] T --(readuncommitted)
												
															INNER JOIN [Dados].[PropostaCapitalizacaoTitulo] pct --(readuncommitted)
																ON    T.NumeroTitulo = pct.NumeroTitulo
																		and T.SerieTitulo = pct.SerieTitulo
																		and T.DigitoNumeroTitulo = pct.DigitoNumeroTitulo
							-- AND T.[DataProposta] >= PS.[DataArquivo]
													 )
					 AND pcts.LastValue = 1

--------------------------------------------
/*Atualização dos Títulos de Capitalização Situacao*/
--------------------------------------------

MERGE INTO [Dados].[PropostaCapitalizacaoTituloSituacao] AS T
  USING 
	   (SELECT * 
			  FROM (
					SELECT distinct pct.id AS [IDPropostaCapitalizacaoTitulo],
						   p.[SituacaoTitulo],
					       SP.ID AS IDSituacaoTitulo,
					       p.[DataInicioSituacaoTitulo] AS [DataInicioSituacao],
					       p.[MotivoSituacaoTitulo],
					       tm.id as IDMotivoSituacaoTitulo,
						   ROW_NUMBER() OVER(PARTITION BY p.NumeroTitulo, p.SerieTitulo, p.DigitoNumeroTitulo, p.DataInicioVigencia, p.SituacaoTitulo, p.[DataInicioSituacaoTitulo],p.[MotivoSituacaoTitulo] ORDER BY p.DataArquivo DESC, p.Codigo DESC) AS [ordem],
						   p.DataArquivo,
						   p.NomeArquivo AS [TipoArquivo]
						FROM [dbo].[STAFCAP_TP2_TEMP] P
						INNER JOIN Dados.Proposta PRP
						ON P.NumeroProposta = PRP.NumeroProposta
							AND  PRP.IDSeguradora = P.IDSeguradora
					
						INNER JOIN [Dados].[SituacaoProposta] SP
						ON SP.SIGLA = P.SITUACAOTITULO
				
						INNER JOIN [Dados].[TipoMotivo] TM
						ON TM.Codigo = p.MotivoSituacaoTitulo

						INNER JOIN [Dados].[PropostaCapitalizacaoTitulo] pct
						ON p.NumeroTitulo = pct.NumeroTitulo
							AND p.SerieTitulo = pct.SerieTitulo
							AND p.DigitoNumeroTitulo = pct.DigitoNumeroTitulo
				)a
			WHERE a.ordem = 1
	) AS X
	ON 	
	    T.[IDPropostaCapitalizacaoTitulo] = X.[IDPropostaCapitalizacaoTitulo]
	and T.[IDSituacaoTitulo] = X.[IDSituacaoTitulo]
	and T.[IDMotivoSituacaoTitulo] = x.[IDMotivoSituacaoTitulo]
	and t.[DataInicioSituacao] = x.[DataInicioSituacao]

	WHEN MATCHED AND X.[DataArquivo] >= T.[DataArquivo] THEN 
		UPDATE
			SET 
				[TipoArquivo] = COALESCE(X.[TipoArquivo], T.[TipoArquivo]),
				DataArquivo = X.DataArquivo            
	WHEN NOT MATCHED THEN 
		INSERT ([IDPropostaCapitalizacaoTitulo]
				,[IDSituacaoTitulo]
				,[IDMotivoSituacaoTitulo]
				,[DataInicioSituacao] 
				,[DataArquivo]
				,[TipoArquivo])
		VALUES ( X.[IDPropostaCapitalizacaoTitulo], x.[IDSituacaoTitulo],x.[IDMotivoSituacaoTitulo],
				x.[DataInicioSituacao],X.[DataArquivo] ,X.[TipoArquivo]); 

/*Atualiza a marcação LastValue das CapitalizacaoTituloSituacao recebidas para atualizar a última posição*/
/*Diego Lima - Data: 25/02/2014 */	
		 
 UPDATE Dados.[PropostaCapitalizacaoTituloSituacao] 
 SET LastValue = 1
 FROM Dados.[PropostaCapitalizacaoTituloSituacao] PE
INNER JOIN (
			SELECT ID,   ROW_NUMBER() OVER (PARTITION BY  FH.[IDPropostaCapitalizacaoTitulo]
											    ORDER BY FH.DataArquivo DESC) [ORDEM]
			FROM  Dados.[PropostaCapitalizacaoTituloSituacao] FH
			WHERE FH.[IDPropostaCapitalizacaoTitulo] in (
														SELECT DISTINCT pct.ID
														FROM [dbo].[STAFCAP_TP2_TEMP] T --(readuncommitted)
														  INNER JOIN [Dados].[PropostaCapitalizacaoTitulo] pct --(readuncommitted)
															ON  T.NumeroTitulo = pct.NumeroTitulo
															 and T.SerieTitulo = pct.SerieTitulo
															 and T.DigitoNumeroTitulo = pct.DigitoNumeroTitulo
											            ) 
			) A

		ON A.ID = PE.ID 
	 AND A.ORDEM = 1
	 
	 
	 --===============================================
-- Aqui vai pegar a ultima posição do LastValue	na tabela [Dados].[PropostaCapitalizacaoTituloSituacao] 
-- e atualiza na tabela [Dados].[PropostaCapitalizacaoTitulo]

UPDATE [Dados].[PropostaCapitalizacaoTitulo]
	SET 
--SELECT 
        [IDSituacaoTitulo]= fh.IDSituacaoTitulo, 
		[IDMotivoSituacaoTitulo]= fh.IDMotivoSituacaoTitulo,
		[DataInicioSituacaoTitulo] = fh.DataInicioSituacao,
		[DataArquivo] = fh.DataArquivo,
        [TipoArquivo] = fh.TipoArquivo
		
FROM [Dados].[PropostaCapitalizacaoTituloSituacao] FH
	INNER JOIN [Dados].[PropostaCapitalizacaoTitulo] f
		ON (fh.IDPropostaCapitalizacaoTitulo = f.ID)		

WHERE fh.LASTVALUE = 1 
	AND EXISTS ( SELECT *
					FROM [dbo].[STAFCAP_TP2_TEMP] temp
				    WHERE f.NumeroTitulo = temp.NumeroTitulo
							AND f.SerieTitulo = temp.SerieTitulo
							AND f.DigitoNumeroTitulo = temp.DigitoNumeroTitulo
				)
  
/*Atualização do Ponto de Parada, Igualando-o ao Maior Código Trabalhado no Comando Acima*/
SET @PontoDeParada = @MaiorCodigo
 
UPDATE ControleDados.PontoParada 
SET PontoParada = @MaiorCodigo
WHERE NomeEntidade = 'Pagamento_STAFCAP_TIPO2'
  
TRUNCATE TABLE [dbo].[STAFCAP_TP2_TEMP]  

SET @COMANDO = 'INSERT INTO [dbo].[STAFCAP_TP2_TEMP] 
					(	
						[Codigo]
						  ,[NumeroProposta]
						  ,[NumeroOrdemTitular]
						  ,[SerieTitulo]
						  ,[NumeroTitulo]
						  ,[DigitoNumeroTitulo]
						  ,[SituacaoTitulo]
						  ,[DataInicioSituacaoTitulo]
						  ,[DataPostagemTitulo]
						  ,[DataInicioVigencia]
						  ,[DataInicioSorteio]
						  ,[NumeroCombinacao]
						  ,[ValorTitulo]
						  ,[CodigoPlanoSUSEP]
						  ,[MotivoSituacaoTitulo]
						  ,[NomeArquivo]
						  ,[DataArquivo]
                         )
                SELECT [Codigo]
						  ,[NumeroProposta]
						  ,[NumeroOrdemTitular]
						  ,[SerieTitulo]
						  ,[NumeroTitulo]
						  ,[DigitoNumeroTitulo]
						  ,[SituacaoTitulo]
						  ,[DataInicioSituacaoTitulo]
						  ,[DataPostagemTitulo]
						  ,[DataInicioVigencia]
						  ,[DataInicioSorteio]
						  ,[NumeroCombinacao]
						  ,[ValorTitulo]
						  ,[CodigoPlanoSUSEP]
						  ,[MotivoSituacaoTitulo]
						  ,[NomeArquivo]
						  ,[DataArquivo]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaPagamento_STAFCAP_TIPO2] ''''' + @PontoDeParada + ''''''') PRP
                '

EXEC (@COMANDO) 
                
SELECT @MaiorCodigo = MAX(PRP.Codigo)
FROM dbo.STAFCAP_TP2_TEMP PRP  
  
END
               
END TRY                
BEGIN CATCH
  	
EXEC CleansingKit.dbo.proc_RethrowError	
-- RETURN @@ERROR	
 
END CATCH


