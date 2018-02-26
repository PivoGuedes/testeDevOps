
/*
	Autor: Egler Vieira
	Data Criação: 24/07/2014

	Descrição: 
	
	Última alteração : 28/07/2014

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereMovimentoFinanceiro_SSD
	Descrição: Procedimento que realiza a inserção da movimentação financeira (endossos e pagamentos) no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'ANTARES', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereMovimentoFinanceiro_SSD] 
AS

BEGIN TRY		
	    
DECLARE @PontoDeParada AS VARCHAR(400) 
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MovimentoFinanceiro_SSD_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[MovimentoFinanceiro_SSD_TEMP];

CREATE TABLE [dbo].[MovimentoFinanceiro_SSD_TEMP]
(
    [TIPO_DADO]                       VARCHAR(30) DEFAULT ('SSD.MOVFIN') NOT NULL,
    [ID_SEGURADORA]                   [SMALLINT] DEFAULT(1)  NULL,
    [SUK_ENDOSSO_FINANCEIRO]          [int]  NULL,
 	[NUM_ENDOSSO]                     [int]  NULL,
	[DTH_EMISSAO_ENDOSSO]             [date]  NULL,
	[COD_TIPO_ENDOSSO]                [char](1)  NULL,
	[COD_TIPO_MOVIMENTO_EF]           [smallint]  NULL,
	[COD_RAMO_EMISSOR_EF]             [smallint]  NULL,
	[DTH_INI_VIGENCIA_EF]             [date]  NULL,
	[DTH_FIM_VIGENCIA_EF]             [date]  NULL,
	[VLR_PREMIO_TARIFARIO_EF]         [decimal](15, 2)  NULL,
	[VLR_PREMIO_LIQUIDO_EF]           [decimal](15, 2)  NULL,
	[VLR_IOF_EF]                      [decimal](15, 2)  NULL,
	[VLR_PREMIO_BRUTO_EF]             [decimal](15, 2)  NULL,
	[DTH_OPERACAO_EF]                 [date]  NULL,
	[COD_OPERACAO_EF]                 [smallint]  NULL,
	[COD_SUBGRUPO_EF]                 [smallint]  NULL,
	[COD_FILIAL]                      [smallint]  NULL,
	[COD_MODALIDADE_EF]               [smallint]  NULL,
	[DTH_ATUALIZACAO_MV]              [date] NOT NULL,
	[VLR_PREMIO_BRUTO_MV]             [decimal](15, 2) NULL,
	[VLR_PREMIO_LIQUIDO_MV]           [decimal](21, 8) NULL,
	[VLR_IOF_MV]                      [decimal](15, 10) NULL,
	[NUM_BIL_CERTIF]                  [VARCHAR](20) NULL,
	[NUM_PROPOSTA_SIVPF]              [VARCHAR](20) NULL,
    [NUM_APOLICE]                     [VARCHAR](20) NULL, 
    [NUM_PROPOSTA_TRATADO]            AS Cast(dbo.fn_TrataNumeroPropostaZeroExtra(ISNULL([NUM_PROPOSTA_SIVPF],'SN' + [NUM_BIL_CERTIF])) as VARCHAR(20)) PERSISTED,
    [NUM_CERTIFICADO_TRATADO]         AS Cast(dbo.fn_TrataNumeroPropostaZeroExtra([NUM_BIL_CERTIF]) as VARCHAR(20)) PERSISTED,
    --[NUM_BIL_CERTIF_PB]               [decimal](15, 0) NULL,
	--[NUM_CERTIFICADO_TRATADO_PB]      AS Cast(dbo.fn_TrataNumeroPropostaZeroExtra([NUM_BIL_CERTIF_PB]) as VARCHAR(20)) PERSISTED,
    [COD_SUBGRUPO]                    [smallint] NULL,
	[IND_ORIGEM_REGISTRO]             [char](1) NULL,
	[NUM_PARCELA]                     [int] NULL,
	[VLR_PREMIO_PARCELA]              [decimal](15, 2) NULL,
	[VLR_PREMIO_LIQUIDO_PARCELA]      [decimal](21, 8) NULL,
	[VLR_IOF_PARCELA]                 [decimal](15, 10) NULL,
	[VLR_PREMIO_VG]                   [decimal](15, 2) NULL,
	[VLR_PREMIO_AP]                   [decimal](15, 2) NULL,
	[VLR_TARIFA]                      [decimal](15, 2) NULL,
	[VLR_BALCAO]                      [decimal](15, 2) NULL,
	[DTH_BAIXA_PARCELA]               [date] NULL,
	[NUM_TITULO]                      [decimal](13, 0) NULL,
	[COD_TIPO_MOVIMENTO]              [smallint]  NULL,
	[COD_ORIGEM_PAGAMENTO]            [char](1) NULL,
    [COD_PRODUTO_SIAS]                [varchar](5) NULL
) 


 /*Cria Índices*/  
CREATE CLUSTERED INDEX idx_SituacaoPagamento_STAFPREV_TEMP ON [dbo].[MovimentoFinanceiro_SSD_TEMP] ([SUK_ENDOSSO_FINANCEIRO] ASC)  

