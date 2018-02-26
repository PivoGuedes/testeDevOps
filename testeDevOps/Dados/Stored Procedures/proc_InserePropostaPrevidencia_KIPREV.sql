
/*******************************************************************************
	Nome: CORPORATIVO.Dados.[proc_InserePropostaPrevidencia_BEMFAMILIA]
	Descrição: PROC ainda não está finalizada - 25/08/2015
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
--BEGIN TRAN
--SELECT @@TRANCOUNT
--SELECT * FROM ControleDados.PontoParada WHERE NomeEntidade = 'PropostaPrevidenciaBEMFamilia'
--SELECT * FROM Dados.Proposta WHERE TipoDado='BEMFAMILIA'
--SELECT * FROM Dados.PropostaCliente WHERE TipoDado='BEMFAMILIA'
--ROLLBACK

CREATE PROCEDURE [Dados].[proc_InserePropostaPrevidencia_KIPREV] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Previdencia_KIPREV_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Previdencia_KIPREV_TEMP];

CREATE TABLE [dbo].[Previdencia_KIPREV_TEMP](
	COD_CUENTA varchar(20) 
	,PROPOSTA varchar(20)
	,DT_PROPOSTA date
	,COD_PRODUCTO varchar(10)
	,PRODUTO varchar(200)
	,COD_AGENCIA varchar(10)
	,NOME_AGENCIA varchar(200)
	,COD_SR	varchar(10)
	,SR	varchar(100)
	,FILIAL varchar(100)
	,SUAT varchar(10)
	,SOBREVIDA_CONTRATADO_PM decimal(19,2)
	,RISCO_CONTRATADO_PM decimal(19,2)
	,SOBREVIDA_CONTRATADO_PU decimal(19,2)
	,RISCO_CONTRATADO_PU decimal(19,2)
	,PRAZO varchar(50)
	,SEXO varchar(5)
	,DATA_NASCIMENTO date
	,RENDA_PARTICIPANTE	decimal(19,2)
	,DataArquivo DATE
	,NomeArquivo varchar(200)
	,Codigo	int
);

/* SELECIONA O ÚLTIMO PONTO DE PARADA */
--SELECT *
SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'PropostaPrevidencia_KIPREV'

--BEGIN TRAN UPDATE ControleDados.PontoParada SET PontoParada=0 WHERE NomeEntidade = 'PropostaPrevidencia_KIPREV'
--commit


/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
--    DECLARE @COMANDO AS NVARCHAR(MAX) 
--	 DECLARE @PontoDeParada AS VARCHAR(400) SET @PONTODEPARADA = 0           
    SET @COMANDO = 'INSERT INTO [dbo].[Previdencia_KIPREV_TEMP]
           (COD_CUENTA, PROPOSTA, DT_PROPOSTA, COD_PRODUCTO, PRODUTO, COD_AGENCIA, NOME_AGENCIA, COD_SR, SR, FILIAL, SUAT, SOBREVIDA_CONTRATADO_PM, RISCO_CONTRATADO_PM, SOBREVIDA_CONTRATADO_PU, RISCO_CONTRATADO_PU
			,PRAZO ,SEXO, DATA_NASCIMENTO, RENDA_PARTICIPANTE, DataArquivo, NomeArquivo, Codigo )
		   SELECT  COD_CUENTA, PROPOSTA, DT_PROPOSTA, COD_PRODUCTO, PRODUTO, COD_AGENCIA, NOME_AGENCIA, COD_SR, SR, FILIAL, SUAT, SOBREVIDA_CONTRATADO_PM, RISCO_CONTRATADO_PM, SOBREVIDA_CONTRATADO_PU, RISCO_CONTRATADO_PU
			,PRAZO ,SEXO, DATA_NASCIMENTO, RENDA_PARTICIPANTE, DataArquivo, NomeArquivo, Codigo
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaPrevidencia_KIPREV]''''' + @PontoDeParada + ''''''') PRP '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.Previdencia_KIPREV_TEMP PRP                    

/*********************************************************************************************************************/
                           
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN

 
/**********************************************************************
       Carrega os PRODUTOS desconhecidos

	   SELECT * FROM Dados.ProdutoKIPREV
***********************************************************************/
--SELECT * FROM [dbo].[Previdencia_KIPREV_TEMP]
--begin tran 
--commit
--SELECT * FROM Dados.Produto
--BEGIN TRAN DELETE FROM Dados.Produto FROM Dados.Produto AS P WHERE
--EXISTS (SELECT * FROM Dados.ProdutoKIPREV AS K WHERE K.Codigo=P.CodigoComercializado AND P.ID>400)
--ROLLBACK

--select * from dados.proposta as pp where exists
--(
--SELECT * FROM Dados.Produto AS P
--WHERE 
--EXISTS (SELECT * FROM Dados.ProdutoKIPREV AS K WHERE K.Codigo=P.CodigoComercializado AND P.ID>400) and
--p.id=pp.idproduto
--)

--SELECT * FROM Dados.ProdutoKIPREV AS P
--WHERE EXISTS (SELECT * FROM Dados.ProdutoKIPREV AS K WHERE K.Codigo=P.CodigoComercializado AND P.ID>400)

;MERGE INTO Dados.ProdutoKIPREV AS T
	USING (
			SELECT DISTINCT PRP.COD_PRODUCTO [Codigo], PRODUTO [Descricao]
            FROM dbo.[Previdencia_KIPREV_TEMP] PRP
			WHERE PRP.COD_PRODUCTO IS NOT NULL
          ) X
         ON T.[Codigo] = X.[Codigo] 
       WHEN NOT MATCHED
		          THEN INSERT ([Codigo], Descricao)
		               VALUES (X.[Codigo], X.[Descricao]); 

/***********************************************************************
       Carregar as agencias desconhecidas
***********************************************************************/

/*INSERE PVs NÃO LOCALIZADOS*/
;INSERT INTO Dados.Unidade(Codigo)

SELECT DISTINCT CAD.Cod_Agencia
FROM dbo.[Previdencia_KIPREV_TEMP] CAD
WHERE  CAD.Cod_Agencia IS NOT NULL 
  AND not exists (
                  SELECT     *
                  FROM  Dados.Unidade U
                  WHERE U.Codigo = CAD.Cod_Agencia)                  
                                                        

INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)

SELECT DISTINCT U.ID, 
				'UNIDADE NÃO INFORMADA - DADOS INCOMPLETOS' [Unidade], 
				-1 [CodigoNaFonte], 
				'PREV_KIPREV' [TipoDado], 
				MAX(EM.DataArquivo) [DataArquivo], 
				'PREV_KIPREV' [Arquivo]

FROM dbo.[Previdencia_KIPREV_TEMP] EM
INNER JOIN Dados.Unidade U
ON EM.Cod_Agencia = U.Codigo
WHERE 
    not exists (
                SELECT     *
                FROM Dados.UnidadeHistorico UH
                WHERE UH.IDUnidade = U.ID)    
GROUP BY U.ID
-- SELECT * FROM [Previdencia_KIPREV_TEMP]    
 /**********************************************************************
       Carrega as FILIAIS desconhecidos
***********************************************************************/
;MERGE INTO Dados.FilialPrevidencia AS T
	USING (
			SELECT DISTINCT PRP.[Filial] AS Descricao
            FROM dbo.[Previdencia_KIPREV_TEMP] PRP
			WHERE PRP.[Filial] IS NOT NULL
          ) X
         ON T.Descricao = X.Descricao 
       WHEN NOT MATCHED
		          THEN INSERT (Descricao)
		               VALUES (X.[Descricao]); 
					


/***********************************************************************
       Carrega os dados da Proposta
	   	   begin tran	  
rollback
   select @@trancount


***********************************************************************/ 
 ;MERGE INTO Dados.Proposta AS T
		USING (SELECT DISTINCT
					    4 AS IDSeguradora, 
						PRP_TMP.Proposta AS NumeroProposta,
						MAX(PRP_TMP.DT_Proposta) AS DataProposta,
						MAX(PK.IDProduto) AS [IDProduto],						
						U.ID AS [IDAgenciaVenda],
						sum(COALESCE(Sobrevida_contratado_pm, sobrevida_contratado_pu)) AS [ValorPremioTotal],
						'KIPREV' AS [TipoDado],
						MAX(PRP_TMP.DataArquivo) AS DataArquivo

					  FROM [dbo].[Previdencia_KIPREV_TEMP] PRP_TMP
					    INNER JOIN Dados.Unidade U
							ON U.Codigo = PRP_TMP.Cod_Agencia
						
						INNER JOIN Dados.ProdutoKIPREV AS PK
						ON PK.Codigo=PRP_TMP.COD_Producto
						GROUP BY PRP_TMP.Proposta, U.ID 
				)X
		ON X.NumeroProposta = T.NumeroProposta  
			AND X.IDSeguradora = T.IDSeguradora

			--WHEN MATCHED
			--    THEN UPDATE
			--				SET
			--				  [IDProduto] = COALESCE(X.[IDProduto], T.[IDProduto], -1)
			--				  ,[DataProposta] = COALESCE(X.[DataProposta], T.[DataProposta])
			--				  ,[IDAgenciaVenda] = COALESCE(X.[IDAgenciaVenda], T.[IDAgenciaVenda])
			--				  ,[TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
							  --,[DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo])
							  --,[ValorPremioTotal] = COALESCE(X.[ValorPremioTotal], T.[ValorPremioTotal])
			WHEN NOT MATCHED
			    THEN INSERT (
							  [IDSeguradora]
							  ,[NumeroProposta]
							  ,[IDProduto]
							  ,[DataProposta]
							  ,[IDAgenciaVenda]
							  ,[TipoDado]
							  ,[DataArquivo]
							  ,[ValorPremioTotal] )
				VALUES(X.[IDSeguradora], X.[NumeroProposta], ISNULL(X.[IDProduto],-1),  
						X.[DataProposta],X.[IDAgenciaVenda], X.[TipoDado], 
						X.[DataArquivo], X.[ValorPremioTotal] );
/***********************************************************************
Carrega os dados do certificado da Previdência
***********************************************************************/                 
    ;MERGE INTO Dados.PropostaPrevidenciaKIPREV AS T
		USING (
		       SELECT *
		       FROM
		       (
				SELECT DISTINCT
					PRP1.ID [IDProposta]
					, Prod.IDProdutoKIPREV
					, COD_Cuenta AS CodigoConta
					, PRP.Sobrevida_contratado_pm
					, PRP.Sobrevida_contratado_pu
					, PRP.Risco_contratado_pm
					, PRP.Risco_contratado_PU
					, PRP.Prazo
					, PRP.Renda_Participante
					, PRP.Dt_Proposta AS DataEmissao
					, PRP.DataArquivo
					, F.ID AS IDFilialPrevidencia
					, PRP.NomeArquivo
					,'KIPREV' AS TipoDado
				FROM dbo.[Previdencia_KIPREV_TEMP] PRP
					INNER JOIN Dados.Proposta PRP1
				ON PRP.Proposta = PRP1.NumeroProposta
				AND PRP1.IDSeguradora = 4
				INNER JOIN Dados.FilialPrevidencia AS F
				ON F.Descricao=PRP.Filial
				--INNER JOIN Dados.ProdutoKIPREV AS P
				--ON P.Codigo=PRP.Cod_Producto
				INNER JOIN Dados.Unidade AS U
				ON U.Codigo=PRP.Cod_Agencia
				OUTER APPLY
				(SELECT TOP 1 ID as IDProdutoKIPREV FROM Dados.ProdutoKIPREV AS PK WHERE PK.Codigo=PRP.Cod_Producto) AS Prod
				--WHERE PRP1.NumeroProposta='069999145149881'
            ) A
          ) AS X
    ON  X.IDProposta = T.IDProposta
--	AND X.DataArquivo = T.DataArquivo
    WHEN MATCHED
		THEN UPDATE 
			SET 
				CodigoConta = COALESCE(X.CodigoConta, T.CodigoConta)
				,Sobrevida_contratado_pm = COALESCE(X.Sobrevida_contratado_pm, T.Sobrevida_contratado_pm)
				,Sobrevida_contratado_pu = COALESCE(X.Sobrevida_contratado_pu, T.Sobrevida_contratado_pu)
				,Risco_contratado_pm = COALESCE(X.Risco_contratado_pm, T.Risco_contratado_pm)
				,Risco_contratado_PU = COALESCE(X.Risco_contratado_PU, T.Risco_contratado_PU)
				,Prazo = COALESCE(X.Prazo, T.Prazo)
				,Renda_Participante = COALESCE(X.Renda_Participante, T.Renda_Participante)
				--,DataArquivo = COALESCE(X.DataArquivo, T.DataArquivo)
				,IDFilialPrevidencia = COALESCE(X.IDFilialPrevidencia, T.IDFilialPrevidencia)
				,NomeArquivo = COALESCE(X.NomeArquivo, T.NomeArquivo)
    WHEN NOT MATCHED
			    THEN INSERT          
              (
					IDProposta
					,IDProdutoKIPREV
					,CodigoConta
					,Sobrevida_contratado_pm
					,Sobrevida_contratado_pu
					,Risco_contratado_pm
					,Risco_contratado_PU
					,Prazo
					,Renda_Participante
					,DataArquivo
					,IDFilialPrevidencia
					,NomeArquivo
			   )
          VALUES (                         
					X.IDProposta
					,X.IDProdutoKIPREV
					,X.CodigoConta
					,X.Sobrevida_contratado_pm
					,X.Sobrevida_contratado_pu
					,X.Risco_contratado_pm
					,X.Risco_contratado_PU
					,X.Prazo
					,X.Renda_Participante
					,X.DataArquivo
					,X.IDFilialPrevidencia
					,X.NomeArquivo
                 )
		WHEN NOT MATCHED BY SOURCE 
		THEN UPDATE SET DataCancelamentoPAR=CAST(GETDATE() AS DATE)
		;
		


/*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/

  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'PropostaPrevidencia_KIPREV'

 /****************************************************************************************/
  
  TRUNCATE TABLE [dbo].[Previdencia_KIPREV_TEMP]
  
  /**************************************************************************************/
   
    SET @COMANDO = 'INSERT INTO [dbo].[Previdencia_KIPREV_TEMP]
           (COD_CUENTA, PROPOSTA, DT_PROPOSTA, COD_PRODUCTO, PRODUTO, COD_AGENCIA, NOME_AGENCIA, COD_SR, SR, FILIAL, SUAT, SOBREVIDA_CONTRATADO_PM, RISCO_CONTRATADO_PM, SOBREVIDA_CONTRATADO_PU, RISCO_CONTRATADO_PU
			,PRAZO ,SEXO, DATA_NASCIMENTO, RENDA_PARTICIPANTE, DataArquivo, NomeArquivo, Codigo )
		   SELECT  COD_CUENTA, PROPOSTA, DT_PROPOSTA, COD_PRODUCTO, PRODUTO, COD_AGENCIA, NOME_AGENCIA, COD_SR, SR, FILIAL, SUAT, SOBREVIDA_CONTRATADO_PM, RISCO_CONTRATADO_PM, SOBREVIDA_CONTRATADO_PU, RISCO_CONTRATADO_PU
			,PRAZO ,SEXO, DATA_NASCIMENTO, RENDA_PARTICIPANTE, DataArquivo, NomeArquivo, Codigo
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaPrevidencia_KIPREV]''''' + @PontoDeParada + ''''''') PRP '
exec (@COMANDO)  

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.Previdencia_KIPREV_TEMP PRP 

  /*********************************************************************************************************************/
                    
  /*********************************************************************************************************************/
  
END
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Previdencia_KIPREV_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Previdencia_KIPREV_TEMP];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     

			    
			                    