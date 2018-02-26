 
/*
	Autor: Egler Vieira
	Data Criação: 26/02/2014

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InserePremiacao_SAFCBN
	Descrição: Procedimento que realiza a inserção de premiação de correspondente Bancário no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InserePremiacao_SAFCBN] 
AS
			 
		 
BEGIN TRY												

DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PREMIACAO_SAFCBN_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PREMIACAO_SAFCBN_TEMP];

CREATE TABLE [dbo].[PREMIACAO_SAFCBN_TEMP](
	[NomeArquivo] [nvarchar](100) NULL,
	[DataArquivo] [date] NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[Codigo] [bigint] NOT NULL,
	[CodigoProdutor] [int] NOT NULL,
	[NumeroRecibo] [int] NOT NULL,
	[NumeroMatricula] [bigint] NOT NULL,
	[NumeroApolice] [varchar](20) NOT NULL,
	[NumeroEndosso] [int] NOT NULL,
	[NumeroParcela] [smallint] NOT NULL,
	[NumeroBilhete] [varchar](20) NULL,
	[NumeroProposta] [varchar](20) NULL,
	[CodigoOperacao] [smallint] NULL,
	[CodigoFilialFaturamento] [smallint] NULL,
	[ValorCorretagem] [numeric](15, 2) NULL,
	[DataProcessamento] [date],
	[IDTipoProduto] tinyint NOT NULL DEFAULT(1)
)

 /*Cria alguns índices para facilitar a busca*/  
CREATE NONCLUSTERED INDEX idx_PREMIACAO_SAFCBN_TEMP_NumeroMatricula ON [dbo].[PREMIACAO_SAFCBN_TEMP]
( 
	NumeroMatricula ASC,
	[DataArquivo] DESC
)


CREATE NONCLUSTERED INDEX IDX_PREMIACAO_SAFCBN_TEMP_NumeroProposta ON [dbo].[PREMIACAO_SAFCBN_TEMP] 
(
	[NumeroProposta]
)

CREATE NONCLUSTERED INDEX IDX_PREMIACAO_SAFCBN_TEMP_NumeroApolice ON [dbo].[PREMIACAO_SAFCBN_TEMP] 
(
	[NumeroApolice]
)


SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'PREMIACAO_SAFCBN'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
   SET @COMANDO =
    '  INSERT INTO dbo.PREMIACAO_SAFCBN_TEMP
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
       ''EXEC [Fenae].[Corporativo].[proc_recuperaPremiacao_SAFCBN]''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.PREMIACAO_SAFCBN_TEMP PRP                    

/*********************************************************************************************************************/
                           
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN
--print @MaiorCodigo   		   
	  UPDATE ControleDados.PontoParada 
	  SET PontoParada = @PontoDeParada
	  WHERE NomeEntidade = 'PREMIACAO_SAFCBN'


	;MERGE INTO Dados.Correspondente AS T	  --8006629
	USING (
		SELECT DISTINCT
			   PST.NumeroMatricula Matricula, 1 IDTipoCorrespondente, MAX(NomeArquivo) NomeArquivo, MAX(DataArquivo) DataArquivo   /*CORRESPONDENETE 1 -> CASA LÓTÉRICA*/
		FROM PREMIACAO_SAFCBN_TEMP PST
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
		FROM PREMIACAO_SAFCBN_TEMP PST
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
		FROM PREMIACAO_SAFCBN_TEMP PST
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
		  FROM PREMIACAO_SAFCBN_TEMP PST
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
        FROM [dbo].PREMIACAO_SAFCBN_TEMP PST
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
				 FROM PREMIACAO_SAFCBN_TEMP PST
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
	 INNER JOIN PREMIACAO_SAFCBN_TEMP PST
	 ON CNT.NumeroContrato = PST.NumeroApolice
	 AND CNT.IDSeguradora = 1
	 INNER JOIN Dados.Proposta PRP
	 ON PRP.NumeroProposta = PST.NumeroProposta
     AND PRP.IDSeguradora = 1
	 WHERE CNT.IDProposta IS NULL     
	   
	 ------------------if (select count(*)
		------------------ from (SELECT *
		------------------		FROM
		------------------		(
		------------------			SELECT 
		------------------			       FF.ID [IDFilialFaturamento],
		------------------				   PRT.ID [IDProdutor],
		------------------				   CO.ID [IDOperacao],
		------------------				   CRP.ID [IDCorrespondente],
		------------------				   PST.NumeroRecibo,
		------------------				   CNT.ID [IDContrato],
		------------------				   PRP.ID [IDProposta],
		------------------				   PST.NumeroEndosso,
		------------------				   PST.NumeroParcela,
		------------------				   PST.NumeroBilhete,
		------------------				   PST.ValorCorretagem,
		------------------				   PST.DataProcessamento,
		------------------				   PST.NumeroApolice [NumeroContrato],
		------------------				   PST.NumeroProposta,
		------------------				   PST.[NomeArquivo],
		------------------				   PST.[DataArquivo],
		------------------				   PST.NumeroMatricula,
		------------------				   --MAX(PST.[NomeArquivo]) [NomeArquivo],
		------------------				   --MAX(PST.[DataArquivo]) [DataArquivo],

		------------------				   ROW_NUMBER() OVER(PARTITION BY PST.NumeroApolice, PST.NumeroProposta, PST.NumeroParcela, PST.CodigoOperacao ORDER BY PST.DataArquivo DESC, PST.DataProcessamento DESC) ORDEM            
		------------------			FROM dbo.PREMIACAO_SAFCBN_TEMP PST
  ------------------       				LEFT JOIN Dados.Proposta PRP
		------------------				ON PRP.NumeroProposta = PST.NumeroProposta
		------------------				AND PRP.IDSeguradora = 1
		------------------				LEFT JOIN Dados.Contrato CNT
		------------------				ON CNT.NumeroContrato = PST.NumeroApolice
		------------------				AND CNT.IDSeguradora = 1
		------------------				LEFT JOIN Dados.Correspondente CRP
		------------------				ON CRP.Matricula = PST.NumeroMatricula
		------------------				AND CRP.IDTipoCorrespondente = 1
		------------------				LEFT JOIN Dados.ComissaoOperacao CO
		------------------				ON PST.CodigoOperacao = CO.Codigo
		------------------				LEFT JOIN Dados.Produtor PRT
		------------------				ON PST.CodigoProdutor = PRT.Codigo
		------------------				LEFT JOIN Dados.FilialFaturamento FF
		------------------				ON PST.CodigoFilialFaturamento = FF.Codigo
		------------------			--WHERE NumeroApolice = 108101353219
		------------------				--GROUP BY   FF.ID , PRT.ID ,	CO.ID , CRP.ID, PST.NumeroRecibo, CNT.ID ,
		------------------				--		   PRP.ID, PST.NumeroEndosso, PST.NumeroParcela, PST.NumeroBilhete, PST.ValorCorretagem, 
		------------------				--		   PST.DataProcessamento, PST.NumeroApolice, PST.NumeroProposta
		------------------		 ) A 
		------------------		 WHERE  A.ORDEM = 1
		------------------	)a) <> 1000
	 ------------------  begin
	 ------------------   print @pontodeparada
		------------------goto AA
	 ------------------  end

--DELETE Dados.PremiacaoCorrespondente
--FROM Dados.PremiacaoCorrespondente P
--INNER JOIN Dados.Correspondente C
--ON C.ID = P.IDCorrespondente
--WHERE P.DataArquivo BETWEEN '2015-09-01' AND '2015-09-30'
--AND P.IDTipoProduto = 1
--AND C.IDTipoCorrespondente = 1
--AND Arquivo <> 'CORREÇÃO MANUAL OUVIDORIA CEF - 2015-09-21'
--and Arquivo like '%FN0701B.COMISSAO.SAFCBN.TXT'

--SELECT @@TRANCOUNT
	
--SELECT SUM(P.ValorCorretagem)--, IDOPERACAO
--FROM Dados.PremiacaoCorrespondente P
--	INNER JOIN Dados.Correspondente C
--	ON C.ID = P.IDCorrespondente
--WHERE P.DataArquivo BETWEEN '2015-09-01' AND '2015-09-30'
--	AND P.IDTipoProduto = 1
--	AND C.IDTipoCorrespondente = 1
--	AND Arquivo <> 'CORREÇÃO MANUAL OUVIDORIA CEF - 2015-09-21'
--GROUP BY P.IDOPERACAO


	 /***********************************************************************
       Carrega os dados da Correspondente
     ***********************************************************************/   
	 --begin tran          
    ;MERGE INTO Dados.PremiacaoCorrespondente AS T
		USING (
				--SELECT *
				--FROM
				--(
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
						   SUM(PST.ValorCorretagem) ValorCorretagem,
						   PST.DataProcessamento,
						   PST.NumeroApolice [NumeroContrato],
						   PST.NumeroProposta,
						   PST.[NomeArquivo],
						   PST.[DataArquivo],
						  -- CRP.DataArquivo,
						  -- CRP.DIFF,
						   PST.[IDTipoProduto],
						   PST.NumeroMatricula
						   --CRP.*,
						   --MAX(PST.[NomeArquivo]) [NomeArquivo],
						   --MAX(PST.[DataArquivo]) [DataArquivo],

						   --ROW_NUMBER() OVER(PARTITION BY PST.NumeroApolice, ISNULL(PST.NumeroProposta, ''), PST.NumeroParcela, PST.CodigoOperacao, PRT.ID, PST.NumeroMatricula ORDER BY PST.DataArquivo DESC, PST.DataProcessamento DESC) ORDEM            
					FROM dbo.PREMIACAO_SAFCBN_TEMP PST
         				LEFT JOIN Dados.Proposta PRP
						ON PRP.NumeroProposta = PST.NumeroProposta
						AND PRP.IDSeguradora = 1
						LEFT JOIN Dados.Contrato CNT
						ON CNT.NumeroContrato = PST.NumeroApolice
						AND CNT.IDSeguradora = 1
						OUTER APPLY (						            
						             SELECT TOP 1 CRP.ID --CRP.*--, DATEDIFF(DD, CRP.DataArquivo, PST.DataArquivo) MINDIFF--, CRP.DataArquivo, DATEDIFF(DD, CRP.DataArquivo, PST.DataArquivo) DIFF
						             FROM Dados.Correspondente CRP
						             WHERE CRP.Matricula = PST.NumeroMatricula
						               AND CRP.IDTipoCorrespondente = 1
									   --AND CRP.DataArquivo <= PST.DataArquivo
									-- GROUP BY DATEDIFF(DD, CRP.DataArquivo, PST.DataArquivo)
									 --HAVING DATEDIFF(DD, CRP.DataArquivo, PST.DataArquivo) = MIN(DATEDIFF(DD, CRP.DataArquivo, PST.DataArquivo))
									   -- AND DATEDIFF(DD, CRP.DataArquivo, PST.DataArquivo) > -30 
									 ORDER BY ABS(DATEDIFF(DD, CRP.DataArquivo, PST.DataArquivo))  DESC
									-- GROUP BY CRP.ID, CRP.DataArquivo
									) CRP
						LEFT JOIN Dados.ComissaoOperacao CO
						ON PST.CodigoOperacao = CO.Codigo
						LEFT JOIN Dados.Produtor PRT
						ON PST.CodigoProdutor = PRT.Codigo
						LEFT JOIN Dados.FilialFaturamento FF
						ON PST.CodigoFilialFaturamento = FF.Codigo
					GROUP BY  FF.ID ,
						   PRT.ID ,
						   CO.ID ,
						   CRP.ID ,
						   PST.NumeroRecibo,
						   CNT.ID ,
						   PRP.ID ,
						   PST.NumeroEndosso,
						   PST.NumeroParcela,
						   PST.NumeroBilhete,
						   PST.DataProcessamento,
						   PST.NumeroApolice,
						   PST.NumeroProposta,
						   PST.[NomeArquivo],
						   PST.[DataArquivo],
						  -- CRP.DataArquivo,
						  -- CRP.DIFF,
						   PST.[IDTipoProduto],
						   PST.NumeroMatricula
					--WHERE PRP.NumeroProposta = '090337090001953'
						--GROUP BY   FF.ID , PRT.ID ,	CO.ID , CRP.ID, PST.NumeroRecibo, CNT.ID ,
						--		   PRP.ID, PST.NumeroEndosso, PST.NumeroParcela, PST.NumeroBilhete, PST.ValorCorretagem, 
						--		   PST.DataProcessamento, PST.NumeroApolice, PST.NumeroProposta
				-- ) A 
				 --WHERE A.ORDEM = 1	  -- NumeroContrato is null or NumeroProposta is null --
				 --  AND A.IDCorrespondente IS NOT NULL
          ) AS X
    ON X.IDContrato = T.IDContrato  
   AND ISNULL(X.IDProposta,-1) = ISNULL(T.IDProposta,-1)
   AND X.NumeroParcela = T.NumeroParcela
   AND X.IDOperacao = T.IDOperacao
   AND X.IDProdutor = T.IDProdutor
   AND X.[IDCorrespondente] = T.IDCorrespondente
   AND X.DataArquivo = T.DataArquivo
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
  SET @PontoDeParada = LEFT(DATEADD(MM, 1, Cast(@PontoDeParada + '-01' as date)), 7)
   
  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[PREMIACAO_SAFCBN_TEMP]	   
  /*********************************************************************************************************************/                  
    
     SET @COMANDO =
    '  INSERT INTO dbo.PREMIACAO_SAFCBN_TEMP
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
       ''EXEC [Fenae].[Corporativo].[proc_recuperaPremiacao_SAFCBN]''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO)   
                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM dbo.PREMIACAO_SAFCBN_TEMP PRP    
  
 -- IF (@MaiorCodigo  IS NOT NULL)      
          

  /*************************************************************************************/
  /*********************************************************************************************************************/
                    
  /*********************************************************************************************************************/
  
END
AA:
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PREMIACAO_SAFCBN_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PREMIACAO_SAFCBN_TEMP];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     




--EXEC [Dados].[proc_InsereCorrespondente_SAFCBN] 

