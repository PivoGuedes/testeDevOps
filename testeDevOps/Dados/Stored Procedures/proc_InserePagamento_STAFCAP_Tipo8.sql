

CREATE PROCEDURE [Dados].[proc_InserePagamento_STAFCAP_Tipo8] 
AS 

BEGIN TRY	
--BEGIN TRANSACTION

DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(4000) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STAFCAP_TP8_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[STAFCAP_TP8_TEMP];
	
CREATE TABLE [dbo].[STAFCAP_TP8_TEMP](
		[Codigo] [bigint] NOT NULL,
		
		[TipoRegistro] [char](2) NULL,
		[NumeroPlano] [smallint] NULL,
		[SerieTitulo] [char](2) NULL,
		[NumeroTitulo] [char](7) NULL,
		[DigitoNumeroTitulo] [char](1) NULL,
		[NumeroParcela] [int] NULL,
		[MotivoSituacaoTitulo] [int] NULL,
		[ValorTitulo] [numeric](13,2) NULL,		
		[DataArquivo] [date] NULL,
		[NomeArquivo] [varchar](130) NULL,
		[IDSeguradora] smallint DEFAULT(3)
)

 /*Criação de Índices*/  
CREATE CLUSTERED INDEX idx_STASASSE_TP8_TEMP ON STAFCAP_TP8_TEMP 
(
	Codigo ASC
)         
   

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Pagamento_STAFCAP_TIPO8'

--	SELECT @PontoDeParada = 100

--DECLARE @PontoDeParada AS VARCHAR(400)
--set @PontoDeParada = 60100
--DECLARE @MaiorCodigo AS BIGINT
--DECLARE @COMANDO AS NVARCHAR(4000) 
SET @COMANDO = 'INSERT INTO [dbo].[STAFCAP_TP8_TEMP] 
					(	
						[Codigo]
						
						  ,[TipoRegistro]
						  ,[NumeroPlano]
						  ,[SerieTitulo]
						  ,[NumeroTitulo]
						  ,[DigitoNumeroTitulo]
						  ,[NumeroParcela]
						  ,[MotivoSituacaoTitulo]
						  ,[ValorTitulo]
						  ,[DataArquivo]
						  ,[NomeArquivo]
      
                         )
                SELECT [Codigo]
					  
					  ,[TipoRegistro]
					  ,[NumeroPlano]
					  ,[SerieTitulo]
					  ,[NumeroTitulo]
					  ,[DigitoNumeroTitulo]
					  ,[NumeroParcela]
					  ,[MotivoSituacaoTitulo]
					  ,[ValorTitulo]
					  ,[DataArquivo]
					  ,[NomeArquivo]
      
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaPagamento_STAFCAP_TIPO8] ''''' + @PontoDeParada + ''''''') PRP
                '

EXEC (@COMANDO)
 
SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM STAFCAP_TP8_TEMP PRP

                  
SET @COMANDO = ''    

WHILE @MaiorCodigo IS NOT NULL
BEGIN

--    PRINT @MaiorCodigo
-----------------------------------------------------------------------------------------------------------------------
 -----------------------------------------------------------------------------------------------------------------------
 
;MERGE INTO [ControleDados].[LogSTAFCAPTP8] AS T
  USING (
		
		SELECT distinct  PCT.IDPROPOSTA, P.NumeroProposta, t.[TipoRegistro]
      ,t.[NumeroPlano],t.[SerieTitulo],t.[NumeroTitulo],t.[DigitoNumeroTitulo]
      ,t.[NumeroParcela],t.[MotivoSituacaoTitulo],t.[ValorTitulo],t.[DataArquivo],t.[NomeArquivo]
			FROM [dbo].[STAFCAP_TP8_TEMP] AS T
				LEFT JOIN Dados.PropostaCapitalizacaoTitulo AS PCT
					ON T.NumeroTitulo = PCT.NumeroTitulo
						AND T.[SerieTitulo] = PCT.SerieTitulo
						AND T.[DigitoNumeroTitulo] = PCT.DigitoNumeroTitulo

				LEFT JOIN  Dados.Proposta AS P
						ON P.ID = PCT.IDProposta

			WHERE PCT.idproposta is null
						
	  
	   ) X
	ON  isnull(T.NumeroProposta,-1) = isnull(X.NumeroProposta,-1)
	AND T.[SerieTitulo] = X.[SerieTitulo]
	AND T.[NumeroTitulo] = X.[NumeroTitulo]
	AND T.[DigitoNumeroTitulo] = X.[DigitoNumeroTitulo]
	AND isnull(T.[NumeroParcela],0) =  isnull(X.[NumeroParcela],0)
	and T.NumeroPlano = X.NumeroPlano
	AND T.DataArquivo = X.DataArquivo
	AND T.NomeArquivo = X.NomeArquivo

	WHEN NOT MATCHED
         THEN INSERT ([NumeroProposta],[TipoRegistro],[NumeroPlano],[SerieTitulo],[NumeroTitulo],[DigitoNumeroTitulo],[NumeroParcela]
						,[MotivoSituacaoTitulo],[ValorTitulo],[DataArquivo],[NomeArquivo],[FlagCadastrado])
         VALUES ([NumeroProposta],[TipoRegistro],[NumeroPlano],[SerieTitulo],[NumeroTitulo],[DigitoNumeroTitulo],[NumeroParcela]
						,[MotivoSituacaoTitulo],[ValorTitulo],[DataArquivo],[NomeArquivo],'0'
				)
    ;

-----------------------------------------------------------------------------------------------------------------------
 -----------------------------------------------------------------------------------------------------------------------
  	 
;MERGE INTO Dados.CapitalizacaoExtrato AS T
USING 
	(
	 SELECT * FROM (
					SELECT distinct T.*
									,P.ID AS IDProposta
									,tm.id AS IDMotivo
									,ROW_NUMBER() OVER(PARTITION BY P.ID, t.NumeroTitulo, t.SerieTitulo, t.DigitoNumeroTitulo,t.numeroparcela ORDER BY t.DataArquivo DESC, t.Codigo DESC) AS ID
				
					FROM [dbo].[STAFCAP_TP8_TEMP] AS T

							OUTER APPLY 
								(
									SELECT IDProposta
									FROM Dados.PropostaCapitalizacaoTitulo AS PCT
									WHERE   T.NumeroTitulo    = PCT.NumeroTitulo
											AND T.[SerieTitulo]   = PCT.SerieTitulo
											AND T.[DigitoNumeroTitulo] = PCT.DigitoNumeroTitulo
								) AS E	
								
					INNER JOIN Dados.Proposta AS P
						ON P.ID = e.IDProposta

					INNER JOIN dados.TipoMotivo tm
						ON t.motivoSituacaoTitulo = tm.codigo

				 ) Y
		WHERE Y.ID = 1
	) AS X
ON  T.IDProposta = X.IDProposta and
 T.NumeroTitulo = X.NumeroTitulo
AND T.[NumeroSerie] = X.SerieTitulo
AND T.[DigitoTitulo] = X.DigitoNumeroTitulo
and ISNULL(T.NumeroParcela,-1) = ISNULL(X.NumeroParcela,-1)	
and  t.CodigoPlano = X.NumeroPlano
--and T.DataArquivo = X.DataArquivo

WHEN MATCHED and T.DataArquivo = X.DataArquivo THEN 
	UPDATE
		SET --CodigoPlano = COALESCE(X.NumeroPlano, T.CodigoPlano),
			--NumeroParcela = COALESCE(X.NumeroParcela, T.NumeroParcela),
			Valortitulo = COALESCE(X.Valortitulo, T.Valortitulo),
			NomeArquivo = COALESCE(X.NomeArquivo, T.NomeArquivo),
			DataArquivo = COALESCE(X.DataArquivo, T.DataArquivo),
			IDMotivo = COALESCE(X.IDMotivo, T.IDMotivo)
WHEN NOT MATCHED THEN 
	INSERT (IDProposta,NumeroTitulo,NumeroSerie,DigitoTitulo,CodigoPlano,IDMotivo
	        ,NumeroParcela,Valortitulo,NomeArquivo,DataArquivo)
	VALUES (x.IDProposta,x.NumeroTitulo,x.[SerieTitulo],x.DigitoNumeroTitulo,x.NumeroPlano,X.IDMotivo,
	        x.NumeroParcela,x.ValorTitulo,x.NomeArquivo,x.DataArquivo);

/*Atualização do Ponto de Parada, Igualando-o ao Maior Código Trabalhado no Comando Acima*/
SET @PontoDeParada = @MaiorCodigo
 
UPDATE ControleDados.PontoParada 
SET PontoParada = @MaiorCodigo
WHERE NomeEntidade = 'Pagamento_STAFCAP_TIPO8'
  
TRUNCATE TABLE [dbo].[STAFCAP_TP8_TEMP]  
SET @COMANDO = 'INSERT INTO [dbo].[STAFCAP_TP8_TEMP] 
					(	
						[Codigo]
						 
						  ,[TipoRegistro]
						  ,[NumeroPlano]
						  ,[SerieTitulo]
						  ,[NumeroTitulo]
						  ,[DigitoNumeroTitulo]
						  ,[NumeroParcela]
						  ,[MotivoSituacaoTitulo]
						  ,[ValorTitulo]
						  ,[DataArquivo]
						  ,[NomeArquivo]
      
                         )
                SELECT [Codigo]
					 
					  ,[TipoRegistro]
					  ,[NumeroPlano]
					  ,[SerieTitulo]
					  ,[NumeroTitulo]
					  ,[DigitoNumeroTitulo]
					  ,[NumeroParcela]
					  ,[MotivoSituacaoTitulo]
					  ,[ValorTitulo]
					  ,[DataArquivo]
					  ,[NomeArquivo]
      
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaPagamento_STAFCAP_TIPO8] ''''' + @PontoDeParada + ''''''') PRP
                '

EXEC (@COMANDO)
                
SELECT @MaiorCodigo = MAX(PRP.Codigo)
FROM dbo.STAFCAP_TP8_TEMP PRP  
  
END
               
END TRY                
BEGIN CATCH
  	
EXEC CleansingKit.dbo.proc_RethrowError	
-- RETURN @@ERROR	
 
END CATCH


