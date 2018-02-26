

/*
	Autor: Pedro Guedes
	Data Criação: 14/06/2015

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: [Corporativo].dbo.[proc_InsereContaCorrentev_ODS]
	Descrição: Procedimento que realiza a inserção das informãções de abertura de conta corrente no ODS.
		
	Parâmetros de entrada:
	
 			
	Retorno:


*******************************************************************************/
CREATE PROCEDURE [dbo].[proc_InsereContaCorrente_ODS]
AS

BEGIN TRY		
	    
DECLARE @PontoDeParada AS VARCHAR(400) 
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(max) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CONTACORRENTE_ODS_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[CONTACORRENTE_ODS_TEMP];

CREATE TABLE [dbo].[CONTACORRENTE_ODS_TEMP]
(
    [ID] [int] NOT NULL,
	[CodigoUnidade] [int] NOT NULL,
	[CodigoOperacao] [int] NOT NULL,
--	[IDCliente] [int] NULL,
	[NumeroConta] [varchar](50) NOT NULL,
	[DataAberturaConta] [date] NULL,
	[TipoDado] [varchar](100) NOT NULL,
	[DataArquivo] [date] NOT NULL,
	[DataNascimento] [date] NULL,
	[NomeCliente] [varchar](100) NOT NULL,
	[CPFCNPJ] [varchar](50) NOT NULL,

	FlagCCA [bit] not null
) 



 /*Cria Índices*/  
CREATE CLUSTERED INDEX idx_CONTACORRENTEID_TEMP ON [dbo].[CONTACORRENTE_ODS_TEMP] ([ID] ASC)  

--CREATE NONCLUSTERED INDEX idx_CONTACORRENTECPF_TEMP ON [dbo].[CONTACORRENTE_ODS_TEMP] ([CPFCNPJ] ASC)  

CREATE NONCLUSTERED INDEX idx_CONTACORRENTECPFCNPJ_TEMP ON [dbo].[CONTACORRENTE_ODS_TEMP] ([CPFCNPJ] ASC)  

CREATE NONCLUSTERED INDEX idx_CONTACORRENTE_Data_TEMP ON [dbo].[CONTACORRENTE_ODS_TEMP] ([CPFCNPJ] ASC)  
INCLUDE ([DataAberturaConta]);

CREATE NONCLUSTERED INDEX idx_CONTACORRENTE_DataArquivo_TEMP ON [dbo].[CONTACORRENTE_ODS_TEMP] ([CPFCNPJ],[DataAberturaConta] ASC)  



--DECLARE @COMANDO VARCHAR(MAX)
SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'ContaCorrente_ODS'

/*********************************************************************************************************************/               
/*Recupera maior Código do retorno*/ 
/*********************************************************************************************************************/
--declare @comando nvarchar(max)

SET @COMANDO = '
INSERT INTO [dbo].[CONTACORRENTE_ODS_TEMP]
				(      
					   [ID]
					  ,[CodigoUnidade]
					  ,[CodigoOperacao]
					  ,[NumeroConta]
					  ,[DataAberturaConta]
					  ,[DataNascimento]
					  ,[NomeCliente]
					  ,[CPFCNPJ]
					  ,[TipoDado]
					  ,[DataArquivo]
					  ,FlagCCA
				)  
                SELECT 
					  [ID]
					  ,[iCodigo_Unidade]
					  ,[iCodigo_Operacao]
					  ,left([iNumero_Conta],18) as iNumero_Conta
					  ,[dData_Abertura_da_Conta]
					  ,[dData_Nascimento]
					  ,left([vNome_Cliente],50) as vNome_Cliente
					  ,left(CPFCNPJ,18) as CPFCNPJ
					  ,left([NomeArquivo],50) as NomeArquivo
					  ,[DataArquivo]

					  ,FlagCCA
					                                             
               FROM OPENQUERY ([OBERON], ''EXEC [Desep].[dbo].[proc_RecuperaContaCorrente_ODS] ''''' + @PontoDeParada + ''''''') PRP '	
EXEC (@COMANDO)     

SELECT @MaiorCodigo = MAX(PRP.ID)
FROM [dbo].[CONTACORRENTE_ODS_TEMP] PRP

SET @COMANDO = ''     

WHILE @MaiorCodigo IS NOT NULL
BEGIN 




/**********************************************************************
select * From Dados.AberturaCC where NumeroConta  ='10001000227849'	
Inserção dos Dados - Abertura de contas

***********************************************************************/ 

;with Contas as (SELECT t.[ID]
					  ,[CodigoUnidade]
					  ,[CodigoOperacao]
					  ,[NumeroConta]
					  ,[DataAberturaConta]
					--  ,c.[ID] as IDCliente
					  --,[NomeCliente]
					 
					  ,t.[TipoDado]
					  ,t.[DataArquivo]
					  ,t.CPFCNPJ
					  ,FlagCCA
					  ,ROW_NUMBER() OVER (PARTITION BY [NumeroConta] order by [NumeroConta]) linha
		FROM  [dbo].[CONTACORRENTE_ODS_TEMP] t
	--	inner join Dados.ClienteCC c on c.CPFCNPJ = t.CPFCNPJ
	-- where NumeroConta = '10001000227849'
		--select count(distinct [iNumero_Conta]) from [dbo].[CONTACORRENTE_TEMP] t where FlagCCA = 1
		) 
	MERGE INTO [Dados].[AberturaCC] as t
	USING
		(SELECT [ID]
				  ,[CodigoUnidade]
				  ,[CodigoOperacao]
				  ,[NumeroConta]
				  ,[DataAberturaConta]
				--  ,[IDCliente]
				  --,[NomeCliente]
				  ,[CPFCNPJ]
				  ,[TipoDado]
				  ,[DataArquivo]
				  --,CPFCNPJ
				  ,FlagCCA
		FROM Contas
		where linha = 1 
		) as s
		on   s.NumeroConta = t.NumeroConta and s.CodigoOperacao = t.CodigoOperacao
		WHEN NOT MATCHED THEN INSERT ([CodigoUnidade] ,[CodigoOperacao] ,[NumeroConta]  ,[DataAberturaConta]  
					  ,[TipoDado] ,[DataArquivo] ,CCA )
							Values([CodigoUnidade] ,[CodigoOperacao] ,[NumeroConta]  ,[DataAberturaConta]  
					  ,[TipoDado] ,[DataArquivo]  ,s.FlagCCA);
						




/**********************************************************************

Inserção dos Dados - Clientes

***********************************************************************/ 

;with Clientes as (SELECT 
					  --,[CodigoUnidade]
					  --,[CodigoOperacao]
					  --,[NumeroConta]
					  --,[DataAberturaConta]
					 
					  [DataNascimento]
					  ,[NomeCliente]
					  ,[CPFCNPJ]
					  ,t.[TipoDado]
					  ,t.[DataArquivo]
					  ,ROW_NUMBER() OVER (PARTITION BY CPFCNPJ ORDER BY CPFCNPJ) AS LINHA
					  ,a.ID as [IDAberturaConta]
		FROM  [dbo].[CONTACORRENTE_ODS_TEMP] t
		INNER JOIN Dados.AberturaCC a on a.[NumeroConta] = t.NumeroConta and a.CodigoUnidade = t.CodigoUnidade and a.CodigoOperacao = t.CodigoOperacao
		--where CPFCNPJ = '000.350.472-75'
		--select count(distinct [iNumero_Conta]) from [dbo].[CONTACORRENTE_TEMP] t where FlagCCA = 1
		) 
	MERGE INTO [Dados].[ClienteCC] as t
	USING
		(SELECT 
				  [DataNascimento]
				  ,[NomeCliente]
				  ,[CPFCNPJ]
				  ,[TipoDado]
				  ,[DataArquivo]
				  ,[IDAberturaConta]
				  
		FROM Clientes
		WHERE LINHA = 1
		) as s
		on s.[CPFCNPJ] = t.[CpfCnpj] -- and s.DataArquivo > t.DataArquivo 
		WHEN NOT MATCHED THEN INSERT ([TipoDado]  ,[DataNascimento] ,[CPFCNPJ] 
					  ,[NomeCliente] ,[DataArquivo],[IDAberturaConta] )
							Values(s.[TipoDado] , s.[DataNascimento] ,s.[CPFCNPJ]
					  ,s.[NomeCliente] ,s.[DataArquivo] ,s.[IDAberturaConta] );
						

/*****************************************************************************************/
/*Atualização do Ponto de Parada, igualando-o ao Maior Código Trabalhado no comando acima*/
/*****************************************************************************************/
/*****************************************************************************************/
SET @PontoDeParada =  Cast(@MaiorCodigo as varchar(20))
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @PontoDeParada
WHERE NomeEntidade = 'ContaCorrente_ODS'


TRUNCATE TABLE [dbo].[CONTACORRENTE_ODS_TEMP]

    
/*Recuperação do Maior Código do Retorno*/
SET @COMANDO = '
INSERT INTO [dbo].[CONTACORRENTE_ODS_TEMP]
(      
					   [ID]
					  ,[CodigoUnidade]
					  ,[CodigoOperacao]
					  ,[NumeroConta]
					  ,[DataAberturaConta]
					  ,[DataNascimento]
					  ,[NomeCliente]
					  ,[CPFCNPJ]
					  ,[TipoDado]
					  ,[DataArquivo]
					  ,FlagCCA
				)  
                SELECT 
					  [ID]
					  ,[iCodigo_Unidade]
					  ,[iCodigo_Operacao]
					  ,left([iNumero_Conta],18) as iNumero_Conta
					  ,[dData_Abertura_da_Conta]
					  ,[dData_Nascimento]
					  ,left([vNome_Cliente],50) as vNome_Cliente
					  ,left(CPFCNPJ,18) as CPFCNPJ
					  ,left([NomeArquivo],50) as NomeArquivo
					  ,[DataArquivo]

					  ,FlagCCA
				               FROM OPENQUERY ([OBERON], ''EXEC [Desep].[dbo].[proc_RecuperaContaCorrente_ODS] ''''' + @PontoDeParada + ''''''') PRP '	
EXEC (@COMANDO)     
--print '-----antes------'
--print @maiorcodigo

SELECT @MaiorCodigo = MAX(PRP.ID)
FROM [dbo].[CONTACORRENTE_ODS_TEMP] PRP

--print '-----depois------'
--print @maiorcodigo                      
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CONTACORRENTE_ODS_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[CONTACORRENTE_ODS_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH
--select * 
--from dbo.DmTransacao dm where SukProduto <> -1
--inner join dbo.DmProduto p on p.SukProduto = dm.SukProduto
--where FlagTransacao = 0 and SukTipoProduto = 2
--SELECT * FROM dbo.Consignado_TEMP

--select * from dbo.DmTransacao where suktipoproduto = 4  and flagtransacao  = 0
--TRUNCATE TABLE dbo.DmTransacao


