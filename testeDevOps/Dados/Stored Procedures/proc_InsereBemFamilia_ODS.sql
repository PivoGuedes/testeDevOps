

/*
	Autor: Pedro Guedes
	Data Criação: 10/02/2015

	Descrição: 
	
	Última alteração : r

*/

/*******************************************************************************
	Nome: [Corporativo].[Dados].[proc_InsereBemFamilia_ODS]
	
	Descrição: Procedimento que realiza a inserção das propostas Bem Família no ODS

	Parâmetros de entrada:
	
	Retorno:


*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereBemFamilia_ODS]
AS

BEGIN TRY		
	    
DECLARE @PontoDeParada AS VARCHAR(400) 
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(max) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BemFamilia_ODS_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[BemFamilia_ODS_Temp];
--SSD.[NUM_PROPOSTA_TRATADO] [NumeroProposta], SSD.[ID_SEGURADORA] [IDSeguradora], SSD.[TIPO_DADO] [TipoDado], SSD.[DATA_ATUALIZACAO] [DataArquivo]
CREATE TABLE [dbo].[BemFamilia_ODS_Temp]
(
	[ID] [int]  NOT NULL,
	[NU_PROPOSTA] [varchar] (255) NOT NULL,
	[NU_CERTIFICADO] [nvarchar](8) NOT NULL,
	[SITUACAO_CERTIFICADO] [nvarchar](20) NULL,
	[NM_CLIENTE] [nvarchar](255) NULL,
	[CPF] [nvarchar](255) NULL,
	[VLR_VENDA] [float] NULL,
	[PRODUTO] [nvarchar](255) NULL,
	[DT_EMISSAO] [date] NULL,
	[DT_INI_VIGENCIA] [date] NULL,
	[DT_FIM_VIGENCIA] [date] NULL,
	[DT_APROVACAO] [date]NULL,
	[DT_VENCIMENTO] [date] NULL,
	[DT_PAGAMENTO] [date] NULL,
	[FORMA_PAGAMENTO] [nvarchar](255) NULL,
	[AGENCIA] [nvarchar](255) NULL,
	[CODIGO_SR] [float] NULL,
	[MATRICULA_INDICADOR] [float] NULL,
	[NomeArquivo] [varchar](150) NULL,
	[DataArquivo] [date] NULL,
	CPFTRATADO AS SUBSTRING(CPF,1,3)+'.'+SUBSTRING(CPF,4,3)+'.'+SUBSTRING(CPF,7,3)+'.'+SUBSTRING(CPF,10,2) PERSISTED


) 



 /*Cria Índices*/  

CREATE NONCLUSTERED INDEX idx_ConsignadoCPFSegurado_TEMP ON [dbo].[BemFamilia_ODS_Temp] ([CPF] ASC)  


CREATE NONCLUSTERED INDEX idx_ConsignadoCPFTitular_TEMP ON [dbo].[BemFamilia_ODS_Temp] ([CPFTRATADO] ASC)  


/*********************************************************************************************************************/               
/*Recupera ponto de parada*/
/*********************************************************************************************************************/

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'BemFamilia'



/*********************************************************************************************************************/               
/*Carrega tabela temporária*/
/*********************************************************************************************************************/
--declare @comando nvarchar(max)

SET @COMANDO = '
INSERT INTO [dbo].[BemFamilia_ODS_Temp]
				(    [ID]
      ,[NU_PROPOSTA]
      ,[NU_CERTIFICADO]
      ,[SITUACAO_CERTIFICADO]
      ,[NM_CLIENTE]
      ,[CPF]
      ,[VLR_VENDA]
      ,[PRODUTO]
      ,[DT_EMISSAO]
      ,[DT_INI_VIGENCIA]
      ,[DT_FIM_VIGENCIA]
      ,[DT_APROVACAO]
      ,[DT_VENCIMENTO]
      ,[DT_PAGAMENTO]
      ,[FORMA_PAGAMENTO]
      ,[AGENCIA]
      ,[CODIGO_SR]
      ,[MATRICULA_INDICADOR]
      ,[NomeArquivo]
      ,[DataArquivo]
      --,[CPFTRATADO]

				)
				SELECT 
				[ID]
      ,[NU_PROPOSTA]
      ,[NU_CERTIFICADO]
      ,[SITUACAO_CERTIFICADO]
      ,[NM_CLIENTE]
      ,[CPF]
      ,[VLR_VENDA]
      ,[PRODUTO]
      ,[DT_EMISSAO]
      ,[DT_INI_VIGENCIA]
      ,[DT_FIM_VIGENCIA]
      ,[DT_APROVACAO]
      ,[DT_VENCIMENTO]
      ,[DT_PAGAMENTO]
      ,[FORMA_PAGAMENTO]
      ,[AGENCIA]
      ,[CODIGO_SR]
      ,[MATRICULA_INDICADOR]
      ,[NomeArquivo]
      ,[DataArquivo]
      --==,[CPFTRATADO]
	
	FROM OPENQUERY ([OBERON], ''EXEC [Desep].[dbo].[proc_RecuperaBemFamilia_ODS] ''''' + @PontoDeParada + ''''''') PRP '	
EXEC (@COMANDO)     

SELECT @MaiorCodigo = MAX(PRP.ID)
FROM [dbo].[BemFamilia_ODS_Temp] PRP

SET @COMANDO = ''     

WHILE @MaiorCodigo IS NOT NULL
BEGIN 




/**********************************************************************
Inserção dos Dados - Contrato

select @@trancount
select top 1 * from Dados.UnidadeHistorico
rollback
begin tran
SELECT * FROM dbo.BemFamilia_ODS_Temp
select DataEmissao from Dados.Proposta where  NumeroProposta = '294756'
***********************************************************************/ 






MERGE INTO [Dados].[Contrato] as t
	USING
	(SELECT * FROM (SELECT [NU_PROPOSTA] as NumeroContrato
      ,[NU_CERTIFICADO] as NumeroCertificado
      --,[SITUACAO_CERTIFICADO] as
      --,[NM_CLIENTE]
      --,[CPF]
      ,[VLR_VENDA] as ValorPremioLiquido
      ,[PRODUTO]
      ,[DT_EMISSAO] as DataEmissao
      ,[DT_INI_VIGENCIA] as DataInicioVigencia
      ,[DT_FIM_VIGENCIA] as DataFimVigencia
      ,[DT_APROVACAO] as DataAprovacao
      ,[DT_VENCIMENTO] as DataVencimento
      ,[DT_PAGAMENTO] as DataPagamento
      ,[FORMA_PAGAMENTO] as FormaPagamento
      ,[AGENCIA]
      --,[CODIGO_SR]
      --,[MATRICULA_INDICADOR]
      ,[NomeArquivo] as Arquivo
      ,t.[DataArquivo]
			,ROW_NUMBER() OVER (PARTITION BY [NU_PROPOSTA] ORDER BY DataArquivo DESC) as linha
		FROM dbo.BemFamilia_ODS_Temp t
--		INNER JOIN Dados.Contrato c on c.NumeroContrato = t.NUMERO_PROPOSTA and c.IDSeguradora = 18
		--left join Dados.UnidadeHistorico uh on  uh.Nome = t.AGENCIA
		--left join Dados.Unidade u on u.ID = uh.IDUnidade 
		
	) X WHERE LINHA = 1 --and NumeroProposta = '294756'
		) as s
	
		on s.NumeroContrato = t.NumeroContrato
		WHEN NOT MATCHED THEN INSERT (NumeroContrato,ValorPremioLiquido,DataArquivo,Arquivo,DataInicioVigencia,DataFimVigencia,IDSeguradora)
					Values(s.NumeroContrato,s.ValorPremioLiquido,s.DataArquivo,s.Arquivo,s.DataInicioVigencia,s.DataFimVigencia,1)
			WHEN MATCHED THEN UPDATE SET t.NumeroContrato = s.NumeroContrato,
										t.ValorPremioLiquido = s.ValorPremioLiquido,	
										t.DataArquivo = s.DataArquivo,	
										t.Arquivo = s.Arquivo,	
										t.DataInicioVigencia = s.DataInicioVigencia,	
										t.DataFimVigencia = s.DataFimVigencia	
									;




/**********************************************************************
Inserção dos Dados - Proposta

select * from Dados.Proposta where TipoDado = 'D150105_ODONTO_SEG_PF_VLR_MENSAL.TXT'
select @@trancount
select top 1 * from Dados.UnidadeHistorico
rollback
select DataEmissao from Dados.Proposta where  NumeroProposta = '294756'
***********************************************************************/ 

	MERGE INTO [Dados].[Proposta] as t
	USING 
	(SELECT * FROM (SELECT [NU_PROPOSTA] as NumeroProposta
        ,[NU_CERTIFICADO] as NumeroCertificado
      --,[SITUACAO_CERTIFICADO] as
      --,[NM_CLIENTE]
      --,[CPF]
        ,[VLR_VENDA] as Valor
        ,[PRODUTO]
        ,[DT_EMISSAO] as DataEmissao
        ,[DT_INI_VIGENCIA] as DataInicioVigencia
        ,[DT_FIM_VIGENCIA] as DataFimVigencia
      ,[DT_APROVACAO] as DataAprovacao
      ,[DT_VENCIMENTO] as DataVencimento
      ,[DT_PAGAMENTO] as DataPagamento
      ,[FORMA_PAGAMENTO] as FormaPagamento
      ,[AGENCIA]
        --,[CODIGO_SR]
        --,[MATRICULA_INDICADOR]
        ,[NomeArquivo] as TipoDado
        ,t.[DataArquivo]
	    ,c.ID as IDContrato
		,u.ID as IDAgenciaVenda
		,ROW_NUMBER() OVER (PARTITION BY [NU_PROPOSTA] ORDER BY t.DataArquivo DESC) as linha
		FROM dbo.BemFamilia_ODS_Temp t
		INNER  JOIN Dados.Contrato c on c.NumeroContrato = t.NU_PROPOSTA
		
		left join Dados.UnidadeHistorico uh on  uh.Nome = t.AGENCIA AND uh.LastValue = 1
		left join Dados.Unidade u on u.ID = uh.IDUnidade
		
	) X WHERE LINHA = 1 --and NumeroProposta = '294756'
		) as s
		on s.NumeroProposta = t.NumeroProposta WHEN NOT MATCHED THEN INSERT (NumeroProposta,Valor,DataArquivo,TipoDado,DataInicioVigencia,DataFimVigencia,DataEmissao,IDContrato,IDAgenciaVenda,IDProduto,IDSeguradora)
					Values(s.NumeroProposta,s.Valor,s.DataArquivo,s.TipoDado,s.DataInicioVigencia,s.DataFimVigencia,s.DataEmissao,s.IDContrato,s.IDAgenciaVenda,313,1)
			WHEN MATCHED THEN UPDATE SET t.NumeroProposta = s.NumeroProposta,
										t.Valor = s.Valor,	
										t.DataArquivo = s.DataArquivo,
										t.TipoDado= s.TipoDado,	
										t.DataInicioVigencia = s.DataInicioVigencia,	
										t.DataFimVigencia = s.DataFimVigencia;









/**********************************************************************
Inserção de dados - PropostaCertificado
***********************************************************************/ 

/**********************************************************************
Inserção dos Dados - Proposta

select * from Dados.Proposta where TipoDado = 'D150105_ODONTO_SEG_PF_VLR_MENSAL.TXT'
select @@trancount
select top 1 * from Dados.UnidadeHistorico
rollback
select DataEmissao from Dados.Proposta where  NumeroProposta = '294756'
***********************************************************************/ 

	--MERGE INTO [Dados].[PropostaPrevidencia] as t
	--USING 
	--(SELECT * FROM (SELECT [NU_PROPOSTA] as NumeroProposta
 --       --,[NU_CERTIFICADO] as NumeroCertificado
 --     --,[SITUACAO_CERTIFICADO] as
 --     --,[NM_CLIENTE]
 --     --,[CPF]
 --     --  ,[VLR_VENDA] as Valor
 --     --  ,[PRODUTO]
 --     --  ,[DT_EMISSAO] as DataEmissao
 --     --  ,[DT_INI_VIGENCIA] as DataInicioVigencia
 --     --  ,[DT_FIM_VIGENCIA] as DataFimVigencia
 --     --,[DT_APROVACAO] as DataAprovacao
 --     --,[DT_VENCIMENTO] as DataVencimento
 --     --,[DT_PAGAMENTO] as DataPagamento
 --     --,[FORMA_PAGAMENTO] as FormaPagamento
 --     --,[AGENCIA]
 --       --,[CODIGO_SR]
 --       --,[MATRICULA_INDICADOR]
 --       ,[NomeArquivo] as TipoDado
 --       ,t.[DataArquivo]
	--    ,p.ID as IDProposta
	--	,ROW_NUMBER() OVER (PARTITION BY [NU_PROPOSTA] ORDER BY t.DataArquivo DESC) as linha
	--	FROM dbo.BemFamilia_ODS_Temp t
	--	INNER JOIN Dados.Proposta p on p.NumeroProposta = t.NU_PROPOSTA
		
		
	--) X WHERE LINHA = 1 --and NumeroProposta = '294756'
	--	) as s
	--	on s.IDProposta = t.IDProposta
	--	WHEN NOT MATCHED THEN INSERT (IDProposta,DataArquivo,TipoDado)
	--			Values(s.IDProposta,s.DataArquivo,s.TipoDado);
			


/**********************************************************************
Atualiza IDProposta no Contrato
select @@trancount
***********************************************************************/ 

	MERGE INTO [Dados].[Contrato] as t
	USING
	(SELECT * FROM (SELECT c.ID as IDProposta
			,t.NU_PROPOSTA as NumeroProposta
			,ROW_NUMBER() OVER (PARTITION BY NU_PROPOSTA ORDER BY t.DataArquivo DESC) as linha
		FROM dbo.BemFamilia_ODS_Temp t
		INNER JOIN Dados.Proposta c on c.NumeroProposta = t.NU_PROPOSTA 
		) X WHERE LINHA = 1
		) as s
		on s.NumeroProposta = t.NumeroContrato 
		WHEN MATCHED THEN UPDATE SET t.IDProposta = s.IDProposta;





/**********************************************************************
Inserção dos Dados - PropostaCliente
select @@trancount
***********************************************************************/ 
MERGE INTO Dados.PropostaCliente as T USING
(
	SELECT  * FROM (SELECT 
		   p.ID as [IDProposta]
		   ,[NU_PROPOSTA] as NumeroProposta
		   ,[NM_CLIENTE] as Nome
		   ,[CPFTRATADO] as CPFCNPJ
		   ,[NomeArquivo] as TipoDado
		   ,O.[DataArquivo]
		 ,ROW_NUMBER() OVER (PARTITION BY [NU_PROPOSTA] ORDER BY o.DataArquivo DESC) as linha
FROM [dbo].[BemFamilia_ODS_Temp] O
INNER JOIN Dados.Proposta p on O.[NU_PROPOSTA] = p.NumeroProposta
--INNER JOIN Dados.Unidade u on O.NUMERO_AGENCIA = u.Codigo
	) x  where linha =1 
) as S on S.IDProposta = T.IDProposta
	WHEN NOT MATCHED THEN INSERT (IDProposta,CPFCNPJ,Nome,TipoPessoa,TipoDado,DataArquivo)
	VALUES(s.IDProposta,CPFCNPJ,Nome,'Pessoa Física',TipoDado,DataArquivo)
	WHEN MATCHED THEN UPDATE SET CPFCNPJ = COALESCE(S.CPFCNPJ,T.CPFCNPJ),
								 Nome  = 	COALESCE(S.Nome,T.Nome)									
																		;






/**********************************************************************
Inserção dos Dados - Certificado
select @@trancount
select top 20 * from Dados.Certificado 
select top 20 * from dbo.BemFamilia_ODS_TEMP
commit
select * from Dados.PropostaCLiente where IDProposta = 61324099
***********************************************************************/ 
MERGE INTO Dados.Certificado as T USING
(
	SELECT  * FROM (SELECT 
				p.ID as IDProposta		
			   ,p.IDSeguradora
			   ,[NU_CERTIFICADO] as NumeroCertificado
			   ,CPFTRATADO
			   ,O.NM_CLIENTE as NomeCliente
			   ,p.IDAgenciaVenda as IDAgencia
			   ,p.Valor
			   ,p.DataArquivo
			   ,p.TipoDado as Arquivo
			   ,O.MATRICULA_INDICADOR as MatriculaIndicador
				,ROW_NUMBER() OVER (PARTITION BY [NU_PROPOSTA] ORDER BY o.DataArquivo DESC) as linha
FROM [dbo].[BemFamilia_ODS_Temp] O
INNER JOIN Dados.Proposta p on O.[NU_PROPOSTA] = p.NumeroProposta and p.IDSeguradora = 1
--INNER JOIN Dados.Unidade u on O.NUMERO_AGENCIA = u.Codigo
	) x  where linha =1 
) as S on S.IDProposta = T.IDProposta
	WHEN NOT MATCHED THEN INSERT ([IDProposta],[NumeroCertificado],[IDSeguradora],[MatriculaIndicador],[ValorPremioBruto],[ValorPremioLiquido],[Arquivo],[DataArquivo])
	VALUES(s.IDProposta,s.NumeroCertificado,s.IDSeguradora,s.MatriculaIndicador,s.Valor,s.Valor,s.Arquivo,s.DataArquivo);




/**********************************************************************
Inserção dos Dados - PropostaoCertificado
select @@trancount
select * from Dados.PropostaCertificado where NumeroCertificado = '13090960'
commit
select * from Dados.PropostaCLiente where IDProposta = 61324099
***********************************************************************/ 
MERGE INTO Dados.PropostaCertificado as T USING
(
	SELECT  * FROM (SELECT 
				p.ID as IDProposta		
			   ,p.IDSeguradora
			   ,[NU_CERTIFICADO] as NumeroCertificado
				,ROW_NUMBER() OVER (PARTITION BY [NU_PROPOSTA] ORDER BY o.DataArquivo DESC) as linha
FROM [dbo].[BemFamilia_ODS_Temp] O
INNER JOIN Dados.Proposta p on O.[NU_PROPOSTA] = p.NumeroProposta and p.IDSeguradora = 1
--INNER JOIN Dados.Unidade u on O.NUMERO_AGENCIA = u.Codigo
	) x  where linha =1 
) as S on S.IDProposta = T.IDPropostaPagamento
	WHEN NOT MATCHED THEN INSERT ([IDPropostaPagamento],[NumeroCertificado],[IDSeguradora])
	VALUES(s.IDProposta,s.NumeroCertificado,s.IDSeguradora);



						



/*****************************************************************************************/
/*Atualização do Ponto de Parada, igualando-o ao Maior Código Trabalhado no comando acima*/
/*****************************************************************************************/

SET @PontoDeParada =  Cast(@MaiorCodigo as varchar(20))
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @PontoDeParada
WHERE NomeEntidade = 'BemFamilia'

TRUNCATE TABLE [dbo].[BemFamilia_ODS_Temp]

    
/*********************************************************************************************************************/               
/*Carrega tabela temporária*/
/*********************************************************************************************************************/
--declare @comando nvarchar(max)

SET @COMANDO = '
INSERT INTO [dbo].[BemFamilia_ODS_Temp]
				(    [ID]
      ,[NU_PROPOSTA]
      ,[NU_CERTIFICADO]
      ,[SITUACAO_CERTIFICADO]
      ,[NM_CLIENTE]
      ,[CPF]
      ,[VLR_VENDA]
      ,[PRODUTO]
      ,[DT_EMISSAO]
      ,[DT_INI_VIGENCIA]
      ,[DT_FIM_VIGENCIA]
      ,[DT_APROVACAO]
      ,[DT_VENCIMENTO]
      ,[DT_PAGAMENTO]
      ,[FORMA_PAGAMENTO]
      ,[AGENCIA]
      ,[CODIGO_SR]
      ,[MATRICULA_INDICADOR]
      ,[NomeArquivo]
      ,[DataArquivo]
      --,[CPFTRATADO]

				)
				SELECT 
					[ID]
					  ,[NU_PROPOSTA]
					  ,[NU_CERTIFICADO]
					  ,[SITUACAO_CERTIFICADO]
					  ,[NM_CLIENTE]
					  ,[CPF]
					  ,[VLR_VENDA]
					  ,[PRODUTO]
					  ,[DT_EMISSAO]
					  ,[DT_INI_VIGENCIA]
					  ,[DT_FIM_VIGENCIA]
					  ,[DT_APROVACAO]
					  ,[DT_VENCIMENTO]
					  ,[DT_PAGAMENTO]
					  ,[FORMA_PAGAMENTO]
					  ,[AGENCIA]
					  ,[CODIGO_SR]
					  ,[MATRICULA_INDICADOR]
					  ,[NomeArquivo]
					  ,[DataArquivo]
					  --,[CPFTRATADO]
	FROM OPENQUERY ([OBERON], ''EXEC [Desep].[dbo].[proc_RecuperaBemFamilia_ODS] ''''' + @PontoDeParada + ''''''') PRP '	
EXEC (@COMANDO)     

--print '-----antes------'
--print @maiorcodigo

SELECT @MaiorCodigo = MAX(PRP.ID)
FROM [dbo].[BemFamilia_ODS_Temp] PRP

--print '-----depois------'
--print @maiorcodigo                      
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BemFamilia_ODS_Temp]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[BemFamilia_ODS_Temp];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH
