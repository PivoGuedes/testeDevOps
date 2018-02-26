CREATE VIEW Dados.vw_Premiacao_Prestamista_AIC_Teste
AS
SELECT LP.Ano, LP.Mes, P.Gerente, idlote, F.Matricula, P.NumeroApolice, P.NumeroEndosso, P.NumeroTitulo, P.ValorBruto , P.DataArquivo, P.NomeArquivo --, RIGHT(LEFT(NumeroTitulo,8),6) + '77' + RIGHT(NumeroTitulo,7)--P.NumeroApolice, P.NumeroTitulo, P. P.NumeroEndosso, P.DataArquivo, P.IDLote, p.ValorBruto
FROM Dados.PremiacaoIndicadores P
INNER JOIN Dados.ProdutoPremiacao PP
ON PP.ID = P.IDProdutoPremiacao
LEFT JOIN ControleDados.LoteProtheus LP
ON LP.ID = P.IDLote
LEFT JOIN Dados.Funcionario F
ON F.ID = P.IDFuncionario
WHERE p.DataArquivo >= '2015-01-01'