CREATE NONCLUSTERED INDEX IDX_MovimentoFinanceiro_SSD_CodigoSIAS_TEMP
ON [dbo].[MovimentoFinanceiro_SSD_TEMP] ([COD_PRODUTO_SIAS])


CREATE NONCLUSTERED INDEX IDX_MovimentoFinanceiro_SSD_NUM_APOLICE_TEMP
ON [dbo].[MovimentoFinanceiro_SSD_TEMP] ([NUM_APOLICE])
INCLUDE ([TIPO_DADO],[ID_SEGURADORA],[DTH_ATUALIZACAO_MV])


CREATE NONCLUSTERED INDEX IDX_MovimentoFinanceiro_SSD_NUM_PROPOSTA_TRATADO_TEMP
ON [dbo].[MovimentoFinanceiro_SSD_TEMP] ([NUM_PROPOSTA_TRATADO])
INCLUDE ([TIPO_DADO],[ID_SEGURADORA],[DTH_ATUALIZACAO_MV])

--CREATE NONCLUSTERED INDEX IDX_NumeroProposta_STAFPREV_TEMP  ON [dbo].[MovimentoFinanceiro_SSD_TEMP] ([NumeroProposta],[SituacaoCobranca],[DataInicioSituacao], [DataArquivo] DESC, Codigo DESC)

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'MovimentoFinanceiro_SSD'


/*********************************************************************************************************************/               
/*Recupera maior Código do retorno*/
/*********************************************************************************************************************/
--DECLARE @PontoDeParada AS VARCHAR(400) 
--set @PontoDeParada = 0
---DECLARE @MaiorCodigo AS BIGINT
--DECLARE @ParmDefinition NVARCHAR(500)
--DECLARE @COMANDO AS NVARCHAR(max)

