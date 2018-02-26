CREATE VIEW Dados.vw_RecuperaPropostaConsolidado
AS
WITH DadosProposta AS
(
SELECT 
       P.ID AS IDProposta,
	   P.IDContrato,
	   P.NumeroProposta,
	   PP.ID AS IDProduto,
	   P.DataProposta,
	   P.DataInicioVigencia,
	   P.DataFimVigencia,
	   P.Valor,
	   --P.IDSituacaoProposta,
	   E.ValorPremioLiquido,
	   E.ValorDiferencaEndosso,
	   P.ValorPremioTotal,
	   SUM(CASE WHEN NumeroEndosso = 0 THEN E.ValorPremioLiquido ELSE E.ValorDiferencaEndosso END) OVER(PARTITION BY P.ID ORDER BY E.ID) AS SomaValorTotal,
	   ROW_NUMBER() OVER(ORDER BY E.DataArquivo DESC) AS RowNumberID,
	   SUM(ISNULL(PG.Valor,0) + ISNULL(PG.ValorIOF,0)) OVER(PARTITION BY PG.IDProposta ORDER BY PG.ID) AS SaldoPagoBruto,
	   SUM(ISNULL(PG.Valor,0)) OVER(PARTITION BY PG.IDProposta ORDER BY PG.ID) AS SaldoPagoLiquido, 
	   ROW_NUMBER() OVER(ORDER BY PG.DataArquivo DESC) AS RowNumberIDPagamento,
	   E.DataArquivo,
	   PS.ID,
	   PS.IDSituacaoProposta,
	   PS.DataInicioSituacao,
	   PS.IDMotivo,
	   PG.Valor AS ValorPagamento,
	   PG.NumeroParcela,
	   PG.ParcelaCalculada,
	   PG.SaldoProcessado
FROM Dados.Proposta AS P
INNER JOIN Dados.PropostaEndosso AS E
ON P.ID = E.IDProposta
INNER JOIN Dados.Produto AS PP
ON P.IDProduto = PP.ID
INNER JOIN Dados.PropostaSituacao AS PS
ON PS.IDProposta = P.ID
INNER JOIN Dados.Pagamento AS PG
ON PG.IDProposta = P.ID
--WHERE E.DataArquivo <= '2012-05-24'
	AND PS.ID = (SELECT MAX(ID) FROM Dados.PropostaSituacao AS PS WHERE PS.IDProposta = P.ID)
	--AND P.ID = 413
)
SELECT *
FROM DadosProposta
WHERE RowNumberID = 1 
	AND RowNumberIDPagamento = 1



--SELECT *
--FROM Dados.Proposta 
--WHERE ID = 6234716

--SELECT *
--FROM Dados.PropostaEndosso
--WHERE IDProposta = 6234716 

--SELECT *
--FROM Dados.PropostaSituacao
--WHERE IDProposta = 6234716

--SELECT *
--FROM Dados.Pagamento  
--WHERE IDProposta = 6234716
