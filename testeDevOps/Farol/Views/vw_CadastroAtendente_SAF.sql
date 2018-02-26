



CREATE VIEW [Farol].[vw_CadastroAtendente_SAF]
AS
SELECT 
	  CAST(E.NumeroMatricula as int) as Matricula,
	  C.[Nome] as Atendente,
	  C.CPFCNPJ as CPF,
      E.[CodigoProduto],
      CAST(E.[NumeroApolice] as numeric) as Apolice,
      E.[NumeroParcela] as Parcela,
      substring(E.NumeroProposta, 2,15) as Proposta,
	  CAST(E.NumeroBilhete as numeric) as Bilhete,
	  substring(E.DataArquivo, 1,4) + substring(E.DataArquivo, 6,2)-1 as Producao,
      cast(E.[ValorCorretagem] as decimal(18,2)) as Valor,
      E.[CodigoFilialProposta] as Filial_Proposta,
	  F.[Nome] as NomeFilial,
	  C.IDTipoCorrespondente, 
	  Tp.Descricao,
	  --SUM(cast([ValorCorretagem] as decimal(18,2))) OVER(PARTITION BY E.DataArquivo) as TotalPagoMes,
	  SUM(cast(E.[ValorCorretagem] as decimal(18,2))) OVER(PARTITION BY E.NomeArquivo, E.DataArquivo) as TotalRecebidoPelaSeguradora, --Seg
	  SUM(cast(PC.[ValorCorretagem] as decimal(18,2))) OVER(PARTITION BY PC.Arquivo,PC.DataArquivo) as TotalPagoProdutor, --Corr
	  SUM(cast(E.[ValorCorretagem] as decimal(18,2))) OVER(PARTITION BY E.NomeArquivo, E.DataArquivo) - SUM(cast(PC.[ValorCorretagem] as decimal(18,2))) OVER(PARTITION BY PC.DataArquivo) as Diferenca,
	  --SUM(cast([ValorCorretagem] as decimal(18,2))) OVER(PARTITION BY P.Arquivo, P.DataArquivo) as TotalPago,
	  --cast(sum(E.[ValorCorretagem] as decimal(18,2))) as TotalPagoMes,
	  substring(E.DataArquivo, 6,2) as Mes,
      E.[NomeArquivo] as Premiacao_Atendente,
      E.[DataArquivo],
	  --P.IDContrato
	  E.[DataProcessamento],
	  E.NomeArquivo as NomeArquivo
  FROM OBERON.[FENAE].[dbo].[DC0701_CBN_Atendente] E
  INNER JOIN Dados.Correspondente C on C.Matricula = E.NumeroMatricula and c.cpfcnpj is not null
  INNER JOIN Dados.FilialFaturamento F on E.CodigoFilialProposta = F.Codigo
  LEFT JOIN Dados.Proposta P on E.NumeroProposta = P.NumeroProposta 
  INNER JOIN Dados.PremiacaoCorrespondente PC on E.NumeroBilhete = PC.NumeroBilhete
  INNER JOIN Dados.TipoCorrespondente Tp on C.IDTipoCorrespondente = Tp.ID
  WHERE E.DataArquivo >= '2017-04-05'



