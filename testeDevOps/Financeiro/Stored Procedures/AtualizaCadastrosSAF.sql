
-- =============================================
-- Author:		Sadrine Oliveira 
-- Create date: 23/05/2017
-- Procedimento para atualização do Painel Farol de Pagamentos
-- =============================================
CREATE PROCEDURE [Financeiro].[AtualizaCadastrosSAF]
AS

-- EXEC [Financeiro].[AtualizaFarolPagamentos] select * from #Atendente
--select * from #Atendente

SELECT * INTO  #Atendente FROM OPENQUERY(OBERON,
	 'SELECT CAST(E.NumeroMatricula as bigint) Matricula,  
	  CAST(E.[CodigoProduto] AS bigint) as CodigoProduto,
	  CAST(E.[NumeroApolice] as numeric) as Apolice,
      E.[NumeroParcela] as Parcela,E.NumeroProposta as Proposta,
	  E.NumeroBilhete as Bilhete,
	  substring(E.DataArquivo, 1,4) + substring(E.DataArquivo, 6,2)-1 as Producao,
      cast(E.[ValorCorretagem] as decimal(18,2)) as Valor,
      CAST(E.[CodigoFilialProposta] AS bigint) as CodigoFilialProposta,
	  cast(E.[ValorCorretagem] as decimal(18,2)) ValorCorretagem,
	  E.[DataArquivo],
	  E.NomeArquivo as NomeArquivo,
	  E.[DataProcessamento]
	  --E.NomeArquivo as Premiacao_Empresario
	  FROM [FENAE].[dbo].[DC0701_CBN_Atendente] E
	  where DataArquivo >=''2016-01-01''')



	
  /***********************************************************************************************************************************************************************
    ***************************************************************ATUALIZA CADASTROS ATENDENTES*****************************************************************************
	*********************************************************************************************************************************************************************/	

  
  TRUNCATE TABLE [Financeiro].[CadastrosSaf]     

  INSERT INTO [Financeiro].[CadastrosSaf] (  
		Matricula, 
		Atendente_Empresario,
		CPF_CNPJ,
		C.UF,
		CodigoProduto,
		Apolice,
		Parcela,
		Proposta, 
		Bilhete, 
		Producao,
		Valor,
		CodigoFilialProposta,
		NomeFilial,
		IDTipoCorrespondente,
		Descricao,
		TotalRecebidoPelaSeguradora,
		TotalPagoProdutor,
		Diferenca,
		Mes,
		Ano,
		DataArquivo,
		DataProcessamento,
		NomeArquivo,
		Proposta_Paga,
		DescricaoBox, 
		Operacao 
		)

  SELECT 
		E.Matricula, 
		C.[Nome] as Atendente_Empresario,
		C.CPFCNPJ as CPF_CNPJ,
		C.UF,
		E.CodigoProduto, 
		E.Apolice, 
		E.Parcela, 
		E.Proposta, 
		E.Bilhete, 
		E.Producao, 
		E.Valor, 
		E.CodigoFilialProposta,
		F.[Nome] as NomeFilial, 
		C.IDTipoCorrespondente, 
	    Tp.Descricao,
		SUM(E.[ValorCorretagem]) OVER(PARTITION BY E.NomeArquivo, E.DataArquivo,E.Matricula,E.Proposta) as TotalRecebidoPelaSeguradora, --Seg
		SUM(PC.[ValorCorretagem]) OVER(PARTITION BY PC.Arquivo, PC.DataArquivo, E.Matricula,E.Proposta) as TotalPagoProdutor, --Corr
		SUM(E.[ValorCorretagem]) OVER(PARTITION BY E.DataArquivo, E.Matricula,E.Proposta) - SUM(PC.[ValorCorretagem]) OVER(PARTITION BY PC.DataArquivo,C.Matricula,PC.NumeroProposta) as Diferenca,
		SUBSTRING(E.DataArquivo, 6,2) as Mes,
		SUBSTRING(E.DataArquivo, 0,5) as Ano,
		E.DataArquivo, 
		E.DataProcessamento, 
		E.NomeArquivo,
		P.NumeroProposta as Proposta_Paga,
			CASE E.Matricula  WHEN '0'  
		    THEN 'Matricula Vazia'
			WHEN NULL 
			THEN 'Matricula Invalida'
			--WHEN 'NULL' THEN 'Matricula Invalida'
         ELSE 'Cadastro Valido' end as  DescricaoBox,
		'SAF' as Opercao
  FROM #Atendente E
  INNER JOIN Dados.Correspondente C on C.Matricula = E.Matricula and c.cpfcnpj is not null and c.idtipocorrespondente = 2
  INNER JOIN Dados.FilialFaturamento F on E.CodigoFilialProposta = F.Codigo
  LEFT JOIN  Dados.Proposta P on P.NumeroProposta = E.Proposta
  INNER JOIN Dados.PremiacaoCorrespondente PC on cast(E.Proposta as bigint) = cast(PC.NumeroProposta as bigint) and pc.DataArquivo = E.DataArquivo and pc.IDCorrespondente = c.Id
  INNER JOIN Dados.TipoCorrespondente Tp on C.IDTipoCorrespondente = Tp.ID
  WHERE E.DataArquivo >= '2016-01-01'
  --and e.Proposta = '0090171290000132'
  --and E.Matricula = 10106677

  --select cast('' as bigint)
/*Atualiza Cadastros de Empresarios*/

SELECT * INTO  #Empresario FROM OPENQUERY(OBERON,
	 'SELECT  CAST(E.NumeroMatricula as bigint) Matricula,  
	  CAST(E.[CodigoProduto] AS bigint) as CodigoProduto,
	  CAST(E.[NumeroApolice] as numeric) as Apolice,
      E.[NumeroParcela] as Parcela,E.NumeroProposta as Proposta,
	  E.NumeroBilhete as Bilhete,
	  substring(E.DataArquivo, 1,4) + substring(E.DataArquivo, 6,2) -1 as Producao,
      cast(E.[ValorCorretagem] as decimal(18,2)) as Valor,
      CAST(E.[CodigoFilialProposta] AS bigint) as CodigoFilialProposta,
	  cast(E.[ValorCorretagem] as decimal(18,2)) ValorCorretagem,
	  E.[DataArquivo],
	  E.NomeArquivo as NomeArquivo,
	  E.[DataProcessamento]
	  FROM [FENAE].[dbo].[DC0701_CBN_Empresario] E
	  WHERE DataArquivo >=''2016-01-01''')

  --TRUNCATE TABLE [Financeiro].[CadastroEmpresario_SAF]

  INSERT INTO  [Financeiro].[CadastrosSaf]      														 
  (
		Matricula, 
		Atendente_Empresario,
		CPF_CNPJ,
		C.UF,
		CodigoProduto,
		Apolice,
		Parcela,
		Proposta, 
		Bilhete, 
		Producao,
		Valor,
		CodigoFilialProposta,
		NomeFilial,
		IDTipoCorrespondente,
		Descricao,
		TotalRecebidoPelaSeguradora,
		TotalPagoProdutor,
		Diferenca,
		Mes,
		Ano,
		DataArquivo,
		DataProcessamento,
		NomeArquivo,
		Proposta_Paga,
		DescricaoBox,
		Operacao 
		)

  SELECT 
		E.Matricula, 
		C.[Nome] as Atendente_Empresario,
		C.CPFCNPJ as CPF_CNPJ,
		C.UF,
		E.CodigoProduto, 
		E.Apolice, 
		E.Parcela, 
		E.Proposta, 
		E.Bilhete, 
		E.Producao, 
		E.Valor, 
		E.CodigoFilialProposta,
		F.[Nome] as NomeFilial, 
		C.IDTipoCorrespondente, 
	    Tp.Descricao,
		SUM(E.[ValorCorretagem]) OVER(PARTITION BY E.NomeArquivo, E.DataArquivo,E.Matricula,E.Proposta) as TotalRecebidoPelaSeguradora, --Seg
		SUM(PC.[ValorCorretagem]) OVER(PARTITION BY PC.Arquivo, PC.DataArquivo, E.Matricula, E.Proposta) as TotalPagoProdutor, --Corr
		SUM(E.[ValorCorretagem]) OVER(PARTITION BY E.DataArquivo, E.Matricula,E.Proposta) - SUM(PC.[ValorCorretagem]) OVER(PARTITION BY PC.DataArquivo,C.Matricula,PC.NumeroProposta) as Diferenca,
		SUBSTRING(E.DataArquivo, 6,2) as Mes,
		SUBSTRING(E.DataArquivo, 0,5) as Ano,
		E.DataArquivo, 
		E.DataProcessamento, 
		E.NomeArquivo,
		P.NumeroProposta as Proposta_Paga,    
			CASE E.Matricula  WHEN '0'  
		    THEN 'Matricula Vazia'
			WHEN NULL 
			THEN 'Matricula Invalida'
			--WHEN 'NULL' THEN 'Matricula Invalida'
         ELSE 'Cadastro Valido' end as  DescricaoBox,
		'SAF' as Opercao
  FROM #Empresario E
  INNER JOIN Dados.Correspondente C on C.Matricula = E.Matricula and c.cpfcnpj is not null and c.IDTipoCorrespondente = 1
  INNER JOIN Dados.FilialFaturamento F on E.CodigoFilialProposta = F.Codigo
  LEFT JOIN  Dados.Proposta P on P.NumeroProposta = E.Proposta
  INNER JOIN Dados.PremiacaoCorrespondente PC on cast(E.Proposta as bigint) = cast(PC.NumeroProposta as bigint) and pc.DataArquivo = E.DataArquivo and pc.IDCorrespondente = c.Id
  INNER JOIN Dados.TipoCorrespondente Tp on C.IDTipoCorrespondente = Tp.ID
  WHERE E.DataArquivo >= '2016-01-01'

  /***********************************************************************************************************************************************************************
    ***************************************************************ATUALIZA CADASTRO CONSÓRCIO*****************************************************************************
	***********************************************************************************************************************************************************************/
																																							
   SELECT * INTO #Consorcio FROM OPENQUERY(OBERON,
	 'SELECT  
	  CAST(REPLACE(E.NumeroMatricula, ''-'','''') AS bigint) AS  Matricula, 
	  RazaoSocial,
	  NumeroCNPJ,
	  CodigoBanco,
	  CodigoAgencia,
	  CodigoOperacao,
	  NumeroConta, 
	  DigitoConta, 
	  Cidade,
	  UF,
	  DataArquivo,
	  NomeArquivo,
	  DataHoraProcessamento
	  FROM [FENAE].[dbo].[Cadastro_CONSCBN] E
	  WHERE DataArquivo >=''2016-01-01''')

--SELECT * FROM [Financeiro].[Cadastro_Consorcio]	
 TRUNCATE TABLE [Financeiro].[Cadastro_Consorcio]
 	
 INSERT INTO [Financeiro].[Cadastro_Consorcio](
	   Matricula
	  ,RazaoSocial
	  ,NumeroCNPJ 
	  ,CodigoBanco
	  ,CodigoAgencia 
	  ,CodigoOperacao
	  ,NumeroConta 
	  ,DigitoConta 
	  ,Cidade
	  ,UF  
	  ,Operacao 
	  ,DescricaoBOX
	  ,Producao 
	  ,DataArquivo 
	  ,NomeArquivo 
	  ,DataHoraprocessamento
	  )

 SELECT
	  Matricula
	 ,RazaoSocial
	 ,NumeroCNPJ 
	 ,CodigoBanco
	 ,CodigoAgencia 
	 ,CodigoOperacao
	 ,NumeroConta 
	 ,DigitoConta
	 ,Cidade
	 ,UF  
	 ,'Consorcio' as Operacao 
	 ,CASE Matricula  WHEN '0'  
		    THEN 'Matricula Vazia'
			WHEN NULL 
			THEN 'Matricula Invalida'
			--WHEN 'NULL' THEN 'Matricula Invalida'
         ELSE 'Cadastro Valido' end as DescricaoBox
	 ,MONTH(DataArquivo)-1 as Producao
	 ,DataArquivo 
	 ,NomeArquivo
	 ,DataHoraprocessamento
 FROM #Consorcio C

	
  /***********************************************************************************************************************************************************************
    ***************************************************************ATUALIZA COMISSÃO CONSÓRCIO*****************************************************************************
	************************************************************************************************************************************************************************/	
																																										                                                                                                                                                      
	 SELECT * INTO   #ComissaoConsorcio FROM OPENQUERY(OBERON,
	 'SELECT 
	 CAST(REPLACE(NumeroMatricula, ''-'','''') AS bigint) AS  Matricula
    ,[NumeroContrato] 
	,[Grupo] 
	,[Cota] 
	,[NumeroParcela]  
	,CAST([ValorComissao] AS decimal (18,2)) as ValorComissao
	,[UF]  
	,[DataArquivo] 
	,[NomeArquivo]  
	,[Codigo] 
	,[DataHoraprocessamento]
	 FROM [dbo].[Comissao_CONSCBN]
	 WHERE DataArquivo >=''2016-01-01''')
 
-- SELECT * FROM  #ComissaoConsorcio	
	 
 TRUNCATE TABLE [Financeiro].[Comissao_Consorcio]

 --SELECT * FROM [Financeiro].[Comissao_Consorcio]
 INSERT INTO [Financeiro].[Comissao_Consorcio](
	 Matricula
	,Correspondente
	,CNPJ
	,NumeroContrato 
	,Grupo 
	,Cota  
	,NumeroParcela  
	,ValorComissao
	,UF  
	,DataArquivo 
	,NomeArquivo 
	,Producao 
	,Operacao
	,ValorRecebido
	,ValorPago 
	,Diferenca 
	,Codigo 
	,DataHoraprocessamento
	,Observacao
	)

SELECT 
	 F.Matricula
	,C.Nome as Correpondente
	,C.CPFCNPJ as CNPJ 
	,F.NumeroContrato 
	,F.Grupo 
	,F.Cota 
	,F.NumeroParcela 
	,F.ValorComissao 
	,F.UF 
	,F.DataArquivo 
	,F.NomeArquivo 
	,MONTH(F.DataArquivo) AS Producao 
	,'Consorcio' as Operacao
	,F.ValorComissao as ValorRecebido
	,isnull (P.ValorCorretagem,0) as ValorPago 
	--,SUM(F.ValorComissao) OVER(PARTITION BY F.DataArquivo, F.Matricula)-SUM(P.ValorCorretagem) OVER(PARTITION BY P.DataArquivo,C.Matricula) as Diferenca  
	,F.ValorComissao - ISNULL(P.ValorCorretagem,0) as Diferenca   
	,F.Codigo 
	,F.DataHoraprocessamento
	,CASE	when ISNULL(P.ValorCorretagem,0) >  0 
		    THEN 'PAGAMENTO EFETUADO'
			--WHEN 'NULL' THEN 'Matricula Invalida'
         ELSE 'PAGAMENTO PENDENTE' end as Observacao
--	into #Teste
FROM #ComissaoConsorcio F
INNER JOIN Dados.Correspondente C on C.Matricula = F.Matricula AND C.cpfcnpj is not null and C.IDTipoCorrespondente = 1
LEFT JOIN  Dados.PremiacaoCorrespondente P ON F.NumeroContrato = P.NumeroContrato and F.NumeroParcela = P.NumeroParcela and F.Grupo = P.Grupo
--LEFT JOIN Dados.Contrato CO ON CO.ID = P.IDContrato
and F.Cota = P.Cota and F.ValorComissao  = P.ValorCorretagem
INNER JOIN Dados.TipoCorrespondente Tp on C.IDTipoCorrespondente = Tp.ID
--and F.DataArquivo >='2017-07-01' 
--and Diferenca > '0.00'





--SELECT sum(ValorRecebido) VL 
--FROM #Teste
--WHERE ValorPago = '0.00'

--SELECT TOP 1 * FROM [OBERON].[fenae].[dbo].[Comissao_CONSCBN]
--SELECT TOP 1 * FROM Dados.PremiacaoCorrespondente WHERE IDTipoproduto = 2



/*Atualiza tabela de pagamentos indevidos*/	

--TRUNCATE TABLE Financeiro.PagamentosIncorretos 

--INSERT INTO Financeiro.PagamentosIncorretos (
--	Contrato,
--	ID, 
--	IDProdutor, 
--	IDOperacao, 
--	IDCorrespondente, 
--	IDFilialFaturamento, 
--	NumeroRecibo, 
--	IDContrato, 
--	IDProposta, 
--	Endosso, 
--	NumeroParcela, 
--	Bilhete, 
--	ValorCorretagem,
--	DataProcessamento, 
--	Proposta, 
--	Arquivo,
--	DataArquivo
--)

--SELECT 
--CAST(PC.NumeroContrato as bigint) as Contrato, 
--	   PC.ID,
--	   PC.IDProdutor,
--	   PC.IDOperacao,
--	   PC.IDCorrespondente,
--	   PC.IDFilialFaturamento,
--	   PC.NumeroRecibo,
--	   PC.IDContrato,
--	   PC.IDProposta,
--CAST(PC.NumeroEndosso as bigint) as Endosso,
--	   PC.NumeroParcela,
--CAST(PC.NumeroBilhete as numeric) as Bilhete, 
--	   PC.ValorCorretagem,
--	   --PC.Grupo,
--	   --PC.Cota,
--	   PC.DataProcessamento, 
--	   --PC.NumeroContrato,
--CAST(PC.NumeroProposta as bigint) as Proposta, 
--	   PC.Arquivo, 
--	   PC.DataArquivo
--	   --PC.IDTipoProduto
----C.NumeroContrato as NC,* 
--FROM Dados.PremiacaoCorrespondente AS PC
--INNER JOIN  Dados.Correspondente AS C2 ON C2.ID = PC.IDCorrespondente
--INNER JOIN Dados.TipoProduto AS TP
--ON TP.ID=PC.IDTipoProduto
--INNER JOIN Dados.Contrato AS C
--ON C.ID=PC.IDContrato
--WHERE EXISTS 
--(
--       SELECT *-- ID, IDProdutor, IDOperacao, IDCORRESPONDENTE, IDProposta, IDContrato, NumeroParcela, 
--	   --NumeroEndosso, Arquivo, DataArquivo  
--       FROM Dados.PremiacaoCorrespondente AS PC2
--		WHERE PC2.IDCorrespondente = PC.IDCorrespondente
--			AND PC2.IDProposta = PC.IDProposta	   
--			AND PC2.IDContrato = PC.IDContrato
--			AND PC2.NumeroParcela = PC.NumeroParcela
--			AND PC2.NumeroEndosso = PC.NumeroEndosso
--			and PC2.Arquivo <> PC.Arquivo
--)
----AND C.NumeroContrato like '%103701587372%' 
----AND C.NumeroContrato = '25532601'
--and PC.DataArquivo >= '2017-01-01' 


	
  /***********************************************************************************************************************************************************************
    ***************************************************************ATUALIZA MATRICULAS*****************************************************************************
	************************************************************************************************************************************************************************/	


--Atualiza Matriculas Distintas 

TRUNCATE TABLE [Financeiro].[MatriculaPagamentos]
select count (*) from [Financeiro].[MatriculaPagamentos] --46021


INSERT INTO  [Financeiro].[MatriculaPagamentos]
(
	Matricula, 
	Nome
)


SELECT DISTINCT
	  CAST(E.NumeroMatricula as int) as Matricula,
		   C.Nome
FROM OBERON.[FENAE].[dbo].[DC0701_CBN_Empresario] E
INNER JOIN Dados.Correspondente C on C.Matricula = E.NumeroMatricula --18448
WHERE C.NOME IS NOT NULL



UNION ALL

SELECT DISTINCT
	  CAST(E.NumeroMatricula as int) as Matricula,
		   C.Nome
FROM OBERON.[FENAE].[dbo].[DC0701_CBN_Atendente] E
INNER JOIN Dados.Correspondente C on C.Matricula = E.NumeroMatricula -- 21381 
WHERE C.NOME IS NOT NULL

UNION ALL

SELECT DISTINCT 
	CAST(REPLACE(E.NumeroMatricula, '-','') AS bigint) AS Matricula,
	 C.Nome
FROM OBERON.[FENAE].[dbo].[COMISSAO_CONSCBN] E
INNER JOIN Dados.Correspondente C on C.Matricula = CAST(REPLACE(E.NumeroMatricula, '-','') AS bigint) -- 5264
AND C.Nome is not null
