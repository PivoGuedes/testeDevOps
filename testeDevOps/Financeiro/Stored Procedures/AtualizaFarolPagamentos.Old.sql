-- =============================================
-- Author:		Sadrine Oliveira 
-- Create date: 23/05/2017
-- Procedimento para atualização do Painel Farol de Pagamentos
-- =============================================
CREATE PROCEDURE [Financeiro].[AtualizaFarolPagamentos.Old]
AS

-- EXEC [Financeiro].[AtualizaFarolPagamentos] select * from #Atendente

SELECT * INTO #Atendente FROM OPENQUERY(OBERON,
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
	  FROM [FENAE].[dbo].[DC0701_CBN_Atendente] E')


	 

/*Atualiza Cadastros de Atendentes*/
  
  TRUNCATE TABLE [Financeiro].[CadastroAtendente_SAF]     

  INSERT INTO  [Financeiro].[CadastroAtendente_SAF] (  
		Matricula, 
		Atendente,
		CPF,
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
		Proposta_Paga 
		)

  SELECT 
		E.Matricula, 
		C.[Nome] as Atendente,
		C.CPFCNPJ as CPF,
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
		P.NumeroProposta as Proposta_Paga
  FROM #Atendente E
  INNER JOIN Dados.Correspondente C on C.Matricula = E.Matricula and c.cpfcnpj is not null and c.idtipocorrespondente = 2
  INNER JOIN Dados.FilialFaturamento F on E.CodigoFilialProposta = F.Codigo
  LEFT JOIN  Dados.Proposta P on P.NumeroProposta = E.Proposta
  INNER JOIN Dados.PremiacaoCorrespondente PC on cast(E.Proposta as bigint) = cast(PC.NumeroProposta as bigint) and pc.DataArquivo = E.DataArquivo and pc.IDCorrespondente = c.Id
  INNER JOIN Dados.TipoCorrespondente Tp on C.IDTipoCorrespondente = Tp.ID
  WHERE E.DataArquivo >= '2016-01-01'
  --and e.Proposta = '0090171290000132'
  --and E.Matricula = 10106677


/*Atualiza Cadastros de Empresarios*/

SELECT * INTO  #Empresario FROM OPENQUERY(OBERON,
	 'SELECT CAST(E.NumeroMatricula as bigint) Matricula,  
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
	  FROM [FENAE].[dbo].[DC0701_CBN_Empresario] E')

  TRUNCATE TABLE [Financeiro].[CadastroEmpresario_SAF]

  INSERT INTO  [Financeiro].[CadastroEmpresario_SAF]     														 
  (
		Matricula, 
		Empresario,
		CNPJ,
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
		Proposta_Paga 
		)

  SELECT 
		E.Matricula, 
		C.[Nome] as Empresario,
		C.CPFCNPJ as CNPJ,
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
		P.NumeroProposta as Proposta_Paga
  FROM #Empresario E
  INNER JOIN Dados.Correspondente C on C.Matricula = E.Matricula and c.cpfcnpj is not null and c.IDTipoCorrespondente = 1
  INNER JOIN Dados.FilialFaturamento F on E.CodigoFilialProposta = F.Codigo
  LEFT JOIN  Dados.Proposta P on P.NumeroProposta = E.Proposta
  INNER JOIN Dados.PremiacaoCorrespondente PC on cast(E.Proposta as bigint) = cast(PC.NumeroProposta as bigint) and pc.DataArquivo = E.DataArquivo and pc.IDCorrespondente = c.Id
  INNER JOIN Dados.TipoCorrespondente Tp on C.IDTipoCorrespondente = Tp.ID
  WHERE E.DataArquivo >= '2016-01-01'



/*Atualiza tabela de pagamentos indevidos*/	

TRUNCATE TABLE Financeiro.PagamentosIncorretos 

INSERT INTO Financeiro.PagamentosIncorretos (
	Contrato,
	ID, 
	IDProdutor, 
	IDOperacao, 
	IDCorrespondente, 
	IDFilialFaturamento, 
	NumeroRecibo, 
	IDContrato, 
	IDProposta, 
	Endosso, 
	NumeroParcela, 
	Bilhete, 
	ValorCorretagem,
	DataProcessamento, 
	Proposta, 
	Arquivo,
	DataArquivo
)

SELECT 
CAST(PC.NumeroContrato as bigint) as Contrato, 
	   PC.ID,
	   PC.IDProdutor,
	   PC.IDOperacao,
	   PC.IDCorrespondente,
	   PC.IDFilialFaturamento,
	   PC.NumeroRecibo,
	   PC.IDContrato,
	   PC.IDProposta,
CAST(PC.NumeroEndosso as bigint) as Endosso,
	   PC.NumeroParcela,
CAST(PC.NumeroBilhete as numeric) as Bilhete, 
	   PC.ValorCorretagem,
	   --PC.Grupo,
	   --PC.Cota,
	   PC.DataProcessamento, 
	   --PC.NumeroContrato,
CAST(PC.NumeroProposta as bigint) as Proposta, 
	   PC.Arquivo, 
	   PC.DataArquivo
	   --PC.IDTipoProduto
--C.NumeroContrato as NC,* 
FROM Dados.PremiacaoCorrespondente AS PC
INNER JOIN  Dados.Correspondente AS C2 ON C2.ID = PC.IDCorrespondente
INNER JOIN Dados.TipoProduto AS TP
ON TP.ID=PC.IDTipoProduto
INNER JOIN Dados.Contrato AS C
ON C.ID=PC.IDContrato
WHERE EXISTS 
(
       SELECT *-- ID, IDProdutor, IDOperacao, IDCORRESPONDENTE, IDProposta, IDContrato, NumeroParcela, 
	   --NumeroEndosso, Arquivo, DataArquivo  
       FROM Dados.PremiacaoCorrespondente AS PC2
		WHERE PC2.IDCorrespondente = PC.IDCorrespondente
			AND PC2.IDProposta = PC.IDProposta	   
			AND PC2.IDContrato = PC.IDContrato
			AND PC2.NumeroParcela = PC.NumeroParcela
			AND PC2.NumeroEndosso = PC.NumeroEndosso
			and PC2.Arquivo <> PC.Arquivo
)
--AND C.NumeroContrato like '%103701587372%' 
--AND C.NumeroContrato = '25532601'
and PC.DataArquivo >= '2017-01-01' 


--Atualiza Matriculas Distintas 

TRUNCATE TABLE [Financeiro].[MatriculaPagamentos]

INSERT INTO [Financeiro].[MatriculaPagamentos]
(
	Matricula, 
	Nome
)


SELECT DISTINCT
	  CAST(E.NumeroMatricula as int) as Matricula,
		   C.Nome
FROM OBERON.[FENAE].[dbo].[DC0701_CBN_Empresario] E
INNER JOIN Dados.Correspondente C on C.Matricula = E.NumeroMatricula --18448

UNION ALL

SELECT DISTINCT
	  CAST(E.NumeroMatricula as int) as Matricula,
		   C.Nome
FROM OBERON.[FENAE].[dbo].[DC0701_CBN_Atendente] E
INNER JOIN Dados.Correspondente C on C.Matricula = E.NumeroMatricula -- 21381 




