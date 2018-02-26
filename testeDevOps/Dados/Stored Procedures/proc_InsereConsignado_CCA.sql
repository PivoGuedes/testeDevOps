

/*
	Autor: Pedro Guedes
	Data Criação: 10/02/2015

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: [PortalDesep].dbo.[[proc_InsereConsignado_TMC]]
	Descrição: Procedimento que realiza a inserção dos acordos,contratos, propostas, assim como sua situação e clientes no banco de dados.
		
	Parâmetros de entrada:
	
truncate table Dados.ContratoConsignado
	Retorno:


*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereConsignado_CCA]
AS

BEGIN TRY		
	    
DECLARE @PontoDeParada AS VARCHAR(400) 
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(max) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Consignado_TMC_CCA_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].Consignado_TMC_CCA_TEMP;
--SSD.[NUM_PROPOSTA_TRATADO] [NumeroProposta], SSD.[ID_SEGURADORA] [IDSeguradora], SSD.[TIPO_DADO] [TipoDado], SSD.[DATA_ATUALIZACAO] [DataArquivo]
CREATE TABLE [dbo].Consignado_TMC_CCA_TEMP
(
    [ID] bigint NOT NULL,
	[CONTRATO] [varchar](20) NOT NULL,
	[CPF_CGC] [varchar](14) NOT NULL,
	--[NUM_CONTROLE_CPF] [varchar](4) NOT  NULL,
	--[NUM_DEPENDENTE] [varchar](3) not NULL,
	[DTA_LIBERACAO] [date] NOT NULL,
	[VAL_CONTRATO] DECIMAL(24,4)  NULL,
	[COD_SUREG] [varchar](4) NOT NULL,
	[COD_AGENCIA] [varchar](4) NOT NULL,
	[COD_TIPO_CONTRATO] smallint   NULL,
	[COD_CANAL_CONCESSAO] [varchar](2)   NULL,
	[COD_CONVENENTE] int   NULL,
	[COD_CORRESPONDENTE] int  NULL,
	[SEGURO] bit not NULL default 0,
	[VAL_SEGURO] DECIMAL(24,4)  NULL,
	[SITUACAO_CONTRATO] [varchar](10) NULL,
	[MATRICULA] [varchar](7) NULL,
	[NOME_FUNCIONARIO] [varchar](20) NULL,
	[DataArquivo] [date]  NULL,
	[NomeArquivo] [varchar](150)  NULL default '[DBM_MKT].[dbo].[CREDITO_CONSIGNADO_DTMART]',
	[CpfTratado]  [varchar](14) NOT NULL,
	[CONTRATO2] [varchar](60) NOT NULL,
	--[CPFNOMASK]  [varchar](14) NOT NULL,
	--PropostaLike as  '%' + SUBSTRING(CONTRATO,11,5)+'%'  PERSISTED,
	--PropostaCCALike as  '%' + SUBSTRING(CONTRATO,10,5)+'%'  PERSISTED,
	----PropostaLike2 as  '%' + SUBSTRING(CONTRATO,11,5)+'%'  PERSISTED,
	----PropostaCCALike2 as  '%' + SUBSTRING(CONTRATO,10,5)+'%'  PERSISTED,
) 



 /*Cria Índices*/  
CREATE CLUSTERED INDEX idx_ConsignadoID_TEMP ON [dbo].Consignado_TMC_CCA_TEMP ([ID] ASC)  

--CREATE NONCLUSTERED INDEX idx_ConsignadoCPF_TEMP ON [dbo].Consignado_TMC_CCA_TEMP ([CpfTratado] ASC)  

----CREATE NONCLUSTERED INDEX idx_Consignado_CPFNomask_TEMP ON [dbo].Consignado_TMC_CCA_TEMP ([CPFNOMASK] ASC)  


--CREATE NONCLUSTERED INDEX idx_Consignado_Data_TEMP ON [dbo].Consignado_TMC_CCA_TEMP ([CpfTratado] ASC)  
--INCLUDE (DTA_LIBERACAO);



--CREATE NONCLUSTERED INDEX idx_Consignado_DataArquivo_TEMP ON [dbo].Consignado_TMC_CCA_TEMP ([CPF_CGC],[DataArquivo] ASC)  

--CREATE NONCLUSTERED INDEX idx_Consignado_PropostaLike_ContratoCpfDataAgenciaValor_TEMP ON [dbo].Consignado_TMC_CCA_TEMP (Contrato,CpfTratado,DTA_LIBERACAO,COD_AGENCIA,VAL_CONTRATO)  


--CREATE NONCLUSTERED INDEX [NCL_idx_contrato]
--ON [dbo].Consignado_TMC_CCA_TEMP ([CONTRATO])
--INCLUDE ([DTA_LIBERACAO],[VAL_CONTRATO],[COD_AGENCIA],[VAL_SEGURO],[DataArquivo],[NomeArquivo])
/*********************************************************************************************************************/               
/*Recupera maior Código do retorno*/
/*********************************************************************************************************************/

--select top 1 * From ControleDados.PontoParada order by ID desc
--declare @COMANDO  varchar(MAX)
--DECLARE @PontoDeParada VARCHAR(MAX)
SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Consignado_TMC_CCA'


SET @COMANDO = '
INSERT INTO [dbo].Consignado_TMC_CCA_TEMP
				(      [ID]       
					  ,[CONTRATO]
					  ,[CPF_CGC]
					  --,[NUM_CONTROLE_CPF]
					  --,[NUM_DEPENDENTE]
					  ,[DTA_LIBERACAO]
					  ,VAL_CONTRATO
					  ,[COD_SUREG]
					  ,[COD_AGENCIA]
					  ,[COD_TIPO_CONTRATO]
					  ,[COD_CANAL_CONCESSAO]
					  ,[COD_CONVENENTE]
					  ,[COD_CORRESPONDENTE]
					  ,[SEGURO]
					  ,[VAL_SEGURO]
					  ,[SITUACAO_CONTRATO]
					  ,[MATRICULA]
					  ,[NOME_FUNCIONARIO]
					  ,[DataArquivo]
					  ,[NomeArquivo]
					  ,[CPFTRATADO]
					 -- ,[CPFNOMASK]
					 ,[CONTRATO2]


				)  
                SELECT 
					   [ID]       
					  ,[CONTRATO]
					  ,[CPF_CGC]
					  --,[NUM_CONTROLE_CPF]
					  --,[NUM_DEPENDENTE]
					  ,[DTA_LIBERACAO]
					  ,VAL_CONTRATO
					  ,[COD_SUREG]
					  ,[COD_AGENCIA]
					  ,ISNULL([COD_TIPO_CONTRATO],0) [COD_TIPO_CONTRATO]
					  ,[COD_CANAL_CONCESSAO]
					  ,[COD_CONVENENTE]
					  ,[COD_CORRESPONDENTE]
					  , case when [SEGURO] = ''FINANCIADO'' THEN 1 ELSE 0 END AS SEGURO
					  , VAL_SEGURO
					  ,[SITUACAO_CONTRATO]
					  ,[MATRICULA]
					  ,[NOME_FUNCIONARIO]
					  ,[DataArquivo]
					  ,[NomeArquivo]
					  ,[CPFTRATADO]
					--  ,[CPFNOMASK]
					,[CONTRATO2]
					                                             
               FROM OPENQUERY ([OBERON], ''EXEC [Fenae].[dbo].[proc_RecuperaConsignadoCCA] ''''' + @PontoDeParada + ''''''') PRP '	
EXEC (@COMANDO)     


	  
SELECT @MaiorCodigo = MAX(PRP.ID)
FROM [dbo].Consignado_TMC_CCA_TEMP PRP


SET @COMANDO = ''     

WHILE @MaiorCodigo IS NOT NULL
BEGIN 
DELETE FROM Dados.ContratoConsignado WHERE DataLiberacao BETWEEN CAST(GETDATE() - 60 AS DATE) and CAST(GETDATE() AS DATE)


/*--------------------------------------------------

--INSERE FAIXAS DE CREDITO NO ODS

*/---------------------------------------------------

MERGE INTO Dados.FaixaCredito as T
USING(SELECT DISTINCT (((cast([VAL_CONTRATO] as int) /5000)+1) * 5000)-5000 as ValorInicial,
((cast([VAL_CONTRATO] as int) /5000)+1) * 5000   as ValorFinal,
cast((((cast([VAL_CONTRATO] as int) /5000)+1) * 5000)-5000 as varchar(10)) + ' a ' +  cast(((cast([VAL_CONTRATO] as int) /5000)+1) * 5000 as varchar(10))   as Descricao
FROM dbo.Consignado_TMC_CCA_TEMP t
--ORDER BY ValorInicial
) AS S
ON S.ValorInicial = T.ValorInicial
AND S.ValorFinal = T.ValorFinal
WHEN NOT MATCHED THEN INSERT
(ValorInicial,ValorFinal,Descricao)
VALUES
(S.ValorInicial,S.ValorFinal,S.Descricao);

/*--------------------------------------------------

--INSERE CONTRATOS NO ODS

*/---------------------------------------------------
;INSERT INTO Dados.ContratoConsignadoCCA
(Contrato,ValorCredito,DataLiberacao,TipoDado,CPFCNPJ,CodigoTipoContrato,MatriculaFuncionario,CargoFuncionario,
CodigoCanalConcessao,CodigoCorrespondente,CodigoConvenente,FlagPrestamista,ValorPrestamista,Agencia,CodigoSR,SituacaoContrato,ContratoComposto,IDConvenente,IDFaixaCredito
)SELECT 
 [CONTRATO],[VAL_CONTRATO],[DTA_LIBERACAO],[NomeArquivo],[CpfTratado],[COD_TIPO_CONTRATO],[MATRICULA],[NOME_FUNCIONARIO]
		,[COD_CANAL_CONCESSAO],[COD_CORRESPONDENTE],[COD_CONVENENTE],[SEGURO],[VAL_SEGURO],[COD_AGENCIA],[COD_SUREG],[SITUACAO_CONTRATO],[CONTRATO2],cv.ID as IDconvenente,f.ID
		FROM dbo.Consignado_TMC_CCA_TEMP t
		inner join Dados.Convenente cv on cv.Codigo = t.COD_CONVENENTE
		inner join Dados.FaixaCredito f on t.VAL_CONTRATO between f.ValorInicial and f.ValorFinal
		--where Contrato ='010055110012885105'
	--alter table Dados.ContratoConsignadoCCA add IDFaixaCredito int not null constraint fk_IDFaixaCredito_FaixaCredito foreign key references Dados.FaixaCredito(ID)
	--select count(Contrato) from dbo.Consignado_TMC_CCA_TEMP group by Contrato having count(Contrato) > 1
	--	7007734	
	--	7978810
	----SELECT COUNT(Contrato),SUM(ValorCredito) FROM DAdos.ContratoConsignado WHERE MONTH(DataLiberacao) = 10 AND YEAR(DataLiberacao) = 2015			

/*****************************************************************************************/
/*Atualização do Ponto de Parada, igualando-o ao Maior Código Trabalhado no comando acima*/
/*****************************************************************************************/
/*****************************************************************************************/
SET @PontoDeParada =  Cast(@MaiorCodigo as varchar(20))
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @PontoDeParada
WHERE NomeEntidade = 'Consignado_TMC_CCA'

TRUNCATE TABLE [dbo].Consignado_TMC_CCA_TEMP

    
/*Recuperação do Maior Código do Retorno*/
SET @COMANDO = '
INSERT INTO [dbo].Consignado_TMC_CCA_TEMP
				(      [ID]    
					  ,[CONTRATO]
					  ,[CPF_CGC]
					  --,[NUM_CONTROLE_CPF]
					  --,[NUM_DEPENDENTE]
					  ,[DTA_LIBERACAO]
					  ,[VAL_CONTRATO]
					  ,[COD_SUREG]
					  ,[COD_AGENCIA]
					  ,[COD_TIPO_CONTRATO]
					  ,[COD_CANAL_CONCESSAO]
					  ,[COD_CONVENENTE]
					  ,[COD_CORRESPONDENTE]
					  ,[SEGURO]
					  ,[VAL_SEGURO]
					  ,[SITUACAO_CONTRATO]
					  ,[MATRICULA]
					  ,[NOME_FUNCIONARIO]
					  ,[DataArquivo]
					  ,[NomeArquivo]
					  ,[CPFTRATADO]
					  --,[CPFNOMASK]
					  ,[CONTRATO2]
				)  
                SELECT 
					   [ID]       
					  ,[CONTRATO]
					  ,[CPF_CGC]
					  --,[NUM_CONTROLE_CPF]
					  --,[NUM_DEPENDENTE]
					  ,[DTA_LIBERACAO]
					  , VAL_CONTRATO
					  ,[COD_SUREG]
					  ,[COD_AGENCIA]
					  ,ISNULL([COD_TIPO_CONTRATO],0) [COD_TIPO_CONTRATO]
					  ,[COD_CANAL_CONCESSAO]
					  ,[COD_CONVENENTE]
					  ,[COD_CORRESPONDENTE]
					  , case when [SEGURO] = ''FINANCIADO'' THEN 1 ELSE 0 END AS SEGURO
					  , VAL_SEGURO
					  ,[SITUACAO_CONTRATO]
					  ,[MATRICULA]
					  ,[NOME_FUNCIONARIO]
					  ,[DataArquivo]
					  ,[NomeArquivo]
					  ,[CPFTRATADO]
					  --,[CPFNOMASK]
					  ,[CONTRATO2]
					                                             
               FROM OPENQUERY ([OBERON], ''EXEC [Desep].[dbo].[proc_RecuperaConsignadoCCA] ''''' + @PontoDeParada + ''''''') PRP '	
EXEC (@COMANDO)         

--print '-----antes------'
--print @maiorcodigo

SELECT @MaiorCodigo = MAX(PRP.ID)
FROM [dbo].Consignado_TMC_CCA_TEMP PRP

--print '-----depois------'
--print @maiorcodigo                      
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].Consignado_TMC_CCA_TEMP') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].Consignado_TMC_CCA_TEMP;				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH
 