
/*
	Autor: Diego Lima
	Data Criação: 08/11/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereApoliceEspecifica_Contrato_PRPESPEC
	Descrição: Procedimento que realiza a inserção de contratos ou apolices no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
-- Número da Apolice é igual ao Número do Contrato
CREATE PROCEDURE [Dados].[proc_InsereApoliceEspecifica_Contrato_PRPESPEC] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[APOLICE_ESPECIFICA_CONTRATO_PRPESPEC_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[APOLICE_ESPECIFICA_CONTRATO_PRPESPEC_TEMP];

CREATE TABLE [dbo].[APOLICE_ESPECIFICA_CONTRATO_PRPESPEC_TEMP](

[Codigo] bigint null,
[ControleVersao] decimal(16,8),
[NomeArquivo] varchar(100),
[DataArquivo] date,
[NumeroProposta] varchar(20),
[InfoVariavel] varchar(500),
[Numeroapolice] varchar(20),
[SubGrupo] varchar(6)

);

 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX IDX_APOLICE_ESPECIFICA_CONTRATO_PRPESPEC_TEMP_CODIGO ON [dbo].[APOLICE_ESPECIFICA_CONTRATO_PRPESPEC_TEMP]
( 
  Codigo ASC
)   

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Contrato_PRPESPEC'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
 --DECLARE @COMANDO AS NVARCHAR(MAX) 
 --DECLARE @PontoDeParada AS VARCHAR(400) set @PontoDeParada = 0               
 SET @COMANDO =
		'  INSERT INTO dbo.APOLICE_ESPECIFICA_CONTRATO_PRPESPEC_TEMP
				( [Codigo]
				 ,[ControleVersao]
				 ,[NomeArquivo]
				 ,[DataArquivo]
		         ,[NumeroProposta]
				 ,[InfoVariavel]
				 ,[Numeroapolice]
				 ,[SubGrupo]
				  )
			SELECT 
				 [Codigo]
				 ,[ControleVersao]
				 ,[NomeArquivo]
				 ,[DataArquivo]
		         ,[NumeroProposta]
				 ,[InfoVariavel]
				 ,[Numeroapolice]
				 ,[SubGrupo]
		   FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaApoliceEspecifica_Apolice_PRPESPEC] ''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO) 

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.APOLICE_ESPECIFICA_CONTRATO_PRPESPEC_TEMP PRP  

/**************************************************************************************************/

SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN

/**************************************************************************************************
		INSERE AS APOLICES OU CONTRATOS NÃO CADASTRADOS
**************************************************************************************************/
 
;MERGE INTO [Dados].[Contrato] AS T
  USING	
		( SELECT * FROM (
							SELECT DISTINCT Numeroapolice, DataArquivo, NomeArquivo Arquivo,
											ROW_NUMBER() OVER(PARTITION BY Numeroapolice ORDER BY Numeroapolice, DataArquivo DESC )  [ORDER]

							FROM dbo.APOLICE_ESPECIFICA_CONTRATO_PRPESPEC_TEMP
							WHERE Numeroapolice IS NOT NULL
						) A
				where a.[order] = 1
		) X
	 ON T.NumeroContrato = X.Numeroapolice
		AND T.IDSeguradora = 1
  WHEN NOT MATCHED
          THEN INSERT (NumeroContrato, IDSeguradora, DataArquivo, Arquivo)
               VALUES (X.Numeroapolice, 1, X.DataArquivo, X.Arquivo );

/**************************************************************************************************
		ATUALIZA O CAMPO IDContrato E Subgrupo NA Tabela PROPOSTA
**************************************************************************************************/

;MERGE INTO [Dados].[Proposta] AS T
  USING	
		(SELECT * 
		 FROM (SELECT  C.ID AS IDCONTRATO
					,isnull(T.SubGrupo,0)SubGrupo
					,P.ID [IDProposta]
					,ROW_NUMBER() OVER(PARTITION BY t.Numeroapolice,t.NUMEROPROPOSTA ORDER BY Numeroapolice, t.DataArquivo DESC )  [ORDER]
				FROM dbo.APOLICE_ESPECIFICA_CONTRATO_PRPESPEC_TEMP T
					LEFT JOIN [Dados].[Contrato] C
						ON T.Numeroapolice = C.NumeroContrato
							AND c.IDSeguradora = 1
					LEFT JOIN [Dados].[Proposta] P
						ON T.NumeroProposta = P.NumeroProposta
							AND p.IDSeguradora = 1
				) A
			WHERE A.[order]=1
	    ) X
		ON T.ID = X.IDPROPOSTA
		AND T.IDSeguradora = 1
		
		WHEN MATCHED
			    THEN UPDATE
				     SET IDContrato = COALESCE(T.IDContrato, X.IDContrato) --Carrega o Contrato somento quando este for NULL
					   , [SubGrupo] = X.SubGrupo; --Carrega o subgrupo


/**************************************************************************************************
		ATUALIZA O CAMPO IDProposta na Tabela Contrato com menor SubGrupo da proposta
**************************************************************************************************/
;MERGE INTO [Dados].[Contrato] AS T
  USING	(SELECT IDPROPOSTA,
                Numeroapolice
         FROM 
			(SELECT DISTINCT 
				x.IDPROPOSTA,
				--MIN(ISNULL(x.SubGrupo,0))SubGrupo,
				Numeroapolice,
				ROW_NUMBER() OVER (PARTITION BY X.Numeroapolice ORDER BY X.dataArquivo desc, x.SubGrupo ASC ) NUMERADOR
			FROM 
				(SELECT 
						P.ID AS IDPROPOSTA,
						T.Numeroapolice AS Numeroapolice, 
						C.NumeroContrato,
						T.DataArquivo,
						ISNULL(T.SubGrupo,0) SubGrupo
				FROM dbo.APOLICE_ESPECIFICA_CONTRATO_PRPESPEC_TEMP T
					LEFT JOIN [Dados].[Contrato] C
						ON T.Numeroapolice = C.NumeroContrato
							AND c.IDSeguradora = 1
					LEFT JOIN [Dados].[Proposta] P
						ON T.NumeroProposta = P.NumeroProposta
							AND p.IDSeguradora = 1
				) X
				GROUP BY x.IDPROPOSTA, X.Numeroapolice, X.DataArquivo, x.SubGrupo)A 
			WHERE A.NUMERADOR = 1 --and
		-- A.Numeroapolice_TEMP in('108210738491', '109300000452')
			) B
		ON T.NumeroContrato = B.Numeroapolice
	   AND T.IDSeguradora = 1	  
	WHEN MATCHED AND T.IDPROPOSTA IS NULL
			THEN UPDATE
				 SET IDProposta = B.IDProposta;

--=====================================
-- TODO MUNDO DA TABELA TEMP ATUALIZANDO O SUBGRUPO DE TODOS OS REGISTROS DO CONTRATO / 
-- PROPOSTA PARA O SUBGRUPO MAIS RECENTE, ISTO É... ordem acima = 1

;MERGE INTO dbo.APOLICE_ESPECIFICA_CONTRATO_PRPESPEC_TEMP AS T
  USING	( SELECT * 
			FROM ( 
					SELECT P.ID AS IDPROPOSTA,
							T.numeroproposta,
							1 AS IDSeguradora,
							isnull(P.IDProduto,-1) IDProduto,
							C.ID AS IDCONTRATO,
							T.numeroapolice,
							T.DataArquivo, 
							T.NomeArquivo as Arquivo,
							T.SubGrupo SubGrupo
							,ROW_NUMBER() OVER (PARTITION BY C.ID, P.ID ORDER BY t.dataArquivo desc ) NUMERADOR
						FROM dbo.APOLICE_ESPECIFICA_CONTRATO_PRPESPEC_TEMP T
							LEFT JOIN [Dados].[Contrato] C
								ON T.Numeroapolice = C.NumeroContrato
									AND c.IDSeguradora = 1
							LEFT JOIN [Dados].[Proposta] P
								ON T.NumeroProposta = P.NumeroProposta
									AND p.IDSeguradora = 1
					) Y
				where numerador = 1 --and IDCONTRATO = 7514588
		)X

		ON 
			T.numeroproposta = X.numeroproposta
		AND T.numeroapolice = X.numeroapolice

	WHEN MATCHED
		THEN UPDATE
				 SET
					SubGrupo = X.SubGrupo;
					
				
/**************************************************************************************************
		Atualiza CodigoSubestipulante 
**************************************************************************************************/
;MERGE INTO [Dados].[Endosso] AS T
  USING (SELECT * 
		 FROM (SELECT 
						P.ID AS IDPROPOSTA,
						1 AS IDSeguradora,
						isnull(P.IDProduto,-1) IDProduto,
						C.ID AS IDCONTRATO,
						T.DataArquivo, 
						T.NomeArquivo as Arquivo,
						T.SubGrupo SubGrupo
						,ROW_NUMBER() OVER (PARTITION BY C.ID, isnull(P.IDProduto,-1), T.SubGrupo ORDER BY t.dataArquivo desc ) NUMERADOR
					FROM dbo.APOLICE_ESPECIFICA_CONTRATO_PRPESPEC_TEMP T
						LEFT JOIN [Dados].[Contrato] C
							ON T.Numeroapolice = C.NumeroContrato
								AND c.IDSeguradora = 1
						LEFT JOIN [Dados].[Proposta] P
							ON T.NumeroProposta = P.NumeroProposta
								AND p.IDSeguradora = 1
				) Y
			WHERE Y.NUMERADOR = 1 --and IDCONTRATO = 7514588
			) X
		ON T.IDContrato = X.IDContrato
			AND T.IDProduto = isnull(X.IDProduto,-1)
			and t.NumeroEndosso = -1
			and T.Idproposta = X.Idproposta
			--AND ISNULL(T.CodigoSubestipulante,-1) = ISNULL(X.SubGrupo,-1)

	WHEN MATCHED --AND x.DataArquivo >= t.DataArquivo --AND T.IDPROPOSTA IS NULL
			THEN UPDATE
				 SET
					CodigoSubestipulante = X.SubGrupo
					,DataArquivo = x.DataArquivo
					,Arquivo = x.Arquivo;

/**************************************************************************************************
		INSERE ENDOSSO FAKE
**************************************************************************************************/
;MERGE INTO [Dados].[Endosso] AS T
  USING (SELECT * 
		 FROM (SELECT 
						P.ID AS IDPROPOSTA,
						1 AS IDSeguradora,
						isnull(P.IDProduto,-1) IDProduto,
						C.ID AS IDCONTRATO,
						T.DataArquivo, 
						T.NomeArquivo as Arquivo,
						T.SubGrupo SubGrupo
						,ROW_NUMBER() OVER (PARTITION BY C.ID, isnull(P.IDProduto,-1), T.SubGrupo ORDER BY t.dataArquivo desc ) NUMERADOR
					
					FROM dbo.APOLICE_ESPECIFICA_CONTRATO_PRPESPEC_TEMP T
						LEFT JOIN [Dados].[Contrato] C
							ON T.Numeroapolice = C.NumeroContrato
								AND c.IDSeguradora = 1
						LEFT JOIN [Dados].[Proposta] P
							ON T.NumeroProposta = P.NumeroProposta
								AND p.IDSeguradora = 1
												) Y
			WHERE Y.NUMERADOR = 1 --and IDCONTRATO = 3527526
			) X
		ON T.IDContrato = X.IDContrato
			AND T.IDProduto = isnull(X.IDProduto,-1)
			AND ISNULL(T.CodigoSubestipulante,-1) = ISNULL(X.SubGrupo,-1)

	WHEN MATCHED AND x.DataArquivo >= t.DataArquivo AND T.IDPROPOSTA IS NULL
			THEN UPDATE
				 SET IDProposta = COALESCE(T.IDPROPOSTA, X.IDProposta)--Carrega o ID Proposta somento quando este for NULL
					--,CodigoSubestipulante = isnull(X.SubGrupo,-1)
					--,DataArquivo = x.DataArquivo
					--,Arquivo = x.Arquivo

	WHEN NOT MATCHED
          THEN INSERT (IDcontrato, idproposta, NumeroEndosso, IDProduto, CodigoSubestipulante,DataArquivo, Arquivo)
               VALUES (X.IDContrato, X.IDPROPOSTA, -1 , X.IDProduto, X.SubGrupo, X.DataArquivo, X.Arquivo );


