
/*
	Autor: Egler Vieira
	Data Criação: 18/04/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereCobertura_COBAUTO
	Descrição: Procedimento que realiza a inserção das Coberturas (COBAUTO) no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InsereCobertura_COBAUTO] as
BEGIN TRY		
 
	    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 
   	    

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[COBAUTO_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[COBAUTO_TEMP];

CREATE TABLE [dbo].[COBAUTO_TEMP](
	[Codigo] bigint NOT NULL,
	[ControleVersao] decimal(16, 8) NOT NULL,
	[NomeArquivo] varchar(100) NOT NULL,
	[DataArquivo] date NOT NULL,
	[NumeroApolice] varchar(20) NOT NULL,
	[NumeroEndosso] INT NOT NULL ,
	[NumeroItem] smallint NULL,
	[RamoCobertura] smallint NULL,
	[CodigoCobertura] smallint NULL,
	[DataInicioVigencia] date NULL,
	[DataFimVigencia] date NULL,
	[ImportanciaSegurada] numeric(15, 5) NULL,
	[LimiteIndenizacao] numeric(15, 5) NULL,
	[ValorFranquia] numeric(15, 5) NULL,
	[ValorPremioLiquido] numeric(15, 5) NULL
) 

 


 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_COBAUTO_TEMP ON [dbo].[COBAUTO_TEMP]
( 
  Codigo ASC
)         


SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Cobertura_COBAUTO'


--select @PontoDeParada = 20007037


/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[COBAUTO_TEMP] ( 
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
	                    [NumeroEndosso] ,
	                    [NumeroItem],
	                    [RamoCobertura] ,
	                    [CodigoCobertura],
	                    [DataInicioVigencia],
	                    [DataFimVigencia] ,
	                    [ImportanciaSegurada] ,
	                    [LimiteIndenizacao] ,
	                    [ValorFranquia] ,
	                    [ValorPremioLiquido] 
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaEndossoCobertura_COBAUTO] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)     

                
SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM [dbo].[COBAUTO_TEMP] PRP
                  
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
             FROM [COBAUTO_TEMP] COB
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
             FROM [COBAUTO_TEMP] COB
             INNER JOIN Dados.Ramo R
             ON R.Codigo = COB.RamoCobertura
            ) X
       ON T.[Codigo] = X.CodigoCobertura 
       AND T.IDRamo = X.IDRamo
     WHEN NOT MATCHED
	          THEN INSERT (IDRamo, Codigo, Nome)
	               VALUES (X.IDRamo, X.[CodigoCobertura], X.[Nome])
     WHEN MATCHED
	          THEN UPDATE SET T.IDRamo = X.IDRamo;	
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
        FROM [dbo].[COBAUTO_TEMP] EM
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
        FROM [dbo].[COBAUTO_TEMP] EM
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
    --Comando para inserir as Coberturas recebidas no arquivo COBAUTO
    -----------------------------------------------------------------------------------------------------------------------		               
   	MERGE INTO Dados.EndossoCobertura AS T
		USING (
			SELECT 
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
			      COB.ValorFranquia
       FROM        Dados.Endosso EN
        INNER JOIN Dados.Contrato CNT 
        ON CNT.ID = EN.IDContrato
        INNER JOIN [COBAUTO_TEMP] COB
        ON COB.NumeroApolice = CNT.NumeroContrato
        AND EN.NumeroEndosso = COB.NumeroEndosso
        INNER JOIN Dados.Ramo R
        ON R.Codigo = COB.RamoCobertura
        INNER JOIN Dados.Cobertura C
        ON C.Codigo = COB.CodigoCobertura
        AND C.IDRamo = R.ID
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
		WHEN NOT MATCHED
			THEN INSERT (IDEndosso, IDCobertura, NumeroItem, DataInicioVigencia, DataFimVigencia
			           , ImportanciaSegurada, LimiteIndenizacao, ValorPremioLiquido, ValorFranquia
			           , DataArquivo, Arquivo)
				VALUES (O.IDEndosso, O.IDCobertura, O.NumeroItem, O.DataInicioVigencia, O.DataFimVigencia
			        , O.ImportanciaSegurada, O.LimiteIndenizacao, O.ValorPremioLiquido, O.ValorFranquia
			        , O.DataArquivo, O.Arquivo);
    -----------------------------------------------------------------------------------------------------------------------				
				
    
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Cobertura_COBAUTO'
  /*************************************************************************************/
  
 /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[COBAUTO_TEMP] 
    
  /*********************************************************************************************************************/               
  /*Recupeara maior Código do retorno*/
  /*********************************************************************************************************************/

  SET @COMANDO = 'INSERT INTO [dbo].[COBAUTO_TEMP] ( 
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
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaEndossoCobertura_COBAUTO] ''''' + @PontoDeParada + ''''''') PRP'

  EXEC (@COMANDO)         

                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM [dbo].[COBAUTO_TEMP] PRP
                    
  /*********************************************************************************************************************/
  
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[COBAUTO_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[COBAUTO_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH
