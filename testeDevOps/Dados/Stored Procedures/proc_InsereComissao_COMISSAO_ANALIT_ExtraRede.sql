/*
	Autor: Egler Vieira
	Data Criação: 03/03/2015

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereComissao_COMISSAO_ANALIT_ExtraRede
	Descrição: Procedimento que realiza a inserção dos lançamentos de comissão.
		
	Parâmetros de entrada:	
					
	Retorno:

OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
*/
CREATE PROCEDURE [Dados].[proc_InsereComissao_COMISSAO_ANALIT_ExtraRede](@DataComissao DATE = NULL) 
AS

BEGIN TRY

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CAExtraRede_TEMP]') AND type in (N'U'))
BEGIN
	DROP TABLE [dbo].[CAExtraRede_TEMP];
  
  --RAISERROR (N'A tabela temporária [CAExtraRede_TEMP] foi encontrada. Verifique se há um processo paralelo executando a função.',
  --            16, -- Severity.
  --            1 -- State.
  --          )
END
--DECLARE @DataComissao AS DATE = NULL--'2014-02-19'
DECLARE @PontoDeParada AS DATE  --= '2014-02-19'
DECLARE @COMANDO AS NVARCHAR(4000);
DECLARE @MaiorCodigo AS DATE;
DECLARE @ParmDefinition NVARCHAR(500);
                
/*Cria tabela temporária para carregar os dados que vem da base primária*/


CREATE TABLE [dbo].[CAExtraRede_TEMP]
(
	[ID] [bigint] NOT NULL,
	[TP_REG] [varchar](350) NULL,
	[DATA_REFERENCIA] [varchar](50) NULL,
	[DATA_MOVIMENTO] [varchar](50) NULL,
	[DATA_INI_REFER] [varchar](50) NULL,
	[DATA_FIM_REFER] [varchar](50) NULL,
	[CONTRATO_APOL] [varchar](50) NULL,
	[COD_PESSOA_CONTRTE] [varchar](50) NULL,
	[COD_PESSOA_SUBCONT] [varchar](50) NULL,
	[SEQ_OP_FATURA] [varchar](50) NULL,
	[NUM_APOLICE_SIAS] [varchar](50) NULL,
	[NUM_ENDOSSO_SIAS] [varchar](50) NULL,
	[NUM_RAMO_SIAS] [varchar](50) NULL,
	[COD_PRODUTO_SIAS] [varchar](5) NULL,
	[COD_COBERTURA_SIAS] [varchar](50) NULL,
	[NUM_CONTRATO_SEGUR] [varchar](50) NULL,
	[COD_COBERTURA] [varchar](50) NULL,
	[VLR_PREMIO_TARIF] [decimal](19, 2) NULL,
	[VLR_IOF] [decimal](19, 2) NULL,
	[SEQ_PREMIO] [varchar](50) NULL,
	[NUMERO_PARCELA] SMALLINT NULL,
	[PCT_COMISSAO] [decimal](10, 6) NULL,
	[VLR_COMISSAO] [decimal](25, 6) NULL,
	[COD_OPERACAO] [varchar](4) NULL,
	[NumeroProposta] [varchar](22) NULL,
	[NUM_RAMO_EMISSOR EF] [varchar](50) NULL,
	[DATA_REGISTRO_OPER] [date] NULL,
	[DATA_ASSIN_CONTRATO] [date] NULL,
	[QTD_MESES_CONTRATO] [smallint] NULL,
	[COD_UNID_OPER] [varchar](5) NULL,
	[COD_PESSOA] [varchar](50) NULL,
	[COD_PRODUTO_EF] [varchar](50) NULL,
	[DataArquivo] [datetime] NULL,
	[NomeArquivo] [varchar](100) NULL,
	IDEmpresa     smallint DEFAULT(3) NOT NULL,
	IDSeguradora    smallint DEFAULT(1) NOT NULL,
	IDProduto       INT NULL,
	IDProposta      INT NULL,
	IDUnidade       INT NULL
);

-- /*Cria alguns índices para facilitar a busca*/  
--CREATE CLUSTERED INDEX idx_CLProposta ON CAExtraRede_TEMP
--( 
--NumeroApolice,
--NumeroEndosso,
--CodigoProduto,
--CodigoOperacao
--);

--CREATE NONCLUSTERED INDEX idx_NCLFilialProposta ON CAExtraRede_TEMP
--(
--  CodigoFilialProposta
--);
CREATE NONCLUSTERED INDEX idx_NCL_CAExtraRede_TEMP_COD_PRODUTO_SIAS
ON [dbo].[CAExtraRede_TEMP] ([COD_PRODUTO_SIAS],[NUM_RAMO_SIAS])


CREATE NONCLUSTERED INDEX idx_NCL_CAExtraRede_TEMP_NUM_RAMO_SIAS
ON [dbo].[CAExtraRede_TEMP] ([NUM_RAMO_SIAS])
INCLUDE ([COD_PRODUTO_SIAS])


CREATE NONCLUSTERED INDEX idx_NCLCAExtraRede_TEMP_NUM_APOLICE_SIAS
ON [dbo].[CAExtraRede_TEMP] ([NUM_APOLICE_SIAS])
INCLUDE ([DataArquivo],[IDSeguradora])


CREATE NONCLUSTERED INDEX idx_NCL_CAExtraRede_TEMP_PontoVenda
ON [dbo].[CAExtraRede_TEMP] ([COD_UNID_OPER])


CREATE NONCLUSTERED INDEX idx_NCLProposta ON CAExtraRede_TEMP
(
  [NumeroProposta]
);

CREATE NONCLUSTERED INDEX idx_NCL_CAExtraRede_TEMP_COD_OPERACAO
ON [dbo].[CAExtraRede_TEMP] ([COD_OPERACAO])
                                                               

IF @DataComissao IS NULL
BEGIN
  SELECT @PontoDeParada = Cast(PontoParada as date)
  FROM ControleDados.PontoParada
  WHERE NomeEntidade = 'COMISSAO_ExtraRede';
  
  
  SET @ParmDefinition = N'@MaiorCodigo DATE OUTPUT';     

  SET @COMANDO = 'SELECT @MaiorCodigo= EM.MaiorData
                FROM OPENQUERY ([OBERON], 
                '' SELECT MAX(DataArquivo) [MaiorData]
                   FROM FENAE.dbo.COMISSAO_HABSEG
                   WHERE DataArquivo >= ''''' + Cast(@PontoDeParada as varchar(10)) + ''''''') EM';

                
  exec sp_executesql @COMANDO
                    ,@ParmDefinition
                    ,@MaiorCodigo = @MaiorCodigo OUTPUT;
END
ELSE
BEGIN
  SET @PontoDeParada = @DataComissao
  SET @MaiorCodigo = @DataComissao
END
PRINT @MaiorCodigo
                  
WHILE @PontoDeParada <= @MaiorCodigo /*'2012-12-31'*/
BEGIN 

--BEGIN TRAN
--DECLARE @PontoDeParada AS DATE 
--DECLARE @COMANDO AS NVARCHAR(4000);
--DECLARE @MaiorCodigo AS DATE;
--DECLARE @ParmDefinition NVARCHAR(500);

;SET @COMANDO =   
'INSERT INTO CAExtraRede_TEMP (	
							   [ID]
							  ,[TP_REG]
							  ,[DATA_REFERENCIA]
							  ,[DATA_MOVIMENTO]
							  ,[DATA_INI_REFER]
							  ,[DATA_FIM_REFER]
							  ,[CONTRATO_APOL]
							  ,[COD_PESSOA_CONTRTE]
							  ,[COD_PESSOA_SUBCONT]
							  ,[SEQ_OP_FATURA]
							  ,[NUM_APOLICE_SIAS]
							  ,[NUM_ENDOSSO_SIAS]
							  ,[NUM_RAMO_SIAS]
							  ,[COD_PRODUTO_SIAS]
							  ,[COD_COBERTURA_SIAS]
							  ,[NUM_CONTRATO_SEGUR]
							  ,[COD_COBERTURA]
							  ,[VLR_PREMIO_TARIF]
							  ,[VLR_IOF]
							  ,[SEQ_PREMIO]
							  ,[NUMERO_PARCELA]
							  ,[PCT_COMISSAO]
							  ,[VLR_COMISSAO]
							  ,[COD_OPERACAO]
							  ,NumeroProposta
							  ,[NUM_RAMO_EMISSOR EF]
							  ,[DATA_REGISTRO_OPER]
							  ,[DATA_ASSIN_CONTRATO]
							  ,[QTD_MESES_CONTRATO]
							  ,[COD_UNID_OPER]
							  ,[COD_PESSOA]
							  ,[COD_PRODUTO_EF]
							  ,[DataArquivo]
							  ,[NomeArquivo]
							 )
					SELECT 	
						 [ID]
						,[TP_REG]
						,[DATA_REFERENCIA]
						,[DATA_MOVIMENTO]
						,[DATA_INI_REFER]
						,[DATA_FIM_REFER]
						,[CONTRATO_APOL]
						,[COD_PESSOA_CONTRTE]
						,[COD_PESSOA_SUBCONT]
						,[SEQ_OP_FATURA]
						,[NUM_APOLICE_SIAS]
						,[NUM_ENDOSSO_SIAS]
						,[NUM_RAMO_SIAS]
						,[COD_PRODUTO_SIAS]
						,[COD_COBERTURA_SIAS]
						,[NUM_CONTRATO_SEGUR]
						,[COD_COBERTURA]
						,[VLR_PREMIO_TARIF]
						,[VLR_IOF]
						,[SEQ_PREMIO]
						,[NUMERO_PARCELA]
						,[PCT_COMISSAO]
						,[VLR_COMISSAO]
						,[COD_OPERACAO]
						,NumeroProposta
						,[NUM_RAMO_EMISSOR EF]
						,[DATA_REGISTRO_OPER]
						,[DATA_ASSIN_CONTRATO]
						,[QTD_MESES_CONTRATO]
						,[COD_UNID_OPER]
						,[COD_PESSOA]
						,[COD_PRODUTO_EF]
						,[DataArquivo]
						,[NomeArquivo]        
					FROM  OPENQUERY ([OBERON], ''EXEC [Fenae].[Corporativo].[proc_RecuperaComissaoExtraRede] ''''' + Cast(@PontoDeParada as varchar(20)) + ''''''') CAD'

;exec sp_executesql @COMANDO

print '1'

IF (SELECT COUNT(*) FROM CAExtraRede_TEMP) > 0
BEGIN
/**************************************/
/*Faz a compensação de arredondamento*/
/**************************************/
--DESNECESSARIO POIS NAO HA SUBVALOR A SER AGREGADO

/*******************************************************************************************************************************************************************************************************************************************/

--COMMIT TRAN
print '2'
--BEGIN TRAN
                  --,@ParmDefinition
                  --,@MaiorCodigo = @MaiorCodigo OUTPUT
    


--SELECT *
--FROM Dados.Proposta PRP
--WHERE PRP.NumeroProposta LIKE 'HB00672470042328_'


--SELECT count(*)
--FROM dados.proposta p
--where exists (select *
--             from CAExtraRede_TEMP c
--			 where P.NumeroProposta LIKE c.NumeroProposta)
--OPTION (MAXDOP 7)

	/*INSERE CONTRATOS NÃO LOCALIZADOS*/
	;MERGE INTO Dados.Contrato AS T
	USING	
	(
	SELECT DISTINCT
		   CAD.[IDSeguradora] /*Caixa Seguros*/               
		 , CAD.[NUM_APOLICE_SIAS] [NumeroContrato]
		 --, CAD.NumeroCertificado
		 , /*@PontoDeParada*/ [DataArquivo]
		 , 'COMI EXTRA REDE' [Arquivo]
	FROM CAExtraRede_TEMP CAD
	WHERE CAD.NUM_APOLICE_SIAS IS NOT NULL
	) X
	ON T.[NumeroContrato] = X.[NumeroContrato]
	AND T.[IDSeguradora] = X.[IDSeguradora]
	WHEN NOT MATCHED
			THEN INSERT ([NumeroContrato], [IDSeguradora], [Arquivo], [DataArquivo])
				 VALUES (X.[NumeroContrato], X.[IDSeguradora], X.[Arquivo], X.[DataArquivo]);   


/*INSERE PRODUTOS NÃO LOCALIZADOS*/	
;MERGE INTO Dados.Produto AS T
USING (
    SELECT DISTINCT
           CAD.COD_PRODUTO_SIAS CodigoProduto 
    FROM CAExtraRede_TEMP CAD
    WHERE CAD.COD_PRODUTO_SIAS IS NOT NULL
      ) AS X
ON  T.[CodigoComercializado] = Cast(X.CodigoProduto as varchar(5))
   WHEN NOT MATCHED  
	    THEN INSERT          
          (   
           CodigoComercializado
          )
      VALUES (   
              X.[CodigoProduto]);   

/*INSERE PRODUTOS NÃO LOCALIZADOS*/	
;MERGE INTO Dados.Produto AS T
USING (
    SELECT DISTINCT
          'H' + CAD.COD_PRODUTO_SIAS CodigoProduto 
    FROM CAExtraRede_TEMP CAD
    WHERE CAD.COD_PRODUTO_SIAS IS NOT NULL
      ) AS X
ON  T.[CodigoComercializado] = Cast(X.CodigoProduto as varchar(5))
   WHEN NOT MATCHED  
	    THEN INSERT          
          (   
           CodigoComercializado
          )
      VALUES (   
              X.[CodigoProduto]);

/*INSERE PVs NÃO LOCALIZADOS*/
;INSERT INTO Dados.Unidade(Codigo)
SELECT DISTINCT CAD.COD_UNID_OPER CodigoPontoVenda
FROM CAExtraRede_TEMP CAD
WHERE  CAD.COD_UNID_OPER IS NOT NULL 
  AND not exists (
                  SELECT     *
                  FROM         Dados.Unidade U
                  WHERE U.Codigo = CAD.COD_UNID_OPER)                  
                                                        

INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)
SELECT DISTINCT U.ID, 'UNIDADE COM DADOS INCOMPLETOS' [Unidade], -1 [CodigoNaFonte], 'COMI EXTRA REDE' [TipoDado], MAX(EM.DataArquivo) [DataArquivo], 'COMI EXTRA REDE' [Arquivo]
FROM CAExtraRede_TEMP EM
INNER JOIN Dados.Unidade U
ON EM.COD_UNID_OPER = U.Codigo
WHERE 
    not exists (
                SELECT     *
                FROM         Dados.UnidadeHistorico UH
                WHERE UH.IDUnidade = U.ID)    
GROUP BY U.ID 

print '3'                  
--begin tran
--select @@TRANCOUNT
--SELECT        *
--FROM            Dados.Proposta
--WHERE        (NumeroProposta LIKE 'HB00144440504449_')


	;WITH  T1
	AS (
			  --select count(*), [NumeroProposta]
			  --from
			  --(
					 SELECT  EM.NUM_APOLICE_SIAS [NumeroApolice], PRP.ID [IDProposta], PRP.NumeroProposta NumeroPropostaPRP, EM.[NumeroProposta] [NumeroPropostaEM], EM.[IDSeguradora], PRD.ID [IDProduto], prd.codigocomercializado, U.ID IDAgenciaVenda, [NomeArquivo], EM.[DataArquivo]
					 FROM CAExtraRede_TEMP EM
					INNER JOIN Dados.Produto PRD
					ON PRD.CodigoComercializado = EM.COD_PRODUTO_SIAS
					and prd.idseguradora = em.idseguradora
					LEFT JOIN Dados.Unidade U
					ON U.Codigo = EM.COD_UNID_OPER
					--WHERE EM.NumeroProposta IS NOT NULL
					LEFT JOIN Dados.Proposta PRP
					ON PRP.NumeroProposta like  EM.[NumeroProposta]
					AND  PRP.IDSeguradora = EM.IDSeguradora
					WHERE  EM.COD_PRODUTO_SIAS NOT IN (SELECT CodigoProdutoDfi   
													   FROM ConfiguracaoDados.ImportaHabitacionalExtratoFinanceiro IHEF) --Remove o reseguro para eliminar "DUPLICIDADE" existe uma apólice para o seguro e outra para o Reseguro. ex: Produto 1409
						--AND	EM.NumeroProposta like 'HB00144440504449_'	
		) 
	UPDATE CAExtraRede_TEMP SET IDProduto = T1.IDProduto, NumeroProposta = COALESCE(NumeroPropostaPRP, [NumeroPropostaEM]), IDUnidade = T1.IDAgenciaVenda, IDProposta = T1.IDProposta
	FROM CAExtraRede_TEMP C
	INNER JOIN T1
	ON C.[NumeroProposta] = T1.[NumeroPropostaEM]
	--OPTION (MAXDOP 9)



/*INSERE PROPOSTAS CLIENTE NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
;
/*INSERE PROPOSTAS NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
;MERGE INTO Dados.Proposta AS T
	      USING (
		  --select count(*), [NumeroProposta]
		  --from
		  --(
				SELECT DISTINCT CNT.ID [IDContrato], EM.[IDProposta], NumeroProposta, EM.[IDSeguradora], [IDProduto], IDUnidade, EM.QTD_MESES_CONTRATO, [DATA_ASSIN_CONTRATO] DataEmissao, [NomeArquivo], EM.[DataArquivo]
				FROM  CAExtraRede_TEMP EM
				LEFT JOIN Dados.Contrato CNT
				ON EM.NUM_APOLICE_SIAS = CNT.NumeroContrato
				WHERE  EM.COD_PRODUTO_SIAS NOT IN (SELECT CodigoProdutoDfi   
													FROM ConfiguracaoDados.ImportaHabitacionalExtratoFinanceiro IHEF)
			--		AND	EM.NumeroProposta like 'HB00144440504449_'				
			--) a
			--group by [NumeroProposta]
			--having count(*) > 1
              ) X
        ON T.ID = X.IDProposta
       WHEN NOT MATCHED
		          THEN INSERT (NumeroProposta,  [IDContrato],  [IDSeguradora],    IDAgenciaVenda,    IDProduto,   IDProdutoSIGPF, IDCanalVendaPAR, IDSituacaoProposta, IDTipoMotivo, QuantidadeParcelas, DataEmissao, TipoDado, DataArquivo)
		               VALUES (X.[NumeroProposta], X.IDContrato, X.[IDSeguradora],    COALESCE(X.IDUnidade, -1),  X.IDProduto,                0,              -1,                  0,           -1, X.QTD_MESES_CONTRATO, X.DataEmissao, 'COMI EXTRA REDE', X.DataArquivo)		               
	   WHEN MATCHED																																			         
	     THEN UPDATE
		 /*Atualiza o código do Produto & código do Produto Anterior com o código recebido no comissionamento
		   Egler - 23/09/2013*/
		       SET T.IDProduto = X.IDProduto,
			       T.IDContrato = X.IDContrato,  
				   T.QuantidadeParcelas = X.QTD_MESES_CONTRATO,
				   T.DataEmissao = X.DataEmissao,
				   T.IDProdutoAnterior = CASE  WHEN NOT (T.IDProduto IS NULL OR T.IDProduto = -1) AND T.IDProduto <> X.IDProduto THEN T.IDProduto
											   ELSE CASE WHEN T.IDProdutoAnterior IS NULL THEN NULL
											             ELSE T.IDProdutoAnterior
												    END
										 END  
				              
		               
	/*INSERE PROPOSTAS CLIENTE NÃO LOCALIZADAS - POR NUMERO DE PROPOSTA*/
	;MERGE INTO Dados.PropostaCliente AS T
	      USING (SELECT DISTINCT PRP.ID [IDProposta], 'CLIENTE DESCONHECIDO - PROPOSTA NÃO RECEBIDA' [NomeCliente], 'COMI EXTRA REDE' [NomeArquivo], EM.[DataArquivo]
                 FROM CAExtraRede_TEMP EM
                 INNER JOIN Dados.Proposta PRP
				 ON PRP.NumeroProposta = EM.NumeroProposta
              ) X
        ON T.IDProposta = X.IDProposta
       WHEN NOT MATCHED
		          THEN INSERT (IDProposta, [TipoDado], [Nome], [DataArquivo])
		               VALUES (X.IDProposta, 'COMI EXTRA REDE', X.[NomeCliente], X.[DataArquivo]);
		               		               
		/*PRODUTOS DE VIDA COM CAPITAL GLOBAL EMPRESARIAL POSSUEM NÚMERO DE PROPOSTA DIFERENTE DO NÚMERO DO CERTIFICADO
		#REMOVIDO EM 06/11/2013 - EGLER
		#REINCLUÍDO EM 12/12/2013 após adaptar a solução para adicionando a condição da cláusula WHERE --### 2013-12-12:*/    

    -----------------------------------------------------------------------------------------------------------------------   
        
print '7'                  
               
/*INSERE AS OPERAÇÕES DE COMISSAO NÃO LOCALIZADAS*/	
;MERGE INTO Dados.ComissaoOperacao AS T
USING (
    SELECT DISTINCT
           CAD.[COD_OPERACAO] CodigoOperacao
    FROM CAExtraRede_TEMP CAD
    WHERE CAD.[COD_OPERACAO] IS NOT NULL
      ) AS X
ON  X.CodigoOperacao = T.[Codigo]
   WHEN NOT MATCHED  
	    THEN INSERT          
          (   
           Codigo
          )
      VALUES (   
              X.[CodigoOperacao]);
    
print '8'    
    
--/*INSERE OS PRODUTORES NÃO LOCALIZADOS*/	
--;MERGE INTO Dados.Produtor AS T
--USING (
--    SELECT DISTINCT
--           CAD.[CodigoProdutor] 
--    FROM CAExtraRede_TEMP CAD
--    WHERE CAD.[CodigoProdutor] IS NOT NULL
--      ) AS X
--ON  X.[CodigoProdutor] = T.[Codigo]
--   WHEN NOT MATCHED  
--	    THEN INSERT          
--          (   
--           Codigo
--          )
--      VALUES (   
--              X.[CodigoProdutor]);                     

print '9'

/*INSERE AS FILIAIS DE FATURAMENTO NÃO LOCALIZADAS*/
;MERGE INTO Dados.FilialFaturamento AS T
	USING (
      SELECT 10 [CodigoFilialProposta] 
        ) AS X
  ON  X.[CodigoFilialProposta] = T.[Codigo]
     WHEN NOT MATCHED  
		    THEN INSERT          
            (   
             Codigo
            )
        VALUES (   
                X.[CodigoFilialProposta]);  

print '10'

/*INSERE OS RAMOS DE FATURAMENTO NÃO LOCALIZADOS*/
;MERGE INTO Dados.Ramo AS T
	USING (
      SELECT DISTINCT
             RIGHT(CAD.[NUM_RAMO_SIAS],2) CodigoRamo 
      FROM CAExtraRede_TEMP CAD
      WHERE CAD.[NUM_RAMO_SIAS] IS NOT NULL
        ) AS X
  ON  X.CodigoRamo = T.[Codigo]
     WHEN NOT MATCHED  
		    THEN INSERT          
            (   
             Codigo
            )
        VALUES (   
                X.CodigoRamo);

print '11'

/*INSERE A COMBINAÇÃO DE PRODUTO COM RAMOS DE FATURAMENTO NÃO LOCALIZADOS*/
;MERGE INTO Dados.ProdutoRamo AS T
	USING (
      SELECT DISTINCT
             P.ID [IDProduto], R.ID [IDRamo]
      FROM CAExtraRede_TEMP CAD
      INNER JOIN Dados.Ramo R
      ON R.Codigo = RIGHT(CAD.[NUM_RAMO_SIAS],2)
      INNER JOIN Dados.Produto P
      ON P.CodigoComercializado = CAD.[COD_PRODUTO_SIAS]
      WHERE CAD.[NUM_RAMO_SIAS] IS NOT NULL
        ) AS X
  ON  X.IDProduto = T.IDProduto
  AND X.[IDRamo] = T.[IDRamo]
     WHEN NOT MATCHED  
		    THEN INSERT          
            (   
             IDProduto, IDRamo
            )
        VALUES (   
                X.[IDProduto], X.[IDRamo]);   
                 
print '12';            
     
--COMMIT TRAN;

--/*INSERE PRODUTOS NÃO LOCALIZADOS*/	
--;MERGE INTO Dados.Produto AS T
--USING (
--    SELECT DISTINCT
--           'H' + CAD.COD_PRODUTO_SIAS CodigoProduto 
--    FROM CAExtraRede_TEMP CAD
--    WHERE CAD.COD_PRODUTO_SIAS IS NOT NULL
--      ) AS X
--ON  T.[CodigoComercializado] = Cast(X.CodigoProduto as varchar(5))
--   WHEN NOT MATCHED  
--	    THEN INSERT          
--          (   
--           CodigoComercializado
--          )
--      VALUES (   
--              X.[CodigoProduto]);   

--BEGIN TRAN;

--DISABLE TRIGGER Dados_Comissao_ChangeTracking ON Dados.Comissao;
/*LIMPA OS DADOS DO MESMO PERÍODO (DIA)*/
DELETE C
FROM Dados.Comissao_Partitioned C
WHERE DataRecibo = Cast(@PontoDeParada as Date)
  AND C.LancamentoManual = 0
  AND C.IDEmpresa = 3 --PAR Corretora
  AND C.Arquivo = 'COMI EXTRA REDE';


print '13';	
--DECLARE @PontoDeParada DATE = '2015-01-27'
DECLARE @NumeroReciboGerado int

SELECT @NumeroReciboGerado = '-9' + RIGHT(LEFT(ISNULL(MIN(NumeroReciboGerado),Cast(YEAR(GETDATE()) as varchar(6))),6),4) +
							 right('0000' + 
							  Cast(((Cast(RIGHT(ISNULL(MIN(NumeroReciboGerado),'0000'),4)as int))  + 1) as varchar(4))
							 ,4)

FROM
(
SELECT MIN(ISNULL(NumeroReciboGerado, '-920140000')) NumeroReciboGerado
FROM [ControleDados].[ReciboComissaoExtraRede] R
WHERE LEFT(NumeroReciboGerado,6) = '-9' + Cast(YEAR(GETDATE()) as varchar(4))
UNION
SELECT '-9' + CAST(YEAR(GETDATE()) AS VARCHAR(4)) + '0000'
) A

print @NumeroReciboGerado

INSERT INTO [ControleDados].[ReciboComissaoExtraRede]
VALUES(@NumeroReciboGerado)



/*CARREGA A TABELA DE COMISSÃO*/    
INSERT INTO Dados.Comissao_Partitioned
(
IDRamo,
PercentualCorretagem,
ValorCorretagem,
ValorBase,
DataRecibo,
DataCompetencia,
ValorComissaoPAR,
ValorRepasse,
NumeroRecibo,
NumeroEndosso,
NumeroParcela,
DataCalculo,
DataQuitacaoParcela,
TipoCorretagem,
IDContrato,
IDOperacao,
IDProdutor,
IDFilialFaturamento,
IDProduto,                                               --SELECT Cast(8 * (6.8800 - 1.3800) / 6.88 as decimal(38,4)) [5.500],  Cast(8 * (1.38) / 6.88 as decimal(38,4)) [1.38]
IDUnidadeVenda,
IDProposta,
Arquivo,
DataArquivo,
IDEmpresa
)  
SELECT R.ID [IDRamo], CAD.PCT_COMISSAO, CAD.VLR_COMISSAO * CO.SinalOperacao [ValorCorretagem],
       CAD.[VLR_PREMIO_TARIF]/*ValorBase */* CO.SinalOperacao [ValorBase], CAD.[DATA_REGISTRO_OPER] DataRecibo, [DATA_MOVIMENTO] [DataCompetencia], --CAD.ValorBaseCERT, CAD.ValorPremioAP, CAD.ValorPremioVG, CAD.ValorBaseAgrupado,    /**/
       /*********************************************************************************************************************************************************/
       /*APLICAÇÃO DE REGRA DE 3 PARA DISTRIBUIR COMISSÃO E REPASSE*/ 
       /*********************************************************************************************************************************************************/
     
        ((CAD.VLR_COMISSAO * CO.SinalOperacao * /*MULTIPLICADO PELA COMISSAO DA PAR (PRIORITARIAMENTE) OU PELA TAXA DE CORRETAGEM (CS) MENOS A TAXA DE REPASSE*/
                                         CASE /*PEGA A TAXA DE CORRETAGEM, PRIORIZANDO O VALOR INSERIDO NA TABELA DE PRODUTO (HISTÓRICO ÚLTIMO STATUS)*/
                                             WHEN ISNULL(PH.PercentualCorretora,0.00) = 0.00  THEN (ISNULL(CAD.PCT_COMISSAO, 0.00) - ISNULL(PH.PercentualRepasse,0.00)) 
                                             ELSE PH.PercentualCorretora 
                                         END) 
                                         / /*DIVIDIRO POR -> PERCENTUAL DE CORRETAGEM*/
                   CASE WHEN ISNULL(CAD.PCT_COMISSAO, 0.00) = 0.00 AND ISNULL(PH.PercentualCorretora, 0.00) <> 0.00 THEN ISNULL(PH.PercentualCorretora,0.00) + ISNULL(PH.PercentualRepasse,0.00) 
                        WHEN ISNULL(CAD.PCT_COMISSAO, 0.00) = 0.00 AND (ISNULL(PH.PercentualCorretora, 0.00) = 0.00) THEN 1.00 
                        ELSE ISNULL(CAD.PCT_COMISSAO, 1.00) END) /*EVITA O ERRO DE DIVISÃO POR ZERO*/ [ValorComissaoPAR], 
       /*********************************************************************************************************************************************************/
       /*********************************************************************************************************************************************************/
       /*CALCULA O REPASSE*/
       /*********************************************************************************************************************************************************/
       ((CAD.VLR_COMISSAO * CO.SinalOperacao * PH.PercentualRepasse)
             / /*DIVIDIRO POR -> PERCENTUAL DE CORRETAGEM*/
              CASE WHEN ISNULL(CAD.PCT_COMISSAO, 0.00) = 0.00 AND ISNULL(PH.PercentualCorretora, 0.00) <> 0.00 THEN ISNULL(PH.PercentualCorretora,0.00) + ISNULL(PH.PercentualRepasse,0.00) 
              WHEN ISNULL(CAD.PCT_COMISSAO, 0.00) = 0.00 AND (ISNULL(PH.PercentualCorretora, 0.00) = 0.00) THEN 1.00 
              ELSE ISNULL(CAD.PCT_COMISSAO, 1.00) END) /*EVITA O ERRO DE DIVISÃO POR ZERO*/ [ValorRepasse],
       /*********************************************************************************************************************************************************/ 
       @NumeroReciboGerado NumeroRecibo, CAD.[NUM_ENDOSSO_SIAS] NumeroEndosso, CAD.NUMERO_PARCELA, CAD.[DATA_MOVIMENTO] DataCalculo, CAD.[DATA_MOVIMENTO] DataQuitacaoParcela,
       1 TipoCorretagem, CNT.ID [IDContrato],  CO.ID [IDOperacao],
       PTR.ID [IDProdutor], FF.ID [IDFilialFaturamento],
       PRD.ID [IDProduto], CAD.IDUnidade [IDUnidadeVenda], CAD.[IDProposta], 'COMI EXTRA REDE' [Arquivo],  CAD.DataArquivo,
	   IDEmpresa
       --CAD.NumeroPropostaTratado [NumeroProposta], CAD.NumeroCertificadoTratado [NumeroCertificado]
FROM CAExtraRede_TEMP [CAD]
INNER JOIN Dados.FilialFaturamento FF
ON FF.Codigo = '10' -- MATRIZ
INNER JOIN Dados.Produto PRD
ON PRD.CodigoComercializado = CAD.COD_PRODUTO_SIAS
INNER JOIN Dados.ComissaoOperacao CO
ON CO.ID = CASE WHEN CAD.NUMERO_PARCELA IN (1,2) THEN 254 /*AGENCIAMENTO - EXTRA REDE*/
	                                                ELSE 255 /*CORRETAGEM - EXTRA REDE*/ END
INNER JOIN Dados.Contrato CNT
ON CNT.NumeroContrato = CAD.NUM_APOLICE_SIAS
--AND CNT.IDSeguradora = 1 /*CaixaSeguros - ##TODO##*/
INNER JOIN Dados.Produtor PTR
ON PTR.id = -1 --PRODUTOR MANUAL - EXTRA REDE
/*Alterado no dia 01/10/2013 para pegar a última configuração de comissão com base na (datafim da configuração) X (DataCalculo comissão)*/
OUTER APPLY (SELECT TOP 1  PH.PercentualRepasse, PH.PercentualCorretora, PH.DataInicio, PH.DataFim 
             FROM Dados.ProdutoHistorico PH 
             WHERE PH.IDProduto = PRD.ID --AND PH.DataFim IS NULL
			 AND  CAD.[DATA_MOVIMENTO] <= ISNULL(PH.DataFim, '9999-12-31')
             ORDER BY PH.IDProduto ASC, PH.DataFim DESC) PH

LEFT JOIN Dados.Ramo R
ON R.Codigo = RIGHT(CAD.[NUM_RAMO_SIAS],2) 

--AND PRP.IDSeguradora = 1 ##TODO##
  ;
print '14';
 
/*CALCULA OS CANAIS DE VENDA DA DATA*/
   --BEGIN TRY     
	  -- /*CALCULA OS CANAIS DE VENDA DA DATA*/
	  -- EXEC Dados.proc_AtualizaCanalVendaPAR_Comissao @DataRecibo = @PontoDeParada, @ForcarAtualizacaoCompleta = 0;

   --END TRY
   --BEGIN CATCH
   --  PRINT @@ERROR
   --END CATCH

   --;ENABLE TRIGGER Dados_Comissao_ChangeTracking ON Dados.Comissao;

--COMMIT TRAN
print '15';       /*					   r
         DECLARE @PontoDeParada AS DATE  = '20130430'
DECLARE @COMANDO AS NVARCHAR(4000);  */
--BEGIN TRAN
--------DELETE FROM Dados.Recomissao 
--------WHERE DataArquivo = Cast(@PontoDeParada as Date)
--------AND IDEmpresa = 15;	--Riscos Especiais

--------print '16';
--------	-- DECLARE @COMANDO NVARCHAR(4000)
--------/*CARREGA A TABELA DE RECOMISSÃO*/
--------SET @COMANDO =   
--------'INSERT INTO Dados.Recomissao 
--------(IDProdutor,
-------- NumeroRecibo,
-------- --IDFilialFaturamento,
-------- ValorCorretagem,
-------- ValorAdiantamento,
-------- ValorRecuperacao,
-------- ValorISS,
-------- ValorIRF,
-------- ValorAIRE,
-------- ValorLiquido,
-------- NomeArquivo,
-------- DataArquivo,
-------- IDEmpresa
--------)
--------SELECT PTR.Id [IdProdutor],
--------       RF.NumeroRecibo,
--------       --FF.ID [IDFilialFaturamento],
--------	   RF.ValorCorretagem,
--------       RF.ValorAdiantamento,
--------	   RF.ValorRecuperacao,
--------       RF.ValorISS, 
--------	   RF.ValorIRF,
--------       RF.ValorAIRE, 
--------	   RF.ValorLiquido,
--------       RF.NomeArquivo,
--------	   RF.DataArquivo,
--------	   RF.[IDEmpresa] --15 PAR Riscos Especiais 
--------FROM
--------OPENQUERY ([OBERON], ''SELECT *, 15 [IDEmpresa]	  /*15 PAR Riscos Especiais*/
--------                      FROM FENAE.dbo.COMISSAO_GERAL_RE RF 
--------                      WHERE RF.DataArquivo = ''''' + Cast(@PontoDeParada as varchar(20)) + ''''''') RF 
--------INNER JOIN Dados.Produtor PTR
--------ON RF.CodigoProdutor =  PTR.Codigo
----------INNER JOIN Dados.FilialFaturamento FF
----------ON RF.CodigoFonte =  FF.Codigo
--------'

--------exec sp_executesql @COMANDO;		 

print '17';

END

  /*************************************************************************************/
  /*INSERE O DIA PARA CONTROLE DE EXPORTAÇÃO DE FATURAMENTO PARA A BASE INTERMEDIÁRIA */
  /*************************************************************************************/
  ;MERGE INTO ControleDados.ExportacaoFaturamento AS T
	  USING (
        SELECT DISTINCT [DATA_REGISTRO_OPER] DataRecibo, @NumeroReciboGerado NumeroRecibo, [DATA_REGISTRO_OPER] [DataCompetencia], IDEmpresa
        FROM dbo.CAExtraRede_TEMP [PontoDeParada]
          ) AS X
    ON  X.DataRecibo = T.DataRecibo
    AND X.NumeroRecibo = T.NumeroRecibo
    AND X.DataCompetencia = T.DataCompetencia
	AND X.IDEmpresa = T.IDEmpresa
       WHEN NOT MATCHED  
		      THEN INSERT          
              (   
               DataRecibo,
               NumeroRecibo,
               DataCompetencia,
			   IDEmpresa
              )
          VALUES (   
                  X.DataRecibo,
                  X.NumeroRecibo,
                  X.DataCompetencia,
				  X.IDEmpresa);  
  /*************************************************************************************/

  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = DATEADD(DD, 1, @PontoDeParada)
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @PontoDeParada
  WHERE NomeEntidade = 'COMISSAO_ExtraRede'
  /*************************************************************************************/
  
print '18'  


print '19'
  TRUNCATE TABLE [dbo].[CAExtraRede_TEMP];
   /*
  /*************************************************************************************/
  /*Atualiza o produto por meio do produto da proposta recebida pela COMISSÃO*/
  /*************************************************************************************/
  UPDATE Dados.Proposta SET IDProduto = C.IDProduto
  --SELECT *
  FROM Dados.Proposta PRP
  INNER JOIN
  (
  SELECT DISTINCT IDProposta, IDProduto
  FROM Dados.Comissao C
  WHERE C.DataArquivo = Cast(@PontoDeParada as Date)
  AND C.IDProduto IS NOT NULL
  AND C.IDProduto NOT IN (-1, 193) /*Produtos de controle interno*/
  )C
  ON C.IDProposta = PRP.ID
  AND (PRP.IDProduto IS NULL OR PRP.IDProduto <> C.IDProduto)
  /*************************************************************************************/
print '20'  	  */


 
  --COMMIT TRAN
print '23'  
END


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CAExtraRede_TEMP]') AND type in (N'U'))
	DROP TABLE [dbo].[CAExtraRede_TEMP];
	
print '24'	


END TRY
BEGIN CATCH
  --ENABLE TRIGGER Dados_Comissao_ChangeTracking ON Dados.Comissao;
   --ROLLBACK TRAN

  EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH

--EXEC [Dados].[proc_InsereComissao_COMISSAO_ANALIT_ExtraRede] @DataComissao = NULL 

