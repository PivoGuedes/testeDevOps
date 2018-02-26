CREATE FUNCTION [Dados].[fn_RecuperaDados_BeneficiarioPrestamista](@NumeroCertificado AS VARCHAR(20))
RETURNS TABLE
AS
RETURN

SELECT C.NumeroCertificado, CB.Nome, CB.Numero, CB.Parentesco, CB.PercentualBeneficio,CB.DataInclusao, CB.DataExclusao
FROM Dados.Certificado C
LEFT JOIN Dados.CertificadoBeneficiario CB
ON CB.IDCertificado = C.ID
WHERE C.NumeroCertificado = @NumeroCertificado
