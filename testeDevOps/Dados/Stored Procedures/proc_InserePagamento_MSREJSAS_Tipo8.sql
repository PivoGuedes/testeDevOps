
CREATE PROCEDURE [Dados].[proc_InserePagamento_MSREJSAS_Tipo8] 
AS
 
BEGIN TRY	

DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(4000) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MSREJSAS_TP8_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[MSREJSAS_TP8_TEMP];

	
CREATE TABLE [dbo].[MSREJSAS_TP8_TEMP]
(
	[CodigoNaFonte] [bigint]NOT NULL,
	[NumeroProposta] [varchar](20) NULL,
	[ParcelaProposta] [int] NULL,
	[TipoMotivo] [smallint] NULL,
	[TipoLancamento] [smallint] NULL,
	[Valor] [numeric](13, 2) NULL,
	[ValorEstoque] [numeric](13, 2) NULL,
	[DataLancamento] [date] NULL,
	[DataArquivo] [date] NULL,
	[TipoDado] [nvarchar](100) NULL,
	[NomeArquivo] [nvarchar](100) NULL,
	[IDSeguradora] INT DEFAULT 1
) 

 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_MSREJSAS_TP8_TEMP ON MSREJSAS_TP8_TEMP
( 
  [CodigoNaFonte] ASC
)         

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Pagamento_MSREJSAS_TIPO8'

--SELECT @PontoDeParada = 0

/*********************************************************************************************************************/               
/*Recuperação do Maior Código do Retorno*/
/*********************************************************************************************************************/
SET @COMANDO = 'INSERT INTO [dbo].[MSREJSAS_TP8_TEMP] 
					(
                      	[CodigoNaFonte],
						[NumeroProposta],
						[ParcelaProposta],
						[TipoMotivo],
						[TipoLancamento],
						[Valor],
						[ValorEstoque],
						[DataLancamento],
						[DataArquivo],
						[TipoDado],
						[NomeArquivo]
                    )
                SELECT [CodigoNaFonte],
					   [NumeroProposta],
					   [ParcelaProposta],
					   [TipoMotivo],
					   [TipoLancamento],
					   [Valor],
					   [ValorEstoque],
					   [DataLancamento],
					   [DataArquivo],
					   [TipoDado],
					   [NomeArquivo] 
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaPagamento_MSREJSAS_Tipo8] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)
 

SELECT @MaiorCodigo = MAX(PRP.CodigoNaFonte)
FROM MSREJSAS_TP8_TEMP PRP
          
SET @COMANDO = ''    

WHILE @MaiorCodigo IS NOT NULL
BEGIN

--    PRINT @MaiorCodigo

/*Comando para Inserção de Propostas não Recebidas no Arquivo*/
MERGE INTO Dados.Proposta AS T
USING 
(
	SELECT DISTINCT PGTO.NumeroProposta, 
				    PGTO.[IDSeguradora], 
					PGTO.[TipoDado], 
					PGTO.DataArquivo
	FROM [dbo].MSREJSAS_TP8_TEMP PGTO
	WHERE PGTO.NumeroProposta IS NOT NULL
) X
ON T.NumeroProposta = X.NumeroProposta
AND T.IDSeguradora = X.IDSeguradora
WHEN NOT MATCHED THEN 
	INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
	VALUES (X.NumeroProposta, X.[IDSeguradora], -1, -1, -1, 0, -1, X.TipoDado, X.DataArquivo);

/*Inserção de Propostas de Clientes não Localizados - Por Número de Proposta*/
MERGE INTO Dados.PropostaCliente AS T
USING 
(
	SELECT PRP.ID [IDProposta], 'Cliente Desconhecido - Proposta não Recebida' [NomeCliente], 
		   PGTO.[TipoDado], 
		   MAX(PGTO.[DataArquivo]) [DataArquivo]
	FROM MSREJSAS_TP8_TEMP PGTO
	INNER JOIN Dados.Proposta PRP
	ON PRP.NumeroProposta = PGTO.NumeroProposta
	AND PRP.IDSeguradora = 1
	WHERE PGTO.NumeroProposta IS NOT NULL
	GROUP BY PRP.ID, PGTO.[TipoDado] 
) X
ON T.IDProposta = X.IDProposta
WHEN NOT MATCHED THEN 
	INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
	VALUES (X.IDProposta, [TipoDado], X.[NomeCliente], X.[DataArquivo]);   
                 
 /*Comando para Inserção de Pagamentos não Recebidas no Arquivo*/         
MERGE INTO Dados.Pagamento AS T
USING 
(
SELECT *
FROM (
SELECT DISTINCT ROW_NUMBER() OVER(PARTITION BY PRP.ID, TM.ID, PGTO.[DataArquivo], PGTO.[Valor] ORDER BY CodigoNaFonte DESC) AS ID,
				PRP.ID [IDProposta], 
				TM.ID [IDMotivo], 
				TM1.ID [IDMotivoSituacao], 
			    PGTO.Valor, 
				NULL ValorIOF, 
				PGTO.DataArquivo,
				PGTO.[CodigoNaFonte], 
				PGTO.TipoDado, 
				0 [EfetivacaoPgtoEstimadoPelaEmissao],
				NULL [SinalLancamento], 
				0 [ExpectativaDeReceita], 
				PGTO.NomeArquivo [Arquivo]
FROM [dbo].MSREJSAS_TP8_TEMP PGTO
INNER JOIN Dados.Proposta PRP
ON PGTO.NumeroProposta = PRP.NumeroProposta
AND PGTO.IDSeguradora = PRP.IDSeguradora
LEFT OUTER JOIN Dados.TipoMotivo TM
ON PGTO.TipoMotivo = TM.Codigo
LEFT OUTER JOIN Dados.TipoMotivo TM1
ON PGTO.TipoMotivo = TM1.Codigo
) AS T
WHERE ID = 1

) AS X
ON X.[IDProposta] = T.[IDProposta]   
	AND X.[IDMotivo] = T.[IDMotivo]
	AND X.[DataArquivo] = T.[DataArquivo]
	AND X.[Valor] = T.[Valor]
WHEN MATCHED THEN 
	UPDATE
		SET   [IDMotivoSituacao] = COALESCE(X.[IDMotivoSituacao],T.[IDMotivoSituacao])
			, [Valor] = COALESCE(X.[Valor], T.[Valor])
			, [ValorIOF] = COALESCE(X.[ValorIOF], T.[ValorIOF])
			, [CodigoNaFonte] = COALESCE(X.[CodigoNaFonte], T.[CodigoNaFonte])
			, [TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
			, [EfetivacaoPgtoEstimadoPelaEmissao] = COALESCE(X.[EfetivacaoPgtoEstimadoPelaEmissao], T.[EfetivacaoPgtoEstimadoPelaEmissao])
			, [SinalLancamento] = COALESCE(X.[SinalLancamento], T.[SinalLancamento])
			, [ExpectativaDeReceita] = COALESCE(X.[ExpectativaDeReceita], T.[ExpectativaDeReceita])
			, [Arquivo] = COALESCE(X.[Arquivo], T.[Arquivo])
WHEN NOT MATCHED
THEN INSERT          
([IDProposta],  [IDMotivo], [IDMotivoSituacao],[DataArquivo], [Valor], [ValorIOF],[CodigoNaFonte], 
 [TipoDado], [EfetivacaoPgtoEstimadoPelaEmissao], [SinalLancamento], [ExpectativaDeReceita], [Arquivo])
VALUES (X.[IDProposta],X.[IDMotivo],X.[IDMotivoSituacao],X.[DataArquivo],X.[Valor],X.[ValorIOF],
	    X.[CodigoNaFonte],X.[TipoDado],X.[EfetivacaoPgtoEstimadoPelaEmissao],X.[SinalLancamento],X.[ExpectativaDeReceita],X.[Arquivo]); 
           
 	           
 /*Atualização do Ponto de Parada,  igualando-o ao Maior Código Trabalhado no comando acima*/   
 SET @PontoDeParada = @MaiorCodigo
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @MaiorCodigo
WHERE NomeEntidade = 'MSREJSAS_TP8_TEMP'

  
TRUNCATE TABLE [dbo].[MSREJSAS_TP8_TEMP] 
  
SET @COMANDO = 'INSERT INTO [dbo].[MSREJSAS_TP8_TEMP] 
					(
                      	[CodigoNaFonte],
						[NumeroProposta],
						[ParcelaProposta],
						[TipoMotivo],
						[TipoLancamento],
						[Valor],
						[ValorEstoque],
						[DataLancamento],
						[DataArquivo],
						[TipoDado],
						[NomeArquivo]
                    )
                SELECT [CodigoNaFonte],
					   [NumeroProposta],
					   [ParcelaProposta],
					   [TipoMotivo],
					   [TipoLancamento],
					   [Valor],
					   [ValorEstoque],
					   [DataLancamento],
					   [DataArquivo],
					   [TipoDado],
					   [NomeArquivo] 
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaPagamento_MSREJSAS_Tipo8] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)
 

SELECT @MaiorCodigo = MAX(PRP.CodigoNaFonte)
FROM MSREJSAS_TP8_TEMP PRP 

END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MSREJSAS_TP8_TEMP]') AND type in (N'U'))
	DROP TABLE [dbo].[MSREJSAS_TP8_TEMP];
	
END TRY                
BEGIN CATCH
  	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
 
END CATCH




