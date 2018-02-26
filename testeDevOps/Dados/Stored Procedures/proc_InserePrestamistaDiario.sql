/*
Created by: Pedro Guedes
Date: 2016-01-31
*/

CREATE PROCEDURE [Dados].[proc_InserePrestamistaDiario]
AS
BEGIN TRY
DECLARE @PontoDeParada AS VARCHAR(400) 
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(max) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Prestamista_Diario_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Prestamista_Diario_TEMP];
--SSD.[NUM_PROPOSTA_TRATADO] [NumeroProposta], SSD.[ID_SEGURADORA] [IDSeguradora], SSD.[TIPO_DADO] [TipoDado], SSD.[DATA_ATUALIZACAO] [DataArquivo]
CREATE TABLE [dbo].[Prestamista_Diario_TEMP]
(
    [ID] bigint NOT NULL,
	[UF] VARCHAR(2) NULL,
    [CEP] VARCHAR(8) NULL,
    [DDD] VARCHAR(4) NULL,
    [MES_REFERENCIA_MOVIMENTO] VARCHAR(8) NULL,
	  --,[MES_REFERENCIA_MOVIMENTO]
      --,[MES_GERACAO_ARQUIVO]
	[MES_GERACAO_ARQUIVO] VARCHAR(8) NULL,
    [COD_PRODUTO] VARCHAR(4) NULL,
    [COD_TIPO_REPASSE] VARCHAR(1) NULL,
    [SUREG_CONCESSAO] VARCHAR(2) NOT NULL,
    [AGENCIA_CONCESSAO] VARCHAR(4) NOT NULL,
    [OPERACAO_APLICACAO] VARCHAR(4) NOT NULL,
    [NUM_CONTRATO] VARCHAR(18) NOT NULL,
    [NUM_DV_CONTRATO] VARCHAR(2) NOT NULL,
	[CONTRATO] VARCHAR(24),
    [COD_MODALIDADE_OPER] VARCHAR(4) NOT NULL,
    [COD_CANAL] VARCHAR(4) NULL,
    [NOME_CANAL] VARCHAR(15) NULL,
    [NOME_CLIENTE] VARCHAR(50) NULL,
      --,[DTA_CONCESSAO_CONTR]
	 [DTA_CONCESSAO_CONTR] DATE NOT NULL,
      --,[DTA_TERMINO_CONTR]
	  [DTA_TERMINO_CONTR] DATE NOT NULL,
      --,[VALOR_CONTRATO]
	  [VALOR_CONTRATO] DECIMAL(18,8) NOT NULL,
      --,[VALOR_SEGURO]
	  [VALOR_SEGURO] DECIMAL(18,8) NOT NULL,
      [TIPO_PESSOA] VARCHAR(1) NOT NULL,
      [NUM_CPF_CGC] VARCHAR(12) NOT NULL,
      --,[TAXA_APLICADA]
	  [TAXA_APLICADA] DECIMAL(5,2) NOT NULL,
      [COD_NAT_EMPRESA] VARCHAR(2) NOT NULL,
      [EST_CONTRATO_ORIGEM] VARCHAR(18) NOT NULL,
      [COD_NAT_PROFISSIONAL] VARCHAR(4) NOT NULL,
      [PRZ_VENC_CONTRATO] VARCHAR(3) NOT NULL,
      --,[DT_NASCIMENTO]
	  [DT_NASCIMENTO] DATE NOT NULL,
      [IDADE] VARCHAR(3) NULL,
      [SEXO] VARCHAR(1) NULL,
      [ESTADO_CIVIL] VARCHAR(2) NULL,
      [ENDERECO] VARCHAR(50) NULL,
      [COMPL_ENDERECO] VARCHAR(30) NULL,
      [CIDADE] VARCHAR(30) NULL,
      [TELEFONE] VARCHAR(9) NULL,
      [EMAIL] VARCHAR(35) NULL,
      [COD_MATRICULA] VARCHAR(7) NULL,
      [TIPO_CORRESPONDENTE] VARCHAR(2) NULL,
      [COD_CORRESPONDENTE] VARCHAR(8) NULL,
      [DV_CORRESPONDENTE] VARCHAR(1) NULL,
      [NomeArquivo] VARCHAR(50) NOT NULL,
      [DataArquivo] DATE NOT NULL
	
	)
 /*Cria Índices*/  

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Prestamista_Diario'


SET @COMANDO = '
INSERT INTO [dbo].[Prestamista_Diario_TEMP]
				(   [ID]
      ,[UF]
      ,[CEP]
      ,[DDD]
      ,[MES_REFERENCIA_MOVIMENTO]
      ,[MES_GERACAO_ARQUIVO]
      ,[COD_PRODUTO]
      ,[COD_TIPO_REPASSE]
      ,[SUREG_CONCESSAO]
      ,[AGENCIA_CONCESSAO]
      ,[OPERACAO_APLICACAO]
      ,[NUM_CONTRATO]
      ,[NUM_DV_CONTRATO]
      ,[CONTRATO]
      ,[COD_MODALIDADE_OPER]
      ,[COD_CANAL]
      ,[NOME_CANAL]
      ,[NOME_CLIENTE]
      ,[DTA_CONCESSAO_CONTR]
      ,[DTA_TERMINO_CONTR]
      ,[VALOR_CONTRATO]
      ,[VALOR_SEGURO]
      ,[TIPO_PESSOA]
      ,[NUM_CPF_CGC]
      ,[TAXA_APLICADA]
      ,[COD_NAT_EMPRESA]
      ,[EST_CONTRATO_ORIGEM]
      ,[COD_NAT_PROFISSIONAL]
      ,[PRZ_VENC_CONTRATO]
      ,[DT_NASCIMENTO]
      ,[IDADE]
      ,[SEXO]
      ,[ESTADO_CIVIL]
      ,[ENDERECO]
      ,[COMPL_ENDERECO]
      ,[CIDADE]
      ,[TELEFONE]
      ,[EMAIL]
      ,[COD_MATRICULA]
      ,[TIPO_CORRESPONDENTE]
      ,[COD_CORRESPONDENTE]
      ,[DV_CORRESPONDENTE]
      ,[NomeArquivo]
      ,[DataArquivo]
  

				)  
               SELECT 
					ID
				  ,[UF]
				  ,[CEP]
				  ,[DDD]
				  ,[MES_REFERENCIA_MOVIMENTO]
				  ,[MES_GERACAO_ARQUIVO]
				  ,[COD_PRODUTO]
				  ,[COD_TIPO_REPASSE]
				  ,[SUREG_CONCESSAO]
				  ,[AGENCIA_CONCESSAO]
				  ,[OPERACAO_APLICACAO]
				  ,[NUM_CONTRATO]
				  ,[NUM_DV_CONTRATO]
				  ,[CONTRATO]
				  ,[COD_MODALIDADE_OPER]
				  ,[COD_CANAL]
				  ,[NOME_CANAL]
				  ,[NOME_CLIENTE]
				  ,[DTA_CONCESSAO_CONTR]
				  ,[DTA_TERMINO_CONTR]
				  ,[VALOR_CONTRATO]
				  ,[VALOR_SEGURO]
				  ,[TIPO_PESSOA]
				  ,[NUM_CPF_CGC]
				  ,[TAXA_APLICADA]
				  ,[COD_NAT_EMPRESA]
				  ,[EST_CONTRATO_ORIGEM]
				  ,[COD_NAT_PROFISSIONAL]
				  ,[PRZ_VENC_CONTRATO]
				  ,[DT_NASCIMENTO]
				  ,[IDADE]
				  ,[SEXO]
				  ,[ESTADO_CIVIL]
				  ,[ENDERECO]
				  ,[COMPL_ENDERECO]
				  ,[CIDADE]
				  ,[TELEFONE]
				  ,[EMAIL]
				  ,[COD_MATRICULA]
				  ,[TIPO_CORRESPONDENTE]
				  ,[COD_CORRESPONDENTE]
				  ,[DV_CORRESPONDENTE]
				  ,[NomeArquivo]
				  ,[DataArquivo]
			                                             
               FROM OPENQUERY ([OBERON], ''EXEC [Desep].[dbo].[proc_RecuperaPrestamista] ''''' + @PontoDeParada + ''''''') PRP '	
EXEC (@COMANDO)     


	  
SELECT @MaiorCodigo = MAX(PRP.ID)
FROM [dbo].[Prestamista_Diario_TEMP] PRP

SET @COMANDO = ''     

WHILE @MaiorCodigo IS NOT NULL
BEGIN 


/*****************************************************************************************/
/*Atualização do Ponto de Parada, igualando-o ao Maior Código Trabalhado no comando acima*/
/*****************************************************************************************/
/*****************************************************************************************/
SET @PontoDeParada =  Cast(@MaiorCodigo as varchar(20))


---------insere contratos

MERGE INTO Dados.Contrato as T 
USING
(
	SELECT   [COD_PRODUTO]
			  ,[COD_TIPO_REPASSE]
			  ,[SUREG_CONCESSAO]
			  ,[AGENCIA_CONCESSAO]
			  ,[OPERACAO_APLICACAO]
			  ,[NUM_CONTRATO]
			  ,[NUM_DV_CONTRATO]
			  ,[CONTRATO] as NumeroContrato
			  ,[COD_MODALIDADE_OPER]
			  ,[COD_CANAL]
			  ,[NOME_CANAL]
			  ,[DTA_CONCESSAO_CONTR] as DataEmissao
			  ,[DTA_TERMINO_CONTR] as DataFimVigencia
			  ,[VALOR_CONTRATO]
			  ,[VALOR_SEGURO] as ValorPremioTotal
			  ,[PRZ_VENC_CONTRATO]
			  ,[NomeArquivo] as Arquivo
			  ,[DataArquivo]
	FROM [dbo].[Prestamista_Diario_TEMP] PRP
)
AS S on S.NumeroContrato = T.NumeroContrato
WHEN NOT MATCHED THEN INSERT (NumeroContrato,DataEmissao,DataFimVigencia,ValorPremioTotal,DataArquivo,Arquivo)
	VALUES (NumeroContrato,DataEmissao,DataFimVigencia,ValorPremioTotal,DataArquivo,Arquivo);


---------insere propostas
select top 1 * from Dados.Proposta
MERGE INTO Dados.Proposta as T 
USING
(
	SELECT [COD_PRODUTO]
			--,[COD_TIPO_REPASSE]
			--,[SUREG_CONCESSAO]
			--,[AGENCIA_CONCESSAO]
			--,[OPERACAO_APLICACAO]
			--,[NUM_CONTRATO]
			--,[NUM_DV_CONTRATO]
			,[CONTRATO] as NumeroProposta
			--,[COD_MODALIDADE_OPER]
			,[COD_CANAL]
			,[NOME_CANAL]
			--,[NOME_CLIENTE]
			,[DTA_CONCESSAO_CONTR] as DataInicioVigencia
			,[DTA_TERMINO_CONTR] as DataFimVigencia
			--,[VALOR_CONTRATO]
			,[VALOR_SEGURO] as Valor
			--,[TIPO_PESSOA]
			--,[NUM_CPF_CGC]
			--,[TAXA_APLICADA]
			--,[COD_NAT_EMPRESA]
			--,[EST_CONTRATO_ORIGEM]
			--,[COD_NAT_PROFISSIONAL]
			,[PRZ_VENC_CONTRATO]
			,[DT_NASCIMENTO]
			--,[IDADE]
			--,[SEXO]
			--,[ESTADO_CIVIL]
			--,[ENDERECO]
			--,[COMPL_ENDERECO]
			--,[CIDADE]
			--,[TELEFONE]
			--,[EMAIL]
			--,[COD_MATRICULA]
			--,[TIPO_CORRESPONDENTE]
			--,[COD_CORRESPONDENTE]
			--,[DV_CORRESPONDENTE]
			,[NomeArquivo] as TipoDado
			,[DataArquivo]
		FROM [dbo].[Prestamista_Diario_TEMP] PRP
)
AS S on S.NumeroProposta = T.NumeroProposta
WHEN NOT MATCHED THEN INSERT (NumeroProposta,DataEmissao,DataFimVigencia,ValorPremioTotal,DataArquivo,TipoDado)
	VALUES (NumeroProposta,DataInicioVigencia,DataFimVigencia,Valor,DataArquivo,TipoDado);

	

  
UPDATE ControleDados.PontoParada 
SET PontoParada = @PontoDeParada
WHERE NomeEntidade = 'Prestamista_Diario'


TRUNCATE TABLE [dbo].[Prestamista_Diario_TEMP]

    
/*Recuperação do Maior Código do Retorno*/
SET @COMANDO = '
INSERT INTO [dbo].[Prestamista_Diario_TEMP]
				(      [ID]    
					  ,[CONTRATO]
					  ,[CPF_CGC]
					  --,[NUM_CONTROLE_CPF]
					  --,[NUM_DEPENDENTE]
					  ,[DTA_LIBERACAO]
					  ,[VAL_CONTRATO]
					  --,[COD_SUREG]
					  ,[COD_AGENCIA]
					  ,[COD_TIPO_CONTRATO]
					  ,[COD_CANAL_CONCESSAO]
					  ,[COD_CONVENENTE]
					  ,[COD_CORRESPONDENTE]
					  ,[SEGURO]
					  ,[VAL_SEGURO]
					  --,[SITUACAO_CONTRATO]
					  --,[MATRICULA]
					  --,[NOME_FUNCIONARIO]
					  ,[DataArquivo]
					  ,[NomeArquivo]
					  ,[CPFTRATADO]
					  --,[CPFNOMASK]
				)  
                SELECT 
					   [ID]       
					  ,[CONTRATO]
					  ,[CPF_CGC]
					  --,[NUM_CONTROLE_CPF]
					  --,[NUM_DEPENDENTE]
					  ,[DTA_LIBERACAO]
					  ,[VAL_CONTRATO] /100 as VAL_CONTRATO
					  --,[COD_SUREG]
					  ,[COD_AGENCIA]
					  ,[COD_TIPO_CONTRATO]
					  ,[COD_CANAL_CONCESSAO]
					  ,[COD_CONVENENTE]
					  ,[COD_CORRESPONDENTE]
					  , case when [SEGURO] = ''FINANCIADO'' THEN 1 ELSE 0 END AS SEGURO
					  ,[VAL_SEGURO] /10 AS VAL_SEGURO
					  --,[SITUACAO_CONTRATO]
					  --,[MATRICULA]
					  --,[NOME_FUNCIONARIO]
					  ,[DataArquivo]
					  ,[NomeArquivo]
					  ,[CPFTRATADO]
					  --,[CPFNOMASK]
					                                             
               FROM OPENQUERY ([OBERON], ''EXEC [Desep].[dbo].[proc_RecuperaConsignado_ODS] ''''' + @PontoDeParada + ''''''') PRP '	
EXEC (@COMANDO)         

--print '-----antes------'
--print @maiorcodigo

SELECT @MaiorCodigo = MAX(PRP.ID)
FROM [dbo].[Prestamista_Diario_TEMP] PRP

--print '-----depois------'
--print @maiorcodigo                      
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Prestamista_Diario_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Prestamista_Diario_TEMP];				


END
END TRY	

BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH
