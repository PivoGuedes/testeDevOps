CREATE FUNCTION Dados.fn_CertificadoExists(@NumeroCertificado varchar(20), @IDSeguradora smallint)
RETURNS BIT
AS
BEGIN 
	RETURN (SELECT Cast(count(*) as bit) from (Select TOP 1 NumeroCertificado From Dados.Certificado C WHERE C.NumeroCertificado = @NumeroCertificado AND C.IDSeguradora = @IDSeguradora) a)
END