

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
CREATE PROCEDURE [Dados].[proc_InsereContratoFinanciamentoHabitacional_ODS]
AS

BEGIN TRY		
	    
DECLARE @PontoDeParada AS VARCHAR(400) 
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(max) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Financ_Habitacional_ODS_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Financ_Habitacional_ODS_TEMP];
	
--SSD.[NUM_PROPOSTA_TRATADO] [NumeroProposta], SSD.[ID_SEGURADORA] [IDSeguradora], SSD.[TIPO_DADO] [TipoDado], SSD.[DATA_ATUALIZACAO] [DataArquivo]
CREATE TABLE [dbo].[Financ_Habitacional_ODS_TEMP](
	[ID] [INT] NOT NULL,
	[NumeroContrato] [VARCHAR](12) NOT NULL,
	[CodigoUnidade] [SMALLINT] NOT NULL,
	[BitCCA] [BIT] NOT NULL,
	[CodigoProdutoGestaoProdutividade] [SMALLINT] NOT NULL,
	[DataContratacao] [DATE] NOT NULL,
	[ValorFinanciamento] [DECIMAL](18, 2) NOT NULL,
	[BitOutlier] [BIT] NOT NULL,
	[NomeUnidade] [VARCHAR](200) NULL,
	[CodigoSR] [VARCHAR](6) NOT NULL,
	[NomeSR] [VARCHAR](100) NOT NULL,
	[CodigoSUAT] [VARCHAR](6) NOT NULL,
	[NomeSUAT] [VARCHAR](100) NOT NULL,
	[CodigoCCA] [BIGINT] NULL,
	[CNPJCCA] [VARCHAR](20) NULL,
	[NomeCCA] [VARCHAR](100) NULL,
	[CPF] [VARCHAR](20) NOT NULL,
	[DataArquivo] [DATE] NOT NULL,
	[NomeArquivo] [VARCHAR](250) NOT NULL,
	[CPFTRATADO]  AS ((((((SUBSTRING([CPF],(1),(3))+'.')+SUBSTRING([CPF],(4),(3)))+'.')+SUBSTRING([CPF],(7),(3)))+'-')+SUBSTRING([CPF],(9),(2))) PERSISTED,
	[FlagLarMais] [BIT] NOT NULL CONSTRAINT [cnt_LarMais]  DEFAULT ((0))
) 



 /*Cria Índices*/  
CREATE CLUSTERED INDEX cl_idx_Financ_Habitacional_CPF_Contrato_TEMP ON [dbo].[Financ_Habitacional_ODS_TEMP] ([NumeroContrato] ASC,[CPFTRATADO] ASC,CodigoUnidade ASC)  

CREATE NONCLUSTERED INDEX idx_Financ_Habitacional_CPF_TEMP ON [dbo].[Financ_Habitacional_ODS_TEMP] ([CPFTRATADO] ASC)  

CREATE NONCLUSTERED INDEX idx_Financ_Habitacional_CPF_Contrato_TEMP ON [dbo].[Financ_Habitacional_ODS_TEMP] ([CPFTRATADO] ASC,[NumeroContrato] ASC)   include ([CodigoUnidade],DataArquivo)


CREATE NONCLUSTERED INDEX idx_Financ_Habitacional_Unidade_TEMP ON [dbo].[Financ_Habitacional_ODS_TEMP] ([CodigoUnidade] ASC)  

CREATE NONCLUSTERED INDEX idx_Financ_Habitacional_teste_TEMP ON [dbo].[Financ_Habitacional_ODS_TEMP] (CodigoProdutoGestaoProdutividade ASC)  

CREATE NONCLUSTERED INDEX [ncl_idx_CodigoProduto_Fin_Habitacional_TEMP]
ON [dbo].[Financ_Habitacional_ODS_TEMP] ([CodigoProdutoGestaoProdutividade])
INCLUDE ([NumeroContrato],[CodigoUnidade],[BitCCA],[DataContratacao],[ValorFinanciamento],[BitOutlier],[CodigoCCA],[CPF],[DataArquivo],[NomeArquivo],[CPFTRATADO],[FlagLarMais])

--drop index [ncl_idx_CodigoProduto_Fin_Habitacional_TEMP] on [dbo].[Financ_Habitacional_ODS_TEMP]
--drop index  cl_idx_Financ_Habitacional_CPF_Contrato_TEMP ON [dbo].[Financ_Habitacional_ODS_TEMP] 
/*********************************************************************************************************************/               
/*Recupera ponto de parada*/
/*********************************************************************************************************************/

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada  
WHERE NomeEntidade = 'FinanciamentoHabitacional' 



/*********************************************************************************************************************/               
/*Carrega tabela temporária*/
/*********************************************************************************************************************/
--declare @comando nvarchar(max)

SET @COMANDO = '
INSERT INTO [dbo].[Financ_Habitacional_ODS_TEMP]
				(	[ID]
				  ,[NumeroContrato]
				  ,[CodigoUnidade]
				  ,[BitCCA]
				  ,[CodigoProdutoGestaoProdutividade]
				  ,[DataContratacao]
				  ,[ValorFinanciamento]
				  ,[BitOutlier]
				  ,[NomeUnidade]
				  ,[CodigoSR]
				  ,[NomeSR]
				  ,[CodigoSUAT]
				  ,[NomeSUAT]
				  ,[CodigoCCA]
				  ,[CNPJCCA]
				  ,[NomeCCA]
				  ,[CPF]
				  ,[DataArquivo]
				  ,[NomeArquivo]
				  ,[CPFTRATADO]
				  ,[FlagLarMais]

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
--SELECT * FROM Dados.Correspondente where Matricula like '299979%'		

;MERGE INTO Dados.Correspondente as T
USING
(
SELECT DISTINCT CodigoCCA,NomeCCA,CNPJCCA,NomeArquivo,DataArquivo from Financ_Habitacional_ODS_TEMP t where CodigoCCA is not null

)
AS S
ON T.Matricula = S.CodigoCCA
WHEN NOT MATCHED THEN INSERT
(Matricula,Nome,CPFCNPJ,NomeArquivo,DataArquivo)
VALUES
(S.CodigoCCA,s.NomeCCA,s.CNPJCCA,S.NomeArquivo,S.DataArquivo);

/**********************************************************************
Inserção dos Dados - FinanciamentoHabitacional
select * from Dados.Proposta where TipoDado = 'D150105_ODONTO_SEG_PF_VLR_MENSAL.TXT'
select @@trancount
begin tran
select top 1 * from Dados.UnidadeHistorico
rollback
select DataEmissao from Dados.Proposta where  NumeroProposta = '294756'

***********************************************************************/ 
--select * from [Dados].[ContratoFinanciamentoHabitacional]
--begin tran
--select COUNT(DISTINCT nUMEROcoNTRATO) from Dados.[ContratoFinanciamentoHabitacional] where idtIPOFINANCIAMENTO <> 3
MERGE INTO [Dados].[ContratoFinanciamentoHabitacional] as t
	USING
	(	SELECT  x.*,u.ID As IDUnidade,uh.Nome,o.ID as IDTipoFinanciamento FROM (SELECT --top 5000		
			[NumeroContrato]
			,CodigoUnidade
			,[BitCCa]
			,[CodigoProdutoGestaoProdutividade]
			,[DataContratacao]
			,ValorFinanciamento
			,[BitOutlier]
			--,uh.Nome
			--,u.ID
			--,[NO_UNIDADE] as Agencia
			--,[CO_SR]
			--,[NO_SR]
			--,[CO_SUAT]
			----,[NO_SUAT]
			--,[CO_CCA] as [CodigoCCA]
			--,[NU_CNPJ_CCA]  as [CNPJCCA]
			--,[NO_CCA] as [NomeCCA]
			--,cleansingkit.dbo.fn_formataCPF([CPF]) as CPFCNPJ
			,t.[DataArquivo]
			,t.[NomeArquivo]
			,[CPFTRATADO] as CPFCNPJ
			,FlagLarMais as BitLarMais
			,c.ID as IDCorrespondente
			
			--,o.ID as IDTipoFinanciamento
			,ROW_NUMBER () OVER (PARTITION BY [NumeroContrato],CPFTRATADO ORDER BY [NumeroContrato],CPFTRATADO,CodigoUnidade ) as linha
		
	--	,ROW_NUMBER() OVER (PARTITION BY [CONT] ORDER BY DataArquivo DESC) as linha
	FROM dbo.Financ_Habitacional_ODS_TEMP t 
		
		left join Dados.Correspondente c on c.Matricula = t.[CodigoCCA]
		--left join Dados.Unidade u on u.Codigo = t.CodigoUnidade
		--left join Dados.UnidadeHistorico uh on uh.IDUnidade = u.ID and uh.LastValue = 1
		--where NumeroContrato = '144440588591'
		) as x 
		INNER JOIN [Dados].[TipoFinanciamentoHabitacional] o on o.Codigo = x.[CodigoProdutoGestaoProdutividade]
		left join Dados.Unidade u on u.Codigo = x.CodigoUnidade
		left join Dados.UnidadeHistorico uh on uh.IDUnidade = u.ID and uh.LastValue = 1
		
		
		where linha  = 1
		--order by NumeroContrato
		
		--CROSS APPLY (SELECT TOP 1 u.Codigo from Dados.UnidadeHistorico uh 
		--INNER JOIN Dados.Unidade u on uh.IDUnidade = u.ID and  uh.Nome = t.[NO_UNIDADE] where  uh.Nome = t.[NO_UNIDADE] and uh.lastvalue = 1) teste
		--and  Valor is nulltruncate table Dados.FinanciamentoHabitacional
--		INNER JOIN Dados.Contrato c on c.NumeroContrato = t.NUMERO_PROPOSTA and c.IDSeguradora = 18
		--left join Dados.UnidadeHistorico uh on  uh.Nome = t.AGENCIA
		--left join Dados.Unidade u on u.ID = uh.IDUnidade
		
	--) X WHERE LINHA = 1 --and NumeroProposta = '294756'
		) as s
	
		on s.NumeroContrato = t.NumeroContrato and s.CPFCNPJ = t.CPFCNPJ
		WHEN NOT MATCHED THEN INSERT ([DataContratacao],IDUnidade,[NumeroContrato],IDTipoFinanciamento,[BitCCa],[BitOutlier]
										,IDCorrespondente,[DataArquivo],[NomeArquivo],ValorFinanciamento,BitLarMais,CPFCNPJ)
					Values(s.[DataContratacao],s.IDUnidade,s.[NumeroContrato],s.IDTipoFinanciamento,s.[BitCCa],s.[BitOutlier]
										,s.IDCorrespondente,s.[DataArquivo],s.[NomeArquivo],s.ValorFinanciamento,s.BitLarMais,s.CPFCNPJ);					

