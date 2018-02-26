

/*
	Autor: Pedro Guedes
	Data Criação: 11/07/2015

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: [Corporativo].[Dados].[proc_InsereFinanciamentoAuto_ODS]
	
	Descrição: Procedimento que realiza a inserção dos contratos de financiamento Auto no ODS

	Parâmetros de entrada:
	
	Retorno:


*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereFinanciamentoAuto_ODS]
AS

BEGIN TRY		
	    
DECLARE @PontoDeParada AS VARCHAR(400) 
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(max) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Financ_Auto_ODS_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Financ_Auto_ODS_TEMP];
--SSD.[NUM_PROPOSTA_TRATADO] [NumeroProposta], SSD.[ID_SEGURADORA] [IDSeguradora], SSD.[TIPO_DADO] [TipoDado], SSD.[DATA_ATUALIZACAO] [DataArquivo]
CREATE TABLE [dbo].[Financ_Auto_ODS_TEMP]
(
	[ID] [int]  NOT NULL,
		[DT_LIB] [date]  NULL,
	[AG] [varchar](4) NOT NULL,
	[CONT] [varchar](18) not NULL,
	[NOME] [varchar](50) NOT NULL,
	[CPF] [varchar](50) NOT NULL,
	[DT_NAS] [date] NOT NULL,
	[END] [varchar](150) NOT NULL,
	[COMPLEMENTO] [varchar](30) NULL,
	[CID] [varchar](25) NOT NULL,
	[UF] [varchar](50) NOT NULL,
	[CEP] [varchar](50) NOT NULL,
	[DDD] [varchar](10)  NULL,
	[FONE] [varchar](10) NULL,
	[SEXO] [CHAR](10) NOT NULL,
	[EST_CIVIL] [varchar](30) NOT NULL,
	[ANO_FABR] [varchar](10) NOT NULL,
	[ANO_MODE] [varchar](10) NOT NULL,
	[CHASSI] [varchar](20) NULL,
	[PZ_VENC] [INT] NOT NULL,
	[VL_CONTRATO ] DECIMAL(24,8) NULL,
	[NomeArquivo] [varchar](150) NOT NULL,
	[DataArquivo] [DATE] NOT NULL,
	[CPFTRATADO]  [varchar] (20) NOT NULL

) 



 /*Cria Índices*/  

CREATE NONCLUSTERED INDEX idx_Financ_Auto_CPF_TEMP ON [dbo].[Financ_Auto_ODS_TEMP] ([CPFTRATADO] ASC)  



/*********************************************************************************************************************/               
/*Recupera ponto de parada*/
/*********************************************************************************************************************/

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'FinanciamentoAuto'


/*********************************************************************************************************************/               
/*Carrega tabela temporária*/
/*********************************************************************************************************************/
--declare @comando nvarchar(max)

SET @COMANDO = '
INSERT INTO [dbo].[Financ_Auto_ODS_TEMP]
				(	[ID]
				  ,[DT_LIB]
				  ,[AG]
				  ,[CONT]
				  ,[NOME]
				  ,[CPF]
				  ,[DT_NAS]
				  ,[END]
				  ,[COMPLEMENTO]
				  ,[CID]
				  ,[UF]
				  ,[CEP]
				  ,[DDD]
				  ,[FONE]
				  ,[SEXO]
				  ,[EST_CIVIL]
				  ,[ANO_FABR]
				  ,[ANO_MODE]
				  ,[CHASSI]
				  ,[PZ_VENC]
				  ,[VL_CONTRATO ]
				  ,[NomeArquivo]
				  ,[DataArquivo]
				  ,[CPFTRATADO]

				)
				SELECT 
				[ID]
			  ,[DT_LIB]
			  ,[AG]
			  ,[CONT]
			  ,[NOME]
			  ,[CPF]
			  ,[DT_NAS]
			  ,[END]
			  ,[COMPLEMENTO]
			  ,[CID]
			  ,[UF]
			  ,[CEP]
			  ,[DDD]
			  ,[FONE]
			  ,[SEXO]
			  ,[EST_CIVIL]
			  ,[ANO_FABR]
			  ,[ANO_MODE]
			  ,[CHASSI]
			  ,[PZ_VENC]
			  ,[VL_CONTRATO ]
			  ,[NomeArquivo]
			  ,[DataArquivo]
			  ,[CPFTRATADO]
	
	FROM OPENQUERY ([OBERON], ''EXEC [Desep].[dbo].[proc_RecuperaFinanciamentoAuto_ODS] ''''' + @PontoDeParada + ''''''') PRP '	
EXEC (@COMANDO)     

SELECT @MaiorCodigo = MAX(PRP.ID)
FROM [dbo].[Financ_Auto_ODS_TEMP] PRP

SET @COMANDO = ''     

WHILE @MaiorCodigo IS NOT NULL
BEGIN 




/**********************************************************************
Inserção dos Dados - FinanciamentoAuto
select * from Dados.Proposta where TipoDado = 'D150105_ODONTO_SEG_PF_VLR_MENSAL.TXT'
select @@trancount
begin tran
select top 1 * from Dados.UnidadeHistorico
rollback
select DataEmissao from Dados.Proposta where  NumeroProposta = '294756'
***********************************************************************/ 



MERGE INTO [Dados].[FinanciamentoAuto] as t
	USING
	(SELECT * FROM (SELECT 		
					[DT_LIB] as [DataLiberacao]
				  ,[AG] as [Agencia]
				  ,[CONT] as NumeroContrato
				  --,[NOME]
				  --,[CPF]
				  --,[DT_NAS]
				  --,[END]
				  --,[COMPLEMENTO]
				  --,[CID]
				  --,[UF]
				  --,[CEP]
				  --,[DDD]
				  --,[FONE]
				  --,[SEXO]
				  --,[EST_CIVIL]
				  ,[ANO_FABR] as [AnoFabricacao]
				  ,[ANO_MODE] as [AnoModelo]
				  ,[CHASSI]
				  ,[PZ_VENC] as [PrazoVencimento]
				  ,[VL_CONTRATO ] as [Valor]
				  ,[NomeArquivo]
				  ,[DataArquivo]
				  ,[CPFTRATADO]

		,ROW_NUMBER() OVER (PARTITION BY [CONT] ORDER BY DataArquivo DESC) as linha
		FROM dbo.Financ_Auto_ODS_TEMP t
--		INNER JOIN Dados.Contrato c on c.NumeroContrato = t.NUMERO_PROPOSTA and c.IDSeguradora = 18
		--left join Dados.UnidadeHistorico uh on  uh.Nome = t.AGENCIA
		--left join Dados.Unidade u on u.ID = uh.IDUnidade
		
	) X WHERE LINHA = 1 --and NumeroProposta = '294756'
		) as s
	
		on s.NumeroContrato = t.NumeroContrato
		WHEN NOT MATCHED THEN INSERT ([DataLiberacao],[Agencia],[NumeroContrato],[AnoFabricacao],[AnoModelo],[Chassi]
									,[PrazoVencimento],[Valor],[NomeArquivo],[DataArquivo])
					Values(s.[DataLiberacao],s.[Agencia],s.[NumeroContrato],s.[AnoFabricacao],s.[AnoModelo],s.[Chassi]
									,s.[PrazoVencimento],s.[Valor],s.[NomeArquivo],s.[DataArquivo]);					




/**********************************************************************
Inserção dos Dados - FinanciamentoCliente
select * from Dados.Proposta where TipoDado = 'D150105_ODONTO_SEG_PF_VLR_MENSAL.TXT'
select @@trancount
begin tran
select   * from Dados.FinanciamentoAuto where ID In (271,721)
rollback
select DataEmissao from Dados.Proposta where  NumeroProposta = '294756'
***********************************************************************/ 

MERGE INTO [Dados].[FinanciamentoCliente] as t
	USING
	(SELECT * FROM (SELECT 		
					[DT_LIB] as [DataLiberacao]
				  ,[AG] as [Agencia]
				  ,[CONT] as NumeroContrato
				  ,[NOME]
				  --,[CPF]
				  ,[DT_NAS] as [DataNacimento]
				  ,[END] as [Endereco]
				  ,[COMPLEMENTO]
				  ,[CID] as [Cidade]
				  ,[UF]
				  ,[CEP]
				  ,[DDD]
				  ,[FONE] as [Telefone]
				  ,[SEXO]
				  ,[EST_CIVIL] as [EstadoCivil]
				  ,t.[NomeArquivo]
				  ,t.[DataArquivo]
				  ,[CPFTRATADO] as CPF
				  ,f.ID as [IDFinanciamento]

		,ROW_NUMBER() OVER (PARTITION BY [CONT] ORDER BY t.DataArquivo DESC) as linha
		FROM dbo.Financ_Auto_ODS_TEMP t
		INNER JOIN Dados.FinanciamentoAuto f on f.NumeroContrato  = t.CONT
	) X WHERE LINHA = 1 --and NumeroProposta = '294756'
		) as s
	
		on s.IDFinanciamento = t.IDFinanciamentoAuto
		WHEN NOT MATCHED THEN INSERT ([IDFinanciamentoAuto],[Nome],[CPF],[DataNacimento],[Endereco],[Complemento],[Cidade],[UF],[CEP]
									,[DDD],[Telefone],[Sexo],[EstadoCivil],[NomeArquivo],[DataArquivo])
					Values(s.[IDFinanciamento],s.[Nome],s.[CPF],s.[DataNacimento],s.[Endereco],s.[Complemento],s.[Cidade],s.[UF],s.[CEP]
									,s.[DDD],s.[Telefone],s.[Sexo],s.[EstadoCivil],s.[NomeArquivo],s.[DataArquivo]);					




/*****************************************************************************************/
/*Atualização do Ponto de Parada, igualando-o ao Maior Código Trabalhado no comando acima*/
/*****************************************************************************************/

SET @PontoDeParada =  Cast(@MaiorCodigo as varchar(20))
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @PontoDeParada
WHERE NomeEntidade = 'FinanciamentoAuto'

TRUNCATE TABLE [dbo].[Financ_Auto_ODS_TEMP]

    
/*********************************************************************************************************************/               
/*Carrega tabela temporária*/
/*********************************************************************************************************************/
--declare @comando nvarchar(max)

SET @COMANDO = '
INSERT INTO [dbo].[Financ_Auto_ODS_TEMP]
				(	[ID]
				  ,[DT_LIB]
				  ,[AG]
				  ,[CONT]
				  ,[NOME]
				  ,[CPF]
				  ,[DT_NAS]
				  ,[END]
				  ,[COMPLEMENTO]
				  ,[CID]
				  ,[UF]
				  ,[CEP]
				  ,[DDD]
				  ,[FONE]
				  ,[SEXO]
				  ,[EST_CIVIL]
				  ,[ANO_FABR]
				  ,[ANO_MODE]
				  ,[CHASSI]
				  ,[PZ_VENC]
				  ,[VL_CONTRATO ]
				  ,[NomeArquivo]
				  ,[DataArquivo]
				  ,[CPFTRATADO]


				)
				SELECT 
				[ID]
			  ,[DT_LIB]
			  ,[AG]
			  ,[CONT]
			  ,[NOME]
			  ,[CPF]
			  ,[DT_NAS]
			  ,[END]
			  ,[COMPLEMENTO]
			  ,[CID]
			  ,[UF]
			  ,[CEP]
			  ,[DDD]
			  ,[FONE]
			  ,[SEXO]
			  ,[EST_CIVIL]
			  ,[ANO_FABR]
			  ,[ANO_MODE]
			  ,[CHASSI]
			  ,[PZ_VENC]
			  ,[VL_CONTRATO ]
			  ,[NomeArquivo]
			  ,[DataArquivo]
			  ,[CPFTRATADO]
	
	FROM OPENQUERY ([OBERON], ''EXEC [Desep].[dbo].[proc_RecuperaFinanciamentoAuto_ODS] ''''' + @PontoDeParada + ''''''') PRP '	
EXEC (@COMANDO)     

--print '-----antes------'
--print @maiorcodigo

SELECT @MaiorCodigo = MAX(PRP.ID)
FROM [dbo].[Financ_Auto_ODS_TEMP] PRP

--print '-----depois------'
--print @maiorcodigo                      
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Financ_Auto_ODS_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Financ_Auto_ODS_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH
