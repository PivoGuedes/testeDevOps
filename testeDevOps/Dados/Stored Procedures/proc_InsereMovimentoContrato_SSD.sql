

/*
	Autor: Egler Vieira
	Data Criação: 25/07/2014

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereMovimentoContrato_SSD
	Descrição: Procedimento que realiza a inserção das movimentações das propostas  no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'ANTARES', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereMovimentoContrato_SSD] 
AS
   
BEGIN TRY		
	    
DECLARE @PontoDeParada AS VARCHAR(400) 
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MovimentoContrato_SSD_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[MovimentoContrato_SSD_TEMP];

CREATE TABLE [dbo].[MovimentoContrato_SSD_TEMP]
(
    [TIPO_DADO]                       VARCHAR(30) DEFAULT ('SSD.MOVCON') NOT NULL,
    [ID_SEGURADORA]                   [SMALLINT] DEFAULT(1) NOT NULL,
	[SUK_CONTRATO_VIDA]               [INT] NOT NULL,
    [DTH_MOVIMENTO]                   [date] NOT NULL,
	[DTH_OPERACAO]                    [date] NOT NULL,
	[NUM_OCORRENCIA]                  [int] NOT NULL,
	[DTH_ATUALIZACAO]                 [date] NOT NULL,
	[VLR_PREMIO]                      [decimal](18, 2) NULL,
	[VLR_IS]                          [decimal](18, 2) NULL,
	[QTD_VIDAS]                       [int] NULL,
	[NUM_BIL_CERTIF]                  [varchar](20) NOT NULL,
	[NUM_APOLICE]                     [decimal](15, 0) NULL,
	[NUM_PROPOSTA_SIVPF]              [varchar](20) NULL,
    [NUM_PROPOSTA_TRATADO]            AS Cast(dbo.fn_TrataNumeroPropostaZeroExtra(ISNULL([NUM_PROPOSTA_SIVPF],'SN' + [NUM_BIL_CERTIF])) as VARCHAR(20)) PERSISTED,
    [NUM_CERTIFICADO_TRATADO]         AS Cast(dbo.fn_TrataNumeroPropostaZeroExtra([NUM_BIL_CERTIF]) as VARCHAR(20)) PERSISTED,
	[NUM_CONTRATO]                    [decimal](15, 0) NULL,
	[IND_ORIGEM_REGISTRO]             [char](1) NULL,
	[COD_PRODUTO_SIAS]                [varchar](5) NOT NULL,
	[COD_PRODUTO_SIVPF]               [char](2) NULL,
	[IDSUBOPERACAO]                   [varchar](11) NULL,
	[STA_ANTECIPACAO]				  [bit] null,
	[STA_MUDANCA_PLANO]				  [bit] null
) 


 /*Cria Índices*/  
CREATE CLUSTERED INDEX idx_SituacaoPagamento_STAFPREV_TEMP ON [dbo].[MovimentoContrato_SSD_TEMP] ([SUK_CONTRATO_VIDA] ASC)  

--CREATE NONCLUSTERED INDEX IDX_NumeroProposta_STAFPREV_TEMP  ON [dbo].[MovimentoFinanceiro_SSD_TEMP] ([NumeroProposta],[SituacaoCobranca],[DataOperacao], [DataArquivo] DESC, Codigo DESC)

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'MovimentoContrato_SSD'


/*********************************************************************************************************************/               
/*Recupera maior Código do retorno*/
/*********************************************************************************************************************/
--DECLARE @PontoDeParada AS VARCHAR(400) 
--set @PontoDeParada = 0
---DECLARE @MaiorCodigo AS BIGINT
--DECLARE @ParmDefinition NVARCHAR(500)
--DECLARE @COMANDO AS NVARCHAR(max)

