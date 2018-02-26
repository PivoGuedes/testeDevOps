
/*
	Autor: Egler Vieira
	Data Criação: 18/04/2013

	Descrição: 
	
	Última alteração : GUSTAVO MOREIRA 04/10/2013 - Alteração no Comando para inserir as Coberturas recebidas no arquivo EMIOUTR
	Incluindo a função para identificar as coberturas iguais e inserir apenas uma.

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereCobertura_EMIOUTR
	Descrição: Procedimento que realiza a inserção das Coberturas (EMIOUTR) no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InsereCobertura_EMIOUTR] as
BEGIN TRY		
 
	    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 
   	    

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMIOUTR_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[EMIOUTR_TEMP];

CREATE TABLE [dbo].[EMIOUTR_TEMP](
	[Codigo] bigint NOT NULL,
	[ControleVersao] decimal(16, 8) NOT NULL,
	[NomeArquivo] varchar(100) NOT NULL,
	[DataArquivo] date NOT NULL,
	[NumeroApolice] varchar(20) NOT NULL,
	[NumeroEndosso] INT NOT NULL ,
	[NumeroItem] smallint NULL,
	[RamoCobertura] varchar(2) NULL,
	[CodigoCobertura] smallint NULL,
	[DataInicioVigencia] date NULL,
	[DataFimVigencia] date NULL,
	[ImportanciaSegurada] numeric(15, 5) NULL,
	[LimiteIndenizacao] numeric(15, 5) NULL,
	[ValorFranquia] numeric(15, 5) NULL,
	[ValorPremioLiquido] numeric(15, 5) NULL,
	FranquiaMinima VARCHAR(50) NULL,
	FranquiaMaxima VARCHAR(50) NULL
) 

 


 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_EMIOUTR_TEMP ON [dbo].[EMIOUTR_TEMP]
( 
  Codigo ASC
)         
WITH(FILLFACTOR=100)


CREATE NONCLUSTERED INDEX idx_EMIOUTR__RamoCobetura_TEMP
ON [dbo].[EMIOUTR_TEMP] ([RamoCobertura]) include (codigo)
WITH(FILLFACTOR=100)

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Cobertura_EMIOUTR'


--select @PontoDeParada = 20007037


/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[EMIOUTR_TEMP] ( 
                      [Codigo] ,
	                    [ControleVersao] ,
	                    [NomeArquivo] ,
	                    [DataArquivo] ,
	                    [NumeroApolice],
	                    [NumeroEndosso]  ,
	                    [NumeroItem] ,
	                    [RamoCobertura] ,
	                    [CodigoCobertura],
	                    [DataInicioVigencia] ,
	                    [DataFimVigencia] ,
	                    [ImportanciaSegurada] ,
	                    [LimiteIndenizacao] ,
	                    [ValorFranquia] ,
	                    [ValorPremioLiquido],
						FranquiaMinima,
						FranquiaMaxima
						)
                SELECT 
                      [Codigo] ,
	                    [ControleVersao] ,
	                    [NomeArquivo] ,
	                    [DataArquivo] ,
	                    [NumeroApolice],
	                    [NumeroEndosso] ,
	                    [NumeroItem],
	                    [RamoCobertura] ,
	                    [CodigoCobertura],
	                    [DataInicioVigencia],
	                    [DataFimVigencia] ,
	                    [ImportanciaSegurada] ,
	                    [LimiteIndenizacao] ,
	                    [ValorFranquia] ,
	                    [ValorPremioLiquido],
						FranquiaMinima,
						FranquiaMaxima
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaEndossoCobertura_EMIOUTR] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)     

                
SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM [dbo].[EMIOUTR_TEMP] PRP
                
/*********************************************************************************************************************/

WHILE @MaiorCodigo IS NOT NULL
BEGIN 
--    PRINT @MaiorCodigo
            /*
                  INNER JOIN Dados.Ramo R
        ON R.Codigo = COB.RamoCobertura
		                           */
	 /***********************************************************************
     Carregar os RAMOS das COBERTURAS
   ***********************************************************************/
         ;MERGE INTO Dados.Ramo AS T
      USING (SELECT DISTINCT COB.RamoCobertura, '' [Nome]
             FROM [EMIOUTR_TEMP] COB
             WHERE COB.RamoCobertura IS NOT NULL
            ) X
       ON T.[Codigo] = X.[RamoCobertura] 
     WHEN NOT MATCHED
	          THEN INSERT (Codigo, Nome)
	               VALUES (X.[RamoCobertura], X.[Nome]);

   /***********************************************************************/                         
   
   /***********************************************************************
     Carregar as COBERTURAS
   ***********************************************************************/
     ;MERGE INTO Dados.Cobertura AS T
      USING (SELECT DISTINCT R.ID [IDRamo], COB.CodigoCobertura, '' [Nome] 
             FROM [EMIOUTR_TEMP] COB
             LEFT JOIN Dados.Ramo R
             ON R.Codigo = COB.RamoCobertura 
             --ORDER BY COB.CodigoCobertura
            ) X
       ON ISNULL(T.[Codigo], '-1') = ISNULL(X.CodigoCobertura, '-1') 
	   AND ISNULL(T.IDRamo,'-1') = ISNULL(X.IDRamo,'-1')
     WHEN NOT MATCHED
	          THEN INSERT (IDRamo, Codigo, Nome)
	               VALUES (X.IDRamo, X.[CodigoCobertura], X.[Nome]);
     /*WHEN MATCHED
	          THEN UPDATE SET T.IDRamo = X.IDRamo;	*/
   /***********************************************************************/                         

		                           

    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir Apólices não recebidas nos arquivos de EMISSAO
    -----------------------------------------------------------------------------------------------------------------------
	    
      ;MERGE INTO Dados.Contrato AS T
      USING	
       (SELECT  DISTINCT
               1 [IDSeguradora] /*Caixa Seguros*/               
             , EM.NumeroApolice [NumeroContrato]
             , MAX(EM.[DataArquivo]) [DataArquivo]
             , MAX(EM.NomeArquivo) [Arquivo]
        FROM [dbo].[EMIOUTR_TEMP] EM
        WHERE EM.NumeroApolice IS NOT NULL
        GROUP BY EM.NumeroApolice 
       ) X
      ON T.[NumeroContrato] = X.[NumeroContrato]
     AND T.[IDSeguradora] = X.[IDSeguradora]
     WHEN NOT MATCHED
                THEN INSERT ([NumeroContrato], [IDSeguradora], [Arquivo], [DataArquivo])
                     VALUES (X.[NumeroContrato], X.[IDSeguradora], X.[Arquivo], X.[DataArquivo]);    
                     
    -----------------------------------------------------------------------------------------------------------------------
           
		
		    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir Endossos não recebidos nos arquivos de EMISSAO
    -----------------------------------------------------------------------------------------------------------------------
	    
      ;MERGE INTO Dados.Endosso AS T
      USING	
       (SELECT DISTINCT 
               1 [IDSeguradora] /*Caixa Seguros*/               
             , E.[ID] [IDContrato]
             , EM.NumeroEndosso
             , CASE WHEN PRD.IDProduto IS NULL THEN -1 ELSE PRD.IDProduto END [IDProduto]
             , MAX(EM.[DataArquivo]) [DataArquivo]
             , MAX(EM.NomeArquivo) [Arquivo]
        FROM [dbo].[EMIOUTR_TEMP] EM
        INNER JOIN Dados.Contrato E
        ON  E.[NumeroContrato] = EM.[NumeroApolice]
        AND E.[IDSeguradora] = 1 /*Caixa Seguros*/               
        OUTER APPLY( SELECT TOP 1 IDProduto FROM Dados.Endosso EN
                     WHERE EN.IDContrato = E.ID
                     ORDER BY IDContrato ASC, DataArquivo DESC, ID DESC) PRD
        WHERE EM.NumeroApolice IS NOT NULL
        AND NOT EXISTS (SELECT * FROM Dados.Endosso EN
                        WHERE EN.IDContrato = E.ID
                          AND EN.NumeroEndosso = EM.NumeroEndosso)
        GROUP BY E.[ID], EM.NumeroEndosso, CASE WHEN PRD.IDProduto IS NULL THEN -1 ELSE PRD.IDProduto END  
       ) X
      ON  T.IDContrato = X.IDContrato
      AND T.NumeroEndosso = X.NumeroEndosso
     WHEN NOT MATCHED
                THEN INSERT (IDContrato, NumeroEndosso, IDProduto, [Arquivo], [DataArquivo])
                     VALUES (X.IDContrato, X.[NumeroEndosso], X.IDProduto, X.[Arquivo], X.[DataArquivo]);                         
    -----------------------------------------------------------------------------------------------------------------------
           
		
		
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir as Coberturas recebidas no arquivo EMIOUTR
    -----------------------------------------------------------------------------------------------------------------------		               
   	MERGE INTO Dados.EndossoCobertura AS T
		USING (
			SELECT  C.[Arquivo],
					C.[DataArquivo],
					C.[IDEndosso],
					C.[IDCobertura],
					C.NumeroItem,
					C.DataInicioVigencia,
					C.DataFimVigencia,
					C.ImportanciaSegurada,
					C.LimiteIndenizacao,
					C.ValorPremioLiquido,
					C.ValorFranquia,
					C.FranquiaMinima,
					C.FranquiaMaxima,
					C.RANQ

			FROM
			(SELECT --top 2
				  COB.[NomeArquivo] [Arquivo],
				  COB.[DataArquivo],	       
			      EN.ID [IDEndosso],
			      C.ID [IDCobertura],
			      ISNULL(COB.NumeroItem, 0) NumeroItem,
			      COB.DataInicioVigencia,
			      COB.DataFimVigencia,
			      COB.ImportanciaSegurada,
			      COB.LimiteIndenizacao,
			      COB.ValorPremioLiquido,
			      COB.ValorFranquia,
				  COB.FranquiaMinima,
				  COB.FranquiaMaxima,
				  ROW_NUMBER () OVER (PARTITION BY COB.NumeroApolice, COB.NumeroEndosso, COB.NumeroItem, COB.CodigoCobertura, COB.RamoCobertura ORDER BY COB.Codigo) AS RANQ 
       FROM        Dados.Endosso EN
        INNER JOIN Dados.Contrato CNT 
        ON CNT.ID = EN.IDContrato
        INNER JOIN [EMIOUTR_TEMP] COB
        ON COB.NumeroApolice = ISNULL(CNT.NumeroContrato, '-1')
        AND COB.NumeroEndosso = ISNULL(EN.NumeroEndosso, -1)
        INNER JOIN Dados.Ramo R
        ON R.Codigo = COB.RamoCobertura
        INNER JOIN Dados.Cobertura C
        ON C.Codigo = COB.CodigoCobertura
        AND C.IDRamo = R.ID
		) C
		WHERE C.RANQ = 1
    ) AS O
		ON  T.IDEndosso = O.IDEndosso
    AND T.NumeroItem = O.NumeroItem
    AND T.IDCobertura = O.IDCobertura
		WHEN MATCHED
			THEN UPDATE 
				SET T.IDEndosso            =    COALESCE(O.[IDEndosso], T.[IDEndosso])
				   ,T.IDCobertura          =    COALESCE(O.[IDCobertura], T.[IDCobertura])
				   ,T.NumeroItem           =    COALESCE(O.NumeroItem, T.NumeroItem)
				   ,T.DataInicioVigencia   =    COALESCE(O.DataInicioVigencia, T.DataInicioVigencia)
				   ,T.DataFimVigencia      =    COALESCE(O.DataFimVigencia, T.DataFimVigencia)
				   ,T.ImportanciaSegurada  =    COALESCE(O.ImportanciaSegurada, T.ImportanciaSegurada)
				   ,T.LimiteIndenizacao    =    COALESCE(O.LimiteIndenizacao, T.LimiteIndenizacao)
				   ,T.ValorPremioLiquido   =    COALESCE(O.ValorPremioLiquido, T.ValorPremioLiquido)
				   ,T.ValorFranquia        =    COALESCE(O.ValorFranquia, T.ValorFranquia)
				   ,T.DataArquivo          =    COALESCE(O.DataArquivo, T.DataArquivo)
				   ,T.Arquivo              =    COALESCE(O.Arquivo, T.Arquivo)
				   ,T.FranquiaMinima       =    COALESCE(O.FranquiaMinima, T.FranquiaMinima)
				   ,T.FranquiaMaxima       =    COALESCE(O.FranquiaMaxima, T.FranquiaMaxima)
		WHEN NOT MATCHED
			THEN INSERT (IDEndosso, IDCobertura, NumeroItem, DataInicioVigencia, DataFimVigencia
			           , ImportanciaSegurada, LimiteIndenizacao, ValorPremioLiquido, ValorFranquia
			           , DataArquivo, Arquivo, FranquiaMinima, FranquiaMaxima)
				VALUES (O.IDEndosso, O.IDCobertura, O.NumeroItem, O.DataInicioVigencia, O.DataFimVigencia
			        , O.ImportanciaSegurada, O.LimiteIndenizacao, O.ValorPremioLiquido, O.ValorFranquia
			        , O.DataArquivo, O.Arquivo, O.FranquiaMinima, O.FranquiaMaxima);
    -----------------------------------------------------------------------------------------------------------------------				
				
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir LOG das Coberturas recebidas mais de uma vez no arquivo EMIOUTR
	--Bloco inserido por: Gustavo Moreira / 2013-10-07
    -----------------------------------------------------------------------------------------------------------------------		               
 MERGE INTO ControleDados.[LogEMIOUTR] AS T
		USING (
			SELECT  C.[Arquivo],
					C.[DataArquivo],
					C.[IDEndosso],
					C.[IDCobertura],
					C.[NumeroApolice],
					C.[NumeroEndosso],
					C.NumeroItem,
					C.[RamoCobertura],
					C.[CodigoCobertura],
					C.DataInicioVigencia,
					C.DataFimVigencia,
					C.ImportanciaSegurada,
					C.LimiteIndenizacao,
					C.ValorPremioLiquido,
					C.ValorFranquia,
					C.RANQ

			FROM
			(SELECT 
				  COB.[NomeArquivo] [Arquivo],
				  COB.[DataArquivo],	       
			      EN.ID [IDEndosso],
			      C.ID [IDCobertura],
				  COB.[NumeroApolice],
				  COB.[NumeroEndosso],
			      ISNULL(COB.NumeroItem, 0) NumeroItem,
				  COB.[RamoCobertura] ,
				  COB.[CodigoCobertura],
			      COB.DataInicioVigencia,
			      COB.DataFimVigencia,
			      COB.ImportanciaSegurada,
			      COB.LimiteIndenizacao,
			      COB.ValorPremioLiquido,
			      COB.ValorFranquia,
				  ROW_NUMBER () OVER (PARTITION BY COB.NumeroApolice, COB.NumeroEndosso, COB.NumeroItem,COB.CodigoCobertura, COB.RamoCobertura ORDER BY COB.Codigo) AS RANQ 
       FROM        Dados.Endosso EN
        INNER JOIN Dados.Contrato CNT 
        ON CNT.ID = EN.IDContrato
        INNER JOIN [EMIOUTR_TEMP] COB
		ON COB.NumeroApolice = ISNULL(CNT.NumeroContrato, '-1')
        AND COB.NumeroEndosso = ISNULL(EN.NumeroEndosso, -1)
        INNER JOIN Dados.Ramo R
        ON R.Codigo = COB.RamoCobertura
        INNER JOIN Dados.Cobertura C
        ON C.Codigo = COB.CodigoCobertura
        AND C.IDRamo = R.ID
		) C
		WHERE C.RANQ > 1
    ) AS O
		ON  T.IDEndosso = O.IDEndosso
		AND T.NumeroItem = O.NumeroItem
		AND T.IDCobertura = O.IDCobertura
		AND T.RANQ = O.RANQ
		WHEN MATCHED
			THEN UPDATE 
				SET T.[IDEndosso]      =    COALESCE(O.[IDEndosso], T.[IDEndosso])
				   ,T.[IDCobertura]      =    COALESCE(O.[IDCobertura], T.[IDCobertura])					
				   ,T.[NumeroApolice]      =    COALESCE(O.[NumeroApolice], T.[NumeroApolice])
				   ,T.[NumeroEndosso]      =    COALESCE(O.[NumeroEndosso], T.[NumeroEndosso])
				   ,T.NumeroItem           =    COALESCE(O.NumeroItem, T.NumeroItem)
				   ,T.[RamoCobertura]      =    COALESCE(O.[RamoCobertura], T.[RamoCobertura])
				   ,T.[CodigoCobertura]    =    COALESCE(O.[CodigoCobertura], T.[CodigoCobertura])
				   ,T.DataInicioVigencia   =    COALESCE(O.DataInicioVigencia, T.DataInicioVigencia)
				   ,T.DataFimVigencia      =    COALESCE(O.DataFimVigencia, T.DataFimVigencia)
				   ,T.ImportanciaSegurada  =    COALESCE(O.ImportanciaSegurada, T.ImportanciaSegurada)
				   ,T.LimiteIndenizacao    =    COALESCE(O.LimiteIndenizacao, T.LimiteIndenizacao)
				   ,T.ValorPremioLiquido   =    COALESCE(O.ValorPremioLiquido, T.ValorPremioLiquido)
				   ,T.ValorFranquia        =    COALESCE(O.ValorFranquia, T.ValorFranquia)
				   ,T.DataArquivo          =    COALESCE(O.DataArquivo, T.DataArquivo)
				   ,T.Arquivo              =    COALESCE(O.Arquivo, T.Arquivo)
				   ,T.RANQ				   =    COALESCE(O.RANQ, T.RANQ)
		WHEN NOT MATCHED
			THEN INSERT ([IDEndosso], [IDCobertura],[NumeroApolice], [NumeroEndosso], NumeroItem, [RamoCobertura]
					, [CodigoCobertura], DataInicioVigencia, DataFimVigencia, ImportanciaSegurada, LimiteIndenizacao
					, ValorPremioLiquido, ValorFranquia, DataArquivo, Arquivo, RANQ)
				VALUES (O.IDEndosso, O.IDCobertura, O.NumeroApolice, O.NumeroEndosso, O.NumeroItem, O.RamoCobertura
					, O.CodigoCobertura, O.DataInicioVigencia, O.DataFimVigencia, O.ImportanciaSegurada
					, O.LimiteIndenizacao, O.ValorPremioLiquido, O.ValorFranquia, O.DataArquivo, O.Arquivo, O.RANQ);

 -----------------------------------------------------------------------------------------------------------------------				


    
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Cobertura_EMIOUTR'
  /*************************************************************************************/
  
 /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[EMIOUTR_TEMP] 
    
  /*********************************************************************************************************************/               
  /*Recupeara maior Código do retorno*/
  /*********************************************************************************************************************/

  SET @COMANDO = 'INSERT INTO [dbo].[EMIOUTR_TEMP] ( 
                      [Codigo] ,
	                    [ControleVersao] ,
	                    [NomeArquivo] ,
	                    [DataArquivo] ,
	                    [NumeroApolice],
	                    [NumeroEndosso]  ,
	                    [NumeroItem] ,
	                    [RamoCobertura] ,
	                    [CodigoCobertura],
	                    [DataInicioVigencia] ,
	                    [DataFimVigencia] ,
	                    [ImportanciaSegurada] ,
	                    [LimiteIndenizacao] ,
	                    [ValorFranquia] ,
	                    [ValorPremioLiquido])
                SELECT 
                      [Codigo] ,
	                    [ControleVersao] ,
	                    [NomeArquivo] ,
	                    [DataArquivo] ,
	                    [NumeroApolice],
	                    [NumeroEndosso]  ,
	                    [NumeroItem] ,
	                    [RamoCobertura] ,
	                    [CodigoCobertura],
	                    [DataInicioVigencia] ,
	                    [DataFimVigencia] ,
	                    [ImportanciaSegurada] ,
	                    [LimiteIndenizacao] ,
	                    [ValorFranquia] ,
	                    [ValorPremioLiquido] 
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaEndossoCobertura_EMIOUTR] ''''' + @PontoDeParada + ''''''') PRP'

  EXEC (@COMANDO)         

                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM [dbo].[EMIOUTR_TEMP] PRP
                    
  /*********************************************************************************************************************/
  
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EMIOUTR_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[EMIOUTR_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH