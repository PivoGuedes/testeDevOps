
CREATE PROCEDURE [Dados].[proc_InsereStatus_MSREJSAS_Tipo1]
AS
 
BEGIN TRY	

DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(4000) 


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MSREJSAS_TP1_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[MSREJSAS_TP1_TEMP];
	
CREATE TABLE [dbo].[MSREJSAS_TP1_TEMP]
(
	[Codigo] [bigint] NOT NULL,
	[NumeroProposta] [varchar](20) NULL,
	[SituacaoProposta] [varchar](3) NULL,
	[TipoMotivo] [varchar](3) NULL,
	[DataInicioSituacao] [date] NULL,
	[SequencialArquivo] [int] NULL,
	[SequencialProposta] [int] NULL,
	[DataArquivo] [date] NULL,
	[NomeArquivo] [nvarchar](100) NULL,
	[Motivo] [char](3) NULL,
	[DataHoraProcessamento] [datetime2](7) NOT NULL,
	[TipoArquivo] VARCHAR(30) NOT NULL,
	[IDSeguradora] SMALLINT DEFAULT(1)
)

 /*Cria de alguns Índices*/  
CREATE CLUSTERED INDEX idx_MSREJSAS_TP1_TEMP ON MSREJSAS_TP1_TEMP
( 
  Codigo ASC
)         


CREATE NONCLUSTERED INDEX idxNCL_MSREJSAS_TP1_TEMP ON MSREJSAS_TP1_TEMP
( 
  NumeroProposta ASC,
  IDSeguradora,
  DataInicioSituacao
)      

CREATE NONCLUSTERED INDEX idxNCL_MSREJSAS_TP1_Situacao_TEMP ON MSREJSAS_TP1_TEMP
( 
  SituacaoProposta
)     

CREATE NONCLUSTERED INDEX idxNCL_MSREJSAS_TP1_TipoMotivo_TEMP ON MSREJSAS_TP1_TEMP
( 
  TipoMotivo
)     

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Status_MSREJSAS_TIPO1'

--SET @PontoDeParada = 0

/*********************************************************************************************************************/               
/*Recuperação do Maior Código do Retorno*/
/*********************************************************************************************************************/

/*                
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(4000) 
*/

