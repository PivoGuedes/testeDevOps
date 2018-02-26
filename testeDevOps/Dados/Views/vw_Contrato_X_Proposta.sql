
CREATE VIEW Dados.vw_Contrato_X_Proposta
AS
SELECT P.IDContrato,
	   C.IDProposta,
	   C.NumeroContrato,
	   P.NumeroProposta,
	   C.DataInicioVigencia AS DataInicioVigenciaContrato,
	   C.DataFimVigencia AS DataFimVigenciaContrato,
	   P.DataInicioVigencia AS DataInicioVigenciaProposta,
	   P.DataFimVigencia AS DataFimVigenciaProposta,
	   P.Valor,
	   C.ValorPremioTotal AS ValorPremioTotalContrato,
	   P.ValorPremioTotal AS ValorPremioTotalProposta,
	   C.ValorPremioLiquido AS ValorPremioLiquidoContrato,
	   C.ValorPremioBrutoCalculado AS ValorPremioBrutoCalculadoContrato,
	   P.ValorPremioBrutoCalculado AS ValorPremioBrutoCalculadoProposta,
	   C.ValorPremioLiquidoCalculado AS ValorPremioLiquidoCalculadoContrato,
	   P.ValorPremioLiquidoCalculado AS ValorPremioLiquidoCalculadoProposta,
	   C.ValorPagoAcumulado AS ValorPagoAcumuladoContrato,
	   P.ValorPagoAcumulado AS ValorPagoAcumuladoProposta,
	   C.QuantidadeParcelas,
	   P.IDProduto,
	   PROD.Descricao AS NomeProduto,
	   P.IDSituacaoProposta,
	   SP.Descricao AS NomeSituacaoProposta,
	   P.DataProposta,
	   P.DataArquivo
FROM Dados.Contrato AS C
INNER JOIN Dados.Proposta AS P
ON C.ID = P.IDContrato
INNER JOIN Dados.Produto AS PROD
ON PROD.ID = P.IDProduto
INNER JOIN Dados.SituacaoProposta AS SP
ON SP.ID = P.IDSituacaoProposta
--WHERE C.ID = 3270953

--3395647
--4969644
--496335
--1522796