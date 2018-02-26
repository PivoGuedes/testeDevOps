CREATE FUNCTION [Marketing].[fn_RecuperaVidaPagamentosCancelamentos](@AnoMes varchar(6))
RETURNS TABLE
AS
RETURN
SELECT *
FROM Dados.fn_RecuperaVidaVigentes_COMISSAO(@AnoMes) AS VVC