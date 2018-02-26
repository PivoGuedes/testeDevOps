
/*
	Autor: Egler Vieira
	Data Criação: 07/05/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereProposta_CoberturaMultirisco_TIPO6_SRG2
	Descrição: Procedimento que realiza a inserção de COBERTURAS DE RISCO (MULTIRISCO) SUBREGISTRO 2
	           das propostas no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereProposta_CoberturaMultirisco_TIPO6_SRG2] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CoberturaMultirisco_TIPO6_SRG2_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
BEGIN
	DROP TABLE [dbo].[CoberturaMultirisco_TIPO6_SRG2_TEMP];
	/*
		RAISERROR   (N'A tabela temporária [CoberturaMultirisco_TIPO6_SRG2_TEMP] foi encontrada. Verifique se há um processo paralelo executando a função.',
    16, -- Severity.
    1 -- State.
    );
    */
END


CREATE TABLE [dbo].[CoberturaMultirisco_TIPO6_SRG2_TEMP]
(
	[Codigo] [bigint] NOT NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[NomeArquivo] [varchar] (100) NOT NULL,
	[DataArquivo] [date] NOT NULL,
	[NumeroProposta] [varchar](20) NULL,
	[NumeroPropostaTratado]    as Cast(dbo.fn_TrataNumeroPropostaZeroExtra(NumeroProposta) as   varchar(20)) PERSISTED,
	[CodigoCobertura] [varchar](4) NULL,
	[IdentificacaoCobertura] [varchar](16) NOT NULL,
	[ValorIS] [decimal](13, 2) NULL,
	[ValorPremio] [decimal](13, 2) NULL
);  
                


 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_CoberturaMultirisco_TIPO6_SRG2_TEMP ON [dbo].[CoberturaMultirisco_TIPO6_SRG2_TEMP]
( 
 -- Codigo ASC
  [NumeroPropostaTratado],
  [CodigoCobertura]
);   

 /*Cria alguns índices para facilitar a busca*/  
CREATE NONCLUSTERED INDEX idx_CoberturaMultirisco_TIPO6_SRG2_TEMP_CodigoCobertura ON [dbo].[CoberturaMultirisco_TIPO6_SRG2_TEMP]
( 
 -- Codigo ASC
  [CodigoCobertura]
);   

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Proposta_CoberturaMultirisco_TIPO6_SRG2'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
                
    SET @COMANDO =
    '  INSERT INTO dbo.CoberturaMultirisco_TIPO6_SRG2_TEMP
        (   
          [Codigo],                          
        	[ControleVersao],                  
        	[NomeArquivo],                     
        	[DataArquivo],                     
        	[NumeroProposta],                  
        	[CodigoCobertura],                 
        	[IdentificacaoCobertura],          
        	[ValorIS],                         
        	[ValorPremio]  
	      )
     SELECT 
         [Codigo],                          
        	[ControleVersao],                  
        	[NomeArquivo],                     
        	[DataArquivo],                     
        	[NumeroProposta],                  
        	[CodigoCobertura],                 
        	[IdentificacaoCobertura],          
        	[ValorIS],                         
        	[ValorPremio]  
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_CoberturaMultirisco_TIPO6_SRG2] ''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.CoberturaMultirisco_TIPO6_SRG2_TEMP PRP                    

/*********************************************************************************************************************/
                  
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN
--print @MaiorCodigo

  
   /***********************************************************************
     Carregar as COBERTURAS
   ***********************************************************************/
     ;MERGE INTO Dados.Cobertura AS T
      USING (SELECT DISTINCT Q.CodigoCobertura, '' [Nome] 
             FROM CoberturaMultirisco_TIPO6_SRG2_TEMP Q
             WHERE Q.CodigoCobertura IS NOT NULL
            ) X
       ON T.[Codigo] = X.CodigoCobertura 
     WHEN NOT MATCHED
	          THEN INSERT (Codigo, Nome)
	               VALUES (X.[CodigoCobertura], X.[Nome])
   /***********************************************************************/   
               
      
   
  /*INSERE PROPOSTAS NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
  ;MERGE INTO Dados.Proposta AS T
    USING (SELECT DISTINCT Q.[NumeroPropostaTratado], 1 [IDSeguradora], /*Q.[NomeArquivo],*/ Q.[DataArquivo]
        FROM [dbo].[CoberturaMultirisco_TIPO6_SRG2_TEMP] Q
        WHERE Q.NumeroPropostaTratado IS NOT NULL
          ) X
    ON T.NumeroProposta = X.NumeroPropostaTratado
   AND T.IDSeguradora = X.IDSeguradora
   WHEN NOT MATCHED
          THEN INSERT ([NumeroProposta], [IDSeguradora], [TipoDado], [DataArquivo])
               VALUES (X.[NumeroPropostaTratado], X.[IDSeguradora], 'PRP-MULTIRSITO-TP6-SRG2', X.[DataArquivo]);
		     
		     
		     
    /*INSERE PROPOSTAS CLIENTE NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
    MERGE INTO Dados.PropostaCliente AS T
      USING (SELECT PRP.ID [IDProposta], 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' [NomeCliente], MAX(Q.[DataArquivo]) [DataArquivo]
          FROM [CoberturaMultirisco_TIPO6_SRG2_TEMP] Q
          INNER JOIN Dados.Proposta PRP
          ON PRP.NumeroProposta = Q.NumeroPropostaTratado
          AND PRP.IDSeguradora = 1
          WHERE Q.NumeroPropostaTratado IS NOT NULL
          GROUP BY PRP.ID
            ) X
      ON T.IDProposta = X.IDProposta
     WHEN NOT MATCHED
            THEN INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
                 VALUES (X.IDProposta, 'PRP-MULTIRSITO-TP6-SRG2', X.[NomeCliente], X.[DataArquivo]);   
                 		     

 /***********************************************************************

/*Apaga a marcação LastValue da tabela PropostaCobertura para atualizar a 
última posição das propostas recebidas. */

/* Gustavo Moreira - Data: 18/10/2013 */

     ***********************************************************************/	  

UPDATE Dados.PropostaCobertura SET LastValue = 0
--SELECT PRP.NumeroProposta, PC.*
FROM Dados.PropostaCobertura PC
	INNER JOIN Dados.Proposta PRP
	ON PC.IDProposta = PRP.ID
	AND PRP.IDSeguradora = 1
	INNER JOIN Dados.Cobertura COB
	ON COB.ID = PC.IDCobertura
	INNER JOIN DBO.CoberturaMultirisco_TIPO6_SRG2_TEMP CTT
	ON CTT.NumeroPropostaTratado = PRP.NumeroProposta
	AND CTT.CodigoCobertura = COB.Codigo
	WHERE PC.LastValue = 1												

  /*************************************************************************************/
  /*Chama a PROC que roda a importação registro a registro dos detalhes do RESIDENTIAL TP6 (PRPSASSE)*/
  /*************************************************************************************/ 
    ;MERGE INTO Dados.PropostaCobertura AS T
		USING (       
            SELECT *                                                                          
            FROM                                                                              
            (                                                                                
            SELECT                                                                           
              Q.[Codigo],                                                     
              Q.[ControleVersao],                                             
              Q.[NomeArquivo] [Arquivo],                                                
              Q.[DataArquivo],                           
              PRP.ID [IDProposta],                     
              C.[IDCobertura],
              TC.ID [IDTipoCobertura], 
              Q.[ValorIS] [ValorImportanciaSegurada],   
              Q.[ValorPremio], 
			  0 LastValue,
              ROW_NUMBER() OVER(PARTITION BY PRP.[ID], Q.[CodigoCobertura],  TC.ID ORDER BY Q.DataArquivo DESC, Q.[Codigo] DESC)  [ORDER]
            FROM [dbo].[CoberturaMultirisco_TIPO6_SRG2_TEMP]  Q
              LEFT JOIN Dados.Proposta PRP
              ON PRP.NumeroProposta = Q.NumeroPropostaTratado
              OUTER APPLY (SELECT TOP 1 ID [IDCobertura]
                           FROM Dados.Cobertura C
                           WHERE C.Codigo = Q.CodigoCobertura
                           ORDER BY ID ASC) C
              LEFT JOIN Dados.TipoCobertura TC
              ON TC.Descricao = Q.IdentificacaoCobertura
            ) A
            WHERE A.[ORDER] = 1
            /*LEFT JOIN Dados.Contrato CNT
            ON CNT.NumeroContrato = RTP5.[NumeroApoliceAnterior]              */
          ) AS X
    ON  T.[IDProposta] = X.[IDProposta]
    AND T.[IDCobertura] = X.[IDCobertura]
    AND T.[IDTipoCobertura] = X.[IDTipoCobertura]
    WHEN MATCHED
			    THEN UPDATE
				     SET
				         [ValorImportanciaSegurada] = COALESCE(X.[ValorImportanciaSegurada], T.[ValorImportanciaSegurada])
				        ,[ValorPremio] = COALESCE(X.[ValorPremio], T.[ValorPremio]) 
				        ,[DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo]) 
				        ,[Arquivo] = COALESCE(X.[Arquivo], T.[Arquivo])
						,LastValue = X.LastValue
    WHEN NOT MATCHED  
			    THEN INSERT          
              (   [IDProposta]                      
                , [IDCobertura]  
                , [IDTipoCobertura]
                , [ValorImportanciaSegurada]
                , [ValorPremio] 
				, LastValue
                , [DataArquivo]    
                , [Arquivo]
                )
          VALUES (   
                  X.[IDProposta]                           
                , X.[IDCobertura]  
                , X.[IDTipoCobertura]
                , X.[ValorImportanciaSegurada]
                , X.[ValorPremio]  
				, X.LastValue
                , X.[DataArquivo]    
                , X.[Arquivo]
                ); 
  /*************************************************************************************/ 

 	/*Atualiza a marcação LastValue das propostas recebidas para atualizar a última posição*/
	/*Egler - Data: 23/09/2013 */		 
    UPDATE Dados.PropostaCobertura SET LastValue = 1
    FROM Dados.PropostaCobertura PE
	INNER JOIN (
				SELECT ID, /*  PS.IDProposta, PS.IDCobertura*/ ROW_NUMBER() OVER (PARTITION BY PS.IDProposta, PS.IDCobertura ORDER BY PS.DataArquivo DESC, PS.ID DESC) [ORDEM]
				FROM Dados.PropostaCobertura PS
				WHERE PS.IDProposta IN (
										SELECT PRP.ID
										FROM DBO.CoberturaMultirisco_TIPO6_SRG2_TEMP CTT
										INNER JOIN Dados.Proposta PRP
										 ON CTT.NumeroPropostaTratado = PRP.NumeroProposta
										 AND PRP.IDSeguradora = 1
									   )
					) A
	 ON A.ID = PE.ID 
	 AND A.ORDEM = 1	  						

  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Proposta_CoberturaMultirisco_TIPO6_SRG2'
  /*************************************************************************************/
  
    
                  
  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[CoberturaMultirisco_TIPO6_SRG2_TEMP]        
  /*********************************************************************************************************************/
                
    SET @COMANDO =
    '  INSERT INTO dbo.CoberturaMultirisco_TIPO6_SRG2_TEMP
        (   
          [Codigo],                          
        	[ControleVersao],                  
        	[NomeArquivo],                     
        	[DataArquivo],                     
        	[NumeroProposta],                  
        	[CodigoCobertura],                 
        	[IdentificacaoCobertura],          
        	[ValorIS],                         
        	[ValorPremio]  
	      )
     SELECT 
         [Codigo],                          
        	[ControleVersao],                  
        	[NomeArquivo],                     
        	[DataArquivo],                     
        	[NumeroProposta],                  
        	[CodigoCobertura],                 
        	[IdentificacaoCobertura],          
        	[ValorIS],                         
        	[ValorPremio]  
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaProposta_CoberturaMultirisco_TIPO6_SRG2] ''''' + @PontoDeParada + ''''''') PRP
         '
  exec (@COMANDO)  

                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM dbo.CoberturaMultirisco_TIPO6_SRG2_TEMP PRP    

  
                    
  /*********************************************************************************************************************/

                    
  /*********************************************************************************************************************/
  
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CoberturaMultirisco_TIPO6_SRG2_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[CoberturaMultirisco_TIPO6_SRG2_TEMP];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH                                      

--EXEC [Dados].[proc_InsereProposta_CoberturaMultirisco_TIPO6_SRG2] 

