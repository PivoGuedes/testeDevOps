
CREATE PROCEDURE [Dados].[proc_InserePagamento_MSREJSAS_Tipo2] 
AS
 
BEGIN TRY	

DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(4000) 


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MSREJSAS_TP2_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[MSREJSAS_TP2_TEMP];

CREATE TABLE [dbo].[MSREJSAS_TP2_TEMP]
(
	[Codigo] [bigint] NOT NULL,
	[NumeroProposta] [varchar](20) NULL,
	[NumeroCertificado] [nvarchar](4000) NULL,
	[NumeroCertificadoTratado] AS CAST(dbo.fn_TrataNumeroPropostaZeroExtra(NumeroCertificado) AS VARCHAR(20)) PERSISTED,
	[DataInicioVigencia] [date] NULL,
	[DataFimVigencia] [date] NULL,
	[Valor] [numeric](15, 2) NULL,
	[ValorIOF] [numeric](15, 2) NULL,
	[DataArquivo] [date] NULL,
	[NomeArquivo] [nvarchar](100) NULL,
	[NumeroParcela] [int] NOT NULL,
	[IDSeguradora] [int] NOT NULL,
	[Motivo] [char](3) NULL,
	[TipoArquivo] [nvarchar](100) NULL
	
);

 /*Cria alguns Índices*/  
CREATE CLUSTERED INDEX idx_MSREJSAS_TP2_TEMP ON [dbo].[MSREJSAS_TP2_TEMP]
( 
  Codigo ASC
)   

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Pagamento_MSREJSAS_Tipo2'

--SET @PontoDeParada = 0

/*********************************************************************************************************************/               
/*Recuperação do  Maior Código do Retorno*/
/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[MSREJSAS_TP2_TEMP]  
                   (
						[Codigo],
						[NumeroProposta],
						[NumeroCertificado],
						[DataInicioVigencia],
						[DataFimVigencia],
						[Valor],
						[ValorIOF],
						[DataArquivo],
						[NomeArquivo],
						[NumeroParcela],
						[IDSeguradora],
						[Motivo],
						[TipoArquivo]
				   )
				SELECT [Codigo],
					   [NumeroProposta],
					   [NumeroCertificado],
					   [DataInicioVigencia],
					   [DataFimVigencia],
					   [Valor],
					   [ValorIOF],
					   [DataArquivo],
					   [NomeArquivo],
					   [NumeroParcela],
					   [IDSeguradora],
					   [Motivo],
					   [TipoArquivo]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaPagamento_MSREJSAS_Tipo2] ''''' + @PontoDeParada + ''''''') PRP'                
EXEC (@COMANDO)
  
SELECT @MaiorCodigo = MAX(STA.Codigo)
FROM dbo.MSREJSAS_TP2_TEMP STA    

SET @COMANDO = ''    

WHILE @MaiorCodigo IS NOT NULL
BEGIN

/*Insere Tipo de Motivo de Proposta Desconhecidos*/
MERGE INTO  Dados.TipoMotivo AS T
USING 
(
	SELECT DISTINCT [Motivo] AS Codigo, 
		  'Tipo Motivo Desconhecido' AS [TipoMotivo]
	FROM MSREJSAS_TP2_TEMP PGTO 
	WHERE PGTO.[Motivo] IS NOT NULL     
) X
ON T.Codigo = X.[Codigo]
WHEN NOT MATCHED THEN 
	INSERT (Codigo, [Nome])
	VALUES (X.Codigo, X.[TipoMotivo]);              	               	               
    
	
/*Comando para Inserção de Propostas não Recebidas*/
MERGE INTO Dados.Proposta AS T
USING 
(
	SELECT DISTINCT PGTO.NumeroProposta, 
					PGTO.[IDSeguradora], 
					PGTO.[TipoArquivo], 
					PGTO.DataArquivo
	FROM dbo.MSREJSAS_TP2_TEMP PGTO            
) X
ON T.NumeroProposta = X.NumeroProposta  
	AND T.IDSeguradora = X.IDSeguradora
WHEN NOT MATCHED THEN 
	INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
	VALUES (X.NumeroProposta, X.[IDSeguradora], -1, -1, 0, -1, 0, -1, X.TipoArquivo, X.DataArquivo);		               

/*Inserção de Proposta de Cliente não Lozalizados - Por Número de Proposta*/
MERGE INTO Dados.PropostaCliente AS T
USING 
(
	SELECT PRP.ID [IDProposta], 1 
		  [IDSeguradora], 
		  'Cliente Desconhecido - Proposta não Recebida' [NomeCliente], 
		  MAX(PGTO.[TipoArquivo]) [TipoDado], 
		  MAX(PGTO.[DataArquivo]) [DataArquivo]
	FROM MSREJSAS_TP2_TEMP PGTO
	INNER JOIN Dados.Proposta PRP
	ON PRP.NumeroProposta = PGTO.NumeroProposta
	AND PRP.IDSeguradora = 1
	WHERE PGTO.NumeroProposta IS NOT NULL
	GROUP BY PRP.ID
) X
ON T.IDProposta = X.IDProposta
WHEN NOT MATCHED THEN 
	INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
	VALUES (X.IDProposta, [TipoDado], X.[NomeCliente], X.[DataArquivo]);


/*Inserção dos Registros para Posterior Análise*/
;MERGE INTO ControleDados.LogSTATP2 AS T
USING 
(	 
	SELECT   
			PGTO.NumeroCertificado, PGTO.[NumeroProposta], 
			MAX(PGTO.Valor) ValorPremioTotal,
			MIN(PGTO.DataInicioVigencia) DataInicioVigencia, 
			MAX(ISNULL(PGTO.DataFimVigencia, '9999-12-31')) DataFimVigencia,
			PGTO.DataArquivo, 
			PGTO.NomeArquivo	                         
	FROM dbo.MSREJSAS_TP2_TEMP PGTO
	INNER JOIN Dados.Proposta PRP
	ON PRP.NumeroProposta = PGTO.NumeroProposta
		AND PRP.IDSeguradora = 1
		AND PRP.IDProdutoSIGPF = 0 
	GROUP BY PGTO.NumeroCertificado, PGTO.[NumeroProposta], PGTO.DataArquivo, PGTO.NomeArquivo    
) X
ON  T.NumeroProposta = X.NumeroProposta
	AND T.DataArquivo = X.DataArquivo
	AND T.NomeArquivo = X.NomeArquivo
WHEN NOT MATCHED THEN 
	INSERT (NumeroContrato,NumeroProposta,Ocorrencia,DataInicioVigencia,DataFimVigencia,ValorPremioTotal,DataArquivo,NomeArquivo)
	VALUES (NumeroCertificado,[NumeroProposta],'Proposta não recebida',DataInicioVigencia,DataFimVigencia,ValorPremioTotal,DataArquivo,NomeArquivo);


/*Comando para Inserção um Contrato - Apólice das Propostas de Emissão Recebidos*/
INSERT INTO Dados.Contrato (NumeroContrato,IDProposta,IDSeguradora,Arquivo,DataArquivo,DataInicioVigencia,DataFimVigencia,ValorPremioTotal)
SELECT NumeroCertificado,   
	   [IDProposta],
	   [IDSeguradora],
	   (SELECT TOP 1 NomeArquivo FROM dbo.MSREJSAS_TP2_TEMP PGTO1 WHERE PGTO1.Codigo = A.Codigo) NomeArquivo,
       (SELECT TOP 1 DataArquivo FROM dbo.MSREJSAS_TP2_TEMP PGTO1 WHERE PGTO1.Codigo = A.Codigo) DataArquivo,
	   DataInicioVigencia, 
	   DataFimVigencia, 
	   ValorPremioTotal
FROM            
(     
	SELECT PGTO.NumeroCertificado, 
		   PRP.ID [IDProposta], 
		   PGTO.[IDSeguradora], 
		   MAX(PGTO.Codigo) Codigo,
		   MAX(PGTO.Valor) ValorPremioTotal,
		   MIN(PGTO.DataInicioVigencia) DataInicioVigencia, 
		   MAX(ISNULL(PGTO.DataFimVigencia, '9999-12-31')) DataFimVigencia	                         
	FROM dbo.MSREJSAS_TP2_TEMP PGTO	 
	INNER JOIN Dados.Proposta PRP
	ON  PRP.NumeroProposta = PGTO.NumeroProposta
	AND PRP.IDSeguradora = PGTO.IDSeguradora
	INNER JOIN Dados.ProdutoSIGPF PSG
	ON PSG.ID = PRP.IDProdutoSIGPF
		AND (PSG.ProdutoComCertificado IS NULL OR PSG.ProdutoComCertificado = 0)
		AND (PSG.ID <> 0)
	WHERE NOT EXISTS 
	(
		SELECT * 
		FROM Dados.Contrato CNT
		WHERE CNT.NumeroContrato = PGTO.NumeroCertificado
			AND CNT.IDSeguradora = PGTO.IDSeguradora)
		GROUP BY PGTO.[IDSeguradora], PRP.ID, PGTO.NumeroCertificado
) A


/*Comando para Inserção um Endosso (1º Endosso) da Emissão das Propostas - Status de Emissão Recebidos no Arquivo*/ 
INSERT INTO Dados.Endosso (IDContrato,IDProduto,NumeroEndosso,IDTipoEndosso,IDSituacaoEndosso,Arquivo,
						   DataArquivo,DataInicioVigencia,DataFimVigencia,ValorPremioTotal)
SELECT [IDContrato],[IDProduto],[NumeroEndosso],[IDTipoEndosso],[IDSituacaoEndosso],
	   (SELECT TOP 1 NomeArquivo FROM dbo.MSREJSAS_TP2_TEMP PGTO1 WHERE PGTO1.Codigo = A.Codigo) NomeArquivo,
	   (SELECT TOP 1 DataArquivo FROM dbo.MSREJSAS_TP2_TEMP PGTO1 WHERE PGTO1.Codigo = A.Codigo) DataArquivo,
	   DataInicioVigencia, DataFimVigencia, ValorPremioTotal
FROM            
(     
	SELECT CNT.ID [IDContrato], 
		   -1 [IDProduto] /*Produto não Indicado*/, 
		   -1 [NumeroEndosso] /*Endosso de Emissão Forçado*/,
		   0 [IDTipoEndosso] /*Endosso da Emissão*/, 
		   2 [IDSituacaoEndosso] /*Endosso Pago*/,
		   MAX(PGTO.Codigo) Codigo,
		   MAX(Valor) ValorPremioTotal,
		   MIN(PGTO.DataInicioVigencia) DataInicioVigencia, 
		   MAX(ISNULL(PGTO.DataFimVigencia, '9999-12-31')) DataFimVigencia	                         
	FROM dbo.MSREJSAS_TP2_TEMP PGTO
	INNER JOIN Dados.Contrato CNT
	ON CNT.NumeroContrato = PGTO.NumeroCertificado
	AND CNT.IDSeguradora = PGTO.IDSeguradora
	WHERE NOT EXISTS 
	(
		SELECT * FROM Dados.Endosso EN
		WHERE EN.IDContrato = CNT.ID
	)
AND PGTO.NumeroCertificadoTratado <> PGTO.NumeroProposta
GROUP BY CNT.ID
) A;


/*Atualização dos Dados de Início de Vigência e Fim de Vigência, assim como o 
  do IDContrato das Propostas de Emissão que foram recebidas no arquivo*/ 
MERGE INTO Dados.Proposta AS T																			
USING 
(
	SELECT NumeroProposta, IDSeguradora, (SELECT TOP 1 TipoDado FROM dbo.STASASSE_TP2_TEMP PGTO1 WHERE PGTO1.Codigo = PGTO.Codigo) TipoDado, 
		   DataInicioVigencia, DataFimVigencia,  [IDContrato]
FROM
	(      
		SELECT  PGTO.NumeroProposta, 
				PGTO.[IDSeguradora], 
				MAX(PGTO.Codigo) Codigo,
				MIN(PGTO.DataInicioVigencia) DataInicioVigencia, 
				MAX(ISNULL(PGTO.DataFimVigencia, '9999-12-31')) DataFimVigencia, 
				CNT.ID [IDContrato]		               
		FROM dbo.MSREJSAS_TP2_TEMP PGTO
		LEFT JOIN Dados.Contrato CNT
		ON CNT.NumeroContrato = PGTO.NumeroCertificado
		AND CNT.IDSeguradora = PGTO.IDSeguradora
		GROUP BY PGTO.NumeroProposta, PGTO.[IDSeguradora], CNT.ID
	) PGTO           
) X
ON T.NumeroProposta = X.NumeroProposta  
AND T.IDSeguradora = X.IDSeguradora
WHEN  MATCHED THEN 
	UPDATE
		SET [DataInicioVigencia] = COALESCE(T.[DataInicioVigencia], X.[DataInicioVigencia]),
			[DataFimVigencia] = COALESCE(T.[DataFimVigencia], X.[DataFimVigencia]), 
			IDContrato = COALESCE(T.[IDContrato], X.[IDContrato]);                                                                              
	

/*Atualização do Valor do Prêmio Original*/ 	
MERGE INTO Dados.Proposta AS T																			
USING 
(
	SELECT PRP.ID IDProposta, 
		   PE.ValorPremioBrutoOriginal, 
		   PE.ValorPremioLiquidoOriginal               
	FROM Dados.Proposta PRP
	CROSS APPLY (SELECT TOP 1 ISNULL(PE.Valor,0) - ISNULL(PE.ValorIOF,0) [ValorPremioLiquidoOriginal], ISNULL(PE.Valor,0) [ValorPremioBrutoOriginal]
				 FROM Dados.PagamentoEmissao PE
	INNER JOIN Dados.SituacaoProposta SP
	ON PE.IDSituacaoProposta = SP.ID  
	WHERE PE.IDProposta = PRP.ID
		AND SP.SituacaoDeEmissao = 1 
	ORDER BY PE.DataArquivo ASC
) PE		
WHERE EXISTS 
	( 
		SELECT * 
		FROM dbo.MSREJSAS_TP2_TEMP PGTO 
		WHERE PRP.NumeroProposta = PGTO.NumeroProposta 
		AND PRP.IDSeguradora= PGTO.IDSeguradora	
	) 
)  X
ON T.ID = X.IDProposta
WHEN MATCHED THEN 
	UPDATE  
		SET ValorPremioBrutoEmissao = X.ValorPremioBrutoOriginal,
			ValorPremioLiquidoEmissao =  X.ValorPremioLiquidoOriginal
 		
	   	
--TODO - Realizar o Update do Resto do Prêmio Total a partir do Tipo 2 (ou não)
--TODO - Verificação do Premio Total é equivalente ao Premio Somado ao Custo de Apólice (ou não)

/*Verificação do Produto SIGPF para Inserção do Certificado Fake*/ 			
;MERGE INTO Dados.Certificado AS T
USING 
(
	SELECT   
	--, PRP.Nome 
	  PRP.ID [IDProposta],
	  PGTO.NumeroCertificadoTratado,
	  PGTO.[IDSeguradora],
	--, MAX(PGTO.Codigo) Codigo
	--, MAX(PGTO.Valor) ValorPremioTotal
	  MAX(PGTO.DataInicioVigencia) DataInicioVigencia,
	  MAX(ISNULL(PGTO.DataFimVigencia, '9999-12-31')) DataFimVigencia, 
	  MAX(PGTO.DataArquivo) [DataArquivo],
	  MAX(PGTO.NomeArquivo) [Arquivo]
	FROM dbo.MSREJSAS_TP2_TEMP PGTO
	INNER JOIN Dados.Proposta PRP
	ON PRP.NumeroProposta = PGTO.NumeroProposta
		AND PRP.IDSeguradora = PGTO.[IDSeguradora] --Caixa Seguros
	INNER JOIN Dados.ProdutoSIGPF PSG
	ON PSG.ID = PRP.IDProdutoSIGPF
		AND (PSG.ProdutoComCertificado IS NOT NULL 
		OR PSG.ProdutoComCertificado = 1)
		AND (PSG.ID <> 0) /*Garante que a Proposta foi Recebida ou que de alguma forma sabe-se o Produto da Proposta.*/
	GROUP BY PGTO.[IDSeguradora], PRP.ID, PGTO.NumeroCertificadoTratado  --PRP.ID, PGTO.NumeroProposta--, PRP.Nome
) X
ON  T.IDSeguradora = X.[IDSeguradora] --Caixa Seguros
	AND T.NumeroCertificado = X.NumeroCertificadoTratado
	AND ISNULL(T.IDProposta, -1) = ISNULL(X.IDProposta, -1)
WHEN MATCHED THEN 
	UPDATE
		SET IDProposta = COALESCE(X.IDProposta, T.IDProposta),
			DataArquivo = COALESCE(X.DataArquivo, T.DataArquivo),
			DataInicioVigencia = COALESCE(X.DataInicioVigencia, T.DataInicioVigencia),
			DataFimVigencia = COALESCE(X.DataFimVigencia, T.DataFimVigencia),
			Arquivo = COALESCE(X.[Arquivo], T.[Arquivo])
WHEN NOT MATCHED THEN 
	INSERT (IDProposta, IDSeguradora, NumeroCertificado, /*DataInicioVigencia, DataFimVigencia,*/ DataArquivo, Arquivo)
	VALUES (X.IDProposta, X.[IDSeguradora], X.NumeroCertificadoTratado, /*X.DataInicioVigencia, X.DataFimVigencia,*/ X.DataArquivo, X.[Arquivo]);


/*Inserção do Histórico do Certificado das Propostas cujo Status foram Recebidos no Arquivo Tipo 2*/ 	
MERGE INTO Dados.CertificadoHistorico AS T
USING 
(
	SELECT CRT.ID [IDCertificado],
		   'TP2' NumeroProposta,
		    PGTO.[IDSeguradora],
			MAX(PGTO.Codigo) Codigo,
			MAX(PGTO.Valor - ValorIOF) ValorPremioLiquido,				
			MAX(PGTO.Valor) ValorPremioTotal,
			MIN(PGTO.DataInicioVigencia) DataInicioVigencia,
			MAX(ISNULL(PGTO.DataFimVigencia, '9999-12-31')) DataFimVigencia,
			MAX(PGTO.DataArquivo) [DataArquivo],
			MAX(PGTO.NomeArquivo) [Arquivo]
	FROM dbo.MSREJSAS_TP2_TEMP PGTO
	INNER JOIN Dados.Proposta PRP
	ON PGTO.NumeroProposta = PRP.NumeroProposta          
		AND PRP.IDSeguradora = 1
	INNER JOIN Dados.Certificado CRT
	ON CRT.NumeroCertificado = PGTO.NumeroCertificadoTratado
		AND CRT.IDSeguradora = PGTO.[IDSeguradora] --Caixa Seguros
		AND CRT.IDProposta = PRP.ID     
	GROUP BY PGTO.[IDSeguradora], PRP.ID, PGTO.NumeroCertificadoTratado,  CRT.ID, PGTO.NumeroProposta
) X
ON  T.NumeroProposta = X.NumeroProposta 
	AND T.[IDCertificado] = X.[IDCertificado] 
	AND T.DataArquivo = X.DataArquivo
WHEN MATCHED THEN 
	UPDATE
		SET 
			DataInicioVigencia = X.DataInicioVigencia,
			DataFimVigencia = X.DataFimVigencia,
			ValorPremioTotal = X.ValorPremioTotal,
			ValorPremioLiquido = X.ValorPremioLiquido,
			Arquivo = X.[Arquivo]
WHEN NOT MATCHED THEN 
	INSERT ([IDCertificado], NumeroProposta, ValorPremioTotal, ValorPremioLiquido, DataInicioVigencia, DataFimVigencia, DataArquivo, Arquivo)
	VALUES (X.[IDCertificado], X.[NumeroProposta], X.ValorPremioTotal, X.ValorPremioLiquido, X.DataInicioVigencia, X.DataFimVigencia, X.DataArquivo, X.[Arquivo]);

/*Comando para Inserção dos Pagamentos Recebidos no Arquivo Tipo 2*/ 	
MERGE INTO Dados.PagamentoEmissao AS T
USING 
(
SELECT *
FROM (
		SELECT DISTINCT ROW_NUMBER() OVER(PARTITION BY PRP.ID, NumeroParcela, TM.ID, PGTO.DataArquivo ORDER BY PGTO.Codigo  DESC) AS ID,
				PRP.ID [IDProposta], 
				TM.ID [IDMotivo], 
				NULL AS [IDSituacaoProposta], 
				PGTO.NumeroParcela,
				PGTO.Valor, 
				PGTO.ValorIOF,
				PGTO.DataArquivo, 
				PGTO.DataInicioVigencia, 
				PGTO.DataFimVigencia,
			    PGTO.Codigo [CodigoNaFonte], 
				PGTO.TipoArquivo AS TipoDado,
				NULL [SinalLancamento], 
				0 [ExpectativaDeReceita], 
				PGTO.NomeArquivo [Arquivo]
		FROM dbo.MSREJSAS_TP2_TEMP PGTO
		INNER JOIN Dados.Proposta PRP
		ON PGTO.NumeroProposta = PRP.NumeroProposta
		AND PGTO.IDSeguradora = PRP.IDSeguradora
		LEFT OUTER JOIN Dados.TipoMotivo TM
		ON PGTO.Motivo = TM.Codigo    
	  ) AS T
	WHERE ID = 1
) AS X
ON X.[IDProposta] = T.[IDProposta]   
	AND ISNULL(X.[IDMotivo], -1) = ISNULL(T.[IDMotivo], -1)
	AND X.[DataArquivo] = T.[DataArquivo]  
	AND X.[Valor] = T.[Valor]          
WHEN MATCHED THEN 
	UPDATE
		SET [IDSituacaoProposta] = COALESCE(X.[IDSituacaoProposta], T.[IDSituacaoProposta])
		  , [Valor] = COALESCE(X.[Valor],T.Valor)
		  , [ValorIOF] = COALESCE(X.[ValorIOF], T.[ValorIOF])
		  , [CodigoNaFonte] = COALESCE(X.[CodigoNaFonte], T.[CodigoNaFonte])
		  , [TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
		  , [SinalLancamento] = COALESCE(X.[SinalLancamento], T.[SinalLancamento])
		  , [ExpectativaDeReceita] = COALESCE(X.[ExpectativaDeReceita], T.[ExpectativaDeReceita])
		  , [Arquivo] = COALESCE(X.[Arquivo], T.[Arquivo])
		  , [DataInicioVigencia] = COALESCE(X.[DataInicioVigencia], T.[DataInicioVigencia])
		  , [DataFimVigencia] = COALESCE(X.[DataFimVigencia], T.[DataFimVigencia])               		 
WHEN NOT MATCHED THEN 
	INSERT          
		(
		  [IDProposta],  [IDMotivo], [IDSituacaoProposta]
		, [DataArquivo], [Valor], [ValorIOF]
		, [CodigoNaFonte], [TipoDado]
		, [SinalLancamento]
		, [ExpectativaDeReceita], [Arquivo], [DataInicioVigencia], [DataFimVigencia]             
		)
VALUES 
		(
		 X.[IDProposta]
		,X.[IDMotivo]
		,X.[IDSituacaoProposta]
		,X.[DataArquivo]
		,X.[Valor]
		,X.[ValorIOF]
		,X.[CodigoNaFonte]
		,X.[TipoDado]
		,X.[SinalLancamento]
		,X.[ExpectativaDeReceita]
		,X.[Arquivo]     
		,X.[DataInicioVigencia]
		,X.[DataFimVigencia]          
		);


/*TODO - Atualização do Saldo Pago*/

/*Atualização do Ponto de Parada, igualando-o ao maior código trabalhado no comando acima*/ 

SET @PontoDeParada = @MaiorCodigo
  
UPDATE ControleDados.PontoParada 
	SET PontoParada = @MaiorCodigo
WHERE NomeEntidade = 'Pagamento_MSREJSAS_Tipo2'
  
  
TRUNCATE TABLE [dbo].[MSREJSAS_TP2_TEMP] 
  

SET @COMANDO = 'INSERT INTO [dbo].[MSREJSAS_TP2_TEMP]  
                   (
						[Codigo],
						[NumeroProposta],
						[NumeroCertificado],
						[DataInicioVigencia],
						[DataFimVigencia],
						[Valor],
						[ValorIOF],
						[DataArquivo],
						[NomeArquivo],
						[NumeroParcela],
						[IDSeguradora],
						[Motivo],
						[TipoArquivo]
				   )
				SELECT [Codigo],
					   [NumeroProposta],
					   [NumeroCertificado],
					   [DataInicioVigencia],
					   [DataFimVigencia],
					   [Valor],
					   [ValorIOF],
					   [DataArquivo],
					   [NomeArquivo],
					   [NumeroParcela],
					   [IDSeguradora],
					   [Motivo],
					   [TipoArquivo]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaPagamento_MSREJSAS_Tipo2] ''''' + @PontoDeParada + ''''''') PRP'                
EXEC (@COMANDO)
  
SELECT @MaiorCodigo = MAX(STA.Codigo)
FROM dbo.MSREJSAS_TP2_TEMP STA    

END


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MSREJSAS_TP2_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[MSREJSAS_TP2_TEMP];
  	      	                                
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH

                

