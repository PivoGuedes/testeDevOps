
/*
	Autor: Egler Vieira
	Data Criação: 16/08/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereStatus_STASASSE_TIPO1
	Descrição: Procedimento que realiza a inserção dos lançamentos de MOVIMENTAÇÃO DE STATUS de propostas no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InsereStatus_STASASSE_TIPO1] as 
BEGIN TRY	
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(4000) 


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STASASSE_TP1_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[STASASSE_TP1_TEMP];
	
CREATE TABLE [dbo].[STASASSE_TP1_TEMP](
	[Codigo] [bigint] NOT NULL,
	[NumeroProposta] [varchar](20) NOT NULL,
	[TipoMotivo] [smallint] NULL,
	[SituacaoProposta] [varchar](3) NULL,
	[DataInicioSituacao] [date] NULL,
	[DataArquivo] [date] NULL,
	[TipoDado] [varchar](30) NULL,
	[IDSeguradora] smallint DEFAULT(1)
)

 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_STASASSE_TP1_TEMP ON STASASSE_TP1_TEMP
( 
  Codigo ASC
)         


CREATE NONCLUSTERED INDEX idxNCL_STASASSE_TP1_TEMP ON STASASSE_TP1_TEMP
( 
  NumeroProposta ASC,
  IDSeguradora,
  DataInicioSituacao
)      

CREATE NONCLUSTERED INDEX idxNCL_STASASSE_TP1_Situacao_TEMP ON STASASSE_TP1_TEMP
( 
  SituacaoProposta
)     

CREATE NONCLUSTERED INDEX idxNCL_STASASSE_TP1_TipoMotivo_TEMP ON STASASSE_TP1_TEMP
( 
  TipoMotivo
)     

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Status_STASASSE_TIPO1'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
      /*                DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(4000) 
*/
SET @COMANDO = 'INSERT INTO [dbo].[STASASSE_TP1_TEMP] (
                            	[Codigo],
                              [NumeroProposta],
                              [TipoMotivo],
                              [SituacaoProposta],
                              [DataInicioSituacao],
                              [DataArquivo],
                              [TipoDado]
                         )
                SELECT [CodigoNaFonte],
                      [NumeroProposta],
                      [TipoMotivo],
                      [SituacaoProposta],
                      [DataInicioSituacao],
                      [DataArquivo],
                      [TipoArquivo]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaStatus_STASASSE_TIPO1] ''''' + @PontoDeParada + ''''''') PRP
                '

EXEC (@COMANDO)
 

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM STASASSE_TP1_TEMP PRP

                  
/*********************************************************************************************************************/
                  
SET @COMANDO = ''    

WHILE @MaiorCodigo IS NOT NULL
BEGIN
--    PRINT @MaiorCodigo


 
     /*INSERE SITUAÇÕES DE PROPOSTA DESCONHECIDAS*/
    MERGE INTO  Dados.SituacaoProposta AS T
      USING (SELECT DISTINCT SituacaoProposta [Sigla], 'SITUAÇÃO DESCONHECIDA' SituacaoProposta
          FROM [STASASSE_TP1_TEMP] PGTO 
          WHERE PGTO.SituacaoProposta IS NOT NULL     
            ) X
      ON T.Sigla = X.[Sigla]
     WHEN NOT MATCHED
	          THEN INSERT (Sigla, [Descricao])
	               VALUES (X.[Sigla], X.SituacaoProposta);  
	                           	               
	               
     /*INSERE TIPO MOTIVO DE PROPOSTA DESCONHECIDOS*/
    MERGE INTO  Dados.TipoMotivo AS T
      USING (SELECT DISTINCT [TipoMotivo] Codigo, 'TIPO MOTIVO DESCONHECIDO' [TipoMotivo]
          FROM [STASASSE_TP1_TEMP] PGTO 
          WHERE PGTO.[TipoMotivo] IS NOT NULL     
            ) X
      ON T.Codigo = X.[Codigo]
     WHEN NOT MATCHED
	          THEN INSERT (Codigo, [Nome])
	               VALUES (X.Codigo, X.[TipoMotivo]);              	               	               
	               
	               
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir propostas não recebidas nos arquivos PRPSASSE
    -----------------------------------------------------------------------------------------------------------------------

      MERGE INTO Dados.Proposta AS T
	      USING (SELECT PGTO.NumeroProposta, PGTO.[IDSeguradora], MIN(PGTO.[TipoDado]) [TipoDado], MIN(PGTO.DataArquivo) DataArquivo
               FROM [dbo].[STASASSE_TP1_TEMP] PGTO
               WHERE PGTO.NumeroProposta IS NOT NULL
               GROUP BY PGTO.NumeroProposta, PGTO.[IDSeguradora]
              ) X
        ON T.NumeroProposta = X.NumeroProposta
        AND T.IDSeguradora = X.IDSeguradora
       WHEN NOT MATCHED
		          THEN INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
		               VALUES (X.NumeroProposta, X.[IDSeguradora], -1, -1, 0, -1, 0, -1, X.TipoDado, X.DataArquivo);
					                                               
	-----------------------------------------------------------------------------------------------------------------------


    /*INSERE PROPOSTAS CLIENTE NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
    MERGE INTO Dados.PropostaCliente AS T
      USING (SELECT PRP.ID [IDProposta], 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' [NomeCliente], MIN(PGTO.[TipoDado]) [TipoDado], MAX(PGTO.[DataArquivo]) [DataArquivo]
          FROM [STASASSE_TP1_TEMP] PGTO
          INNER JOIN Dados.Proposta PRP
          ON PRP.NumeroProposta = PGTO.NumeroProposta
          AND PRP.IDSeguradora = PGTO.IDSeguradora
          WHERE PGTO.NumeroProposta IS NOT NULL
          GROUP BY PRP.ID
            ) X
      ON T.IDProposta = X.IDProposta
     WHEN NOT MATCHED
            THEN INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
                 VALUES (X.IDProposta, [TipoDado], X.[NomeCliente], X.[DataArquivo]);   
                 

    /*Apaga a marcação LastValue das propostas recebidas para atualizar a última posição -> logo depois da inserção das Situações (abaixo)*/
    UPDATE Dados.PropostaSituacao SET LastValue = 0
   -- SELECT *
    FROM Dados.PropostaSituacao PS
    WHERE PS.IDProposta IN (SELECT PRP.ID
                            FROM Dados.Proposta PRP                      
                            INNER JOIN dbo.[STASASSE_TP1_TEMP] PGTO
                                   ON PGTO.NumeroProposta = PRP.NumeroProposta
                                  AND PGTO.IDSeguradora = PRP.IDSeguradora  
                                  AND PS.DataInicioSituacao < PGTO.DataInicioSituacao
                            --WHERE PRP.ID = PS.IDProposta
                            )
           AND PS.LastValue = 1
           


    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os Status recebidos no arquivo STASASSE - TIPO - 1
    -----------------------------------------------------------------------------------------------------------------------		             
    MERGE INTO Dados.PropostaSituacao AS T
		USING (
        SELECT 
               PRP.ID [IDProposta], TM.ID [IDMotivo], STPRP.ID [IDSituacaoProposta]
             , PGTO.DataInicioSituacao, MAX(PGTO.DataArquivo) DataArquivo
             , MAX(ISNULL(PGTO.TipoDado, 'DESCONHECIDO')) TipoDado --, PGTO.[Codigo]
        FROM [dbo].[STASASSE_TP1_TEMP] PGTO
          INNER JOIN Dados.Proposta PRP
          ON PGTO.NumeroProposta = PRP.NumeroProposta
          AND PGTO.IDSeguradora = PRP.IDSeguradora
          /*LEFT OUTER JOIN Dados.SituacaoProposta STPRP
          ON PGTO.SituacaoProposta = STPRP.Sigla  */
          INNER JOIN Dados.TipoMotivo TM
          ON PGTO.TipoMotivo = TM.Codigo
          INNER JOIN Dados.SituacaoProposta STPRP
          ON PGTO.SituacaoProposta = STPRP.Sigla          
--WHERE PRP.ID =         9027754 /*TODO - FAZER UM PIVOT E ALIMENTAR MAIS UMA COLUNA DE MOTIVO QUANDO FOR NO MESMO DIA*/
        GROUP BY PRP.ID, TM.ID, STPRP.ID
               , PGTO.DataInicioSituacao	   
          ) AS X
    ON X.[IDProposta] = T.[IDProposta]   
	AND ISNULL(X.[DataInicioSituacao], CAST('1900-01-01' AS DATE)) = ISNULL (T.[DataInicioSituacao], CAST('1900-01-01' AS DATE))
    AND X.[IDSituacaoProposta] = T.[IDSituacaoProposta]
    AND ISNULL(X.[IDMotivo], -1) = ISNULL(T.[IDMotivo], -1)
    WHEN MATCHED
			    THEN UPDATE
				     SET [IDMotivo] = COALESCE(X.[IDMotivo],T.[IDMotivo])
               , [DataArquivo] = X.[DataArquivo]
               , [TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
    WHEN NOT MATCHED
			    THEN INSERT          
              ([IDProposta],  [IDMotivo], [IDSituacaoProposta] 
             , [DataArquivo], [DataInicioSituacao], [TipoDado]
             , LastValue             )
          VALUES (X.[IDProposta]
                 ,X.[IDMotivo]
                 ,X.[IDSituacaoProposta]
                 ,X.[DataArquivo]       
                 ,X.[DataInicioSituacao]    
                 ,X.[TipoDado]
                 ,0
                 ); 
                 
    WITH CTE 
    AS 
    (
     SELECT DISTINCT PRP.ID [IDProposta], PRP.DataSituacao
     FROM Dados.Proposta PRP                      
      INNER JOIN dbo.[STASASSE_TP1_TEMP] PGTO
             ON PGTO.NumeroProposta = PRP.NumeroProposta
            AND PGTO.IDSeguradora = PRP.IDSeguradora  
      )   /*
select *      
    FROM  CTE
    CROSS APPLY (SELECT TOP 1 ID
                 FROM Dados.PropostaSituacao PS1
                 WHERE PS1.IDProposta =  CTE.IDProposta
                 ORDER BY [IDProposta] ASC,
	                        [DataInicioSituacao] DESC,
	                        [IDSituacaoProposta] 
                 ) LASTVALUE  */
           
    /*Atualiza a marcação LastValue das propostas recebidas buscando o último Status*/
    UPDATE Dados.PropostaSituacao SET LastValue = 1
    FROM  CTE
    CROSS APPLY (SELECT TOP 1 ID
                 FROM Dados.PropostaSituacao PS1
                 WHERE PS1.IDProposta =  CTE.IDProposta
                 AND ISNULL(PS1.DataInicioSituacao, '0001-01-01') > ISNULL(CTE.DataSituacao, '0001-01-01') --Garante que a última situação seja a mais recente
                 ORDER BY [IDProposta] ASC,
	                        [DataInicioSituacao] DESC,
	                        [IDSituacaoProposta] 
                 ) LASTVALUE 
    INNER JOIN Dados.PropostaSituacao PS
    ON PS.ID = LASTVALUE.ID;
    
    

     --##############################################################################
	 /*ATUALIZA A PROPOSTA COM O ÚLTIMO STATUS RECEBIDO
	 Autor: Egler Vieira
	 Data: 2013-10-28*/   
	 --############################################################################## 
	 UPDATE Dados.Proposta SET IDSituacaoProposta = PS.IDSituacaoProposta, 
							   DataSituacao = PS.DataInicioSituacao, 
							   IDTipoMotivo = PS.IDMotivo
							   --,DataArquivo = PRP.DataArquivo   
	 --SELECT *
	 FROM Dados.Proposta PRP
	 INNER JOIN Dados.PropostaSituacao PS
	 ON PS.IDProposta = PRP.ID                      
	 WHERE PS.LastValue = 1
	 AND EXISTS (SELECT *
	             FROM dbo.[STASASSE_TP1_TEMP] PGTO
                 WHERE PGTO.NumeroProposta = PRP.NumeroProposta
                   AND PGTO.IDSeguradora = PRP.IDSeguradora)  
    --##############################################################################


	/*************************************************************************************/
	/*Atualização dos Dados de IDSituacaoProposta, DataSituacao e IDTipoMotivo*/
	/*Contrato pode estar vinculado a mais de uma proposta, por isso estamos buscando a proposta mais atual e realizando a atualização de todas as outras.*/
	/*************************************************************************************/			

/*
	;WITH DadosUpdateProposta AS
	(
		SELECT  PRP.IDContrato, 
		        PRP.ID [IDProposta],
				PRP.IDSituacaoProposta,
				PRP.DataSituacao,
				PRP.IDTipoMotivo,
				PRP.DataArquivo,
				ROW_NUMBER() OVER(PARTITION BY PRP.ID ORDER BY PRP.[ID] ASC,
															   PRP.[DataSituacao] DESC,
															   PRP.[IDSituacaoProposta] ) AS [ORDER]
		FROM Dados.Proposta AS PRP
		INNER JOIN Dados.ProdutoSIGPF SIGPF
		ON SIGPF.ID = PRP.IDProdutoSIGPF
		WHERE  EXISTS (SELECT * 
					  FROM dbo.[STASASSE_TP1_TEMP] PGTO
					  WHERE PGTO.NumeroProposta = PRP.NumeroProposta
					AND PGTO.IDSeguradora = PRP.IDSeguradora)
			AND (SIGPF.ProdutoComCertificado IS NULL OR SIGPF.ProdutoComCertificado = 0)   --Faz a operação apenas para produtos onde não existe um contrato "mãe"
			                                                                               --Egler Vieira # 2013/10/28
	--AND C.ID = 5464133
	)
	UPDATE Dados.Proposta 
		SET IDSituacaoProposta = DadosUpdateProposta.IDSituacaoProposta,
			DataSituacao = DadosUpdateProposta.DataSituacao ,
			IDTipoMotivo = DadosUpdateProposta.IDTipoMotivo
	FROM Dados.Proposta PRP
	INNER JOIN DadosUpdateProposta
	ON PRP.IDContrato = DadosUpdateProposta.IDContrato
	AND DadosUpdateProposta.[ORDER] = 1
	WHERE PRP.ID <>  DadosUpdateProposta.IDProposta



*/


/*************************************************************************************/
/*Atualização do Código do Produto da proposta, buscando o Produto da EMISSAO (Endosso)
Egler: 2013-10-14*/
/*************************************************************************************/		
	UPDATE Dados.Proposta SET IDProduto = EN.IDProduto
	FROM Dados.Proposta AS P
	INNER JOIN Dados.Contrato AS CN
	ON P.IDContrato = CN.ID
	cross apply
		(SELECT IDProduto
		 FROM Dados.Endosso EN
		 WHERE IDContrato in
							(
							 SELECT IDContrato
							 FROM Dados.Endosso AS EN
							 WHERE CN.ID = EN.IDContrato
							   AND EN.IDProduto <> -1
							 GROUP BY IDContrato, IDProduto 
							 HAVING COUNT(DISTINCT IDProduto) = 1
							 )
		) EN 
	/*INNER JOIN Dados.Produto AS PRD
	ON PRD.ID = EN.IDProduto
	INNER JOIN Dados.ProdutoSIGPF AS SIGPF
	ON SIGPF.ID = PRD.IDProdutoSIGPF
	WHERE (SIGPF.ProdutoComCertificado = 0 OR SIGPF.ProdutoComCertificado IS NULL) 
		AND SIGPF.ProdutoComContrato = 1*/
	WHERE P.IDProduto = -1
		AND EXISTS (
		            SELECT * 
	                FROM dbo.[STASASSE_TP1_TEMP] PGTO
				    WHERE PGTO.NumeroProposta = P.NumeroProposta
				      AND PGTO.IDSeguradora = P.IDSeguradora 
				   )


   /*
    REMOVIDO PARA ELEVAR O DESEMPENHO. A SITUAÇÃO DO CERTIFICADO SERÁ RESGATADA NA TABELA PROPOSTA

	/*TODO Verificar se é possível atualizar o certificado - 2013/09/19*/
	/*Atualização dos campos de Certificado*/
	/*Criação dos campos - IDSituacaoProposta, DataSitaucao e IDTipoMotivo - 16-10-2013*/

	UPDATE Dados.Certificado 
		SET IDSituacaoProposta = PS.IDSituacaoProposta, 
			DataSituacao = PS.DataInicioSituacao, 
			IDTipoMotivo = PS.IDMotivo
	--SELECT * 
	FROM Dados.Proposta AS PRP
	INNER JOIN Dados.Certificado AS C
	ON PRP.ID = C.IDProposta                
	INNER JOIN dbo.[STASASSE_TP1_TEMP] PGTO
	ON PGTO.NumeroProposta = PRP.NumeroProposta
		AND PGTO.IDSeguradora = PRP.IDSeguradora  
	INNER JOIN Dados.PropostaSituacao PS
	ON PRP.ID = PS.IDProposta
	AND PS.LastValue = 1;    
  -----------------------------------------------------------------------------------------------------------------------		           
   */

  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
 --print '@MaiorCodigo' 
 --print @MaiorCodigo
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Status_STASASSE_TIPO1'
  /*************************************************************************************/
   
  
  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[STASASSE_TP1_TEMP]  
  /*********************************************************************************************************************/

  SET @COMANDO = 'INSERT INTO [dbo].[STASASSE_TP1_TEMP] (
                            	[Codigo],
                              [NumeroProposta],
                              [TipoMotivo],
                              [SituacaoProposta],
                              [DataInicioSituacao],
                              [DataArquivo],
                              [TipoDado]
                         )
                SELECT [CodigoNaFonte],
                      [NumeroProposta],
                      [TipoMotivo],
                      [SituacaoProposta],
                      [DataInicioSituacao],
                      [DataArquivo],
                      [TipoArquivo]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaStatus_STASASSE_TIPO1] ''''' + @PontoDeParada + ''''''') PRP
                '

 
  EXEC (@COMANDO)  
   
                
                
   SELECT @MaiorCodigo= MAX(PRP.Codigo)
   FROM dbo.STASASSE_TP1_TEMP PRP  
  /*********************************************************************************************************************/

  /*********************************************************************************************************************/
  
END
                  /*    
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STASASSE_TP1_TEMP]') AND type in (N'U'))
	DROP TABLE [dbo].[STASASSE_TP1_TEMP];      */
	
END TRY                
BEGIN CATCH
  	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
 
END CATCH

--EXEC [Dados].[proc_InserePagamento_STASASSE_TIPO1] 
