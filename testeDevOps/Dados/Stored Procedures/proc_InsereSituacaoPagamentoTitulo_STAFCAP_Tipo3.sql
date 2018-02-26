
CREATE PROCEDURE [Dados].[proc_InsereSituacaoPagamentoTitulo_STAFCAP_Tipo3] 
AS

BEGIN TRY		
	    
DECLARE @PontoDeParada AS VARCHAR(400) 
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 
   	    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SituacaoPagamentoTitulos_STAFCAP_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[SituacaoPagamentoTitulos_STAFCAP_TEMP];

CREATE TABLE [dbo].[SituacaoPagamentoTitulos_STAFCAP_TEMP]
(
	[Codigo] [bigint] NOT NULL,
	[CodigoPlano] [smallint] NULL,
	[NumeroSerie] [char](2) NULL,
	[NumeroTitulo] [char](7) NULL,
	[DigitoTitulo]  [char](1) NULL,
	[ValorJurosAtraso] [numeric](13, 2) NULL,
	[NumeroParcela] [tinyint] NULL,
	[ValorProvisaoMatematica] [numeric](13, 2) NULL,
	[DataReferenciaProvisao] [date] NULL,
	[NossoNumeroComDV] [numeric](14, 0) NULL,
	[ValorEmAtraso] [numeric](13, 2) NULL,
	[DataValidadeValorAtraso] [date] NULL,
	[DataVencimento] [date] NULL,
	[ValorParcela] [numeric](13, 2) NULL,
	[NomeArquivo] [nvarchar](50) NULL,
	[DataArquivo] [date] NULL,
	[ControleVersao] [decimal](16, 8) NULL
)


 /*Cria Índices*/  
CREATE CLUSTERED INDEX idx_InfoComplementares_PRPFPREV_TEMP ON [dbo].[SituacaoPagamentoTitulos_STAFCAP_TEMP] (Codigo ASC)         

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'SituacaoPagamentoTitulos_STAFCAP_Tipo3'

--SELECT @PontoDeParada = 0


/*********************************************************************************************************************/               
/*Recupera maior Código do retorno*/
/*********************************************************************************************************************/
--DECLARE @PontoDeParada AS VARCHAR(400) 
--set @PontoDeParada = 0
---DECLARE @MaiorCodigo AS BIGINT
--DECLARE @ParmDefinition NVARCHAR(500)
--DECLARE @COMANDO AS NVARCHAR(max)
SET @COMANDO = 'INSERT INTO [dbo].[SituacaoPagamentoTitulos_STAFCAP_TEMP] 
				(      [Codigo],
                        [CodigoPlano],
						[NumeroSerie],
						[NumeroTitulo],
						[DigitoTitulo],
						[ValorJurosAtraso],
						[NumeroParcela],
						[ValorProvisaoMatematica],
						[DataReferenciaProvisao],
						[NossoNumeroComDV],
						[ValorEmAtraso],
						[DataValidadeValorAtraso],
						[DataVencimento],
						[ValorParcela],
						[NomeArquivo],
						[DataArquivo],
						[ControleVersao]
				)  
                SELECT  [Codigo],
                        [CodigoPlano],
						[NumeroSerie],
						[NumeroTitulo],
						[DigitoTitulo],
						[ValorJurosAtraso],
						[NumeroParcela],
						[ValorProvisaoMatematica],
						[DataReferenciaProvisao],
						[NossoNumeroComDV],
						[ValorEmAtraso],
						[DataValidadeValorAtraso],
						[DataVencimento],
						[ValorParcela],
						[NomeArquivo],
						[DataArquivo],
						[ControleVersao]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaSituacaoPagamentoTitulo_STAFCAP_Tipo3] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)     

SELECT @MaiorCodigo = MAX(PRP.Codigo)
FROM [dbo].[SituacaoPagamentoTitulos_STAFCAP_TEMP] PRP
        

WHILE @MaiorCodigo IS NOT NULL
BEGIN 
--    PRINT @MaiorCodigo
 
 
-----------------------------------------------------------------------------------------------------------------------
 -----------------------------------------------------------------------------------------------------------------------
  ;MERGE INTO [ControleDados].[LogSTAFCAPTP3] AS T
USING (
		SELECT distinct  P.NumeroProposta, t.*
			FROM [dbo].[SituacaoPagamentoTitulos_STAFCAP_TEMP] AS T
				LEFT JOIN Dados.PropostaCapitalizacaoTitulo AS PCT
					ON T.NumeroTitulo = PCT.NumeroTitulo
						AND T.[NumeroSerie] = PCT.SerieTitulo
						AND T.[DigitoTitulo] = PCT.DigitoNumeroTitulo

				LEFT JOIN  Dados.Proposta AS P
						ON P.ID = PCT.IDProposta

			WHERE P.NumeroProposta is null
	  
	   ) X
	ON  isnull(T.NumeroProposta,-1) = isnull(X.NumeroProposta,-1)
	AND T.[NumeroSerie] = X.[NumeroSerie]
	AND T.[NumeroTitulo] = X.[NumeroTitulo]
	AND T.[DigitoTitulo] = X.[DigitoTitulo]
	AND isnull(T.[NumeroParcela],0) =  isnull(X.[NumeroParcela],0)
	and T.CodigoPlano = X.CodigoPlano
	AND T.[NossoNumeroComDV] = X.[NossoNumeroComDV]
	--AND t.[ValorProvisaoMatematica] = X.[ValorProvisaoMatematica]
	AND t.[DataReferenciaProvisao] = x.[DataReferenciaProvisao]
	AND T.DataArquivo = X.DataArquivo
	AND T.NomeArquivo = X.NomeArquivo

	WHEN NOT MATCHED
         THEN INSERT ([NumeroProposta],[CodigoPlano],[NumeroSerie],[NumeroTitulo],[DigitoTitulo],[NumeroParcela],[ValorJurosAtraso]
					,[ValorProvisaoMatematica],[DataReferenciaProvisao],[NossoNumeroComDV],[ValorEmAtraso],[DataValidadeValorAtraso]
					,[DataVencimento],[ValorParcela],[NomeArquivo],[DataArquivo],[FlagCadastrado])
         VALUES (X.[NumeroProposta],X.[CodigoPlano],X.[NumeroSerie],X.[NumeroTitulo],X.[DigitoTitulo],X.[NumeroParcela],
				 X.[ValorJurosAtraso],X.[ValorProvisaoMatematica],X.[DataReferenciaProvisao],X.[NossoNumeroComDV],X.[ValorEmAtraso],
				 X.[DataValidadeValorAtraso],X.[DataVencimento],X.[ValorParcela],X.[NomeArquivo],X.[DataArquivo],'0'
			)
    ;


	----===============================================
	-- desmarcação do LastValue

	UPDATE Dados.[PropostaSituacaoPagamento] SET LastValue = 0

--SELECT top 1000 psp.* 
             FROM (
					SELECT distinct T.*,
									P.ID AS IDProposta
									
									--,ROW_NUMBER() OVER(PARTITION BY P.ID, t.NumeroTitulo, t.NumeroSerie, t.DigitoTitulo,t.numeroparcela,t.DataArquivo ORDER BY t.DataArquivo DESC, t.Codigo DESC) AS ID
				
					FROM dbo.[SituacaoPagamentoTitulos_STAFCAP_TEMP] AS T
					OUTER APPLY 
								(
									SELECT IDProposta
									FROM Dados.PropostaCapitalizacaoTitulo AS PCT
									WHERE T.NumeroTitulo = PCT.NumeroTitulo
											AND T.[NumeroSerie] = PCT.SerieTitulo
											AND T.[DigitoTitulo] = PCT.DigitoNumeroTitulo
								) AS E	
					INNER JOIN Dados.Proposta AS P
						ON P.ID = E.IDProposta

				 ) Y

				 inner join Dados.[PropostaSituacaoPagamento] psp
					on Y.IDProposta = psp.IDProposta
					and Y.NumeroTitulo = psp.NumeroTitulo
					and Y.NumeroSerie = psp.NumeroSerie
					and Y.DigitoTitulo = psp.DigitoTitulo

		where psp.lastvalue = 1
		--WHERE Y.ID = 1
 -----------------------------------------------------------------------------------------------------------------------
 /*Inserções de Dados - Proposta Situação Pagamento*/
 -----------------------------------------------------------------------------------------------------------------------
   
;MERGE INTO [Dados].[PropostaSituacaoPagamento] AS T
USING 
	(
	 SELECT * FROM (
					SELECT distinct T.*,
									P.ID AS IDProposta
									
									,ROW_NUMBER() OVER(PARTITION BY P.ID, t.NumeroTitulo, t.NumeroSerie, t.DigitoTitulo,t.numeroparcela,t.DataArquivo ORDER BY t.DataArquivo DESC, t.Codigo DESC) AS ID
				
					FROM [SituacaoPagamentoTitulos_STAFCAP_TEMP] AS T
					OUTER APPLY 
								(
									SELECT IDProposta
									FROM Dados.PropostaCapitalizacaoTitulo AS PCT
									WHERE T.NumeroTitulo = PCT.NumeroTitulo
											AND T.[NumeroSerie] = PCT.SerieTitulo
											AND T.[DigitoTitulo] = PCT.DigitoNumeroTitulo
								) AS E	
					INNER JOIN Dados.Proposta AS P
						ON P.ID = E.IDProposta

				 ) Y
		WHERE Y.ID = 1
	) AS X
ON T.IDProposta = X.IDProposta
and T.NumeroTitulo = X.NumeroTitulo
AND T.[NumeroSerie] = X.NumeroSerie
AND T.[DigitoTitulo] = X.DigitoTitulo
and T.[ParcelasPagas] = X.NumeroParcela
and T.[CodigoPlano] = X.[CodigoPlano]
--AND t.[ValorProvisaoMatematica] = X.[ValorProvisaoMatematica]
AND t.[DataReferenciaProvisao] = x.[DataReferenciaProvisao]
--and T.DataArquivo = X.DataArquivo
WHEN MATCHED THEN 
	UPDATE
		SET [ValorJurosAtraso] = COALESCE(X.[ValorJurosAtraso], T.[ValorJurosAtraso]), 
			[CodigoPlano] = COALESCE(X.[CodigoPlano], T.[CodigoPlano]) ,
			--[DataReferenciaProvisao] = COALESCE(X.[DataReferenciaProvisao], T.[DataReferenciaProvisao]),
			[NossoNumeroComDV] = COALESCE(X.[NossoNumeroComDV], T.[NossoNumeroComDV]),
			[ValorProvisaoMatematica] = COALESCE(X.[ValorProvisaoMatematica], T.[ValorProvisaoMatematica]),
			[ValorEmAtraso] = COALESCE(X.[ValorEmAtraso], T.[ValorEmAtraso]),
			[DataValidadeValorAtraso] = COALESCE(X.[DataValidadeValorAtraso], T.[DataValidadeValorAtraso]),
			[DataVencimento] = COALESCE(X.[DataVencimento], T.[DataVencimento]),
			[ValorParcela] = COALESCE(X.[ValorParcela], T.[ValorParcela]),
			NomeArquivo = COALESCE(X.NomeArquivo, T.NomeArquivo),
			DataArquivo = COALESCE(X.DataArquivo, T.DataArquivo),
			CodigoNaFonte = X.Codigo
	
WHEN NOT MATCHED THEN 
	INSERT ([IDProposta],/*[IDSituacaoCobranca],[DataInicioSituacao],*/[ParcelasPagas],/*[TotalDeParcelas],*/[CodigoPlano],[NumeroSerie]
			,[NumeroTitulo],[DigitoTitulo],[ValorJurosAtraso],[ValorProvisaoMatematica],[DataReferenciaProvisao]
			,[NossoNumeroComDV],[ValorEmAtraso],[DataValidadeValorAtraso],[DataVencimento],[ValorParcela],[NomeArquivo],
			[DataArquivo],CodigoNaFonte)
	VALUES (x.IDProposta,x.NumeroParcela,x.CodigoPlano,x.[NumeroSerie],x.NumeroTitulo,x.DigitoTitulo,x.[ValorJurosAtraso],
			x.[ValorProvisaoMatematica],x.[DataReferenciaProvisao],x.[NossoNumeroComDV],x.[ValorEmAtraso],x.[DataValidadeValorAtraso],
	        x.[DataVencimento],x.ValorParcela,x.NomeArquivo,x.DataArquivo,X.Codigo);

---===================================================

-- Marcação do LastValue

 UPDATE Dados.PropostaSituacaoPagamento 
   
   SET LastValue = 1

--SELECT * 

FROM Dados.[PropostaSituacaoPagamento] ps
        inner join

              (
				SELECT psp.id, 
					   ROW_NUMBER() OVER (PARTITION BY PSp.IDProposta,psp.NumeroTitulo, psp.NumeroSerie, psp.DigitoTitulo 
											ORDER BY psp.DataArquivo DESC,psp.[DataReferenciaProvisao]DESC,PSp.CodigoNaFonte DESC) [ORDEM]
				FROM (
					   SELECT T.NumeroTitulo,
							  T.NumeroSerie,
							  T.DigitoTitulo,
							  P.ID AS IDProposta
									
						FROM dbo.[SituacaoPagamentoTitulos_STAFCAP_TEMP] AS T
							OUTER APPLY 
								(
									SELECT IDProposta
									FROM Dados.PropostaCapitalizacaoTitulo AS PCT
									WHERE T.NumeroTitulo = PCT.NumeroTitulo
											AND T.[NumeroSerie] = PCT.SerieTitulo
											AND T.[DigitoTitulo] = PCT.DigitoNumeroTitulo
								) AS E	
						INNER JOIN Dados.Proposta AS P
						ON P.ID = E.IDProposta

					 ) Y

				 INNER JOIN Dados.[PropostaSituacaoPagamento] psp
					ON Y.IDProposta = psp.IDProposta
					AND Y.NumeroTitulo = psp.NumeroTitulo
					AND Y.NumeroSerie = psp.NumeroSerie
					AND Y.DigitoTitulo = psp.DigitoTitulo
				) X
		 ON X.ID = ps.ID 
		 AND X.ORDEM = 1

 
   
/*****************************************************************************************/
/*Atualização do Ponto de Parada, igualando-o ao Maior Código Trabalhado no comando acima*/
/*****************************************************************************************/
SET @PontoDeParada = @MaiorCodigo
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @MaiorCodigo
WHERE NomeEntidade = 'SituacaoPagamentoTitulos_STAFCAP_Tipo3'

TRUNCATE TABLE [dbo].[SituacaoPagamentoTitulos_STAFCAP_TEMP]

    
/*Recuperação do Maior Código do Retorno*/

SET @COMANDO = 'INSERT INTO [dbo].[SituacaoPagamentoTitulos_STAFCAP_TEMP] 
				(      [Codigo],
                        [CodigoPlano],
						[NumeroSerie],
						[NumeroTitulo],
						[DigitoTitulo],
						[ValorJurosAtraso],
						[NumeroParcela],
						[ValorProvisaoMatematica],
						[DataReferenciaProvisao],
						[NossoNumeroComDV],
						[ValorEmAtraso],
						[DataValidadeValorAtraso],
						[DataVencimento],
						[ValorParcela],
						[NomeArquivo],
						[DataArquivo],
						[ControleVersao]
				)  
                SELECT  [Codigo],
                        [CodigoPlano],
						[NumeroSerie],
						[NumeroTitulo],
						[DigitoTitulo],
						[ValorJurosAtraso],
						[NumeroParcela],
						[ValorProvisaoMatematica],
						[DataReferenciaProvisao],
						[NossoNumeroComDV],
						[ValorEmAtraso],
						[DataValidadeValorAtraso],
						[DataVencimento],
						[ValorParcela],
						[NomeArquivo],
						[DataArquivo],
						[ControleVersao]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaSituacaoPagamentoTitulo_STAFCAP_Tipo3] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)   

SELECT @MaiorCodigo = MAX(PRP.Codigo)
FROM [dbo].[SituacaoPagamentoTitulos_STAFCAP_TEMP] PRP
                    
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SituacaoPagamentoTitulos_STAFCAP_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[SituacaoPagamentoTitulos_STAFCAP_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH
