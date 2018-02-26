-- =============================================
-- Author:		Sadrine Oliveira 
-- Create date: 29/05/2017
-- Procedimento para atualização do Painel Farol de Pagamentos
-- =============================================
CREATE PROCEDURE [Financeiro].[AtualizaInconsitenciasPagamentos]
 AS

-- EXEC [Financeiro].[AtualizaInconsitenciasPagamentos]



SELECT 
	 Z5.[ZB5_MATRIC] as Matricula
	,Z7.[ZB7_VALOR] as Valor
	,Z7.[ZB7_NUMBCO] as NumeroBanco
	,Z5.[ZB5_NOME] as Nome
	,Z5.[ZB5_BANCO] as Banco
	,Z5.[ZB5_AGENCI] as Agencia
	,Z5.[ZB5_DVAGE] as DVAgencia
	,Z5.[ZB5_CONTA] as Conta
	,Z5.[ZB5_DVCTA] as DVConta
	,Z5.[ZB5_OPECTA] as Operacao
	,Z5.[ZB5_MUN] as Municipio
	,Z5.[ZB5_EST] as Estado
	,Z7.[ZB7_DATPAG] as DataPagamento
	,C.CPFCNPJ 
	,P.NumeroProposta
	,P.NumeroContrato
	,P.DataArquivo
	,P.DataProcessamento
INTO #Protheus
FROM SCASE.RBDF27.dbo.ZB7010 Z7
INNER JOIN SCASE.RBDF27.dbo.ZB5010 Z5 ON Z5.ZB5_MATRIC = Z7.ZB7_MATRIC
INNER JOIN  Corporativo.Dados.Correspondente C ON C.CPFCNPJ = CleansingKit.dbo.fn_FormataCNPJ(Z5.ZB5_CNPJ)
INNER JOIN  Corporativo.Dados.PremiacaoCorrespondente P ON C.ID = P.ID


/*Atualiza dados Protheus*/
  
 TRUNCATE TABLE [Corporativo].[Financeiro].[RetornoProtheus] 

 INSERT INTO  [Corporativo].[Financeiro].[RetornoProtheus](  
       [Matricula]
      ,[Valor]
      ,[NumeroBanco]
      ,[Nome]
      ,[Banco]
      ,[Agencia]
      ,[DVAgencia]
      ,[Conta]
      ,[DVConta]
      ,[Operacao]
      ,[Municipio]
      ,[Estado]
      ,[CPFCNPJ]
      ,[DataArquivo]
      ,[DataProcessamento]
      ,[NumeroProposta]
      ,[NumeroContrato])

  SELECT 
       [Matricula]
      ,[Valor]
      ,[NumeroBanco]
      ,[Nome]
      ,[Banco]
      ,[Agencia]
      ,[DVAgencia]
      ,[Conta]
      ,[DVConta]
      ,[Operacao]
      ,[Municipio]
      ,[Estado]
      ,[CPFCNPJ]
      ,[DataArquivo]
      ,[DataProcessamento]
      ,[NumeroProposta]
      ,[NumeroContrato]
  FROM #Protheus
 


/*Atualiza Retornos Bancarios*/

SELECT * INTO  #Financeiro FROM OPENQUERY(OBERON,
	  'SELECT 
	   [Codigo]
      ,[CodigoBanco]
      ,[LoteServico]
      ,[CodigoRegistro]
      ,[NSR]
      ,[CodigoSegmento]
      ,[TipoMovimento]
      ,[CodigoInstrucaoMovimento]
      ,[CamaraCompensacao]
      ,[CodigoBancoDestino]
      ,[CodigoAgenciaDestino]
      ,[DVAgenciaDestino]
      ,[ContaCorrenteDestino]
      ,[DVContaDestino]
      ,[DVAgenciaContaDestino]
      ,[NomeFavorecido]
      ,[DocumentoEmpresa]
      ,[Filler_I]
      ,[TipoContaFinalidadeTED]
      ,[DataVencimento]
      ,[TipoMoeda]
      ,[QuantidadeMoeda]
      ,[ValorLancamento]
      ,[NumeroDocumentoBanco]
      ,[Filler_II]
      ,[QuantidadeParcelas]
      ,[IndicadorBloqueio]
      ,[IndicadorFormaParcelamento]
      ,[PeriodoDiaVencimento]
      ,[NumeroParcela]
      ,[DataEfetivacao]
      ,[ValorRealEfetivado]
      ,[Informacao_II]
      ,[FinalidadeDocumento]
      ,[UsoFEBRABAN]
      ,[AvisoFavorecido]
      ,[Ocorrencias]
      ,[DescricaoOcorrencia]
      ,[DataHoraSistema]
      ,[DataArquivo]
      ,[NomeArquivo]
    FROM [FENAE].[dbo].[RetornoPagamento]')

  TRUNCATE TABLE [Financeiro].[RetornoBancario]
  -- SELECT * FROM [Financeiro].[RetornoBancario]
  INSERT INTO [Corporativo].[Financeiro].[RetornoBancario]   														 
  (
	   
       [CodigoBanco]
      ,[LoteServico]
      ,[CodigoRegistro]
      ,[NSR]
      ,[CodigoSegmento]
      ,[TipoMovimento]
      ,[CodigoInstrucaoMovimento]
      ,[CamaraCompensacao]
      ,[CodigoBancoDestino]
      ,[CodigoAgenciaDestino]
      ,[DVAgenciaDestino]
      ,[ContaCorrenteDestino]
      ,[DVContaDestino]
      ,[NomeFavorecido]
      ,[DocumentoEmpresa]
      ,[DataVencimento]
      ,[TipoMoeda]
      ,[QuantidadeMoeda]
      ,[ValorLancamento]
      ,[NumeroDocumentoBanco]
      ,[QuantidadeParcelas]
      ,[IndicadorBloqueio]
      ,[IndicadorFormaParcelamento]
      ,[NumeroParcela]
      ,[DataEfetivacao]
      ,[ValorRealEfetivado]
      ,[Informacao_II]
      ,[FinalidadeDocumento]
      ,[AvisoFavorecido]
      ,[Ocorrencias]
      ,[DescricaoOcorrencia]
		)

  SELECT 
	  
       [CodigoBanco]
      ,[LoteServico]
      ,[CodigoRegistro]
      ,[NSR]
      ,[CodigoSegmento]
      ,[TipoMovimento]
      ,[CodigoInstrucaoMovimento]
      ,[CamaraCompensacao]
      ,[CodigoBancoDestino]
      ,[CodigoAgenciaDestino]
      ,[DVAgenciaDestino]
      ,cast([ContaCorrenteDestino] as int) as ContaCorrenteDestino
      ,[DVContaDestino]
      ,[NomeFavorecido]
      ,[DocumentoEmpresa]
      ,REPLACE([DataVencimento],'/','-') AS DataVencimento
      ,[TipoMoeda]
      ,[QuantidadeMoeda]
      ,[ValorLancamento]
      ,[NumeroDocumentoBanco]
      ,[QuantidadeParcelas]
      ,[IndicadorBloqueio]
      ,[IndicadorFormaParcelamento]
      ,[NumeroParcela]
      ,REPLACE([DataEfetivacao],'/','-') AS DataEfetivacao
      ,[ValorRealEfetivado]
      ,[Informacao_II]
      ,[FinalidadeDocumento]
      ,[AvisoFavorecido]
      ,[Ocorrencias]
      ,[DescricaoOcorrencia]
FROM #Financeiro

