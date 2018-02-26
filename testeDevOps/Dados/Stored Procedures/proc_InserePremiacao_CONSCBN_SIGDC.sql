 
/*
	Autor: Egler Vieira
	Data Criação: 16/04/2014

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InserePremiacao_CONSCBN
	Descrição: Procedimento que realiza a inserção de premiação de correspondente Bancário no banco de dados.
		
	Parâmetros de entrada:	 	
					
	Retorno:	

OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InserePremiacao_CONSCBN_SIGDC] 
AS
			 
BEGIN TRY												
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PREMIACAO_CONSCBN_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PREMIACAO_CONSCBN_TEMP];

CREATE TABLE [dbo].[PREMIACAO_CONSCBN_TEMP](
	[NomeArquivo] [nvarchar](100) NULL,
	[DataArquivo] [date] NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[Codigo] [bigint] NOT NULL,		
	[CodigoProdutor] [bigint] NOT NULL DEFAULT(2), --Codigo 2 ->FPC PAR CORRETORA DE SEGUROS SA - PREMIACAO CONSÓRCIO CBN
	[NumeroMatricula] [bigint] NOT NULL,
	[NumeroContrato] [varchar](20) NOT NULL,
	[NumeroParcela] [smallint] NOT NULL,
	[CodigoOperacao] [smallint] NULL DEFAULT(1001), --Corretagem
	[ValorComissao] [numeric](15, 2) NULL,
	DataReferencia date NOT NULL,
	Grupo bigint NOT NULL,
	Cota bigint NOT NULL, 			  	
	UF varchar(2) NULL,
	IDSeguradora smallint NOT NULL DEFAULT(5), -- Caixa Consórcio
	[IDTipoProduto] tinyint NOT NULL DEFAULT(2),	-- Consórcio
	[DataProcessamento] DATE NOT NULL
)



 /*Cria alguns índices para facilitar a busca*/  
CREATE NONCLUSTERED INDEX idx_PREMIACAO_CONSCBN_TEMP_NumeroMatricula ON [dbo].[PREMIACAO_CONSCBN_TEMP]
( 
	NumeroMatricula ASC,
	[DataArquivo] DESC
) 


CREATE NONCLUSTERED INDEX IDX_PREMIACAO_CONSCBN_TEMP_NumeroContrato ON [dbo].[PREMIACAO_CONSCBN_TEMP] 
(
	[NumeroContrato]
)


SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'PREMIACAO_CONSCBN_SIGDC'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
   SET @COMANDO =
    '  INSERT INTO dbo.PREMIACAO_CONSCBN_TEMP
       ( 
				NomeArquivo,
				DataArquivo,
				ControleVersao,
				Codigo,
				NumeroMatricula, 
				NumeroContrato,
				Grupo,
				Cota,
				NumeroParcela,			  	
				ValorComissao,
				UF,
				DataReferencia,
				DataProcessamento
		)
       SELECT  
	  			NomeArquivo,
				DataArquivo,
				ControleVersao,
				Codigo,
				NumeroMatricula, 
				NumeroContrato,
				Grupo,
				Cota,
				NumeroParcela,			  	
				ValorComissao,
				UF,
				DataReferencia,
				DataProcessamento
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_recuperaPremiacao_CONSCBN_SIGDC]''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.PREMIACAO_CONSCBN_TEMP PRP                    

/*********************************************************************************************************************/
                           
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN
--print @MaiorCodigo   		   
	;MERGE INTO Dados.Correspondente AS T	  --8006629
	USING (
		SELECT DISTINCT
			   PST.NumeroMatricula Matricula, 1 IDTipoCorrespondente, MAX(NomeArquivo) NomeArquivo, MAX(DataArquivo) DataArquivo   /*CORRESPONDENETE 1 -> CASA LÓTÉRICA*/
		FROM PREMIACAO_CONSCBN_TEMP PST
		WHERE PST.NumeroMatricula IS NOT NULL
		--AND NOT EXISTS (SELECT * FROM DADOS.Correspondente C WHERE C.Matricula = pst.numeromatricula)
		GROUP BY PST.NumeroMatricula
		  ) AS X
	ON  X.Matricula = T.Matricula
	   WHEN NOT MATCHED  
			THEN INSERT          
			  (   
			   Matricula, IDTipoCorrespondente, NomeArquivo, DataArquivo
			  )
		  VALUES (   
				  X.Matricula, IDTipoCorrespondente, NomeArquivo, DataArquivo);
		 
	;MERGE INTO Dados.ComissaoOperacao AS T
	USING (
		SELECT DISTINCT
			   PST.CodigoOperacao 
		FROM PREMIACAO_CONSCBN_TEMP PST
		WHERE PST.CodigoOperacao IS NOT NULL
		  ) AS X
	ON  X.CodigoOperacao = T.[Codigo]
	   WHEN NOT MATCHED  
			THEN INSERT          
			  (   
			   Codigo
			  )
		  VALUES (   
				  X.[CodigoOperacao]);

	/*INSERE OS PRODUTORES NÃO LOCALIZADOS*/	
	;MERGE INTO Dados.Produtor AS T
	USING (
		SELECT DISTINCT
			   PST.[CodigoProdutor] 
		FROM PREMIACAO_CONSCBN_TEMP PST
		WHERE PST.[CodigoProdutor] IS NOT NULL
		  ) AS X
	ON  X.[CodigoProdutor] = T.[Codigo]
	   WHEN NOT MATCHED  
			THEN INSERT          
			  (   
			   Codigo
			  )
		  VALUES (   
				  X.[CodigoProdutor]);  
									 
 
			
	  ;MERGE INTO Dados.Contrato AS T
      USING	
       (SELECT 
               [IDSeguradora] /*Caixa Seguros*/               
             , PST.[NumeroContrato]
             --, 'CLIENTE DESCONHECIDO - APÓLICE NÃO RECEBIDA' [NomeCliente]
             , MAX(PST.[DataArquivo]) [DataArquivo]
             , MAX(PST.NomeArquivo) [Arquivo]
        FROM [dbo].PREMIACAO_CONSCBN_TEMP PST
        WHERE PST.[NumeroContrato] IS NOT NULL
        GROUP BY [IDSeguradora], PST.[NumeroContrato]
       ) X
      ON T.[NumeroContrato] = X.[NumeroContrato]
     AND T.[IDSeguradora] = X.[IDSeguradora]
     WHEN NOT MATCHED
                THEN INSERT ([NumeroContrato], [IDSeguradora], /*[NomeCliente],*/ [Arquivo], [DataArquivo])
                     VALUES (X.[NumeroContrato], X.[IDSeguradora], /*X.[NomeCliente],*/ X.[Arquivo], X.[DataArquivo]);  
		 							   
	 			
	 --begin tran          
    ;MERGE INTO Dados.PremiacaoCorrespondente AS T
		USING (
				SELECT *
				FROM
				(
					SELECT 
	
						   PRT.ID [IDProdutor],
						   CO.ID [IDOperacao],
						   CRP.ID [IDCorrespondente],
	
						   CNT.ID [IDContrato],
	
						   PST.NumeroParcela,
						   PST.ValorComissao,

						   PST.[NumeroContrato],

						   PST.[NomeArquivo],
						   PST.[DataArquivo],
						   PST.NumeroMatricula,
						   PST.Grupo,
						   PST.Cota,
						   PST.[IDTipoProduto],
						   --MAX(PST.[NomeArquivo]) [NomeArquivo],
						   --MAX(PST.[DataArquivo]) [DataArquivo],
						   PST.[DataProcessamento],
						   ROW_NUMBER() OVER(PARTITION BY PST.NumeroContrato, PST.NumeroParcela, PST.CodigoOperacao ORDER BY PST.DataArquivo DESC, PST.[DataProcessamento] DESC) ORDEM            
					FROM dbo.PREMIACAO_CONSCBN_TEMP PST
 							LEFT JOIN Dados.Contrato CNT
						ON CNT.NumeroContrato = PST.NumeroContrato
						AND CNT.IDSeguradora = PST.IDSeguradora
						LEFT JOIN Dados.Correspondente CRP
						ON CRP.Matricula = PST.NumeroMatricula
						AND CRP.IDTipoCorrespondente = 1
						--AND PST.[DataArquivo] = CRP.DataArquivo
						LEFT JOIN Dados.ComissaoOperacao CO
						ON PST.CodigoOperacao = CO.Codigo
						LEFT JOIN Dados.Produtor PRT
						ON PST.CodigoProdutor = PRT.Codigo
					--WHERE PST.nUMEROcONTRATO IN ('655996','656013')


					--WHERE PRP.NumeroProposta = '090337090001953'
						--GROUP BY   FF.ID , PRT.ID ,	CO.ID , CRP.ID, PST.NumeroRecibo, CNT.ID ,
						--		   PRP.ID, PST.NumeroEndosso, PST.NumeroParcela, PST.NumeroBilhete, PST.ValorCorretagem, 
						--		   PST.DataProcessamento, PST.NumeroApolice, PST.NumeroProposta
				 ) A 
				 WHERE A.ORDEM = 1	  -- NumeroContrato is null or NumeroProposta is null --
				   AND A.IDCorrespondente IS NOT NULL
          ) AS X
    ON X.IDContrato = T.IDContrato  
   AND T.IDProposta IS NULL
   AND X.NumeroParcela = T.NumeroParcela
   AND X.IDOperacao = T.IDOperacao
   AND X.IDProdutor = T.IDProdutor
   AND X.[IDCorrespondente] = T.IDCorrespondente
   WHEN MATCHED THEN
     UPDATE SET T.[IDCorrespondente] = X.[IDCorrespondente],
	      	    T.[Grupo] = X.[Grupo],
				T.Cota = X.Cota,
				T.IDTipoProduto =  X.IDTipoProduto,
				T.[ValorCorretagem] = X.[ValorComissao]
    WHEN NOT MATCHED
			    THEN INSERT          
              (	 
			  	 [IDProdutor],
			  	 [IDOperacao],
			  	 [IDCorrespondente],
			  	 [IDContrato],
			  	 [NumeroParcela],
			  	 [ValorCorretagem],
			  	 [NumeroContrato],
			  	 [Arquivo],
			  	 [DataArquivo],
				 [Grupo],
				 [Cota],
				 IDTipoProduto,
				 [DataProcessamento]
             )
          VALUES (
				  X.[IDProdutor],
				  X.[IDOperacao],
				  X.[IDCorrespondente],
				  X.[IDContrato],
				  X.[NumeroParcela],
				  X.[ValorComissao],
				  X.[NumeroContrato],
				  X.[NomeArquivo],
				  X.[DataArquivo],
				  X.[Grupo],
				  X.[Cota],
				  X.IDTipoProduto,
				  X.[DataProcessamento]
                 );				 
				  			  
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'PREMIACAO_CONSCBN_SIGDC'
  /*************************************************************************************/
  

  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[PREMIACAO_CONSCBN_TEMP]	   
  /*********************************************************************************************************************/                  
    
      SET @COMANDO =
    '  INSERT INTO dbo.PREMIACAO_CONSCBN_TEMP
       ( 
				NomeArquivo,
				DataArquivo,
				ControleVersao,
				Codigo,
				NumeroMatricula, 
				NumeroContrato,
				Grupo,
				Cota,
				NumeroParcela,			  	
				ValorComissao,
				UF,
				DataReferencia,
				DataProcessamento
		)
       SELECT  
	  			NomeArquivo,
				DataArquivo,
				ControleVersao,
				Codigo,
				NumeroMatricula, 
				NumeroContrato,
				Grupo,
				Cota,
				NumeroParcela,			  	
				ValorComissao,
				UF,
				DataReferencia,
				DataProcessamento
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_recuperaPremiacao_CONSCBN_SIGDC]''''' + @PontoDeParada + ''''''') PRP
	   '
exec (@COMANDO)   
                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM dbo.PREMIACAO_CONSCBN_TEMP PRP    
                    
  /*********************************************************************************************************************/
                    
  /*********************************************************************************************************************/
  
END
AA:
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PREMIACAO_CONSCBN_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PREMIACAO_CONSCBN_TEMP];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     




--EXEC [Dados].[proc_InsereCorrespondente_CONSCBN] 