/**************************************************************************************************
		ATUALIZA O IDProposta NA tabela ENDOSSO
**************************************************************************************************/
--;MERGE INTO [Dados].[Endosso] AS T
--  USING (SELECT T.NumeroProposta AS NumeroProposta_TEMP,
--				P.ID AS IDPROPOSTA,
--				P.NUMEROPROPOSTA,
--				P.IDProduto,
--				T.Numeroapolice AS Numeroapolice_TEMP, 
--				C.ID AS IDCONTRATO,
--				C.NumeroContrato,
--				T.DataArquivo, 
--				T.NomeArquivo as Arquivo,
--				ISNULL(T.SubGrupo,0)SubGrupo
--			FROM dbo.APOLICE_ESPECIFICA_CONTRATO_PRPESPEC_TEMP T
--				LEFT JOIN [Dados].[Contrato] C
--					ON T.Numeroapolice = C.NumeroContrato
--						AND c.IDSeguradora = 1
--				LEFT JOIN [Dados].[Proposta] P
--					ON T.NumeroProposta = P.NumeroProposta
--						AND p.IDSeguradora = 1
--			ORDER BY t.Codigo) X
--		ON T.IDContrato = X.IDContrato
--			AND T.IDProduto = X.IDProduto
--			AND T.CodigoSubestipulante = X.SubGrupo

--	WHEN MATCHED
--			THEN UPDATE
--				 SET IDProposta = X.IDProposta;

/*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/

  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Contrato_PRPESPEC'

/****************************************************************************************/
  
  TRUNCATE TABLE [dbo].[APOLICE_ESPECIFICA_CONTRATO_PRPESPEC_TEMP]
  
/**************************************************************************************/
   
SET @COMANDO =
		'  INSERT INTO dbo.APOLICE_ESPECIFICA_CONTRATO_PRPESPEC_TEMP
				( [Codigo]
				 ,[ControleVersao]
				 ,[NomeArquivo]
				 ,[DataArquivo]
		         ,[NumeroProposta]
				 ,[InfoVariavel]
				 ,[Numeroapolice]
				 ,[SubGrupo]
				  )
			SELECT 
				 [Codigo]
				 ,[ControleVersao]
				 ,[NomeArquivo]
				 ,[DataArquivo]
		         ,[NumeroProposta]
				 ,[InfoVariavel]
				 ,[Numeroapolice]
				 ,[SubGrupo]
		   FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaApoliceEspecifica_Apolice_PRPESPEC] ''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO) 

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.APOLICE_ESPECIFICA_CONTRATO_PRPESPEC_TEMP PRP  

/*********************************************************************************************************************/
                    
  /*********************************************************************************************************************/
  
END
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[APOLICE_ESPECIFICA_CONTRATO_PRPESPEC_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[APOLICE_ESPECIFICA_CONTRATO_PRPESPEC_TEMP];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     
