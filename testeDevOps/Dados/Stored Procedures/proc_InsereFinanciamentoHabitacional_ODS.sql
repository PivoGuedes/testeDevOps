

/*

	Habitacionalr: Pedro Guedes
	Data Criação: 11/07/2015

select * from Dados.FinanciamentoHabitacional	alter table Dados.FinanciamentoCliente alter column Cidade varchar(50) null
update ControleDados.PontoParada set PontoParada = '0' where ID = 91
truncate table Dados.FinanciamentoHabitacional	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: [Corporativo].[Dados].[proc_InsereFinanciamentoHabitacional_ODS]
	
	Descrição: Procedimento que realiza a inserção dos contratos de financiamento Habitacional no ODS

	Parâmetros de entrada:
	
	Retorno:
	select * from Dados.FinanciamentoHabitacional

*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereFinanciamentoHabitacional_ODS]
AS

BEGIN TRY		
	    
DECLARE @PontoDeParada AS VARCHAR(400) 
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(max) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Financ_Habitacional_ODS_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Financ_Habitacional_ODS_TEMP];
--SSD.[NUM_PROPOSTA_TRATADO] [NumeroProposta], SSD.[ID_SEGURADORA] [IDSeguradora], SSD.[TIPO_DADO] [TipoDado], SSD.[DATA_ATUALIZACAO] [DataArquivo]
CREATE TABLE [dbo].[Financ_Habitacional_ODS_TEMP]
(
	[ID] [int]  NOT NULL,
	[NU_CONTRATO] [varchar](12) NOT NULL,
	[CO_UNIDADE_OPERACIONAL] [varchar](200) NOT NULL,
	[IC_CCA] [BIT] not NULL,
	[CO_PRODUTO_GESTAO_PRODUTIVIDADE] [VARCHAR] (200) NULL,
	[DT_CONTRATACAO_ORIGINAL] [date] NOT NULL,
	[VR_FINANCIAMENTO]  decimal(18,2) NOT NULL,
	[IC_OUTLIER] [BIT] not NULL,
	[NO_UNIDADE] [varchar](200) NULL,
	[CO_SR] [varchar](200) not NULL,
	[NO_SR] [varchar](200) not NULL,
	[CO_SUAT] [varchar](200) not NULL,
	[NO_SUAT] [varchar](200) not NULL,
	[CO_CCA] [varchar](200)  NULL,
	[NU_CNPJ_CCA] [varchar](200) NULL,
	[NO_CCA] [varchar](200) NULL,
	[CPF] [varchar](200) NOT NULL,
	[DataArquivo] [date] NOT NULL,
	[NomeArquivo] [varchar](250) NOT NULL,
	[CPFTRATADO] AS SUBSTRING(CPF,1,3)+'.'+SUBSTRING(CPF,4,3)+'.'+SUBSTRING(CPF,7,3)+'-'+SUBSTRING(CPF,9,2) PERSISTED,
	FlagLarMais bit not null constraint cnt_LarMais default 0,
	[CO_UNIDADE_OPERACIONAL_iNT] AS CAST([CO_UNIDADE_OPERACIONAL] AS INT) PERSISTED
) 


 /*Cria Índices*/  

CREATE NONCLUSTERED INDEX idx_Financ_Habitacional_CPF_TEMP ON [dbo].[Financ_Habitacional_ODS_TEMP] ([CPFTRATADO] ASC)  

CREATE NONCLUSTERED INDEX idx_Financ_Habitacional_CPF_Contrato_TEMP ON [dbo].[Financ_Habitacional_ODS_TEMP] ([CPFTRATADO] ASC,[NU_CONTRATO] ASC)   include ([CO_UNIDADE_OPERACIONAL_iNT],DataArquivo)


CREATE NONCLUSTERED INDEX idx_Financ_Habitacional_Contrato_TEMP ON [dbo].[Financ_Habitacional_ODS_TEMP] ([NU_CONTRATO] ASC)  



/*********************************************************************************************************************/               
/*Recupera ponto de parada*/
/*********************************************************************************************************************/

SELECT @PontoDeParada = PontoParada
FROM  ControleDados.PontoParada
WHERE NomeEntidade = 'FinanciamentoHabitacional' 



/*********************************************************************************************************************/               
/*Carrega tabela temporária*/
/*********************************************************************************************************************/
--declare @comando nvarchar(max)

SET @COMANDO = '
INSERT INTO [dbo].[Financ_Habitacional_ODS_TEMP]
				(	[ID]
				  ,[NU_CONTRATO]
				  ,[CO_UNIDADE_OPERACIONAL]
				  ,[IC_CCA]
				  ,[CO_PRODUTO_GESTAO_PRODUTIVIDADE]
				  ,[DT_CONTRATACAO_ORIGINAL]
				  ,[VR_FINANCIAMENTO]
				  ,[IC_OUTLIER]
				  ,[NO_UNIDADE]
				  ,[CO_SR]
				  ,[NO_SR]
				  ,[CO_SUAT]
				  ,[NO_SUAT]
				  ,[CO_CCA] 
				  ,[NU_CNPJ_CCA]
				  ,[NO_CCA]
				  ,[CPF]
				  ,[DataArquivo]
				  ,[NomeArquivo]
				  ,FlagLarMais

				)
				SELECT 
				[ID]
				  ,[NU_CONTRATO]
				  ,[CO_UNIDADE_OPERACIONAL]
				  ,[IC_CCA]
				  ,[CO_PRODUTO_GESTAO_PRODUTIVIDADE]
				  ,[DT_CONTRATACAO_ORIGINAL]
				  ,[VR_FINANCIAMENTO]
				  ,[IC_OUTLIER]
				  ,[NO_UNIDADE]
				  ,[CO_SR]
				  ,[NO_SR]
				  ,[CO_SUAT]
				  ,[NO_SUAT]
				  ,[CO_CCA]
				  ,[NU_CNPJ_CCA]
				  ,[NO_CCA]
				  ,[NUM_CONTROLE_CPF]
				  ,[DataArquivo]
				  ,[NomeArquivo]
				  ,case when idApoliceSeguro is not null then 1 else 0 end as FlagLarMais
	
	FROM OPENQUERY ([OBERON], ''EXEC [Desep].[dbo].[proc_RecuperaImobiliario_ODS] ''''' + @PontoDeParada + ''''''') PRP '	
EXEC (@COMANDO)     

SELECT @MaiorCodigo = MAX(PRP.ID)
FROM [dbo].[Financ_Habitacional_ODS_TEMP] PRP

SET @COMANDO = ''     

WHILE @MaiorCodigo IS NOT NULL
BEGIN 




/**********************************************************************
Inserção dos Dados - FinanciamentoHabitacional
select * from Dados.Proposta where TipoDado = 'D150105_ODONTO_SEG_PF_VLR_MENSAL.TXT'
select @@trancount
begin tran
select top 1 * from Dados.UnidadeHistorico
rollback
select DataEmissao from Dados.Proposta where  NumeroProposta = '294756'

***********************************************************************/ 


--select * from Dados.FinanciamentoHabitacional where NumeroContrato = 144440427983
MERGE INTO [Dados].[FinanciamentoHabitacional] as t
	USING
	(	SELECT x.*,u.Codigo as CodigoAgencia FROM (SELECT 		
			[NU_CONTRATO] as [NumeroContrato]
			,[CO_UNIDADE_OPERACIONAL]
			,[IC_CCA] as [BitCCa]
			,[CO_PRODUTO_GESTAO_PRODUTIVIDADE] as [CodigoProdutoGestaoProdutividade]
			,[DT_CONTRATACAO_ORIGINAL] AS [DataContratacao]
			,[VR_FINANCIAMENTO] as Valor
			,[IC_OUTLIER] as [BitOutlier]
			,[NO_UNIDADE] as Agencia
			,[CO_SR]
			,[NO_SR]
			,[CO_SUAT]
			,[NO_SUAT]
			,[CO_CCA] as [CodigoCCA]
			,[NU_CNPJ_CCA]  as [CNPJCCA]
			,[NO_CCA] as [NomeCCA]
			,[CPF]
			,t.[DataArquivo]
			,[NomeArquivo]
			,[CPFTRATADO]
			,FlagLarMais
			
			
			,ROW_NUMBER () OVER (PARTITION BY NU_CONTRATO,[CPF] ORDER BY DataArquivo DESC) as linha
		
	--	,ROW_NUMBER() OVER (PARTITION BY [CONT] ORDER BY DataArquivo DESC) as linha
		FROM dbo.Financ_Habitacional_ODS_TEMP t) as x 
		--left join Dados.UnidadeHistorico uh on uh.Nome = x.Agencia and uh.LastValue = 1
		left join Dados.Unidade u on u.Codigo = x.[CO_UNIDADE_OPERACIONAL]
		
		where linha = 1
		
		--CROSS APPLY (SELECT TOP 1 u.Codigo from Dados.UnidadeHistorico uh 
		--INNER JOIN Dados.Unidade u on uh.IDUnidade = u.ID and  uh.Nome = t.[NO_UNIDADE] where  uh.Nome = t.[NO_UNIDADE] and uh.lastvalue = 1) teste
		--and  Valor is nulltruncate table Dados.FinanciamentoHabitacional
--		INNER JOIN Dados.Contrato c on c.NumeroContrato = t.NUMERO_PROPOSTA and c.IDSeguradora = 18
		--left join Dados.UnidadeHistorico uh on  uh.Nome = t.AGENCIA
		--left join Dados.Unidade u on u.ID = uh.IDUnidade
		
	--) X WHERE LINHA = 1 --and NumeroProposta = '294756'
		) as s
	
		on s.NumeroContrato = t.NumeroContrato and s.CPF = t.CPF
		WHEN NOT MATCHED THEN INSERT ([DataContratacao],[Agencia],[NumeroContrato],[CodigoProdutoGestaoProdutividade],[BitCCa],[BitOutlier]
										,[CodigoCCA],[NomeCCA],[CNPJCCA],[DataArquivo],[NomeArquivo],Valor,CodigoAgencia,FlagLarMais,CPF)
					Values(s.[DataContratacao],s.[Agencia],s.[NumeroContrato],s.[CodigoProdutoGestaoProdutividade],s.[BitCCa],s.[BitOutlier]
										,s.[CodigoCCA],s.[NomeCCA],s.[CNPJCCA],s.[DataArquivo],s.[NomeArquivo],s.Valor,s.CodigoAgencia,s.FlagLarMais,s.CPF);					




/**********************************************************************
Inserção dos Dados - FinanciamentoCliente
select * from Dados.Proposta where TipoDado = 'D150105_ODONTO_SEG_PF_VLR_MENSAL.TXT'
select @@trancount

begin tran

truncate table Dados.FinanciamentoHabitacional

Delete from Dados.FinanciamentoCliente where IDFInanciemtno
select   * from Dados.FinanciamentoHabitacional where ID In (271,721)
rollback
select DataEmissao from Dados.Proposta where  NumeroProposta = '294756'
***********************************************************************/ 

MERGE INTO [Dados].[FinanciamentoCliente] as t
	USING
	(SELECT * FROM (SELECT [NU_CONTRATO],[CPFTRATADO] as CPF,f.ID as IDFinanciamento,t.NomeArquivo,t.DataArquivo
				  

		,ROW_NUMBER() OVER (PARTITION BY [NU_CONTRATO],[CPFTRATADO]  ORDER BY t.DataArquivo DESC) as linha
		FROM dbo.Financ_Habitacional_ODS_TEMP t
		INNER JOIN Dados.FinanciamentoHabitacional f on f.NumeroContrato  = t.[NU_CONTRATO]
	) X WHERE LINHA = 1 --and NumeroProposta = '294756'
		) as s
	
		on s.IDFinanciamento = t.IDFinanciamentoHabitacional and s.CPF = t.CPF
		WHEN NOT MATCHED THEN INSERT ([CPF],[NomeArquivo],[DataArquivo],IDFinanciamentoHabitacional)
					Values(s.[CPF],s.[NomeArquivo],s.[DataArquivo],IDFinanciamento);					

--rollback
--begin tran
--commit
--select @@TRANCOUNT
MERGE [Dados].[FinanciamentoHabitacional] as t 
using
(
	select * 
	from 
	(
		Select distinct fh.ID,fh.CPF,p.ID as IDProposta,ROW_NUMBER () OVER (PARTITION BY NumeroContrato,fc.[CPF] ORDER BY fc.DataArquivo DESC) as linha
		 --p.ID as IDProposta,fh.NumeroContrato,fh.CPF,
		FROM [Corporativo].[Dados].[PropostaFinanceiro] pf
		inner join dados.Proposta p on p.id = pf.IDProposta
		inner join dados.FinanciamentoHabitacional fh on fh.NumeroContrato = pf.NumeroContratoVinculado
		inner join Dados.FinanciamentoCliente fc on fh.ID = fc.[IDFinanciamentoHabitacional] --and fc.CPF = fh.CPF
		--inner join dbo.Financ_Habitacional_ODS_TEMP t on t.NU_CONTRATO = fh.NumeroContrato and t.[CPFTRATADO] = fc.CPF
		where substring(p.NumeroProposta,1,2) = 'HB' --and fh.ID = 24320646 --and linha
		 --group by fh.ID having count(fh.ID) > 1
	) x where linha = 1

) as S
on s.ID = t.ID and s.CPF = t.CPF
WHEN MATCHED THEN UPDATE SET t.IDProposta = s.IDProposta;


/*****************************************************************************************/
/*Atualização do Ponto de Parada, igualando-o ao Maior Código Trabalhado no comando acima*/
/*****************************************************************************************/

SET @PontoDeParada =  Cast(@MaiorCodigo as varchar(20))
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @PontoDeParada
WHERE NomeEntidade = 'FinanciamentoHabitacional'



TRUNCATE TABLE [dbo].[Financ_Habitacional_ODS_TEMP]

    
/*********************************************************************************************************************/               
/*Carrega tabela temporária*/
/*********************************************************************************************************************/
--declare @comando nvarchar(max)

SET @COMANDO = '
INSERT INTO [dbo].[Financ_Habitacional_ODS_TEMP]
				(	[ID]
				  ,[NU_CONTRATO]
				  ,[CO_UNIDADE_OPERACIONAL]
				  ,[IC_CCA]
				  ,[CO_PRODUTO_GESTAO_PRODUTIVIDADE]
				  ,[DT_CONTRATACAO_ORIGINAL]
				  ,[VR_FINANCIAMENTO]
				  ,[IC_OUTLIER]
				  ,[NO_UNIDADE]
				  ,[CO_SR]
				  ,[NO_SR]
				  ,[CO_SUAT]
				  ,[NO_SUAT]
				  ,[CO_CCA] 
				  ,[NU_CNPJ_CCA]
				  ,[NO_CCA]
				  ,[CPF]
				  ,[DataArquivo]
				  ,[NomeArquivo]
				  ,FlagLarMais

				)
				SELECT 
				[ID]
				  ,[NU_CONTRATO]
				  ,[CO_UNIDADE_OPERACIONAL]
				  ,[IC_CCA]
				  ,[CO_PRODUTO_GESTAO_PRODUTIVIDADE]
				  ,[DT_CONTRATACAO_ORIGINAL]
				  ,[VR_FINANCIAMENTO]
				  ,[IC_OUTLIER]
				  ,[NO_UNIDADE]
				  ,[CO_SR]
				  ,[NO_SR]
				  ,[CO_SUAT]
				  ,[NO_SUAT]
				  ,[CO_CCA]
				  ,[NU_CNPJ_CCA]
				  ,[NO_CCA]
				  ,[NUM_CONTROLE_CPF]
				  ,[DataArquivo]
				  ,[NomeArquivo]
				  ,case when idApoliceSeguro is not null then 1 else 0 end as FlagLarMais
	
	FROM OPENQUERY ([OBERON], ''EXEC [Desep].[dbo].[proc_RecuperaImobiliario_ODS] ''''' + @PontoDeParada + ''''''') PRP '	
EXEC (@COMANDO)  


--print '-----antes------'
--print @maiorcodigo

SELECT @MaiorCodigo = MAX(PRP.ID)
FROM [dbo].[Financ_Habitacional_ODS_TEMP] PRP

--print '-----depois------'
--print @maiorcodigo                      
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Financ_Habitacional_ODS_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Financ_Habitacional_ODS_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH






--select ID,CPF
--	from 
--	(
--		Select DISTINCT fh.ID,fh.CPF,p.ID as IDProposta,ROW_NUMBER () OVER (PARTITION BY NumeroContrato,fc.[CPF] ORDER BY fc.DataArquivo DESC) as linha 
--		 --p.ID as IDProposta,fh.NumeroContrato,fh.CPF,
--		FROM [Corporativo].[Dados].[PropostaFinanceiro] pf
--		inner join dados.Proposta p on p.id = pf.IDProposta
--		inner join dados.FinanciamentoHabitacional fh on fh.NumeroContrato = substring(pf.NumeroContratoVinculado,1,12)
--		inner join Dados.FinanciamentoCliente fc on fh.ID = fc.[IDFinanciamentoHabitacional]-- and fc.CPF = fh.CPF
--		--inner join dbo.Financ_Habitacional_ODS_TEMP t on t.NU_CONTRATO = fh.NumeroContrato and t.[CPFTRATADO] = fc.CPF
--		where substring(p.NumeroProposta,1,2) = 'HB' and fh.ID = '24320850'	and fh.CPF = '22938263848'
--		 --group by fh.ID having count(fh.ID) > 1
--	) x where linha = 1 and ID = '24320850'	and CPF = '22938263848'
	
--	group by ID,CPF having count(*) > 1

	


--	select * from Dados.FinanciamentoHabitacional where IDProposta is not null