SET @COMANDO = 'INSERT INTO [dbo].[MovimentoFinanceiro_SSD_TEMP] 
				(  
                   [SUK_ENDOSSO_FINANCEIRO]          ,
                   [NUM_ENDOSSO]                     ,
                   [DTH_EMISSAO_ENDOSSO]             ,
                   [COD_TIPO_ENDOSSO]                ,
                   [COD_TIPO_MOVIMENTO_EF]           ,
                   [COD_RAMO_EMISSOR_EF]             ,
                   [DTH_INI_VIGENCIA_EF]             ,
                   [DTH_FIM_VIGENCIA_EF]             ,
                   [VLR_PREMIO_TARIFARIO_EF]         ,
                   [VLR_PREMIO_LIQUIDO_EF]           ,
                   [VLR_IOF_EF]                      ,
                   [VLR_PREMIO_BRUTO_EF]             ,
                   [DTH_OPERACAO_EF]                 ,
                   [COD_OPERACAO_EF]                 ,
                   [COD_SUBGRUPO_EF]                 ,
                   [COD_FILIAL]                      ,
                   [COD_MODALIDADE_EF]               ,
                   [DTH_ATUALIZACAO_MV]              ,
                   [VLR_PREMIO_BRUTO_MV]             ,
                   [VLR_PREMIO_LIQUIDO_MV]           ,
                   [VLR_IOF_MV]                      ,
                   [NUM_BIL_CERTIF]                  ,
                   /*  [NUM_BIL_CERTIF_PB]               ,*/
                   [NUM_PROPOSTA_SIVPF]              ,
                   [NUM_APOLICE]                     ,
                   [COD_SUBGRUPO]                    ,
                   [IND_ORIGEM_REGISTRO]             ,
                   [NUM_PARCELA]                     ,
                   [VLR_PREMIO_PARCELA]              ,
                   [VLR_PREMIO_LIQUIDO_PARCELA]      ,
                   [VLR_IOF_PARCELA]                 ,
                   [VLR_PREMIO_VG]                   ,
                   [VLR_PREMIO_AP]                   ,
                   [VLR_TARIFA]                      ,
                   [VLR_BALCAO]                      ,
                   [DTH_BAIXA_PARCELA]               ,
                   [NUM_TITULO]                      ,
                   [COD_TIPO_MOVIMENTO]              ,
                   [COD_ORIGEM_PAGAMENTO]            ,            
                   [COD_PRODUTO_SIAS] 
                
				)  
                SELECT 
                       [SUK_ENDOSSO_FINANCEIRO]          ,
                       [NUM_ENDOSSO]                     ,
                       [DTH_EMISSAO_ENDOSSO]             ,
                       [COD_TIPO_ENDOSSO]                ,
                       [COD_TIPO_MOVIMENTO_EF]           ,
                       [COD_RAMO_EMISSOR_EF]             ,
                       [DTH_INI_VIGENCIA_EF]             ,
                       [DTH_FIM_VIGENCIA_EF]             ,
                       [VLR_PREMIO_TARIFARIO_EF]         ,
                       [VLR_PREMIO_LIQUIDO_EF]           ,
                       [VLR_IOF_EF]                      ,
                       [VLR_PREMIO_BRUTO_EF]             ,
                       [DTH_OPERACAO_EF]                 ,
                       [COD_OPERACAO_EF]                 ,
                       [COD_SUBGRUPO_EF]                 ,
                       [COD_FILIAL]                      ,
                       [COD_MODALIDADE_EF]               ,
                       [DTH_ATUALIZACAO_MV]              ,
                       [VLR_PREMIO_BRUTO_MV]             ,
                       [VLR_PREMIO_LIQUIDO_MV]           ,
                       [VLR_IOF_MV]                      ,
                       [NUM_BIL_CERTIF]                  ,
                     /*  [NUM_BIL_CERTIF_PB]               ,*/
                       [NUM_PROPOSTA_SIVPF]              ,
                       [NUM_APOLICE]                     ,
                       [COD_SUBGRUPO]                    ,
                       [IND_ORIGEM_REGISTRO]             ,
                       [NUM_PARCELA]                     ,
                       [VLR_PREMIO_PARCELA]              ,
                       [VLR_PREMIO_LIQUIDO_PARCELA]      ,
                       [VLR_IOF_PARCELA]                 ,
                       [VLR_PREMIO_VG]                   ,
                       [VLR_PREMIO_AP]                   ,
                       [VLR_TARIFA]                      ,
                       [VLR_BALCAO]                      ,
                       [DTH_BAIXA_PARCELA]               ,
                       [NUM_TITULO]                      ,
                       [COD_TIPO_MOVIMENTO]              ,
                       [COD_ORIGEM_PAGAMENTO]            ,
                       [COD_PRODUTO_SIAS]                               
                FROM OPENQUERY ([ANTARES], 
                ''EXEC [Corporativo].[SSD].[proc_RecuperaMovimentoFinanceiro] ''''' + @PontoDeParada + ''''''') PRP' --@PontoDeParada

EXEC (@COMANDO)     

SELECT @MaiorCodigo = MAX(PRP.SUK_ENDOSSO_FINANCEIRO)
FROM [dbo].[MovimentoFinanceiro_SSD_TEMP] PRP

SET @COMANDO = ''     

WHILE @MaiorCodigo IS NOT NULL
BEGIN 

    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir Ramos não recebidos
    -----------------------------------------------------------------------------------------------------------------------
      ;MERGE INTO Dados.Ramo AS T
	      USING (
                 SELECT DISTINCT
                         SSD.COD_RAMO_EMISSOR_EF [Codigo]
                 FROM dbo.MovimentoFinanceiro_SSD_TEMP SSD
                 WHERE SSD.COD_RAMO_EMISSOR_EF IS NOT NULL              
              ) X
         ON T.[Codigo] = X.[Codigo]  
       WHEN NOT MATCHED
		          THEN INSERT ([Codigo])
		               VALUES (X.[Codigo]);		   
                       
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
    --Comando para inserir FilialFaturamento não registradas
    -----------------------------------------------------------------------------------------------------------------------
      ;MERGE INTO Dados.FilialFaturamento AS T
	      USING (
                 SELECT DISTINCT
                         SSD.[COD_FILIAL] [Codigo]
                 FROM dbo.MovimentoFinanceiro_SSD_TEMP SSD
                 WHERE SSD.[COD_FILIAL] IS NOT NULL              
              ) X
         ON T.[Codigo] = X.[Codigo]  
       WHEN NOT MATCHED
		          THEN INSERT ([Codigo])
		               VALUES (X.[Codigo]);		  
                       
	-----------------------------------------------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir Produtos não registrados
    -----------------------------------------------------------------------------------------------------------------------
    ;MERGE INTO Dados.Produto AS T
	    USING (
                SELECT DISTINCT
                        SSD.[COD_PRODUTO_SIAS] [CodigoComercializado]
                FROM dbo.MovimentoFinanceiro_SSD_TEMP SSD
                WHERE SSD.[COD_PRODUTO_SIAS] IS NOT NULL              
            ) X
        ON T.[CodigoComercializado] = X.[CodigoComercializado]  
    WHEN NOT MATCHED
		        THEN INSERT ([CodigoComercializado])
		            VALUES (X.[CodigoComercializado]);		  
                       
	-----------------------------------------------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir Tipos de Endossos não registrados
    -----------------------------------------------------------------------------------------------------------------------
    ;MERGE INTO Dados.TipoEndosso AS T
	    USING (
                SELECT DISTINCT
                        SSD.COD_TIPO_ENDOSSO [Codigo]
                FROM dbo.MovimentoFinanceiro_SSD_TEMP SSD
                WHERE SSD.COD_TIPO_ENDOSSO IS NOT NULL     
                and SSD.COD_TIPO_ENDOSSO >= 0         
            ) X
        ON T.[ID] = X.[Codigo]  
    WHEN NOT MATCHED
		        THEN INSERT ([ID], [Codigo])
		            VALUES (X.[Codigo], X.[Codigo]);	
	-----------------------------------------------------------------------------------------------------------------------
 --SELECT [NUM_PROPOSTA_TRATADO] FROM dbo.MovimentoFinanceiro_SSD_TEMP
    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir propostas não recebidas nos arquivos PRPSASSE
    -----------------------------------------------------------------------------------------------------------------------
      
      ;MERGE INTO Dados.Proposta AS T
	      USING (
                 SELECT SSD.[NUM_PROPOSTA_TRATADO] [NumeroProposta]
                      , SSD.[ID_SEGURADORA] [IDSeguradora]
                      , SSD.[TIPO_DADO] [TipoDado]
                     , MAX(SSD.[DTH_ATUALIZACAO_MV]) [DataArquivo]
                 FROM dbo.MovimentoFinanceiro_SSD_TEMP SSD
                 WHERE SSD.[NUM_PROPOSTA_TRATADO] IS NOT NULL AND SSD.[NUM_PROPOSTA_TRATADO] <> '0' 
                 GROUP BY SSD.[NUM_PROPOSTA_TRATADO] 
                        , SSD.[ID_SEGURADORA] 
                        , SSD.[TIPO_DADO]             
              ) X
         ON T.NumeroProposta = X.NumeroProposta  
        AND T.IDSeguradora = X.IDSeguradora
       WHEN NOT MATCHED
		          THEN INSERT (NumeroProposta, [IDSeguradora], IDAgenciaVenda, IDProduto, IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, TipoDado, DataArquivo)
		               VALUES (X.NumeroProposta, X.[IDSeguradora], -1, -1, 0, -1, 0, -1, X.TipoDado, X.DataArquivo);		   
	-----------------------------------------------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir as apólices (Contratos Anteriores) ainda não registradas
    -----------------------------------------------------------------------------------------------------------------------
    MERGE INTO Dados.Contrato AS T
	      USING (
                 SELECT 
                 
                        SSD.NUM_APOLICE [NumeroContrato]
                      , SSD.[ID_SEGURADORA] [IDSeguradora]
                      , SSD.[TIPO_DADO] [TipoDado]
                      , MAX(SSD.[DTH_ATUALIZACAO_MV]) [DataArquivo]
                 --*
                 FROM dbo.MovimentoFinanceiro_SSD_TEMP SSD
                 WHERE Cast(SSD.NUM_APOLICE as bigint) > 0 
                   and SSD.NUM_APOLICE is not null
                 group by SSD.NUM_APOLICE 
                      , SSD.[ID_SEGURADORA] 
                      , SSD.[TIPO_DADO] 
              ) X
         ON T.NumeroContrato = X.[NumeroContrato]
        AND T.IDSeguradora = X.IDSeguradora
       WHEN NOT MATCHED
		          THEN INSERT 
                             (
                               [IDSeguradora]
                             , [NumeroContrato]                            
                             , Arquivo
                             , [DataArquivo]
                             
                             )
		               VALUES (
                               X.[IDSeguradora]
                             , X.[NumeroContrato]
                             , X.TipoDado
                             , X.[DataArquivo])	;

    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os ENDOSSOS recebidos no SSD
    -----------------------------------------------------------------------------------------------------------------------		             
    WITH CTE
    AS
    (
        SELECT 
              PRP.ID [IDProposta]
            , CNT.ID [IDContrato]
            , PRD.ID [IDProduto]
            , SSD.COD_SUBGRUPO [CodigoSubEstipulante]
            , SSD.DTH_EMISSAO_ENDOSSO [DataEmissao] 
            , SSD.NUM_ENDOSSO [NumeroEndosso]
            , SSD.DTH_INI_VIGENCIA_EF [DataInicioVigencia]
            , SSD.DTH_FIM_VIGENCIA_EF [DataFimVigencia]
            , SSD.VLR_IOF_EF [ValorIOF]
            , SSD.VLR_PREMIO_BRUTO_EF [ValorPremioTotal]
            , SSD.VLR_PREMIO_LIQUIDO_EF [ValorPremioLiquido]
            , SSD.VLR_PREMIO_TARIFARIO_EF [ValorPremioTarifario]
            , TE.ID [IDTipoEndosso]
            , FF.ID [IDFilialFaturamento]
            , R.ID [IDRamo]
            , SSD.DTH_OPERACAO_EF DataArquivo
            , SSD.Tipo_Dado [Arquivo]
            , ROW_NUMBER() OVER (PARTITION BY SSD.NUM_APOLICE, SSD.NUM_ENDOSSO, SSD.DTH_EMISSAO_ENDOSSO ORDER BY SSD.NUM_APOLICE, SSD.DTH_EMISSAO_ENDOSSO, PRP.ID ) RN
    FROM                                   
        [dbo].MovimentoFinanceiro_SSD_TEMP SSD
        LEFT JOIN Dados.Proposta PRP
            ON SSD.[NUM_PROPOSTA_TRATADO] = PRP.NumeroProposta
            AND SSD.[ID_SEGURADORA] = PRP.IDSeguradora
        LEFT JOIN Dados.Produto PRD
        ON PRD.CodigoComercializado = [COD_PRODUTO_SIAS]
        LEFT JOIN Dados.FilialFaturamento FF
        ON FF.Codigo = SSD.COD_FILIAL
        LEFT JOIN Dados.Ramo R
        ON R.Codigo = SSD.COD_RAMO_EMISSOR_EF
        LEFT JOIN Dados.TipoEndosso TE
        ON TE.Codigo = SSD.COD_TIPO_ENDOSSO
        LEFT JOIN Dados.Contrato CNT
            ON CNT.NumeroContrato = SSD.NUM_APOLICE
            AND CNT.IDSeguradora = SSD.[ID_SEGURADORA] 
    )    
	
    MERGE INTO Dados.Endosso AS T
		USING (
                SELECT  *
                FROM CTE
                WHERE CTE.RN = 1   
          ) AS X
    ON X.[IDcontrato] = T.[IDcontrato]    
   AND X.[NumeroEndosso] = T.[NumeroEndosso]
   AND ISNULL(X.[IDProposta],-1) = ISNULL(T.[IDProposta],-1)
    WHEN MATCHED
		THEN UPDATE
			SET 
                [IDProduto] = COALESCE(X.[IDProduto], T.[IDProduto])
              , [CodigoSubEstipulante] = COALESCE(X.[CodigoSubEstipulante], T.[CodigoSubEstipulante])
              , [DataEmissao] = COALESCE(X.[DataEmissao], T.[DataEmissao])
              , [NumeroEndosso] = COALESCE(X.[NumeroEndosso], T.[NumeroEndosso])
              , [DataInicioVigencia] = COALESCE(X.[DataInicioVigencia], T.[DataInicioVigencia])
              , [DataFimVigencia] = COALESCE(X.[DataFimVigencia], T.[DataFimVigencia])
              , [ValorIOF] = COALESCE(X.[ValorIOF], T.[ValorIOF])
              , [ValorPremioTotal] = COALESCE(X.[ValorPremioTotal], T.[ValorPremioTotal])
              , [ValorPremioLiquido] = COALESCE(X.[ValorPremioLiquido], T.[ValorPremioLiquido])
              , [ValorPremioTarifario] = COALESCE(X.[ValorPremioTarifario], T.[ValorPremioTarifario])
              , [IDFilialFaturamento] = COALESCE(X.[IDFilialFaturamento], T.[IDFilialFaturamento])
              , [IDRamo] = COALESCE(X.[IDRamo], T.[IDRamo])
              , [IDTipoEndosso] = COALESCE(X.[IDTipoEndosso], T.[IDTipoEndosso])
              , [DataArquivo] = X.[DataArquivo]
              , Arquivo = COALESCE(X.Arquivo, T.Arquivo)
    WHEN NOT MATCHED
			    THEN INSERT          
              (                 
                   [IDcontrato]  
                 , [NumeroEndosso]  
                 , [IDProposta]
                 , [IDProduto] 
                 , [CodigoSubEstipulante] 
                 , [DataEmissao]
                 , [DataInicioVigencia]
                 , [DataFimVigencia] 
                 , [ValorIOF] 
                 , [ValorPremioTotal] 
                 , [ValorPremioLiquido]  
                 , [ValorPremioTarifario] 
                 , [IDFilialFaturamento] 
                 , [IDRamo]
                 , [IDTipoEndosso]
                 , [DataArquivo] 
                 , Arquivo 
              )
          VALUES (   
                     [IDcontrato]  
                 , X.[NumeroEndosso]  
                 , X.[IDProposta]
                 , X.[IDProduto] 
                 , X.[CodigoSubEstipulante] 
                 , X.[DataEmissao]
                 , X.[DataInicioVigencia]
                 , X.[DataFimVigencia] 
                 , X.[ValorIOF] 
                 , X.[ValorPremioTotal] 
                 , X.[ValorPremioLiquido]  
                 , X.[ValorPremioTarifario] 
                 , X.[IDFilialFaturamento] 
                 , x.[IDRamo]
                 , X.[IDTipoEndosso]
                 , X.[DataArquivo] 
                 , X.Arquivo 
                 );         
--SELECT *
--FROM Dados.Contrato WHERE ID = 7568

--SELECT * FROM [dbo].MovimentoFinanceiro_SSD_TEMP SSD WHERE NUM_ENDOSSO = 4628839 and NUM_APOLICE = 109300002358

--SELECT *
--FROM Dados.Endosso
    ---------------------------------end ENDOSSOS----------------------------------------------------------



    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os Pagamentos recebidos no SSD
    -----------------------------------------------------------------------------------------------------------------------		             
    WITH CTE
    AS
    (

	--SELECT * FROM (
	
        SELECT 
              PRP.ID [IDProposta]
            , SSD.NUM_ENDOSSO [NumeroEndosso]
            , SSD.NUM_PARCELA [NumeroParcela]
            , SSD.NUM_TITULO [NumeroTitulo]
			, -3 IDMotivo -- SSD
            , SSD.VLR_PREMIO_PARCELA [Valor]
            , SSD.VLR_PREMIO_LIQUIDO_PARCELA [ValorPremioLiquido]
            , SSD.VLR_IOF_PARCELA [ValorIOF]
            , SSD.VLR_PREMIO_VG [ValorPremioVG]
            , SSD.VLR_PREMIO_AP [ValorPremioAP]
			, SSD.DTH_EMISSAO_ENDOSSO [DataEndosso]
            , SSD.VLR_TARIFA [ValorTarifa]
            , SSD.VLR_BALCAO [ValorBalcao]
            , CASE WHEN SSD.COD_TIPO_MOVIMENTO >= 3 THEN '-' WHEN SSD.COD_TIPO_MOVIMENTO < 3 THEN '+' END [SinalLancamento] 
            , SSD.DTH_BAIXA_PARCELA [DataEfetivacao]
            , SSD.DTH_BAIXA_PARCELA [DataArquivo]
            , SSD.TIPO_DADO [TipoDado]
            , SSD.TIPO_DADO + ' ' +  Cast(MAX([DTH_ATUALIZACAO_MV]) as varchar(10)) Arquivo
            , SSD.COD_TIPO_MOVIMENTO [IDTipoMovimento]
			, CASE WHEN SSD.COD_ORIGEM_PAGAMENTO = 'D' THEN 0 
			       WHEN SSD.COD_ORIGEM_PAGAMENTO = 'V' THEN 1
				   ELSE NULL
			  END VendaNova
            
            --, ROW_NUMBER() OVER (PARTITION BY SSD.NUM_APOLICE, SSD.DTH_EMISSAO_ENDOSSO ORDER BY SSD.NUM_APOLICE, SSD.DTH_EMISSAO_ENDOSSO, PRP.ID ) RN
		FROM                                   
			[dbo].MovimentoFinanceiro_SSD_TEMP SSD
			LEFT JOIN Dados.Proposta PRP
				ON SSD.[NUM_PROPOSTA_TRATADO] = PRP.NumeroProposta
				AND SSD.[ID_SEGURADORA] = PRP.IDSeguradora
				
				WHERE PRP.ID IS NOT NULL
			      --AND PRP.ID = 67556780
				  ---INCLUÍDO TEMPORARIAMENTE POR GUEDES
				  AND NOT EXISTS(select * 
									from MovimentoFinanceiro_SSD_TEMP SSD2 
									WHERE SSD2.[NUM_PROPOSTA_TRATADO] = SSD.[NUM_PROPOSTA_TRATADO] 
											AND SSD2.NUM_ENDOSSO = SSD.NUM_ENDOSSO
											AND SSD2.COD_TIPO_MOVIMENTO <> SSD.COD_TIPO_MOVIMENTO
											AND SSD2.NUM_PARCELA = SSD.NUM_PARCELA
											AND SSD2.[DTH_ATUALIZACAO_MV] = SSD.[DTH_ATUALIZACAO_MV])
				---INCLUÍDO TEMPORARIAMENTE POR GUEDES - EXCLUIR ESTE BLOCO APÓS CORREÇÃO DO ÍNDICE UNIQUE
	    GROUP BY    PRP.ID 
            , SSD.NUM_ENDOSSO 
            , SSD.NUM_PARCELA 
            , SSD.NUM_TITULO 
            , SSD.VLR_PREMIO_PARCELA 
            , SSD.VLR_PREMIO_LIQUIDO_PARCELA 
            , SSD.VLR_IOF_PARCELA 
            , SSD.VLR_PREMIO_VG 
            , SSD.VLR_PREMIO_AP 
			, SSD.DTH_EMISSAO_ENDOSSO
            , SSD.VLR_TARIFA 
            , SSD.VLR_BALCAO 
            , CASE WHEN SSD.COD_TIPO_MOVIMENTO >= 3 THEN '-' WHEN SSD.COD_TIPO_MOVIMENTO < 3 THEN '+' END  
            , SSD.DTH_BAIXA_PARCELA 
            , SSD.DTH_BAIXA_PARCELA 
            , SSD.TIPO_DADO 
			, CASE WHEN SSD.COD_ORIGEM_PAGAMENTO = 'D' THEN 0 
			       WHEN SSD.COD_ORIGEM_PAGAMENTO = 'V' THEN 1
				   ELSE NULL
			  END
			, SSD.COD_TIPO_MOVIMENTO 
	  --    ) X
			--	inner joIn dados.pagamento T ON
			--	X.[IDProposta] = T.[IDProposta]    
   --AND X.[NumeroParcela] = T.[NumeroParcela]
   --AND X.[NumeroEndosso] = COALESCE(T.[NumeroEndosso],X.[NumeroEndosso],-1)
   --AND X.[NumeroTitulo] = COALESCE(T.[NumeroTitulo],X.[NumeroTitulo],'')
   --AND X.IDMotivo =    ISNULL(T.IDMotivo,-3)  -- -3 SSD
   --AND X.DataArquivo = T.DataArquivo
   --AND T.Arquivo like 'SSD.%'
	

				--SELECT * FROM DADOS.Pagamento WHERE IDProposta = 11331043
    )    
    MERGE INTO Dados.Pagamento AS T
		USING (
                SELECT *
                FROM CTE
                --WHERE CTE.RN = 1   
          ) AS X
    ON X.[IDProposta] = T.[IDProposta]    
   AND X.[NumeroParcela] = T.[NumeroParcela]
   AND X.[NumeroEndosso] = COALESCE(T.[NumeroEndosso],X.[NumeroEndosso],-1)
   AND X.[NumeroTitulo] = COALESCE(T.[NumeroTitulo],X.[NumeroTitulo],'')
   AND X.IDMotivo =    T.IDMotivo  -- -3 SSD
   AND X.DataArquivo = T.DataArquivo
   AND T.Arquivo like 'SSD.%'
   --Valor
    WHEN MATCHED
		THEN UPDATE
			SET 
			    [NumeroEndosso] = COALESCE(X.[NumeroEndosso], T.[NumeroEndosso]) 
              , [NumeroTitulo] = COALESCE(X.[NumeroTitulo], T.[NumeroTitulo])
              , [Valor] = COALESCE(X.[Valor], T.[Valor])
              , [ValorPremioLiquido] = COALESCE(X.[ValorPremioLiquido], T.[ValorPremioLiquido])
              , [ValorIOF] = COALESCE(X.[ValorIOF], T.[ValorIOF])
              , [ValorPremioVG] = COALESCE(X.[ValorPremioVG], T.[ValorPremioVG])
              , [ValorPremioAP] = COALESCE(X.[ValorPremioAP], T.[ValorPremioAP])
              , [ValorTarifa] = COALESCE(X.[ValorTarifa], T.[ValorTarifa])
              , [ValorBalcao] = COALESCE(X.[ValorBalcao], T.[ValorBalcao])
              , [DataEfetivacao] = COALESCE(X.[DataEfetivacao], T.[DataEfetivacao])
              , [TipoDado] = COALESCE(X.[TipoDado], T.[TipoDado])
              , [IDTipoMovimento] = COALESCE(X.[IDTipoMovimento], T.[IDTipoMovimento])
			  , [IDMotivo] = COALESCE(X.[IDMotivo], T.[IDMotivo])
              , SinalLancamento =  COALESCE(X.[SinalLancamento], T.[SinalLancamento])            
              , [DataArquivo] = X.[DataArquivo]
              , Arquivo = COALESCE(X.[Arquivo], T.[Arquivo])
			  , DataEndosso = COALESCE(X.[DataEndosso], T.[DataEndosso])
			  , VendaNova = COALESCE(X.VendaNova, T.VendaNova)
    WHEN NOT MATCHED
			    THEN INSERT          
              (                 
                    [IDProposta]
                   ,[NumeroEndosso]
                   ,[NumeroParcela]
                   ,[NumeroTitulo]
                   ,[IDTipoMovimento]
                   ,IDMotivo
                   ,[Valor]
                   ,[ValorPremioLiquido]
                   ,[ValorIOF]
                   ,[ValorPremioVG]
                   ,[ValorPremioAP]
                   ,[ValorTarifa]
                   ,[ValorBalcao]
                   ,[DataEfetivacao]
                   ,[SinalLancamento]
                   ,[TipoDado]
                   ,[Arquivo]
                   ,[DataArquivo] 
				   ,[DataEndosso]
				   ,[VendaNova]  
              )
          VALUES (   
                     [IDProposta]
                 , X.[NumeroEndosso]
                 , X.[NumeroParcela]
                 , X.[NumeroTitulo]
                 , X.[IDTipoMovimento]
                 , X.[IDMotivo] 
                 , X.[Valor]
                 , X.[ValorPremioLiquido]
                 , X.[ValorIOF]
                 , X.[ValorPremioVG]
                 , X.[ValorPremioAP]
                 , X.[ValorTarifa]
                 , X.[ValorBalcao]
                 , x.[DataEfetivacao]
                 , X.[SinalLancamento]
                 , X.[TipoDado]
                 , X.[Arquivo]
                 , X.[DataArquivo]
				 , X.[DataEndosso]
				 , X.[VendaNova]
                 );  



--SELECT * FROM MovimentoFinanceiro_SSD_TEMP WHERE [NUM_BIL_CERTIF] = 95450749483
--SELECT * FROM Dados.Proposta WHERE NumeroProposta = '082941460001193'
--SELECT * FROM MovimentoFinanceiro_SSD_TEMP
--SELECT * FROM Dados.Pagamento WHERE Arquivo like 'SSD%'
--Dados.Pagamento
    -----------------------------------------------------------------------------------------------------------------------

    		                   
/*****************************************************************************************/
/*Atualização do Ponto de Parada, igualando-o ao Maior Código Trabalhado no comando acima*/
/*****************************************************************************************/
SET @PontoDeParada = '1900-01-01;' + Cast(@MaiorCodigo as varchar(20))
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @PontoDeParada
WHERE NomeEntidade = 'MovimentoFinanceiro_SSD'

TRUNCATE TABLE [dbo].MovimentoFinanceiro_SSD_TEMP

    
/*Recuperação do Maior Código do Retorno*/

SET @COMANDO = 'INSERT INTO [dbo].[MovimentoFinanceiro_SSD_TEMP] 
				(  
                   [SUK_ENDOSSO_FINANCEIRO]          ,
                   [NUM_ENDOSSO]                     ,
                   [DTH_EMISSAO_ENDOSSO]             ,
                   [COD_TIPO_ENDOSSO]                ,
                   [COD_TIPO_MOVIMENTO_EF]           ,
                   [COD_RAMO_EMISSOR_EF]             ,
                   [DTH_INI_VIGENCIA_EF]             ,
                   [DTH_FIM_VIGENCIA_EF]             ,
                   [VLR_PREMIO_TARIFARIO_EF]         ,
                   [VLR_PREMIO_LIQUIDO_EF]           ,
                   [VLR_IOF_EF]                      ,
                   [VLR_PREMIO_BRUTO_EF]             ,
                   [DTH_OPERACAO_EF]                 ,
                   [COD_OPERACAO_EF]                 ,
                   [COD_SUBGRUPO_EF]                 ,
                   [COD_FILIAL]                      ,
                   [COD_MODALIDADE_EF]               ,
                   [DTH_ATUALIZACAO_MV]              ,
                   [VLR_PREMIO_BRUTO_MV]             ,
                   [VLR_PREMIO_LIQUIDO_MV]           ,
                   [VLR_IOF_MV]                      ,
                   [NUM_BIL_CERTIF]                  ,
                   /*  [NUM_BIL_CERTIF_PB]               ,*/
                   [NUM_PROPOSTA_SIVPF]              ,
                   [NUM_APOLICE]                     ,
                   [COD_SUBGRUPO]                    ,
                   [IND_ORIGEM_REGISTRO]             ,
                   [NUM_PARCELA]                     ,
                   [VLR_PREMIO_PARCELA]              ,
                   [VLR_PREMIO_LIQUIDO_PARCELA]      ,
                   [VLR_IOF_PARCELA]                 ,
                   [VLR_PREMIO_VG]                   ,
                   [VLR_PREMIO_AP]                   ,
                   [VLR_TARIFA]                      ,
                   [VLR_BALCAO]                      ,
                   [DTH_BAIXA_PARCELA]               ,
                   [NUM_TITULO]                      ,
                   [COD_TIPO_MOVIMENTO]              ,
                   [COD_ORIGEM_PAGAMENTO]            ,            
                   [COD_PRODUTO_SIAS] 
                
				)  
                SELECT 
                       [SUK_ENDOSSO_FINANCEIRO]          ,
                       [NUM_ENDOSSO]                     ,
                       [DTH_EMISSAO_ENDOSSO]             ,
                       [COD_TIPO_ENDOSSO]                ,
                       [COD_TIPO_MOVIMENTO_EF]           ,
                       [COD_RAMO_EMISSOR_EF]             ,
                       [DTH_INI_VIGENCIA_EF]             ,
                       [DTH_FIM_VIGENCIA_EF]             ,
                       [VLR_PREMIO_TARIFARIO_EF]         ,
                       [VLR_PREMIO_LIQUIDO_EF]           ,
                       [VLR_IOF_EF]                      ,
                       [VLR_PREMIO_BRUTO_EF]             ,
                       [DTH_OPERACAO_EF]                 ,
                       [COD_OPERACAO_EF]                 ,
                       [COD_SUBGRUPO_EF]                 ,
                       [COD_FILIAL]                      ,
                       [COD_MODALIDADE_EF]               ,
                       [DTH_ATUALIZACAO_MV]              ,
                       [VLR_PREMIO_BRUTO_MV]             ,
                       [VLR_PREMIO_LIQUIDO_MV]           ,
                       [VLR_IOF_MV]                      ,
                       [NUM_BIL_CERTIF]                  ,
                     /*  [NUM_BIL_CERTIF_PB]               ,*/
                       [NUM_PROPOSTA_SIVPF]              ,
                       [NUM_APOLICE]                     ,
                       [COD_SUBGRUPO]                    ,
                       [IND_ORIGEM_REGISTRO]             ,
                       [NUM_PARCELA]                     ,
                       [VLR_PREMIO_PARCELA]              ,
                       [VLR_PREMIO_LIQUIDO_PARCELA]      ,
                       [VLR_IOF_PARCELA]                 ,
                       [VLR_PREMIO_VG]                   ,
                       [VLR_PREMIO_AP]                   ,
                       [VLR_TARIFA]                      ,
                       [VLR_BALCAO]                      ,
                       [DTH_BAIXA_PARCELA]               ,
                       [NUM_TITULO]                      ,
                       [COD_TIPO_MOVIMENTO]              ,
                       [COD_ORIGEM_PAGAMENTO]            ,
                       [COD_PRODUTO_SIAS]                               
                FROM OPENQUERY ([ANTARES], 
                ''EXEC [Corporativo].[SSD].[proc_RecuperaMovimentoFinanceiro] ''''' + @PontoDeParada + ''''''') PRP' --@PontoDeParada

EXEC (@COMANDO)   
--print '-----antes------'
--print @maiorcodigo

SELECT @MaiorCodigo = MAX(PRP.SUK_ENDOSSO_FINANCEIRO)
FROM [dbo].[MovimentoFinanceiro_SSD_TEMP] PRP

--print '-----depois------'
--print @maiorcodigo                      
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MovimentoFinanceiro_SSD_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[MovimentoFinanceiro_SSD_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH


