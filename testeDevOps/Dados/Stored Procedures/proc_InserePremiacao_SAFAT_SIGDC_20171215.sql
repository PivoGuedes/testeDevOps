 
/*
	Autor: André Anselmo
	Data Criação: 01/03/2016

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InserePremiacao_SAFAT_SIGDC
	Descrição: Procedimento que realiza a inserção de Premiação de Correspondente Bancário (ATENDENTE) no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:

	Ultima Ateração: Realizada em 01/03/2016 para adequação a padrão SIGDC

	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InserePremiacao_SAFAT_SIGDC_20171215] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PREMIACAO_SAFAT_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PREMIACAO_SAFAT_TEMP];

CREATE TABLE [dbo].[PREMIACAO_SAFAT_TEMP](
	[NomeArquivo] [nvarchar](100) NULL,
	[DataArquivo] [date] NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[Codigo] [bigint] NOT NULL,
	[CodigoProdutor] [int] NOT NULL,
	[NumeroRecibo] [bigint] NOT NULL,
	[NumeroMatricula] [bigint] NOT NULL,
	[NumeroApolice] [varchar](50) NOT NULL,
	[NumeroEndosso] [int] NOT NULL,
	[NumeroParcela] [smallint] NOT NULL,
	[NumeroBilhete] [varchar](50) NULL,
	[NumeroProposta] [varchar](50) NULL,
	[CodigoOperacao] [smallint] NULL,
	[CodigoFilialFaturamento] [smallint] NULL,
	[ValorCorretagem] [numeric](15, 2) NULL,
	[DataProcessamento] [date],
	[IDTipoProduto] tinyint NOT NULL DEFAULT(1)
)

 /*Cria alguns índices para facilitar a busca*/  
CREATE NONCLUSTERED INDEX idx_PREMIACAO_SAFAT_TEMP_NumeroMatricula ON [dbo].[PREMIACAO_SAFAT_TEMP]
( 
	NumeroMatricula ASC,
	[DataArquivo] DESC
)


CREATE NONCLUSTERED INDEX IDX_PREMIACAO_SAFAT_TEMP_NumeroProposta ON [dbo].[PREMIACAO_SAFAT_TEMP] 
(
	[NumeroProposta]
)

CREATE NONCLUSTERED INDEX IDX_PREMIACAO_SAFAT_TEMP_NumeroApolice ON [dbo].[PREMIACAO_SAFAT_TEMP] 
(
	[NumeroApolice]
)


SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'PREMIACAO_SAFAT_SIGDC'

--select @PontoDeParada = 200639

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
  
    SET @COMANDO =
    '  INSERT INTO dbo.PREMIACAO_SAFAT_TEMP
       ( 
		[NomeArquivo],
		[DataArquivo],
		[ControleVersao],
		[Codigo],
		[CodigoProdutor],
		[NumeroRecibo],
		[NumeroMatricula],
		[NumeroApolice],
		[NumeroEndosso],
		[NumeroParcela],
		[NumeroBilhete],
		[NumeroProposta],
		[CodigoOperacao],
		[CodigoFilialFaturamento],
		[ValorCorretagem],
		[DataProcessamento]
		)
       SELECT  
	  		[NomeArquivo],
			[DataArquivo],
			[ControleVersao],
			[Codigo],
			[CodigoProdutor],
			[NumeroRecibo],
			[NumeroMatricula],
			[NumeroApolice],
			[NumeroEndosso],
			[NumeroParcela],
			[NumeroBilhete],
			[NumeroProposta],
			[CodigoOperacao],
			[CodigoFilialFaturamento],
			[ValorCorretagem],
			[DataProcessamento]
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_recuperaPremiacao_SAFAT_SIGDC]''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.PREMIACAO_SAFAT_TEMP PRP                    

/*********************************************************************************************************************/
                           
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN
--print @MaiorCodigo
			-- BEGIN TRAN	 ROLLBACK
	;MERGE INTO Dados.Correspondente AS T	  --8006629
	USING (
		SELECT DISTINCT
			   PST.NumeroMatricula Matricula, 2 IDTipoCorrespondente, MAX(NomeArquivo) NomeArquivo, MAX(DataArquivo) DataArquivo 
		FROM PREMIACAO_SAFAT_TEMP PST
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
		FROM PREMIACAO_SAFAT_TEMP PST
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
		FROM PREMIACAO_SAFAT_TEMP PST
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
	
	
	/*INSERE AS FILIAIS DE FATURAMENTO NÃO LOCALIZADAS*/
	;MERGE INTO Dados.FilialFaturamento AS T
		USING (
		  SELECT DISTINCT
				 PST.[CodigoFilialFaturamento] 
		  FROM PREMIACAO_SAFAT_TEMP PST
		  WHERE PST.[CodigoFilialFaturamento] IS NOT NULL
			) AS X
	  ON  X.[CodigoFilialFaturamento] = T.[Codigo]
		 WHEN NOT MATCHED  
				THEN INSERT          
				(   
				 Codigo
				)
			VALUES (   
					X.[CodigoFilialFaturamento]);      
			
	  ;MERGE INTO Dados.Contrato AS T
      USING	
       (SELECT 
               1  [IDSeguradora] /*Caixa Seguros*/               
             , PST.[NumeroApolice] [NumeroContrato]
             --, 'CLIENTE DESCONHECIDO - APÓLICE NÃO RECEBIDA' [NomeCliente]
			 , PST.NumeroBilhete
             , MAX(PST.[DataArquivo]) [DataArquivo]
             , MAX(PST.NomeArquivo) [Arquivo]
        FROM [dbo].PREMIACAO_SAFAT_TEMP PST
        WHERE PST.[NumeroApolice] IS NOT NULL
        GROUP BY PST.[NumeroApolice], PST.NumeroBilhete
       ) X
      ON T.[NumeroContrato] = X.[NumeroContrato]
     AND T.[IDSeguradora] = X.[IDSeguradora]
     WHEN NOT MATCHED
                THEN INSERT ([NumeroContrato], [IDSeguradora], NumeroBilhete, /*[NomeCliente],*/ [Arquivo], [DataArquivo])
                     VALUES (X.[NumeroContrato], X.[IDSeguradora], X.NumeroBilhete, /*X.[NomeCliente],*/ X.[Arquivo], X.[DataArquivo]);  
				 				   
	/*INSERE PROPOSTAS NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
	;MERGE INTO Dados.Proposta AS T
	      USING (SELECT DISTINCT CNT.ID IDContrato, PST.[NumeroProposta],  1 [IDSeguradora], -1 [IDProduto], MAX(PST.NomeArquivo) [NomeArquivo], MAX(PST.[DataArquivo]) [DataArquivo]
				 FROM PREMIACAO_SAFAT_TEMP PST
				 INNER JOIN Dados.Contrato CNT
				 ON CNT.NumeroContrato = PST.NumeroApolice
				 AND CNT.IDSeguradora = 1 -- Caixa Seguros
				 WHERE PST.NumeroProposta IS NOT NULL
				 GROUP BY CNT.ID, PST.[NumeroProposta]
              ) X
        ON T.NumeroProposta = X.NumeroProposta
       AND T.IDSeguradora = X.IDSeguradora
       WHEN NOT MATCHED
		          THEN INSERT (NumeroProposta, IDContrato,  [IDSeguradora],  IDAgenciaVenda,    IDProduto,   IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
		               VALUES (X.[NumeroProposta], X.IDContrato, X.[IDSeguradora],       -1,  X.IDProduto,                0,              -1,                  0,           -1, [NomeArquivo], X.DataArquivo)		               

	 --Atualiza a proposta do contrato
	 ;UPDATE Dados.Contrato SET IDProposta = PRP.ID
	 FROM Dados.Contrato CNT
	 INNER JOIN PREMIACAO_SAFAT_TEMP PST
	 ON CNT.NumeroContrato = PST.NumeroApolice
	 AND CNT.IDSeguradora = 1
	 INNER JOIN Dados.Proposta PRP
	 ON PRP.NumeroProposta = PST.NumeroProposta
     AND PRP.IDSeguradora = 1
	 WHERE CNT.IDProposta IS NULL     

	 /***********************************************************************
       Carrega os dados da Correspondente
     ***********************************************************************/             
    ;MERGE INTO Dados.PremiacaoCorrespondente AS T
		USING (
				SELECT *
				FROM
				(
					SELECT 
					       FF.ID [IDFilialFaturamento],
						   PRT.ID [IDProdutor],
						   CO.ID [IDOperacao],
						   CRP.ID [IDCorrespondente],
						   PST.NumeroRecibo,
						   CNT.ID [IDContrato],
						   PRP.ID [IDProposta],
						   PST.NumeroEndosso,
						   PST.NumeroParcela,
						   PST.NumeroBilhete,
						   PST.ValorCorretagem,
						   PST.DataProcessamento,
						   PST.NumeroApolice [NumeroContrato],
						   PST.NumeroProposta,
						   PST.[NomeArquivo],
						   PST.[DataArquivo],						   
						   PST.[IDTipoProduto], 
						   --MAX(PST.[NomeArquivo]) [NomeArquivo],
						   --MAX(PST.[DataArquivo]) [DataArquivo],
						   pst.NumeroMatricula,
						   ROW_NUMBER() OVER(PARTITION BY PST.NumeroApolice, PST.NumeroProposta, PST.NumeroParcela, PST.CodigoOperacao ORDER BY PST.DataArquivo DESC, PST.DataProcessamento DESC) ORDEM            
					FROM dbo.PREMIACAO_SAFAT_TEMP PST
         				LEFT JOIN Dados.Proposta PRP
						ON PRP.NumeroProposta = PST.NumeroProposta
						AND PRP.IDSeguradora = 1
						LEFT JOIN Dados.Contrato CNT
						ON CNT.NumeroContrato = PST.NumeroApolice
						AND CNT.IDSeguradora = 1
						--LEFT JOIN Dados.Correspondente CRP
						--ON CRP.Matricula = PST.NumeroMatricula
						--AND CRP.IDTipoCorrespondente = 2
						OUTER APPLY (						            
						             SELECT TOP 1 CRP.ID --CRP.*--, DATEDIFF(DD, CRP.DataArquivo, PST.DataArquivo) MINDIFF--, CRP.DataArquivo, DATEDIFF(DD, CRP.DataArquivo, PST.DataArquivo) DIFF
						             FROM Dados.Correspondente CRP
						             WHERE CRP.Matricula = PST.NumeroMatricula
						               AND CRP.IDTipoCorrespondente = 2
									   --AND CRP.DataArquivo <= PST.DataArquivo
									-- GROUP BY DATEDIFF(DD, CRP.DataArquivo, PST.DataArquivo)
									 --HAVING DATEDIFF(DD, CRP.DataArquivo, PST.DataArquivo) = MIN(DATEDIFF(DD, CRP.DataArquivo, PST.DataArquivo))
									    AND DATEDIFF(DD, CRP.DataArquivo, PST.DataArquivo) > -30 
									 ORDER BY DATEDIFF(DD, CRP.DataArquivo, PST.DataArquivo)  DESC
									-- GROUP BY CRP.ID, CRP.DataArquivo
									) CRP

						LEFT JOIN Dados.ComissaoOperacao CO
						ON PST.CodigoOperacao = CO.Codigo
						LEFT JOIN Dados.Produtor PRT
						ON PST.CodigoProdutor = PRT.Codigo
						LEFT JOIN Dados.FilialFaturamento FF
						ON PST.CodigoFilialFaturamento = FF.Codigo
					--WHERE NumeroApolice = 108101353219
						--GROUP BY   FF.ID , PRT.ID ,	CO.ID , CRP.ID, PST.NumeroRecibo, CNT.ID ,
						--		   PRP.ID, PST.NumeroEndosso, PST.NumeroParcela, PST.NumeroBilhete, PST.ValorCorretagem, 
						--		   PST.DataProcessamento, PST.NumeroApolice, PST.NumeroProposta
				 ) A 
				 WHERE A.ORDEM = 1	  -- NumeroContrato is null or NumeroProposta is null --
				   AND A.IDCorrespondente IS NOT NULL
          ) AS X
    ON X.IDContrato = T.IDContrato  
   AND ISNULL(X.IDProposta,-1) = ISNULL(T.IDProposta,-1)
   AND X.NumeroParcela = T.NumeroParcela
   AND X.IDOperacao = T.IDOperacao
   AND X.IDProdutor = T.IDProdutor
   AND X.[IDCorrespondente] = T.IDCorrespondente
    WHEN NOT MATCHED
			    THEN INSERT          
              (	 
			     [IDFilialFaturamento],
			  	 [IDProdutor],
			  	 [IDOperacao],
			  	 [IDCorrespondente],
			  	 [NumeroRecibo],
			  	 [IDContrato],
			  	 [IDProposta],
			  	 [NumeroEndosso],
			  	 [NumeroParcela],
			  	 [NumeroBilhete],
			  	 [ValorCorretagem],
			  	 [DataProcessamento],
			  	 [NumeroContrato],
			  	 [NumeroProposta],
			  	 [Arquivo],
			  	 [DataArquivo],
				 [IDTipoProduto]
             )
          VALUES (X.[IDFilialFaturamento],
				  X.[IDProdutor],
				  X.[IDOperacao],
				  X.[IDCorrespondente],
				  X.[NumeroRecibo],
				  X.[IDContrato],
				  X.[IDProposta],
				  X.[NumeroEndosso],
				  X.[NumeroParcela],
				  X.[NumeroBilhete],
				  X.[ValorCorretagem],
				  X.[DataProcessamento],
				  X.[NumeroContrato],
				  X.[NumeroProposta],
				  X.[NomeArquivo],
				  X.[DataArquivo],
				  X.[IDTipoProduto]
                 );
		
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'PREMIACAO_SAFAT_SIGDC'
  /*************************************************************************************/
  

  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[PREMIACAO_SAFAT_TEMP]	   
  /*********************************************************************************************************************/                  
    
     SET @COMANDO =
    '  INSERT INTO dbo.PREMIACAO_SAFAT_TEMP
       ( 
		[NomeArquivo],
		[DataArquivo],
		[ControleVersao],
		[Codigo],
		[CodigoProdutor],
		[NumeroRecibo],
		[NumeroMatricula],
		[NumeroApolice],
		[NumeroEndosso],
		[NumeroParcela],
		[NumeroBilhete],
		[NumeroProposta],
		[CodigoOperacao],
		[CodigoFilialFaturamento],
		[ValorCorretagem],
		[DataProcessamento]
		)
       SELECT  
	  		[NomeArquivo],
			[DataArquivo],
			[ControleVersao],
			[Codigo],
			[CodigoProdutor],
			[NumeroRecibo],
			[NumeroMatricula],
			[NumeroApolice],
			[NumeroEndosso],
			[NumeroParcela],
			[NumeroBilhete],
			[NumeroProposta],
			[CodigoOperacao],
			[CodigoFilialFaturamento],
			[ValorCorretagem],
			[DataProcessamento]
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_recuperaPremiacao_SAFAT_SIGDC]''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO)   
                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM dbo.PREMIACAO_SAFAT_TEMP PRP    
                    
  /*********************************************************************************************************************/
                    
  /*********************************************************************************************************************/
  
END
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PREMIACAO_SAFAT_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PREMIACAO_SAFAT_TEMP];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     




--EXEC [Dados].[proc_InsereCorrespondente_SAFAT] 

