/*
	Alterado por FERNANDO MESSAS
	Data  25/10/2017

	Descrição: algumas propostas com certificados nulo estavam causando erro
*/
/*
	Autor: Egler Vieira
	Data Criação: 20/11/2012

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InserePagamento_STASASSE_TIPO2
	Descrição: Procedimento que realiza a inserção dos lançamentos de parcelas (TIPO 2) de propostas no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InserePagamento_STASASSE_TIPO2] 
AS
    
BEGIN TRY	
  
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(4000) 


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STASASSE_TP2_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[STASASSE_TP2_TEMP];

CREATE TABLE [dbo].[STASASSE_TP2_TEMP](
	[Codigo] [bigint] NOT NULL,
	[IDSeguradora] [int] NOT NULL,
	[NumeroProposta] [varchar](20) NULL,
	[NumeroCertificado] [varchar](20) NULL,
	[DataInicioVigencia] [date] NULL,                           
	[DataFimVigencia] [date] NULL,                              
	[SituacaoProposta] [varchar](3) NULL,
	[TipoMotivo] [varchar](3) NULL,
	[NumeroParcela] [int] NOT NULL,
	[Valor] [numeric](15, 2) NULL,
	[ValorIOF] [numeric](15, 2) NULL,
	[TipoDado] [varchar](26) NULL,
	[DataEfetivacao] [date] NULL,
	[DataArquivo] [date] NULL,
	[NomeArquivo] [varchar](100) NULL,
	[Rank] [bigint] NULL,
	NumeroCertificadoTratado AS Cast(dbo.fn_TrataNumeroPropostaZeroExtra(NumeroCertificado) as VARCHAR(20)) PERSISTED
);


 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_STASASSE_TP2_TEMP ON [dbo].[STASASSE_TP2_TEMP]
( 
  Codigo ASC
)   



SELECT @PontoDeParada=PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Pagamento_STASASSE_TIPO2'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
SET @COMANDO = 'INSERT INTO [dbo].[STASASSE_TP2_TEMP]  
                   ([Codigo],[IDSeguradora],[NumeroProposta],[NumeroCertificado],[DataInicioVigencia],[DataFimVigencia],[SituacaoProposta]
                   ,[TipoMotivo],[NumeroParcela],[Valor],[ValorIOF],[TipoDado],[DataEfetivacao],[DataArquivo],[NomeArquivo],[Rank])
                SELECT [Codigo],[IDSeguradora],[NumeroProposta],[NumeroCertificado],[DataInicioVigencia],[DataFimVigencia],[SituacaoProposta]
                      ,[TipoMotivo],[NumeroParcela],[Valor],[ValorIOF],[TipoDado],[DataEfetivacao],[DataArquivo],[NomeArquivo],[Rank]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaPagamento_STASASSE_TIPO2] ''''' + @PontoDeParada + ''''''') PRP'                
EXEC (@COMANDO)
  
SELECT @MaiorCodigo= MAX(STA.Codigo)
FROM dbo.STASASSE_TP2_TEMP STA    
                  
                  
/*********************************************************************************************************************/
                  
SET @COMANDO = ''    

WHILE @MaiorCodigo IS NOT NULL
BEGIN

    -----------------------------------------------------------------------------------------------------------------------
    --Comandos para carregas tabelas de domínio usadas no status
    -----------------------------------------------------------------------------------------------------------------------
     /*INSERE SITUAÇÕES DE PROPOSTA DESCONHECIDAS*/
    MERGE INTO  Dados.SituacaoProposta AS T
      USING (SELECT DISTINCT SituacaoProposta [Sigla], 'SITUAÇÃO DESCONHECIDA' SituacaoProposta
          FROM STASASSE_TP2_TEMP PGTO 
          WHERE PGTO.SituacaoProposta IS NOT NULL     
            ) X
      ON T.Sigla = X.[Sigla]
     WHEN NOT MATCHED
	          THEN INSERT (Sigla, [Descricao])
	               VALUES (X.[Sigla], X.SituacaoProposta);  
	                           	               
	               
     /*INSERE TIPO MOTIVO DE PROPOSTA DESCONHECIDOS*/
    MERGE INTO  Dados.TipoMotivo AS T
      USING (SELECT DISTINCT [TipoMotivo] Codigo, 'TIPO MOTIVO DESCONHECIDO' [TipoMotivo]
          FROM STASASSE_TP2_TEMP PGTO 
          WHERE PGTO.[TipoMotivo] IS NOT NULL     
            ) X
      ON T.Codigo = X.[Codigo]
     WHEN NOT MATCHED
	          THEN INSERT (Codigo, [Nome])
	               VALUES (X.Codigo, X.[TipoMotivo]);              	               	               
    -----------------------------------------------------------------------------------------------------------------------	               


    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir propostas não recebidas nos arquivos PRPSASSE
    -----------------------------------------------------------------------------------------------------------------------
      
      ;MERGE INTO Dados.Proposta AS T
	      USING (SELECT DISTINCT PGTO.NumeroProposta, PGTO.[IDSeguradora], PGTO.[TipoDado], PGTO.DataArquivo
              FROM dbo.STASASSE_TP2_TEMP PGTO
              WHERE PGTO.[RANK] = 1              
              ) X
         ON T.NumeroProposta = X.NumeroProposta  
        AND T.IDSeguradora = X.IDSeguradora
       WHEN NOT MATCHED
		          THEN INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
		               VALUES (X.NumeroProposta, X.[IDSeguradora], -1, -1, 0, -1, 0, -1, X.TipoDado, X.DataArquivo);		               
	-----------------------------------------------------------------------------------------------------------------------

    /*INSERE PROPOSTAS CLIENTE NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
    MERGE INTO Dados.PropostaCliente AS T
      USING (SELECT PRP.ID [IDProposta], 1 [IDSeguradora], 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' [NomeCliente], MAX(PGTO.[TipoDado]) [TipoDado], MAX(PGTO.[DataArquivo]) [DataArquivo]
          FROM STASASSE_TP2_TEMP PGTO
          INNER JOIN Dados.Proposta PRP
          ON PRP.NumeroProposta = PGTO.NumeroProposta
          AND PRP.IDSeguradora = 1
          WHERE PGTO.NumeroProposta IS NOT NULL
          GROUP BY PRP.ID
            ) X
      ON T.IDProposta = X.IDProposta
     WHEN NOT MATCHED
	          THEN INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
	               VALUES (X.IDProposta, [TipoDado], X.[NomeCliente], X.[DataArquivo])


    -----------------------------------------------------------------------------------------------------------------------
    --Comando para logar propostas cujo status de emissão foram recebidos no arquivo STASASSE mas a proposta não foi recebida,
    --impossibilitando a apropriação da emissão no Certificado / Contrato
    -----------------------------------------------------------------------------------------------------------------------

     
    ;MERGE INTO ControleDados.LogSTATP2 AS T
	      USING (	 
				 SELECT   
						  PGTO.NumeroCertificado, PGTO.[NumeroProposta], MAX(PGTO.Valor) ValorPremioTotal
						, MIN(PGTO.DataInicioVigencia) DataInicioVigencia, MAX(ISNULL(PGTO.DataFimVigencia, '9999-12-31')) DataFimVigencia
						, PGTO.DataArquivo, PGTO.NomeArquivo	                         
				 FROM dbo.STASASSE_TP2_TEMP PGTO
				 INNER JOIN Dados.Proposta PRP
				 ON PRP.NumeroProposta = PGTO.NumeroProposta
				AND PRP.IDSeguradora = 1
				AND PRP.IDProdutoSIGPF = 0 -- Proposta sem produto SIGPF definido    
				 WHERE PGTO.[RANK] = 1
				   --AND PGTO.SituacaoProposta = 'EMT'  
				 GROUP BY PGTO.NumeroCertificado, PGTO.[NumeroProposta], PGTO.DataArquivo, PGTO.NomeArquivo    
          ) X
	ON  T.NumeroProposta = X.NumeroProposta
	AND T.DataArquivo = X.DataArquivo
	AND T.NomeArquivo = X.NomeArquivo
	WHEN NOT MATCHED
         THEN INSERT (NumeroContrato, NumeroProposta, Ocorrencia
                    , DataInicioVigencia, DataFimVigencia, ValorPremioTotal, DataArquivo, NomeArquivo)
         VALUES (NumeroCertificado, [NumeroProposta], 'Proposta não recebida', DataInicioVigencia, DataFimVigencia
		         ,ValorPremioTotal,  DataArquivo,NomeArquivo)
    ;
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir um Contrato [APOLICE] na marra 
    --das propostas cujo status de emissão foram recebidos no arquivo STASASSE
    -----------------------------------------------------------------------------------------------------------------------
     INSERT INTO Dados.Contrato (NumeroContrato, IDProposta, IDSeguradora
                               , Arquivo, DataArquivo, DataInicioVigencia, DataFimVigencia, ValorPremioTotal)
     SELECT NumeroCertificado,   
               [IDProposta],
               [IDSeguradora],
               (SELECT TOP 1 NomeArquivo 
                FROM dbo.STASASSE_TP2_TEMP PGTO1 
                WHERE PGTO1.Codigo = A.Codigo) NomeArquivo,
                
               (SELECT TOP 1 DataArquivo 
                FROM dbo.STASASSE_TP2_TEMP PGTO1 
                WHERE PGTO1.Codigo = A.Codigo) DataArquivo
          , DataInicioVigencia, DataFimVigencia, ValorPremioTotal
     FROM            
     (     
         SELECT   
                  PGTO.NumeroCertificado, PRP.ID [IDProposta], PGTO.[IDSeguradora], MAX(PGTO.Codigo) Codigo, MAX(PGTO.Valor) ValorPremioTotal
                , MIN(PGTO.DataInicioVigencia) DataInicioVigencia, MAX(ISNULL(PGTO.DataFimVigencia, '9999-12-31')) DataFimVigencia	                         
         FROM dbo.STASASSE_TP2_TEMP PGTO
		 
                INNER JOIN Dados.Proposta PRP
                ON  PRP.NumeroProposta = PGTO.NumeroProposta
                  AND PRP.IDSeguradora = PGTO.IDSeguradora
				-------------------------------------------------------------------------------------------------------------------
				--Esse trecho foi adicionado para garantir que o Contrato fake será gerado quando o Produto for conhecido e este
				-- estiver marcado como produto sem certificado
				-- Autor: Egler - 2013/09/18
				-------------------------------------------------------------------------------------------------------------------
				INNER JOIN Dados.ProdutoSIGPF PSG
                ON PSG.ID = PRP.IDProdutoSIGPF
                AND (PSG.ProdutoComCertificado IS NULL OR PSG.ProdutoComCertificado = 0)
                AND (PSG.ID <> 0) /*Garante que a proposta foi recebida ou que de alguma forma sabe-e o Produto da Proposta.*/
                -------------------------------------------------------------------------------------------------------------------
	
         WHERE NOT EXISTS (SELECT * FROM Dados.Contrato CNT
                           WHERE CNT.NumeroContrato = PGTO.NumeroCertificado
                             AND CNT.IDSeguradora = PGTO.IDSeguradora)
            --  AND PGTO.NumeroCertificadoTratado <> PGTO.NumeroProposta -- Retirado após criação de campos de controle de inserção de Contrato / Certificado na tabela ProdutoSIGPF
			                                                             -- Egler - 2013/09/18
           AND PGTO.[RANK] = 1
           --AND PGTO.SituacaoProposta = 'EMT'  
          GROUP BY PGTO.[IDSeguradora], PRP.ID, PGTO.NumeroCertificado
     ) A


     
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir um ENDOSSO (1º Endosso) de emissão na marra 
    --das propostas cujo status de emissão foram recebidos no arquivo STASASSE
    -----------------------------------------------------------------------------------------------------------------------     
     INSERT INTO Dados.Endosso (IDContrato, IDProduto, NumeroEndosso, IDTipoEndosso, IDSituacaoEndosso
                               , Arquivo, DataArquivo, DataInicioVigencia, DataFimVigencia, ValorPremioTotal)
     SELECT [IDContrato], [IDProduto], [NumeroEndosso], [IDTipoEndosso], [IDSituacaoEndosso],
                                                                                  (SELECT TOP 1 NomeArquivo 
                                                                                  FROM dbo.STASASSE_TP2_TEMP PGTO1 
                                                                                  WHERE PGTO1.Codigo = A.Codigo) NomeArquivo,
                                                                                  (SELECT TOP 1 DataArquivo 
                                                                                  FROM dbo.STASASSE_TP2_TEMP PGTO1 
                                                                                  WHERE PGTO1.Codigo = A.Codigo) DataArquivo
          , DataInicioVigencia, DataFimVigencia, ValorPremioTotal
     FROM            
     (     
         SELECT   
                  CNT.ID [IDContrato], -1 [IDProduto] /*PRODUTO NÃO INDICADO*/, -1 [NumeroEndosso] /*ENDOSSO DE EMISSÃO FORÇACO*/
                  , 0 [IDTipoEndosso] /*ENDOSSO DE EMISSÃO*/ , 2 [IDSituacaoEndosso] /*ENDOSSO PAGO*/
                , MAX(PGTO.Codigo) Codigo, MAX(Valor) ValorPremioTotal
                , MIN(PGTO.DataInicioVigencia) DataInicioVigencia, MAX(ISNULL(PGTO.DataFimVigencia, '9999-12-31')) DataFimVigencia	                         
         FROM dbo.STASASSE_TP2_TEMP PGTO
           INNER JOIN Dados.Contrato CNT
           ON CNT.NumeroContrato = PGTO.NumeroCertificado
           AND CNT.IDSeguradora = PGTO.IDSeguradora
         WHERE NOT EXISTS (
                           SELECT * FROM Dados.Endosso EN
                           WHERE EN.IDContrato = CNT.ID
                          )
              AND PGTO.NumeroCertificadoTratado <> PGTO.NumeroProposta
           AND PGTO.[RANK] = 1
           AND PGTO.SituacaoProposta = 'EMT'  
          GROUP BY CNT.ID
     ) A;
     -----------------------------------------------------------------------------------------------------------------------

            
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para atualizar os dados de Inicio e Fim de Vigência, assim como o do IDContrato 
    --das propostas cujo status de emissão foram recebidos no arquivo STASASSE
    -----------------------------------------------------------------------------------------------------------------------
    ;MERGE INTO Dados.Proposta AS T																			
	      USING (SELECT NumeroProposta, IDSeguradora, (SELECT TOP 1 TipoDado FROM dbo.STASASSE_TP2_TEMP PGTO1 WHERE PGTO1.Codigo = PGTO.Codigo) TipoDado
                     , DataInicioVigencia, DataFimVigencia,  [IDContrato]
               FROM
               (      
                  SELECT  PGTO.NumeroProposta, PGTO.[IDSeguradora], MAX(PGTO.Codigo) Codigo
                        , MIN(PGTO.DataInicioVigencia) DataInicioVigencia, MAX(ISNULL(PGTO.DataFimVigencia, '9999-12-31')) DataFimVigencia, CNT.ID [IDContrato]		               
                  FROM dbo.STASASSE_TP2_TEMP PGTO
                  LEFT JOIN Dados.Contrato CNT
                  ON CNT.NumeroContrato = PGTO.NumeroCertificado
                  AND CNT.IDSeguradora = PGTO.IDSeguradora
                  WHERE /*PGTO.SituacaoProposta = 'EMT'           
                    AND*/ PGTO.[RANK] = 1  
                    --AND NUMEROPROPOSTA = '000084619129019'   
                  GROUP BY PGTO.NumeroProposta, PGTO.[IDSeguradora], CNT.ID
                ) PGTO           
              ) X
         ON T.NumeroProposta = X.NumeroProposta  
        AND T.IDSeguradora = X.IDSeguradora
       WHEN  MATCHED
		         THEN UPDATE
				         SET [DataInicioVigencia] = COALESCE(T.[DataInicioVigencia], X.[DataInicioVigencia])
				           , [DataFimVigencia] = COALESCE(T.[DataFimVigencia], X.[DataFimVigencia])
				           , IDContrato = COALESCE(T.[IDContrato], X.[IDContrato])	    				     
				     ;                                                                              
		-----------------------------------------------------------------------------------------------------------------------

		-------------------------------------------------------------------------------------------------------------------------
		-- Atualiza Valor do prêmio Original
		-- Egler Vieira
		-- Data: 2013/10/28
		-------------------------------------------------------------------------------------------------------------------------
		;MERGE INTO Dados.Proposta AS T																			
	      USING (
					SELECT  PRP.ID IDProposta, PE.ValorPremioBrutoOriginal, PE.ValorPremioLiquidoOriginal               
					FROM  Dados.Proposta PRP
					CROSS APPLY (SELECT TOP 1 ISNULL(PE.Valor,0) - ISNULL(PE.ValorIOF,0) [ValorPremioLiquidoOriginal]
											, ISNULL(PE.Valor,0) [ValorPremioBrutoOriginal]
								 FROM Dados.PagamentoEmissao PE
				     				INNER JOIN Dados.SituacaoProposta SP
								   ON PE.IDSituacaoProposta = SP.ID  
								 WHERE PE.IDProposta = PRP.ID
								 AND   SP.SituacaoDeEmissao = 1 
								 ORDER BY PE.DataArquivo ASC
								 ) PE
		
					WHERE EXISTS ( SELECT *
							FROM dbo.STASASSE_TP2_TEMP PGTO
							WHERE PRP.NumeroProposta = PGTO.NumeroProposta
							AND PRP.IDSeguradora= PGTO.IDSeguradora	
							) 
				)  X
		ON T.ID = X.IDProposta
		WHEN MATCHED
		  THEN 
		   UPDATE  SET ValorPremioBrutoEmissao = X.ValorPremioBrutoOriginal-- COALESCE(T.ValorPremioBrutoEmissao, X.ValorPremioBrutoOriginal)
					 , ValorPremioLiquidoEmissao =  X.ValorPremioLiquidoOriginal --COALESCE(T.ValorPremioLiquidoEmissao, X.ValorPremioLiquidoOriginal)  
        --AND NUMEROPROPOSTA = '000084619129019'   
 		
						   
						   	
	--TODO FAZER UPDATE DO PREMIO TOTAL A PARTIR DO TIPO 2	
		
-- Verifica o Produto SIGPF para inserir o certificado Fake
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir um Certificado na marra 
    --das propostas cujos status foram recebidos no arquivo STASASSE  TIPO 2 
      ;MERGE INTO Dados.Certificado AS T
      USING (
                 SELECT   
                         --, PRP.Nome 
                          PRP.ID [IDProposta]
                        , PGTO.NumeroCertificadoTratado
                        , PGTO.[IDSeguradora]
                        --, MAX(PGTO.Codigo) Codigo
                        --, MAX(PGTO.Valor) ValorPremioTotal
                        , MAX(PGTO.DataInicioVigencia) DataInicioVigencia
                        , MAX(ISNULL(PGTO.DataFimVigencia, '9999-12-31')) DataFimVigencia	 
                        , MAX(PGTO.DataArquivo) [DataArquivo]
                        , MAX(PGTO.NomeArquivo) [Arquivo]
                 FROM dbo.STASASSE_TP2_TEMP PGTO
                  INNER JOIN Dados.Proposta PRP
                  ON PRP.NumeroProposta = PGTO.NumeroProposta
                  AND PRP.IDSeguradora = PGTO.[IDSeguradora] --Caixa Seguros
					-------------------------------------------------------------------------------------------------------------------
					--Esse trecho foi adicionado para garantir que o Contrato fake será gerado quando o Produto for conhecido e este
					-- estiver marcado como produto sem certificado
					-- Autor: Egler - 2013/09/18
					-------------------------------------------------------------------------------------------------------------------
					INNER JOIN Dados.ProdutoSIGPF PSG
					ON PSG.ID = PRP.IDProdutoSIGPF
					AND (PSG.ProdutoComCertificado IS NOT NULL OR PSG.ProdutoComCertificado = 1)
					AND (PSG.ID <> 0) /*Garante que a proposta foi recebida ou que de alguma forma sabe-se o Produto da Proposta.*/
					-------------------------------------------------------------------------------------------------------------------
	
                 WHERE --PGTO.NumeroCertificadoTratado <> PGTO.NumeroProposta AND
                   --AND PGTO.NumeroCertificadoTratado  IN ('001201800141855')
                    PGTO.[RANK] = 1
					AND PGTO.NumeroCertificadoTratado IS NOT NULL -- ADICIONADO FERNANDO MESSAS 25/10/2017, algumas propostas com certificados nulo estavam causando erro
                   --AND PGTO.SituacaoProposta = 'EMT'  /*VER POSSÍVEL PROPBLEMA EM COMENTAR ESSA LINHA - 20130710*/
                  GROUP BY PGTO.[IDSeguradora], PRP.ID, PGTO.NumeroCertificadoTratado  --PRP.ID, PGTO.NumeroProposta--, PRP.Nome
             ) X
    ON  T.IDSeguradora = X.[IDSeguradora] --Caixa Seguros
    AND T.NumeroCertificado = X.NumeroCertificadoTratado
    AND ISNULL(T.IDProposta, -1) = ISNULL(X.IDProposta, -1)
    WHEN MATCHED 
       THEN UPDATE
             SET IDProposta = COALESCE(X.IDProposta, T.IDProposta)
               , DataArquivo = COALESCE(X.DataArquivo, T.DataArquivo)
			   --------------------------------------------------------------------------------
			   -- Altera o início e fim de vigência do certificado através do status
			   --Egler - 2013/09/19
			   --------------------------------------------------------------------------------
               , DataInicioVigencia = COALESCE(X.DataInicioVigencia, T.DataInicioVigencia)
               , DataFimVigencia = COALESCE(X.DataFimVigencia, T.DataFimVigencia)
			   --------------------------------------------------------------------------------
               , Arquivo = COALESCE(X.[Arquivo], T.[Arquivo])
    WHEN NOT MATCHED 
       THEN INSERT
            (IDProposta, IDSeguradora, NumeroCertificado, /*DataInicioVigencia, DataFimVigencia,*/ DataArquivo, Arquivo)
            VALUES (X.IDProposta, X.[IDSeguradora], X.NumeroCertificadoTratado, /*X.DataInicioVigencia, X.DataFimVigencia,*/ X.DataArquivo, X.[Arquivo]);




  -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir O HISTORICO DO CERTIFICADO 
    --das propostas cujos status foram recebidos no arquivo STASASSE  TIPO 2 
    -----------------------------------------------------------------------------------------------------------------------
     MERGE INTO Dados.CertificadoHistorico AS T
      USING (
                 SELECT   
                          CRT.ID [IDCertificado]
                        , 'TP2' NumeroProposta
                        , PGTO.[IDSeguradora]
                        , MAX(PGTO.Codigo) Codigo
                        , MAX(PGTO.Valor - ValorIOF) ValorPremioLiquido					
                        , MAX(PGTO.Valor) ValorPremioTotal 
                        , MIN(PGTO.DataInicioVigencia) DataInicioVigencia
                        , MAX(ISNULL(PGTO.DataFimVigencia, '9999-12-31')) DataFimVigencia	 
                        , MAX(PGTO.DataArquivo) [DataArquivo]
                        , MAX(PGTO.NomeArquivo) [Arquivo]
                 FROM dbo.STASASSE_TP2_TEMP PGTO
                  INNER JOIN Dados.Proposta PRP
                    ON   PGTO.NumeroProposta = PRP.NumeroProposta          
                     AND PRP.IDSeguradora = 1
                  INNER JOIN Dados.Certificado CRT
                  ON CRT.NumeroCertificado = PGTO.NumeroCertificadoTratado
                  AND CRT.IDSeguradora = PGTO.[IDSeguradora] --Caixa Seguros
                  AND CRT.IDProposta = PRP.ID     
                 WHERE --PGTO.NumeroCertificadoTratado <> PGTO.NumeroProposta AND
              --CERTIFICADO BICHADO. FORAM FEITAS DUAS PROPOSTAS PARA O MESMO CERTIFICADO E DE EMPRESAS DIFERENTES
                   --AND PGTO.NumeroCertificadoTratado  IN ('001201800141855')
                    PGTO.[RANK] = 1
                   --AND PGTO.SituacaoProposta = 'EMT'  
                  GROUP BY PGTO.[IDSeguradora], PRP.ID, PGTO.NumeroCertificadoTratado,  CRT.ID, PGTO.NumeroProposta
             ) X
    ON  T.NumeroProposta = X.NumeroProposta 
    AND T.[IDCertificado] = X.[IDCertificado] 
    AND T.DataArquivo = X.DataArquivo
    WHEN MATCHED 
       THEN UPDATE
             SET 
                 DataInicioVigencia = X.DataInicioVigencia
               , DataFimVigencia = X.DataFimVigencia
               , ValorPremioTotal = X.ValorPremioTotal
               , ValorPremioLiquido = X.ValorPremioLiquido
               , Arquivo = X.[Arquivo]
    WHEN NOT MATCHED 
       THEN INSERT
                   ([IDCertificado], NumeroProposta, ValorPremioTotal, ValorPremioLiquido
                  , DataInicioVigencia, DataFimVigencia, DataArquivo, Arquivo)
            VALUES (X.[IDCertificado], X.[NumeroProposta], X.ValorPremioTotal, X.ValorPremioLiquido
                  , X.DataInicioVigencia, X.DataFimVigencia, X.DataArquivo, X.[Arquivo]);


    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os pagamentos recebidos no arquivo STASASSE - TIPO - 2
    -----------------------------------------------------------------------------------------------------------------------		         
     ;MERGE INTO Dados.PagamentoEmissao AS T
		USING (
        SELECT DISTINCT PRP.ID [IDProposta], TM.ID [IDMotivo], STPRP.ID [IDSituacaoProposta], PGTO.NumeroParcela
             , PGTO.Valor, PGTO.ValorIOF, PGTO.DataEfetivacao, PGTO.DataArquivo, PGTO.DataInicioVigencia, PGTO.DataFimVigencia
             , PGTO.Codigo [CodigoNaFonte], PGTO.TipoDado
             , NULL [SinalLancamento], 0 [ExpectativaDeReceita], PGTO.NomeArquivo [Arquivo], PGTO.[RANK]
        FROM dbo.STASASSE_TP2_TEMP PGTO
          INNER JOIN Dados.Proposta PRP
          ON PGTO.NumeroProposta = PRP.NumeroProposta
          AND PGTO.IDSeguradora = PRP.IDSeguradora
          LEFT OUTER JOIN Dados.SituacaoProposta STPRP
          ON PGTO.SituacaoProposta = STPRP.Sigla
          LEFT OUTER JOIN Dados.TipoMotivo TM
          ON PGTO.TipoMotivo = TM.Codigo           
        WHERE 
              --PGTO.TipoMotivo IS NOT NULL   AND
           
          PGTO.[RANK] = 1
          ) AS X
    ON X.[IDProposta] = T.[IDProposta]   
   AND ISNULL(X.[IDMotivo], -1) = ISNULL(T.[IDMotivo], -1)
	 AND X.[DataArquivo] = T.[DataArquivo]  
	 AND X.[Valor] = T.[Valor]          
    WHEN MATCHED
			    THEN UPDATE
		     SET [IDSituacaoProposta] = COALESCE(X.[IDSituacaoProposta], T.[IDSituacaoProposta])
			   , [Valor] = COALESCE(X.[Valor],T.Valor)
               , [ValorIOF] = COALESCE(X.[ValorIOF], T.[ValorIOF])
               , [DataEfetivacao] = COALESCE(X.[DataEfetivacao], T.[DataEfetivacao])
               --, [DataArquivo] = X.[DataArquivo]
               , [CodigoNaFonte] = COALESCE(X.[CodigoNaFonte], T.[CodigoNaFonte])
               , [TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
               , [SinalLancamento] = COALESCE(X.[SinalLancamento], T.[SinalLancamento])
               , [ExpectativaDeReceita] = COALESCE(X.[ExpectativaDeReceita], T.[ExpectativaDeReceita])
               , [Arquivo] = COALESCE(X.[Arquivo], T.[Arquivo])
               , [DataInicioVigencia] = COALESCE(X.[DataInicioVigencia], T.[DataInicioVigencia])
			   , [DataFimVigencia] = COALESCE(X.[DataFimVigencia], T.[DataFimVigencia])               		 
    WHEN NOT MATCHED
			    THEN INSERT          
              ([IDProposta],  [IDMotivo], [IDSituacaoProposta]
             , [DataArquivo], [Valor], [ValorIOF]
             , [DataEfetivacao], [CodigoNaFonte], [TipoDado]
             , [SinalLancamento]
             , [ExpectativaDeReceita], [Arquivo], [DataInicioVigencia], [DataFimVigencia]             
             )
          VALUES (X.[IDProposta]
                 ,X.[IDMotivo]
                 ,X.[IDSituacaoProposta]
                 ,X.[DataArquivo]
                 ,X.[Valor]
                 ,X.[ValorIOF]
                 ,X.[DataEfetivacao]
                 ,X.[CodigoNaFonte]
                 ,X.[TipoDado]
                 ,X.[SinalLancamento]
                 ,X.[ExpectativaDeReceita]
                 ,X.[Arquivo]     
                 ,X.[DataInicioVigencia]
                 ,X.[DataFimVigencia]          
                 );

  -----------------------------------------------------------------------------------------------------------------------


  /*TODO - Atualizar saldo pago*/

  
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Pagamento_STASASSE_TIPO2'
  /*************************************************************************************/
  
                    
  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[STASASSE_TP2_TEMP] 
  
  /*********************************************************************************************************************/
  SET @COMANDO = 'INSERT INTO [dbo].[STASASSE_TP2_TEMP]  
                     ([Codigo],[IDSeguradora],[NumeroProposta],[NumeroCertificado],[DataInicioVigencia],[DataFimVigencia],[SituacaoProposta]
                     ,[TipoMotivo],[NumeroParcela],[Valor],[ValorIOF],[TipoDado],[DataEfetivacao],[DataArquivo],[NomeArquivo],[Rank])
                  SELECT [Codigo],[IDSeguradora],[NumeroProposta],[NumeroCertificado],[DataInicioVigencia],[DataFimVigencia],[SituacaoProposta]
                        ,[TipoMotivo],[NumeroParcela],[Valor],[ValorIOF],[TipoDado],[DataEfetivacao],[DataArquivo],[NomeArquivo],[Rank]
                  FROM OPENQUERY ([OBERON], 
                  ''EXEC [Fenae].[Corporativo].[proc_RecuperaPagamento_STASASSE_TIPO2] ''''' + @PontoDeParada + ''''''') PRP'                
  EXEC (@COMANDO)

                  
  SELECT @MaiorCodigo= MAX(STA.Codigo)
  FROM dbo.STASASSE_TP2_TEMP STA    
                    
  /*********************************************************************************************************************/
                    
  /*********************************************************************************************************************/
  
END


--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[STASASSE_TP2_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	--DROP TABLE [dbo].[STASASSE_TP2_TEMP];
  	      	                                
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH

                