--select count(*),sum(ValorFinanciamento) from dados.ContratoFinanciamentoHabitacional  where DataContratacao >= '2016-01-01' and DataContratacao <= '2016-01-31'
--select count(*),sum(ValorFinanciamento) from Financ_Habitacional_ODS_TEMP where DataContratacao >= '2016-01-01' and DataContratacao <= '2016-01-31'


/**********************************************************************
Inserção dos Dados - FinanciamentoCliente
select * from Dados.Proposta where TipoDado = 'D150105_ODONTO_SEG_PF_VLR_MENSAL.TXT'
select @@trancount

begin tran
rollback

truncate table Dados.[ContratoFinanciamentoHabitacional]

Delete from Dados.FinanciamentoCliente where IDFInanciemtno
select   * from Dados.FinanciamentoHabitacional where ID In (271,721)
rollback
select DataEmissao from Dados.Proposta where  NumeroProposta = '294756'
***********************************************************************/ 

--MERGE INTO [Dados].[FinanciamentoCliente] as t
--	USING
--	(SELECT * FROM (SELECT [NU_CONTRATO],[CPFTRATADO] as CPF,f.ID as IDFinanciamento,t.NomeArquivo,t.DataArquivo
				  

--		,ROW_NUMBER() OVER (PARTITION BY [NU_CONTRATO],[CPFTRATADO]  ORDER BY t.DataArquivo DESC) as linha
--		FROM dbo.Financ_Habitacional_ODS_TEMP t
--		INNER JOIN Dados.FinanciamentoHabitacional f on f.NumeroContrato  = t.[NU_CONTRATO]
--	) X WHERE LINHA = 1 --and NumeroProposta = '294756'
--		) as s
	
--		on s.IDFinanciamento = t.IDFinanciamentoHabitacional and s.CPF = t.CPF
--		WHEN NOT MATCHED THEN INSERT ([CPF],[NomeArquivo],[DataArquivo],IDFinanciamentoHabitacional)
--					Values(s.[CPF],s.[NomeArquivo],s.[DataArquivo],IDFinanciamento);					

--rollback
--begin tran
--commit
select top 200 * from Dados.propostafinanceiro where NumeroContratoVinculado like '%144440541135%'
select * from Dados.[ContratoFinanciamentoHabitacional] where numerocontrato = 144440541135
--select @@TRANCOUNT
MERGE [Dados].[ContratoFinanciamentoHabitacional] as t 
using
(
select * from(	select fh.ID,fh.CPFCNPJ,ROW_NUMBER () OVER (PARTITION BY NumeroContrato,fh.[CPFCNPJ] ORDER BY fh.[NumeroContrato],CPFCNPJ DESC) as linha,x.* 
	from 
	(
		Select 
		 p.ID as IDProposta,substring(NumeroContratoVinculado,1,len(NumeroContratoVinculado)-1) NumeroContratovinculado
		 --p.ID as IDProposta,fh.NumeroContrato,fh.CPF,
		FROM [Corporativo].[Dados].[PropostaFinanceiro] pf
		inner join dados.Proposta p on p.id = pf.IDProposta
		
		--inner join Dados.FinanciamentoCliente fc on fh.ID = fc.[IDFinanciamentoHabitacional] --and fc.CPF = fh.CPF
		--inner join dbo.Financ_Habitacional_ODS_TEMP t on t.NU_CONTRATO = fh.NumeroContrato and t.[CPFTRATADO] = fc.CPF
		where p.NumeroProposta like 'HB%' --and fh.ID = 24320646 --and linha
		 --group by fh.ID having count(fh.ID) > 1
	) x 
	inner join dados.[ContratoFinanciamentoHabitacional] fh on  x.NumeroContratoVinculado = fh.NumeroContrato
	) z
	where linha = 1

) as S
on s.ID = t.ID and s.CPFCNPJ = t.CPFCNPJ
WHEN MATCHED THEN UPDATE SET t.IDProposta = s.IDProposta;
commit

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

