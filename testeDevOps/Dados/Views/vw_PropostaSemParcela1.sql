
CREATE VIEW Dados.vw_PropostaSemParcela1
AS
SELECT PRO.ID,
	   PRO.IDContrato,
	   CONT.NumeroContrato,
	   PRO.NumeroProposta,
	   PRO.DataProposta,
	   PRO.DataInicioVigencia,
	   PRO.DataFimVigencia,
	   PRO.ValorPremioTotal,
	   PROD.CodigoComercializado,
	   PROD.Descricao AS NomeProduto,
	   SIGPF.ID AS ProdutoSIGPF,
	   SIGPF.Descricao AS NomeProdutoSIGPF
FROM Dados.PropostaEndosso AS PP
INNER JOIN Dados.Proposta AS PRO
ON PP.IDProposta = PRO.ID
INNER JOIN Dados.Contrato AS CONT
ON CONT.ID = PRO.IDContrato
INNER JOIN Dados.Produto AS PROD
ON PROD.ID = PRO.IDProduto
INNER JOIN Dados.ProdutoSIGPF AS SIGPF
ON SIGPF.ID = PRO.IDProdutoSIGPF
WHERE NumeroEndosso = 0
	AND NOT EXISTS (SELECT * 
				    FROM Dados.Pagamento AS P 
					WHERE P.NumeroParcela = 1 
						AND P.ParcelaCalculada = 1
						AND PP.IDProposta = P.IDProposta)



