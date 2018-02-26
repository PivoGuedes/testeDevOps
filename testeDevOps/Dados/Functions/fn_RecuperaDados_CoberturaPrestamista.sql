CREATE FUNCTION [Dados].[fn_RecuperaDados_CoberturaPrestamista](@NumeroCertificado AS VARCHAR(20))
RETURNS TABLE
AS
RETURN

SELECT C.NumeroCertificado, CB.DataInicioVigencia, CB.DataFimVigencia, CB.ImportanciaSegurada, CB.LimiteIndenizacao, CB.ValorPremioLiquido, COB.Nome AS Cobertura
FROM Dados.Certificado C
LEFT JOIN [Dados].[CertificadoCoberturaHistorico] CB
ON CB.IDCertificado = C.ID
INNER JOIN Dados.Cobertura AS COB
ON COB.ID=CB.IDCobertura
WHERE C.NumeroCertificado = @NumeroCertificado
