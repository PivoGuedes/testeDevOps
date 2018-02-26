
CREATE FUNCTION [Dados].[fn_RecuperaCertificado_PointInTime]
(@IDProposta INT)
RETURNS TABLE
AS   
RETURN
WITH Dados AS 
(
SELECT ROW_NUMBER() OVER(PARTITION BY C.IDCertificado, C.IDCobertura ORDER BY C.DataInicioVigencia DESC, C.DataArquivo DESC) AS RowNumberIDCert,
	   C.IDCertificado,
	   CERTI.IDProposta,
	   CERTI.NumeroCertificado,
	   CERTI.DataInicioVigencia AS DataInicioVigenciaCertificado,
	   CERTI.DataFimVigencia AS DataFimVigenciaCertificado,
	   CERTI.CPF,
	   CERTI.NomeCliente,
	   CERTI.DataNascimento,
	   CERTI.ValorPremioBruto AS ValorPremio,
	   C.IDCobertura,
	   CO.Nome AS NomeCobertura,
	   C.ImportanciaSegurada AS ImportanciaSeguradaCobertura,
	   C.LimiteIndenizacao AS LimiteIndenizacaoCobertura,
	   C.ValorPremioLiquido AS ValorPremioLiquidoCobertura,
	   C.DataInicioVigencia AS DataInicioVigenciaCobertura,
	   C.DataFimVigencia AS DataFimVigenciaCobertura
FROM Dados.CertificadoCoberturaHistorico AS C
INNER JOIN Dados.Certificado AS CERTI
ON CERTI.ID = C.IDCertificado
INNER JOIN Dados.Cobertura AS CO
ON CO.ID = C.IDCobertura 
	AND CO.IDRamo = 27
WHERE CERTI.IDProposta = @IDProposta
)
SELECT D.*,
	   DD.IDContrato,
	   DD.NumeroProposta,
	   DD.IDProduto,
	   DD.DataProposta,
	   DD.DataInicioVigencia,
	   DD.DataFimVigencia,
	   DD.Valor,
	   DD.ValorPremioLiquido,
	   DD.ValorDiferencaEndosso,
	   DD.ValorPremioTotal,
	   DD.SomaValorTotal,
	   DD.RowNumberID,
	   DD.SaldoPagoBruto,
	   DD.SaldoPagoLiquido, 
	   DD.RowNumberIDPagamento,
	   DD.DataArquivo,
	   DD.ID,
	   DD.IDSituacaoProposta,
	   DD.DataInicioSituacao,
	   DD.IDMotivo,
	   DD.ValorPagamento,
	   DD.NumeroParcela,
	   DD.ParcelaCalculada,
	   DD.SaldoProcessado
FROM Dados AS D
OUTER APPLY (SELECT * FROM  Dados.fn_RecuperaProposta_PointInTime(D.IDProposta)) AS DD
WHERE D.RowNumberIDCert = 1