SET @COMANDO = 'INSERT INTO [dbo].[MSREJSAS_TP1_TEMP] 
							(
                              [Codigo],
							  [NumeroProposta],
							  [SituacaoProposta],
							  [TipoMotivo],
							  [DataInicioSituacao],
							  [SequencialArquivo],
							  [SequencialProposta],
							  [DataArquivo],
							  [NomeArquivo],
							  [Motivo],
							  [DataHoraProcessamento],
							  [TipoArquivo]
                            )


                SELECT [CodigoNaFonte],
                       [NumeroProposta],
					   [SituacaoProposta],
					   [TipoMotivo],
					   [DataInicioSituacao],
					   [SequencialArquivo],
					   [SequencialProposta],
					   [DataArquivo],
					   [NomeArquivo],
					   [Motivo],
					   [DataHoraProcessamento],
					   [TipoArquivo]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaStatus_MSREJSAS_Tipo1] ''''' + @PontoDeParada + ''''''') PRP
                '

EXEC (@COMANDO)
 
SELECT @MaiorCodigo = MAX(PRP.Codigo)
FROM MSREJSAS_TP1_TEMP PRP
                 
/*********************************************************************************************************************/
/*********************************************************************************************************************/
                
SET @COMANDO = ''    

WHILE @MaiorCodigo IS NOT NULL
BEGIN
--    PRINT @MaiorCodigo


/*Insere Situações de Propostas Desconhecidas*/
MERGE INTO Dados.SituacaoProposta AS T
USING 
(
	SELECT DISTINCT SituacaoProposta [Sigla], 
					'Situação Desconhecida' AS SituacaoProposta
	FROM [MSREJSAS_TP1_TEMP] PGTO 
	WHERE PGTO.SituacaoProposta IS NOT NULL     
) X
ON T.Sigla = X.[Sigla]
WHEN NOT MATCHED THEN 
	INSERT (Sigla, [Descricao])
	VALUES (X.[Sigla], X.SituacaoProposta);  
	                           	               
	               
/*Insere Tipo Motivo de Proposta Desconhecidos*/
MERGE INTO  Dados.TipoMotivo AS T
USING 
(
	SELECT DISTINCT [TipoMotivo] Codigo, 
					'Tipo Motivo Desconhecido' AS [TipoMotivo]
    FROM [MSREJSAS_TP1_TEMP] PGTO 
    WHERE PGTO.[TipoMotivo] IS NOT NULL     
) X
ON T.Codigo = X.[Codigo]
WHEN NOT MATCHED
	    THEN INSERT (Codigo, [Nome])
	        VALUES (X.Codigo, X.[TipoMotivo]);              	               	               
	            
					 					     
/*Comando para Inserir Propostas não Recebidas*/
MERGE INTO Dados.Proposta AS T
USING 
(
	SELECT PGTO.NumeroProposta, 
		   PGTO.[IDSeguradora], 
		   MIN(PGTO.[TipoArquivo]) [TipoDado],
		   MIN(PGTO.DataArquivo) DataArquivo
	FROM [dbo].[MSREJSAS_TP1_TEMP] PGTO
	WHERE PGTO.NumeroProposta IS NOT NULL
	GROUP BY PGTO.NumeroProposta, PGTO.[IDSeguradora]
) X
ON T.NumeroProposta = X.NumeroProposta
AND T.IDSeguradora = X.IDSeguradora
WHEN NOT MATCHED THEN 
	INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
	VALUES (X.NumeroProposta, X.[IDSeguradora], -1, -1, 0, -1, 0, -1, X.TipoDado, X.DataArquivo);

				                                               
/*Insere Propostas de Clientes não Localizados - Por Número de Proposta*/
MERGE INTO Dados.PropostaCliente AS T
USING 
(
	SELECT PRP.ID AS [IDProposta], 
			'Cliente Desconhecido - Proposta não Recevida' AS [NomeCliente], 
			MIN(PGTO.[TipoArquivo]) AS [TipoDado], 
			MAX(PGTO.[DataArquivo]) AS [DataArquivo]
	FROM [MSREJSAS_TP1_TEMP] PGTO
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
                 

/*Apaga a Marcação do LastValue das Propostas Recebidas para Atualização
 da última Posição -> Logo Depois da Inserção das Situações (Abaixo)*/
UPDATE Dados.PropostaSituacao 
	SET LastValue = 0
--SELECT *
FROM Dados.PropostaSituacao PS
WHERE PS.IDProposta IN 
(
SELECT PRP.ID
FROM Dados.Proposta PRP                      
INNER JOIN dbo.[MSREJSAS_TP1_TEMP] PGTO
ON PGTO.NumeroProposta = PRP.NumeroProposta
	AND PGTO.IDSeguradora = PRP.IDSeguradora  
	AND PS.DataInicioSituacao < PGTO.DataInicioSituacao
)
AND PS.LastValue = 1
           

/*Comando para Inserção dos Status Recebidos*/     
MERGE INTO Dados.PropostaSituacao AS T
USING 
	(
	SELECT PRP.ID [IDProposta], 
		   TM.ID [IDMotivo], 
		   STPRP.ID [IDSituacaoProposta],
		   PGTO.DataInicioSituacao, 
		   MAX(PGTO.DataArquivo) AS DataArquivo,
		   MAX(ISNULL(PGTO.TipoArquivo, 'Desconhecido')) AS TipoDado
	FROM [dbo].[MSREJSAS_TP1_TEMP] PGTO
	INNER JOIN Dados.Proposta PRP
	ON PGTO.NumeroProposta = PRP.NumeroProposta
	AND PGTO.IDSeguradora = PRP.IDSeguradora
	INNER JOIN Dados.TipoMotivo TM
	ON PGTO.TipoMotivo = TM.Codigo
	INNER JOIN Dados.SituacaoProposta STPRP
	ON PGTO.SituacaoProposta = STPRP.Sigla          
	GROUP BY PRP.ID, TM.ID, STPRP.ID , PGTO.DataInicioSituacao	   
) AS X
ON X.[IDProposta] = T.[IDProposta]   
	AND X.[DataInicioSituacao] = T.[DataInicioSituacao]
	AND X.[IDSituacaoProposta] = T.[IDSituacaoProposta]
	AND ISNULL(X.[IDMotivo], -1) = ISNULL(T.[IDMotivo], -1)
WHEN MATCHED THEN 
	UPDATE
		SET [IDMotivo] = COALESCE(X.[IDMotivo],T.[IDMotivo]),
			[DataArquivo] = X.[DataArquivo],
			[TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
WHEN NOT MATCHED THEN 
	INSERT ([IDProposta],[IDMotivo],[IDSituacaoProposta],[DataArquivo],[DataInicioSituacao],[TipoDado],[LastValue])
	VALUES (X.[IDProposta],X.[IDMotivo],X.[IDSituacaoProposta],X.[DataArquivo],X.[DataInicioSituacao],X.[TipoDado],0
); 


/*Atualização da Marcação do LastValue das Propostas Recebidas Buscando o Último Status*/
WITH DadoLastValueProposta 
AS 
(
	SELECT DISTINCT PRP.ID [IDProposta], PRP.DataSituacao
	FROM Dados.Proposta PRP                      
	INNER JOIN dbo.[MSREJSAS_TP1_TEMP] PGTO
	ON PGTO.NumeroProposta = PRP.NumeroProposta
	AND PGTO.IDSeguradora = PRP.IDSeguradora  
) 
UPDATE Dados.PropostaSituacao 
	SET LastValue = 1
FROM  DadoLastValueProposta
CROSS APPLY (SELECT TOP 1 ID
FROM Dados.PropostaSituacao PS1
WHERE PS1.IDProposta = DadoLastValueProposta.IDProposta
	AND ISNULL(PS1.DataInicioSituacao, '0001-01-01') > ISNULL(DadoLastValueProposta.DataSituacao, '0001-01-01') 
ORDER BY [IDProposta] ASC, [DataInicioSituacao] DESC, [IDSituacaoProposta] ASC) LastValue 
INNER JOIN Dados.PropostaSituacao PS
ON PS.ID = LastValue.ID;
    
/*Atualização da Proposta com o Último Status Recebido*/   
UPDATE Dados.Proposta 
	SET IDSituacaoProposta = PS.IDSituacaoProposta, 
		DataSituacao = PS.DataInicioSituacao, 
		IDTipoMotivo = PS.IDMotivo  
--SELECT *
FROM Dados.Proposta PRP
INNER JOIN Dados.PropostaSituacao PS
ON PS.IDProposta = PRP.ID                      
WHERE PS.LastValue = 1
AND EXISTS (SELECT *
FROM dbo.[MSREJSAS_TP1_TEMP] PGTO
WHERE PGTO.NumeroProposta = PRP.NumeroProposta
AND PGTO.IDSeguradora = PRP.IDSeguradora)  

/*Atualização dos Dados de IDSituacaoProposta, DataSituacao e IDTipoMotivo*/
/*Contrato pode estar vinculado a mais de uma Proposta, por isso estamos Buscando a Proposta mais atual 
e realizando a Atualização de todas as outras.*/
;WITH DadosUpdateProposta AS
(
	SELECT  PRP.IDContrato, 
	PRP.ID [IDProposta],
	PRP.IDSituacaoProposta,
	PRP.DataSituacao,
	PRP.IDTipoMotivo,
	PRP.DataArquivo,
	ROW_NUMBER() OVER(PARTITION BY PRP.ID ORDER BY PRP.[ID] ASC,PRP.[DataSituacao] DESC, PRP.[IDSituacaoProposta] 
) AS [ORDER]
FROM Dados.Proposta AS PRP
INNER JOIN Dados.ProdutoSIGPF SIGPF
ON SIGPF.ID = PRP.IDProdutoSIGPF
WHERE  EXISTS 
(
SELECT * 
FROM dbo.[MSREJSAS_TP1_TEMP] PGTO
WHERE PGTO.NumeroProposta = PRP.NumeroProposta
AND PGTO.IDSeguradora = PRP.IDSeguradora
)
AND (SIGPF.ProdutoComCertificado IS NULL 
OR SIGPF.ProdutoComCertificado = 0)
)
UPDATE Dados.Proposta 
SET IDSituacaoProposta = DadosUpdateProposta.IDSituacaoProposta,
DataSituacao = DadosUpdateProposta.DataSituacao ,
IDTipoMotivo = DadosUpdateProposta.IDTipoMotivo
FROM Dados.Proposta PRP
INNER JOIN DadosUpdateProposta
ON PRP.IDContrato = DadosUpdateProposta.IDContrato
AND DadosUpdateProposta.[ORDER] = 1
WHERE PRP.ID <> DadosUpdateProposta.IDProposta


/*Atualização do Código do Produto da Proposta, Buscando o Produto da Emissão - Endosso*/
UPDATE Dados.Proposta SET IDProduto = EN.IDProduto
--SELECT *
FROM Dados.Proposta AS P
INNER JOIN Dados.Contrato AS CN
ON P.IDContrato = CN.ID
CROSS APPLY
(
	SELECT IDProduto
	FROM Dados.Endosso AS EN
	WHERE IDContrato IN
						(
						  SELECT IDContrato
						  FROM Dados.Endosso AS EN
						  WHERE CN.ID = EN.IDContrato
							AND EN.IDProduto <> -1
						  GROUP BY IDContrato, IDProduto 
						  HAVING COUNT(DISTINCT IDProduto) = 1
						)
) EN 
WHERE P.IDProduto = -1
	AND EXISTS 
		(
		    SELECT * 
	        FROM dbo.[MSREJSAS_TP1_TEMP] PGTO
			WHERE PGTO.NumeroProposta = P.NumeroProposta
				AND PGTO.IDSeguradora = P.IDSeguradora 
		)


/*Atualização do Ponto de Parada, Igualando-o ao Maior 
Código Trabalhado no Comando Acima*/
SET @PontoDeParada = @MaiorCodigo

UPDATE ControleDados.PontoParada 
	SET PontoParada = @MaiorCodigo
WHERE NomeEntidade = 'Status_MSREJSAS_TIPO1'

TRUNCATE TABLE [dbo].[MSREJSAS_TP1_TEMP]  

SET @COMANDO = 'INSERT INTO [dbo].[MSREJSAS_TP1_TEMP] 
							(
                              [Codigo],
							  [NumeroProposta],
							  [SituacaoProposta],
							  [TipoMotivo],
							  [DataInicioSituacao],
							  [SequencialArquivo],
							  [SequencialProposta],
							  [DataArquivo],
							  [NomeArquivo],
							  [Motivo],
							  [DataHoraProcessamento],
							  [TipoArquivo]
                            )


                SELECT [CodigoNaFonte],
                       [NumeroProposta],
					   [SituacaoProposta],
					   [TipoMotivo],
					   [DataInicioSituacao],
					   [SequencialArquivo],
					   [SequencialProposta],
					   [DataArquivo],
					   [NomeArquivo],
					   [Motivo],
					   [DataHoraProcessamento],
					   [TipoArquivo]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaStatus_MSREJSAS_Tipo1] ''''' + @PontoDeParada + ''''''') PRP
                '

SELECT @MaiorCodigo = MAX(PRP.Codigo)
FROM dbo.MSREJSAS_TP1_TEMP PRP  
  
END
                 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MSREJSAS_TP1_TEMP]') AND type in (N'U'))
	DROP TABLE [dbo].[MSREJSAS_TP1_TEMP];    
	
END TRY         
BEGIN CATCH
  	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
 
END CATCH

--	EXEC [Dados].[proc_InsereStatus_MSREJSAS_Tipo1] 