SET @COMANDO = 'INSERT INTO [dbo].[MovimentoContrato_SSD_TEMP] 
				(  
                     [SUK_CONTRATO_VIDA]      
                   , [DTH_MOVIMENTO]          
                   , [DTH_OPERACAO]           
                   , [NUM_OCORRENCIA]         
                   , [DTH_ATUALIZACAO]        
                   , [VLR_PREMIO]             
                   , [VLR_IS]                 
                   , [QTD_VIDAS]              
                   , [NUM_BIL_CERTIF]         
                   , [NUM_APOLICE]            
                   , [NUM_PROPOSTA_SIVPF]     
                   , [NUM_CONTRATO]           
                   , [IND_ORIGEM_REGISTRO]    
                   , [COD_PRODUTO_SIAS]  
				   , [COD_PRODUTO_SIVPF]     
                   , [IDSUBOPERACAO] 
				)  
                SELECT 
                     [SUK_CONTRATO_VIDA]      
                   , Cast([DTH_MOVIMENTO] as Date) DTH_MOVIMENTO        
                   , Cast([DTH_OPERACAO] as Date) DTH_OPERACAO         
                   , [NUM_OCORRENCIA]         
                   , Cast([DTH_ATUALIZACAO] as Date) DTH_ATUALIZACAO        
                   , [VLR_PREMIO]             
                   , [VLR_IS]                 
                   , [QTD_VIDAS]              
                   , [NUM_BIL_CERTIF]         
                   , [NUM_APOLICE]            
                   , [NUM_PROPOSTA_SIVPF]     
                   , [NUM_CONTRATO]           
                   , [IND_ORIGEM_REGISTRO]    
                   , [COD_PRODUTO_SIAS]  
				   , [COD_PRODUTO_SIVPF]     
                   , [IDSUBOPERACAO]         
                FROM OPENQUERY ([ANTARES], 
                ''EXEC [Corporativo].[SSD].[proc_RecuperaMovimentoContrato] ''''' + @PontoDeParada + ''''''') PRP' --@PontoDeParada

EXEC (@COMANDO)     

SELECT @MaiorCodigo = MAX(PRP.SUK_CONTRATO_VIDA)
FROM [dbo].[MovimentoContrato_SSD_TEMP] PRP

--SELECT * FROM [dbo].[MovimentoContrato_SSD_TEMP] PRP

SET @COMANDO = ''     

WHILE @MaiorCodigo IS NOT NULL
BEGIN 

    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir OperacaoContratual não recebidas
    -----------------------------------------------------------------------------------------------------------------------
      ;MERGE INTO Dados.OperacaoContratual AS T
	      USING (
                 SELECT DISTINCT
                         SSD.IDSUBOPERACAO [ID], '' Descricao, LEFT(SSD.IDSUBOPERACAO,1) IDOrigem
                 FROM dbo.MovimentoContrato_SSD_TEMP SSD
                 WHERE SSD.IDSUBOPERACAO IS NOT NULL              
              ) X
         ON T.[ID] = X.[ID]  
       WHEN NOT MATCHED
		          THEN INSERT ([ID], Descricao, IDOrigem)
		               VALUES (X.[ID], X.Descricao, X.IDOrigem);		   
                       
                      --, SSD.[VLR_IOF] 
	                  --, SSD.[VLR_CUSTO_EMISSAO]  
                      --, SSD.[NUM_MATRICULA_ECONOM]                                                          
	                  --, SSD.[NUM_MATRICULA_PDV]                                                             
	                  --, SSD.[NUM_APOLICE_ANTERIOR]                                                          
	                  --, SSD.[IND_RENOVACAO]               
                      --, SSD.[COD_SUBGRUPO]                                                                  
	                  --, SSD.[IND_PERI_PAGAMENTO]                                                            
	                  --, SSD.[COD_OPCAO_PAGAMENTO] 
	-----------------------------------------------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir Produtos não registrados
    -----------------------------------------------------------------------------------------------------------------------
    ;MERGE INTO Dados.Produto AS T
	    USING (
                SELECT DISTINCT
                        SSD.[COD_PRODUTO_SIAS] [CodigoComercializado]
                FROM dbo.MovimentoContrato_SSD_TEMP SSD
                WHERE SSD.[COD_PRODUTO_SIAS] IS NOT NULL              
            ) X
        ON T.[CodigoComercializado] = X.[CodigoComercializado]  
    WHEN NOT MATCHED
		        THEN INSERT ([CodigoComercializado])
		            VALUES (X.[CodigoComercializado]);		  
                       
	-----------------------------------------------------------------------------------------------------------------------
		  ------WITH CTE
		  ------AS
		  ------(
		  ------SELECT SSD.[NUM_PROPOSTA_TRATADO] [NumeroProposta]
    ------                  , SSD.[ID_SEGURADORA] [IDSeguradora]
    ------                  , SSD.[TIPO_DADO] [TipoDado]
    ------                  , MAX(SSD.QTD_VIDAS) [TotalDeVidas]
    ------                  , MAX(SSD.[DTH_MOVIMENTO]) [DataArquivo]
    ------             FROM dbo.MovimentoContrato_SSD_TEMP SSD
    ------             WHERE SSD.[NUM_PROPOSTA_TRATADO] <> '0' AND SSD.[NUM_PROPOSTA_TRATADO] IS NOT NULL
				------ AND NUM_PROPOSTA_TRATADO = '000082592979851'
    ------             GROUP BY SSD.[NUM_PROPOSTA_TRATADO] 
    ------                    , SSD.[ID_SEGURADORA] 
    ------                    , SSD.[TIPO_DADO]       
		  ------)
		  ------SELECT COUNT(*), 	 [NumeroProposta]
		  ------FROM CTE
		  ------GROUP BY [NumeroProposta]
		  ------HAVING COUNT(*) > 1
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir propostas não recebidas nos arquivos e atualizar as vidas da já recebidas
    -----------------------------------------------------------------------------------------------------------------------
      
      ;MERGE INTO Dados.Proposta AS T
	      USING (
				 SELECT SSD.[NUM_PROPOSTA_TRATADO] [NumeroProposta]
                      , SSD.[ID_SEGURADORA] [IDSeguradora]
                      , SSD.[TIPO_DADO] [TipoDado]
                      , MAX(SSD.QTD_VIDAS) [TotalDeVidas]
                      , MAX(SSD.[DTH_MOVIMENTO]) [DataArquivo]
					  --,	SSD.[STA_ANTECIPACAO] as BitAntecipacao,SSD.[STA_MUDANCA_PLANO] as BitMudancaPlano
                 FROM dbo.MovimentoContrato_SSD_TEMP SSD
                 WHERE SSD.[NUM_PROPOSTA_TRATADO] <> '0' AND SSD.[NUM_PROPOSTA_TRATADO] IS NOT NULL
                 GROUP BY SSD.[NUM_PROPOSTA_TRATADO] 
                        , SSD.[ID_SEGURADORA] 
                        , SSD.[TIPO_DADO]       
						--, SSD.QTD_VIDAS    
              ) X
         ON T.NumeroProposta = X.NumeroProposta  
        AND T.IDSeguradora = X.IDSeguradora
       WHEN NOT MATCHED
		          THEN INSERT (NumeroProposta, [IDSeguradora], TotalDeVidas, IDAgenciaVenda, IDProduto, IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
		               VALUES (X.NumeroProposta, X.[IDSeguradora], X.TotalDeVidas, -1, -1, 0, -1, 0, -1, X.TipoDado, X.DataArquivo)	
       WHEN MATCHED
            THEN UPDATE SET TotalDeVidas = COALESCE(X.TotalDeVidas, T.TotalDeVidas);
	-----------------------------------------------------------------------------------------------------------------------

    ------------------------------------------------OPERACAO CONTRATUAL-----------------------------------------------
    --Comando para inserir as operações contratuais ainda não registradas
    -----------------------------------------------------------------------------------------------------------------------
      /*Apaga a marcação LastValue das propostas recebidas para atualizar a última posição -> logo depois da inserção das Situações (abaixo)*/
    UPDATE Dados.PropostaOperacaoContratual SET LastValue = 0
   -- SELECT *
    FROM Dados.PropostaOperacaoContratual PS
    WHERE PS.IDProposta IN (SELECT PRP.ID
                            FROM Dados.Proposta PRP                      
                            INNER JOIN dbo.MovimentoContrato_SSD_TEMP SSD
                                   ON SSD.[NUM_PROPOSTA_TRATADO] = PRP.NumeroProposta
                                  AND SSD.[ID_SEGURADORA] = PRP.IDSeguradora  
                                 -- AND PS.DataOperacao < SSD.DTH_OPERACAO
                            --WHERE PRP.ID = PS.IDProposta
                            )
           AND PS.LastValue = 1


    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os Status recebidos no SSD
    -----------------------------------------------------------------------------------------------------------------------		             
    MERGE INTO Dados.PropostaOperacaoContratual AS T
		USING (
        SELECT DISTINCT
               PRP.ID [IDProposta],  OC.ID [IDOperacaoContratual]
             , SSD.DTH_OPERACAO [DataOperacao], SSD.[DTH_MOVIMENTO] DataArquivo
             , [TIPO_DADO] TipoDado --, PGTO.[Codigo] 
			-- ,SSD.[IDSUBOPERACAO]
        FROM [dbo].MovimentoContrato_SSD_TEMP SSD
          INNER JOIN Dados.Proposta PRP
          ON SSD.[NUM_PROPOSTA_TRATADO] = PRP.NumeroProposta
          AND SSD.[ID_SEGURADORA] = PRP.IDSeguradora
          /*LEFT OUTER JOIN Dados.SituacaoProposta STPRP
          ON PGTO.SituacaoProposta = STPRP.Sigla  */
          LEFT JOIN Dados.OperacaoContratual OC
          ON SSD.[IDSUBOPERACAO] = OC.ID
    
          ) AS X
    ON X.[IDProposta] = T.[IDProposta]   
   AND X.[DataOperacao] = T.[DataOperacao]
   AND X.[IDOperacaoContratual] = T.[IDOperacaoContratual]
    WHEN MATCHED
			    THEN UPDATE
			     SET 
                [DataArquivo] = X.[DataArquivo]
               , [TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
    WHEN NOT MATCHED
			    THEN INSERT          
              (
               [IDProposta],  [IDOperacaoContratual] 
             , [DataArquivo], [DataOperacao], [TipoDado]
             , LastValue        
              )
          VALUES (X.[IDProposta]
                 ,X.[IDOperacaoContratual]
                 ,X.[DataArquivo]       
                 ,X.[DataOperacao]    
                 ,X.[TipoDado]
                 ,0
                 ); 
    
    --Atualiza LastValue PropostaOperacaoContratual  para 1         
    WITH CTE 
    AS 
    (
     SELECT DISTINCT PRP.ID [IDProposta]
     FROM Dados.Proposta PRP                      
      INNER JOIN dbo.MovimentoContrato_SSD_TEMP SSD
           ON SSD.[NUM_PROPOSTA_TRATADO] = PRP.NumeroProposta
          AND SSD.[ID_SEGURADORA] = PRP.IDSeguradora
      )  
    /*Atualiza a marcação LastValue das propostas recebidas buscando o último Status*/
    UPDATE Dados.PropostaOperacaoContratual SET LastValue = 1
    FROM  CTE
    CROSS APPLY (SELECT TOP 1 ID
                 FROM Dados.PropostaOperacaoContratual PS1
                 WHERE PS1.IDProposta = CTE.IDProposta
                 ORDER BY [IDProposta] ASC,
	                      [DataOperacao] DESC
                 ) LASTVALUE 
    INNER JOIN Dados.PropostaOperacaoContratual PS
    ON PS.ID = LASTVALUE.ID;
    
    ---------------------------------end PROPOSTA OPERAÇÃO---------------------------------------------------


    ----------------------------TRATA PRODUTO & PRODUTO ANTERIOS------------------------------------------------------------
	MERGE INTO Dados.Proposta AS T
	    USING ( select IDPRoposta,IDProduto,IDProdutoSIGPF,[NomeArquivo],[DataArquivo],[rank] from (
		  SELECT DISTINCT PRP.ID IDProposta, PRD.ID [IDProduto], PSG.ID IDProdutoSIGPF, SSD.TIPO_DADO [NomeArquivo], [DTH_MOVIMENTO] [DataArquivo],ROW_NUMBER() OVER (PARTITION BY PRP.ID ORDER BY [DTH_MOVIMENTO] DESC) as [rank]
		  FROM  [dbo].MovimentoContrato_SSD_TEMP SSD
          INNER JOIN Dados.Proposta PRP
          ON SSD.[NUM_PROPOSTA_TRATADO] = PRP.NumeroProposta
          AND SSD.[ID_SEGURADORA] = PRP.IDSeguradora
			INNER JOIN Dados.Produto PRD
			ON PRD.CodigoComercializado = SSD.[COD_PRODUTO_SIAS]
		  LEFT JOIN Dados.ProdutoSIGPF PSG
		  ON PSG.CodigoProduto = SSD.[COD_PRODUTO_SIVPF]
			WHERE SSD.[NUM_PROPOSTA_TRATADO] IS NOT NULL) t where [rank] = 1
            ) X
    ON T.ID = X.IDProposta
	WHEN MATCHED AND ((T.IDProduto IS NULL OR T.IDProduto = -1)	 OR T.DataArquivo < X.DataArquivo)																																	         
	    THEN UPDATE
		/*Atualiza o código do Produto & código do Produto Anterior com o código recebido do SSD
		Egler - 23/09/2013*/
		    SET T.IDProduto = X.IDProduto
			  ,	T.IDProdutoAnterior = CASE  WHEN NOT (T.IDProduto IS NULL OR T.IDProduto = -1) AND T.IDProduto <> X.IDProduto THEN T.IDProduto
											ELSE CASE WHEN T.IDProdutoAnterior IS NULL THEN NULL
											            ELSE T.IDProdutoAnterior
												END
										END
			  , T.IDProdutoSIGPF = CASE WHEN X.IDProdutoSIGPF IS NOT NULL AND X.IDProdutoSIGPF > 0 THEN X.IDProdutoSIGPF ELSE T.IDProdutoSIGPF END; 
    ----------------------------TRATA PRODUTO & PRODUTO ANTERIOS-----------------------------------------------

    ----------------------------------------------------------------------------------------------------------------------
	--Adicionado para atualizar o ProdutoSIGPF das propostas novas ou sem SIGPF que possuam referencia na tabela Produto.
	----------------------------------------------------------------------------------------------------------------------
	--Egler: 07/10/2014
	UPDATE Dados.Proposta SET IDProdutoSIGPF = PRD.IDProdutoSIGPF
	FROM Dados.Proposta PRP
	INNER JOIN Dados.Produto PRD
	ON PRD.ID = PRP.IDProduto
	WHERE PRP.IDProdutoSIGPF IS NULL
	----------------------------------------------------------------------------------------------------------------------
                                       
    /***********************************************************************
    /*Apaga a marcação LastValue da tabela PropostaCobertura para atualizar a 
    última posição das propostas recebidas. */
    ***********************************************************************/	  

    UPDATE Dados.PropostaCobertura SET LastValue = 0
    --SELECT PRP.NumeroProposta, PC.LastValue
    FROM Dados.PropostaCobertura PC
	    INNER JOIN Dados.Proposta PRP
	    ON PC.IDProposta = PRP.ID	    
        INNER JOIN [dbo].MovimentoContrato_SSD_TEMP SSD
        ON SSD.[NUM_PROPOSTA_TRATADO] = PRP.NumeroProposta
          AND SSD.[ID_SEGURADORA] = PRP.IDSeguradora
          AND PC.IDCobertura = 3
		  --TODO RETORNAR O CÓDIGO ABAIXO
        --CROSS APPLY (SELECT TOP 1 c.ID [IDCobertura]
        --            FROM Dados.Cobertura C
        --            inner join Dados.Ramo R
        --            ON C.IDRamo = R.ID
        --            WHERE R.Codigo = '93' AND C.Codigo = '11' --Morte Natural
        --            AND PC.IDCobertura = C.ID
        --            ORDER BY C.ID ASC) C
        CROSS APPLY (SELECT ID FROM  Dados.TipoCobertura TC WHERE TC.Descricao = 'Básica') TC -- Tipo Básica
	    WHERE PC.LastValue = 1												

    /*************************************************************************************/
    /*Cria um registro Fake com base na IS e Prêmio disponíveis na FATO MOVIMENTO CONTRATO*/
    /*************************************************************************************/ 
    ;MERGE INTO Dados.PropostaCobertura AS T
		USING (      
		    SELECT *
			FROM
			(                                                         
            SELECT                          
              SSD.[TIPO_DADO] [Arquivo],                                                
              SSD.[DTH_MOVIMENTO] [DataArquivo],                           
              PRP.ID [IDProposta],   
			  3 [IDCobertura],
			  --TODO RETORNAR O CÓDIGO ABAIXO                  
              --C.[IDCobertura],
              TC.ID [IDTipoCobertura], 
              SSD.[VLR_PREMIO]  [ValorPremio] ,                   
	          SSD.[VLR_IS] [ValorImportanciaSegurada]    
			  , ROW_NUMBER() OVER(PARTITION BY  PRP.ID, TC.ID, SSD.[DTH_MOVIMENTO] ORDER BY SSD.NUM_OCORRENCIA DESC ) ORDEM
            FROM [dbo].MovimentoContrato_SSD_TEMP SSD
          INNER JOIN Dados.Proposta PRP
          ON SSD.[NUM_PROPOSTA_TRATADO] = PRP.NumeroProposta
          AND SSD.[ID_SEGURADORA] = PRP.IDSeguradora
		  --TODO RETORNAR O CÓDIGO ABAIXO
              --OUTER APPLY (SELECT TOP 1 c.ID [IDCobertura]
              --             FROM Dados.Cobertura C
              --             inner join Dados.Ramo R
              --             ON C.IDRamo = R.ID
              --             WHERE R.Codigo = '93' AND C.Codigo = '11' --Morte Natural
              --             ORDER BY C.ID ASC) C
              LEFT JOIN Dados.TipoCobertura TC
              ON TC.Descricao = 'Básica' -- Tipo Básica
              where  SSD.[VLR_IS] IS NOT NULL
			  ) A
		   WHERE A.ORDEM = 1

			--  and idproposta = 11309000 
            /*LEFT JOIN Dados.Contrato CNT
            ON CNT.NumeroContrato = RTP5.[NumeroApoliceAnterior]         
			SELECT * FROM Dados.Proposta WHERE ID = 11309000


			3, 1, 2014-09-22
			
			     */
          ) AS X
    ON  T.[IDProposta] = X.[IDProposta]
    AND T.[IDCobertura] = X.[IDCobertura]
    AND T.[IDTipoCobertura] = X.[IDTipoCobertura]
	AND T.DataArquivo = X.DataArquivo
    WHEN MATCHED
			    THEN UPDATE
				     SET
				         [ValorImportanciaSegurada] = COALESCE(X.[ValorImportanciaSegurada], T.[ValorImportanciaSegurada])
				        ,[ValorPremio] = COALESCE(X.[ValorPremio], T.[ValorPremio]) 
				        ,[DataArquivo] = COALESCE(X.[DataArquivo], T.[DataArquivo]) 
				        ,[Arquivo] = COALESCE(X.[Arquivo], T.[Arquivo])
    WHEN NOT MATCHED  
			    THEN INSERT          
              (   [IDProposta]                      
                , [IDCobertura]  
                , [IDTipoCobertura]
                , [ValorImportanciaSegurada]
                , [ValorPremio] 
                , [DataArquivo]    
                , [Arquivo]
                )
          VALUES (   
                  X.[IDProposta]                           
                , X.[IDCobertura]  
                , X.[IDTipoCobertura]
                , X.[ValorImportanciaSegurada]
                , X.[ValorPremio]  
                , X.[DataArquivo]    
                , X.[Arquivo]
                ); 
  /*************************************************************************************/ 

 	/*Atualiza a marcação LastValue das propostas recebidas para atualizar a última posição*/
    UPDATE Dados.PropostaCobertura SET LastValue = 1
    FROM Dados.PropostaCobertura PE
	INNER JOIN (
				SELECT ID, /*  PS.IDProposta, PS.IDCobertura*/ ROW_NUMBER() OVER (PARTITION BY PS.IDProposta, PS.IDCobertura, IDTipoCobertura ORDER BY PS.DataArquivo DESC, PS.ID DESC) [ORDEM]
				FROM Dados.PropostaCobertura PS
				WHERE PS.IDProposta IN (
										SELECT PRP.ID
										FROM [dbo].MovimentoContrato_SSD_TEMP SSD
                                        INNER JOIN Dados.Proposta PRP
                                        ON    SSD.[NUM_PROPOSTA_TRATADO] = PRP.NumeroProposta
                                          AND SSD.[ID_SEGURADORA] = PRP.IDSeguradora
									   )
						AND PS.IDCobertura = 3 --VIDA -> MORTE NATURAL
					) A
	 ON     A.ID = PE.ID 
	 AND A.ORDEM = 1	  						
  /*************************************************************************************/ 













--SELECT * FROM MovimentoContrato_SSD_TEMP WHERE [NUM_BIL_CERTIF] = 95450749483
--SELECT * FROM Dados.Proposta WHERE NumeroProposta like '%95450749483%'
--SELECT * FROM MovimentoContrato_SSD_TEMP
--SELECT * FROM Dados.Pagamento
    -----------------------------------------------------------------------------------------------------------------------

    		                   
/*****************************************************************************************/
/*Atualização do Ponto de Parada, igualando-o ao Maior Código Trabalhado no comando acima*/
/*****************************************************************************************/
SET @PontoDeParada = '1900-01-01;' + Cast(@MaiorCodigo as varchar(20))
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @PontoDeParada
WHERE NomeEntidade = 'MovimentoContrato_SSD'

TRUNCATE TABLE [dbo].MovimentoContrato_SSD_TEMP

    
/*Recuperação do Maior Código do Retorno*/

SET @COMANDO = 'INSERT INTO [dbo].[MovimentoContrato_SSD_TEMP] 
				(  
                     [SUK_CONTRATO_VIDA]      
                   , [DTH_MOVIMENTO]          
                   , [DTH_OPERACAO]           
                   , [NUM_OCORRENCIA]         
                   , [DTH_ATUALIZACAO]        
                   , [VLR_PREMIO]             
                   , [VLR_IS]                 
                   , [QTD_VIDAS]              
                   , [NUM_BIL_CERTIF]         
                   , [NUM_APOLICE]            
                   , [NUM_PROPOSTA_SIVPF]     
                   , [NUM_CONTRATO]           
                   , [IND_ORIGEM_REGISTRO]    
                   , [COD_PRODUTO_SIAS]  
				   , [COD_PRODUTO_SIVPF]     
                   , [IDSUBOPERACAO] 
				)  
                SELECT 
                     [SUK_CONTRATO_VIDA]      
                   , Cast([DTH_MOVIMENTO] as Date) DTH_MOVIMENTO        
                   , Cast([DTH_OPERACAO] as Date) DTH_OPERACAO         
                   , [NUM_OCORRENCIA]         
                   , Cast([DTH_ATUALIZACAO] as Date) DTH_ATUALIZACAO        
                   , [VLR_PREMIO]             
                   , [VLR_IS]                 
                   , [QTD_VIDAS]              
                   , [NUM_BIL_CERTIF]         
                   , [NUM_APOLICE]            
                   , [NUM_PROPOSTA_SIVPF]     
                   , [NUM_CONTRATO]           
                   , [IND_ORIGEM_REGISTRO]    
                   , [COD_PRODUTO_SIAS]  
				   , [COD_PRODUTO_SIVPF]     
                   , [IDSUBOPERACAO]         
                FROM OPENQUERY ([ANTARES], 
                ''EXEC [Corporativo].[SSD].[proc_RecuperaMovimentoContrato] ''''' + @PontoDeParada + ''''''') PRP' --@PontoDeParada

EXEC (@COMANDO)    
--print '-----antes------'
--print @maiorcodigo

SELECT @MaiorCodigo = MAX(PRP.SUK_CONTRATO_VIDA)
FROM [dbo].[MovimentoContrato_SSD_TEMP] PRP

--print '-----depois------'
--print @maiorcodigo                      
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MovimentoContrato_SSD_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[MovimentoContrato_SSD_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH

