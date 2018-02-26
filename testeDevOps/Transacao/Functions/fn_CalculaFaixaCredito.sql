CREATE FUNCTION Transacao.fn_CalculaFaixaCredito
(@ValorTransacao as decimal(18,2))
RETURNS decimal(18,2)
AS
BEGIN
	DECLARE @FaixaInicial decimal(18,2)

	select @FaixaInicial = @ValorTransacao - (@ValorTransacao % 5000)
	RETURN @FaixaInicial
END
