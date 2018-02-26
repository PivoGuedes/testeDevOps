
CREATE PROCEDURE [Dados].[proc_InsereStatus_STAFCAP_TIPO1] 
AS 										 

BEGIN TRY	

DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(4000) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STAFCAP_TP1_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[STAFCAP_TP1_TEMP];
	
CREATE TABLE [dbo].[STAFCAP_TP1_TEMP](
		[Codigo] [bigint] NOT NULL,
		[NumeroProposta] [varchar](20) NOT NULL,
		[SituacaoProposta] [varchar](3) NULL,
		[SituacaoCobranca] [varchar](3) NULL,
		[TipoMotivo] [smallint] NULL,
		[DataInicioSituacao] [date] NULL,
		[DataArquivo] [date] NULL,
		[NomeArquivo] [varchar](100) NULL,
		[IDSeguradora] smallint DEFAULT(3),
		[TipoArquivo] [varchar](30)
)

 /*Criação de Índices*/  
CREATE CLUSTERED INDEX idx_STASASSE_TP1_TEMP ON STAFCAP_TP1_TEMP 
(
	Codigo ASC
)         

CREATE NONCLUSTERED INDEX idxNCL_STASASSE_TP1_TEMP ON STAFCAP_TP1_TEMP
( 
  NumeroProposta ASC,
  IDSeguradora,
  DataInicioSituacao
)      

CREATE NONCLUSTERED INDEX idxNCL_STASASSE_TP1_Situacao_TEMP ON STAFCAP_TP1_TEMP
( 
  SituacaoProposta
)     

CREATE NONCLUSTERED INDEX idxNCL_STASASSE_TP1_TipoMotivo_TEMP ON STAFCAP_TP1_TEMP
( 
  TipoMotivo
)    

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Status_STAFCAP_TIPO1'

--	SELECT @PontoDeParada = 100

--DECLARE @PontoDeParada AS VARCHAR(400)
--set @PontoDeParada = 0
--DECLARE @MaiorCodigo AS BIGINT
--DECLARE @COMANDO AS NVARCHAR(4000) 
SET @COMANDO = 'INSERT INTO [dbo].[STAFCAP_TP1_TEMP] 
					(	
						[Codigo],
                              [NumeroProposta],
							  [SituacaoProposta],
							  [SituacaoCobranca],
                              [TipoMotivo],
                              [DataInicioSituacao],
                              [DataArquivo],
                              [NomeArquivo],
							  [TipoArquivo]
                         )
                SELECT [CodigoNaFonte],
                      [NumeroProposta],
					  [SituacaoProposta],
					  [SituacaoCobranca],
                      [TipoMotivo],
                      [DataInicioSituacao],
                      [DataArquivo],
                      [NomeArquivo],
					  [TipoArquivo]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaStatus_STAFCAP_TIPO1] ''''' + @PontoDeParada + ''''''') PRP
                '

EXEC (@COMANDO)
 
SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM STAFCAP_TP1_TEMP PRP

                  
SET @COMANDO = ''    

WHILE @MaiorCodigo IS NOT NULL
BEGIN
--    PRINT @MaiorCodigo


/*Inserção das Situações de Propostas Desconhecidas*/
MERGE INTO Dados.SituacaoProposta AS T
USING 
(
	SELECT DISTINCT SituacaoProposta [Sigla], 
		   'Situação Desconhecida' AS SituacaoProposta
    FROM [STAFCAP_TP1_TEMP] PGTO 
    WHERE PGTO.SituacaoProposta IS NOT NULL     
) X
ON T.Sigla = X.[Sigla]
WHEN NOT MATCHED THEN 
	INSERT (Sigla, [Descricao])
	VALUES (X.[Sigla], X.SituacaoProposta);  

/*Inserção das Situações de Cobranças Desconhecidas*/
MERGE INTO Dados.SituacaoCobranca AS T
USING 
(
	SELECT DISTINCT SituacaoCobranca [Sigla], 
		   'Situação Desconhecida' AS SituacaoCobranca
    FROM [STAFCAP_TP1_TEMP] PGTO 
    WHERE PGTO.SituacaoCobranca IS NOT NULL     
) X
ON T.Sigla = X.[Sigla]
WHEN NOT MATCHED THEN 
	INSERT (Sigla, [Descricao])
	VALUES (X.[Sigla], X.SituacaoCobranca);  
        
/*Inserção dos Tipos de Motivos de Proposta Desconhecidos*/
MERGE INTO Dados.TipoMotivo AS T
USING 
(
	SELECT DISTINCT [TipoMotivo] AS Codigo, 
		   'Tipo Motivo Desconhecido' AS [TipoMotivo]
    FROM [STAFCAP_TP1_TEMP] PGTO 
    WHERE PGTO.[TipoMotivo] IS NOT NULL     
) X
ON T.Codigo = X.[Codigo]
WHEN NOT MATCHED THEN 
	INSERT (Codigo, [Nome])
	VALUES (X.Codigo, X.[TipoMotivo]);           


/*Comando de Inserção de Propostas não Recebidas nos Arquivos PRPFCAP*/
MERGE INTO Dados.Proposta AS T
USING 
(
	SELECT PGTO.NumeroProposta, 
		   PGTO.[IDSeguradora],
		   MIN([TipoArquivo]) [TipoDado], 
		   MIN(PGTO.DataArquivo) DataArquivo
    FROM [dbo].[STAFCAP_TP1_TEMP] PGTO
    WHERE PGTO.NumeroProposta IS NOT NULL
    GROUP BY PGTO.NumeroProposta, PGTO.[IDSeguradora]
    ) X
ON T.NumeroProposta = X.NumeroProposta
	AND T.IDSeguradora = X.IDSeguradora
WHEN NOT MATCHED THEN 
	INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
	VALUES (X.NumeroProposta, X.[IDSeguradora], -1, -1, 0, -1, 0, -1, X.TipoDado, X.DataArquivo);

                                            
/*Comando de Inserção de Proposta de Clientes não Localizados - Por Número de Proposta*/
MERGE INTO Dados.PropostaCliente AS T
USING 
(
	SELECT PRP.ID AS [IDProposta], 
		   'Cliente Desconhecido - Proposta Não Recebida' AS [NomeCliente], 
		   MIN([TipoArquivo]) [TipoDado], 
		   MAX(PGTO.[DataArquivo]) [DataArquivo]
	FROM [STAFCAP_TP1_TEMP] PGTO
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
              
			    
/*Apaga a Marcação do LastValue das Propostas Recebidas para Atualização da Ultima Posição - Após a Insrrção das Situações - Abaixo*/
UPDATE Dados.PropostaSituacao 
	SET LastValue = 0
--SELECT *
FROM Dados.PropostaSituacao PS
WHERE PS.IDProposta IN 
(
	SELECT PRP.ID
	FROM Dados.Proposta PRP                      
	INNER JOIN dbo.[STAFCAP_TP1_TEMP] PGTO
	ON PGTO.NumeroProposta = PRP.NumeroProposta
		AND PGTO.IDSeguradora = PRP.IDSeguradora  
		AND PS.DataInicioSituacao < PGTO.DataInicioSituacao
	--	WHERE PRP.ID = PS.IDProposta
)
AND PS.LastValue = 1
          

/*Comando para Inserção dos Status Recebidos no Arquivo do STFCAP - Tipo1*/             
MERGE INTO Dados.PropostaSituacao AS T
USING 
(
	SELECT PRP.ID AS [IDProposta], 
		   TM.ID AS [IDMotivo], 
		   STPRP.ID AS [IDSituacaoProposta],
		   PGTO.DataInicioSituacao, 
		   MAX(PGTO.DataArquivo) AS DataArquivo,
		   MAX(ISNULL([TipoArquivo], 'Desconhecido')) AS TipoDado
	FROM [dbo].[STAFCAP_TP1_TEMP] PGTO
	INNER JOIN Dados.Proposta PRP
	ON PGTO.NumeroProposta = PRP.NumeroProposta
		AND PGTO.IDSeguradora = PRP.IDSeguradora
	INNER JOIN Dados.TipoMotivo TM
	ON PGTO.TipoMotivo = TM.Codigo
	INNER JOIN Dados.SituacaoProposta STPRP
	ON PGTO.SituacaoProposta = STPRP.Sigla          
	GROUP BY PRP.ID, 
			 TM.ID, 
			 STPRP.ID,
			 PGTO.DataInicioSituacao	   
) AS X
ON      X.[IDProposta] = T.[IDProposta]   
	AND X.[DataInicioSituacao] = T.[DataInicioSituacao]
	AND X.[IDSituacaoProposta] = T.[IDSituacaoProposta]
	AND ISNULL(X.[IDMotivo], -1) = ISNULL(T.[IDMotivo], -1)
WHEN MATCHED THEN 
	UPDATE
		SET [IDMotivo] = COALESCE(X.[IDMotivo],T.[IDMotivo]),
            [DataArquivo] = X.[DataArquivo],
            [TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
WHEN NOT MATCHED THEN 
	INSERT ([IDProposta],[IDMotivo],[IDSituacaoProposta],[DataArquivo], 
			[DataInicioSituacao],[TipoDado],[LastValue])
    VALUES (X.[IDProposta],X.[IDMotivo],X.[IDSituacaoProposta],X.[DataArquivo],     
            X.[DataInicioSituacao],X.[TipoDado],0); 


/*Atualização da Marcação do LastValue das Propostas Recebidas Buscando o Último Status*/
WITH Dados AS 
(
SELECT DISTINCT PRP.ID AS [IDProposta], 
	   PRP.DataSituacao
FROM Dados.Proposta PRP                      
INNER JOIN dbo.[STAFCAP_TP1_TEMP] AS PGTO
ON PGTO.NumeroProposta = PRP.NumeroProposta
	AND PGTO.IDSeguradora = PRP.IDSeguradora  
)  
UPDATE Dados.PropostaSituacao 
	SET LastValue = 1
FROM Dados
CROSS APPLY 
(
    SELECT TOP 1 ID
	FROM Dados.PropostaSituacao PS1
	WHERE PS1.IDProposta =  Dados.IDProposta
		AND ISNULL(PS1.DataInicioSituacao, '0001-01-01') > ISNULL(Dados.DataSituacao, '0001-01-01') --Garante Última Situação + Recente
	ORDER BY [IDProposta] ASC, [DataInicioSituacao] DESC,	[IDSituacaoProposta] ASC
) LastValue 
INNER JOIN Dados.PropostaSituacao PS
ON PS.ID = LastValue.ID;
    

/*Atualização da Propostas com o Último Status Recebido*/
UPDATE Dados.Proposta 
	SET IDSituacaoProposta = PS.IDSituacaoProposta, 
		DataSituacao = PS.DataInicioSituacao, 
		IDTipoMotivo = PS.IDMotivo,
		DataArquivo = PRP.DataArquivo   
--SELECT *
FROM Dados.Proposta PRP
INNER JOIN Dados.PropostaSituacao PS
ON PS.IDProposta = PRP.ID                      
WHERE PS.LastValue = 1
AND EXISTS 
(
	SELECT *
	FROM dbo.[STAFCAP_TP1_TEMP] PGTO
	WHERE PGTO.NumeroProposta = PRP.NumeroProposta
		AND PGTO.IDSeguradora = PRP.IDSeguradora
)  

--######################################################################################################################################################
-- NÃO SE APLICA A CAPITALIZAÇÃO OU PREVIDÊNCIA, JÁ QUE OS MESMOS NÃO POSSUEM CONTRATO, SENDO O TÍTULO/CERTIFICADO OS PAPEIS CONTRATUAIS
--######################################################################################################################################################
------------/*Atualização dos Dados de IDSituacaoProposta, DataSituacao e IDTipoMotivo = Contrato pode estar vinculado a mais de uma proposta*/
------------;WITH DadosUpdateProposta AS
------------(
------------	SELECT  PRP.IDContrato, 
------------		PRP.ID [IDProposta],
------------		PRP.IDSituacaoProposta,
------------		PRP.DataSituacao,
------------		PRP.IDTipoMotivo,
------------		PRP.DataArquivo,
------------		ROW_NUMBER() OVER(PARTITION BY PRP.ID ORDER BY PRP.[ID] ASC, PRP.[DataSituacao] DESC, PRP.[IDSituacaoProposta] ) AS [ORDER]
------------	FROM Dados.Proposta AS PRP
------------	INNER JOIN Dados.ProdutoSIGPF SIGPF
------------	ON SIGPF.ID = PRP.IDProdutoSIGPF
------------	WHERE EXISTS 
------------	(
------------		SELECT * 
------------		FROM dbo.[STAFCAP_TP1_TEMP] PGTO
------------		WHERE PGTO.NumeroProposta = PRP.NumeroProposta
------------		AND (PGTO.IDSeguradora = PRP.IDSeguradora)
------------		--##TODO## VERIFICAR SE A CONDIÇÃO ABAIXO É APLICÁVEL A CAPITALIZAÇÃO
------------		AND (SIGPF.ProdutoComCertificado IS NULL OR SIGPF.ProdutoComCertificado = 0)  --Apenas para Produtos onde não Existe um Contrato "Mãe"
------------	)
------------)
------------UPDATE Dados.Proposta 
------------	SET IDSituacaoProposta = DadosUpdateProposta.IDSituacaoProposta,
------------		DataSituacao = DadosUpdateProposta.DataSituacao ,
------------		IDTipoMotivo = DadosUpdateProposta.IDTipoMotivo
--------------SELECT *
------------FROM Dados.Proposta PRP	
------------INNER JOIN DadosUpdateProposta
------------ON PRP.IDContrato = DadosUpdateProposta.IDContrato
------------AND DadosUpdateProposta.[ORDER] = 1
------------WHERE PRP.ID <>  DadosUpdateProposta.IDProposta	 --Propostas secundárias do contrato

------------/*Atualização do Código do Produto da Proposta, Buscando o Produto da Emissão - (Endosso)*/
------------UPDATE Dados.Proposta 
------------	SET IDProduto = EN.IDProduto
------------FROM Dados.Proposta AS P
------------INNER JOIN Dados.Contrato AS CN
------------ON P.IDContrato = CN.ID
------------CROSS APPLY 
------------(
------------	SELECT IDProduto
------------	FROM Dados.Endosso EN
------------	WHERE IDContrato IN
------------	(
------------		SELECT IDContrato
------------		FROM Dados.Endosso AS EN
------------		WHERE CN.ID = EN.IDContrato
------------			AND EN.IDProduto <> -1
------------		GROUP BY IDContrato, IDProduto 
------------		HAVING COUNT(DISTINCT IDProduto) = 1
------------	)
------------) EN 
------------WHERE P.IDProduto = -1
------------AND EXISTS 
------------(
------------SELECT * 
------------FROM dbo.[STAFCAP_TP1_TEMP] PGTO
------------WHERE PGTO.NumeroProposta = P.NumeroProposta
------------	AND PGTO.IDSeguradora = P.IDSeguradora 
------------)

--######################################################################################################################################################

----------------------------------------------
--/*Atualização dos Títulos de Capitalização*/
----------------------------------------------
--MERGE INTO Dados.PropostaCapitalizacaoTitulo AS T
--USING 
--(
--SELECT PRP.ID AS IDProposta,
--	   [NumeroOrdemTitular],
--	   [NumeroTitulo], --Não,
--	   [SerieTitulo], --Não,
--	   [DigitoNumeroTitulo],
--	   [SituacaoTitulo],
--	   [DataInicioSituacaoTitulo],
--	   [DataPostagemTitulo],
--	   P.[DataInicioVigencia],
--	   [DataInicioSorteio],
--	   [NumeroCombinacao],
--	   [ValorTitulo],
--	   [CodigoPlanoSUSEP],
--	   [MotivoSituacaoTitulo]
--FROM [dbo].[STAFCAP_TP1_TEMP] P
--INNER JOIN Dados.Proposta PRP
--ON P.NumeroProposta = PRP.NumeroProposta
--	AND P.IDSeguradora = PRP.IDSeguradora
--) AS X
--ON T.IDProposta = X.IDProposta
--and T.NumeroTitulo = X.NumeroTitulo
--and T.SerieTitulo = X.SerieTitulo
--and T.DigitoNumeroTitulo = x.DigitoNumeroTitulo
--and T.DataInicioVigencia = X.DataInicioVigencia
--and t.SituacaoTitulo = x.SituacaoTitulo
--and T.[DataInicioSituacaoTitulo] = X.[DataInicioSituacaoTitulo]

--WHEN MATCHED THEN 
--	UPDATE
--		SET [NumeroOrdemTitular] = COALESCE(X.[NumeroOrdemTitular],T.[NumeroOrdemTitular]),
--			[DigitoNumeroTitulo] = COALESCE(X.[DigitoNumeroTitulo],T.[DigitoNumeroTitulo]),
--			[SituacaoTitulo] = COALESCE(X.[SituacaoTitulo],T.[SituacaoTitulo]),
--			[DataInicioSituacaoTitulo] = COALESCE(X.[DataInicioSituacaoTitulo],T.[DataInicioSituacaoTitulo]),
--			[DataPostagemTitulo] = COALESCE(X.[DataPostagemTitulo],T.[DataPostagemTitulo]),
--			[DataInicioVigencia] = COALESCE(X.[DataInicioVigencia],T.[DataInicioVigencia]),
--			[NumeroCombinacao] = COALESCE(X.[NumeroCombinacao],T.[NumeroCombinacao]),
--            [ValorTitulo] = COALESCE(X.[ValorTitulo],T.[ValorTitulo]),
--            [CodigoPlanoSUSEP] = COALESCE(X.[CodigoPlanoSUSEP],T.[CodigoPlanoSUSEP]),
--            [MotivoSituacaoTitulo] = COALESCE(X.[MotivoSituacaoTitulo],T.[MotivoSituacaoTitulo])
            
--WHEN NOT MATCHED THEN 
--	INSERT ([NumeroOrdemTitular],[NumeroTitulo],[SerieTitulo],[DigitoNumeroTitulo],[SituacaoTitulo],[DataInicioSituacaoTitulo],
--	        [DataPostagemTitulo],[DataInicioVigencia],[DataInicioSorteio],[NumeroCombinacao],[ValorTitulo],
--	        [CodigoPlanoSUSEP],[MotivoSituacaoTitulo])
--    VALUES (x.[NumeroOrdemTitular],x.[NumeroTitulo],x.[SerieTitulo],x.[DigitoNumeroTitulo],x.[SituacaoTitulo],x.[DataInicioSituacaoTitulo],
--	        x.[DataPostagemTitulo],x.[DataInicioVigencia],x.[DataInicioSorteio],x.[NumeroCombinacao],x.[ValorTitulo],
--	        x.[CodigoPlanoSUSEP],x.[MotivoSituacaoTitulo]); 
  
/*Atualização do Ponto de Parada, Igualando-o ao Maior Código Trabalhado no Comando Acima*/
SET @PontoDeParada = @MaiorCodigo
 
UPDATE ControleDados.PontoParada 
SET PontoParada = @MaiorCodigo
WHERE NomeEntidade = 'Status_STAFCAP_TIPO1'
  
TRUNCATE TABLE [dbo].[STAFCAP_TP1_TEMP]  

SET @COMANDO = 'INSERT INTO [dbo].[STAFCAP_TP1_TEMP] 
					(	
						[Codigo],
                              [NumeroProposta],
							  [SituacaoProposta],
							  [SituacaoCobranca],
                              [TipoMotivo],
                              [DataInicioSituacao],
                              [DataArquivo],
                              [NomeArquivo],
							  [TipoArquivo]
                         )
                SELECT [CodigoNaFonte],
                      [NumeroProposta],
					  [SituacaoProposta],
					  [SituacaoCobranca],
                      [TipoMotivo],
                      [DataInicioSituacao],
                      [DataArquivo],
                      [NomeArquivo],
					  [TipoArquivo]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaStatus_STAFCAP_TIPO1] ''''' + @PontoDeParada + ''''''') PRP
                '

EXEC (@COMANDO) 
                
SELECT @MaiorCodigo = MAX(PRP.Codigo)
FROM dbo.STAFCAP_TP1_TEMP PRP  
  
END
               
END TRY                
BEGIN CATCH
  	
EXEC CleansingKit.dbo.proc_RethrowError	
-- RETURN @@ERROR	
 
END CATCH

-- EXEC [Dados].[proc_InserePagamento_STAFCAP_TIPO1] 
