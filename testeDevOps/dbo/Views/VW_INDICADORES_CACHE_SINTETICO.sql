CREATE VIEW DBO.VW_INDICADORES_CACHE_SINTETICO
AS
SELECT A.CPF, A.anomes [Referencia], A.Nome, cast(IIF([ valor comissão ] = '', '0.0', [ valor comissão ]) as decimal(19,2)) [ValorComissao],  cast(IIF([ valorIR ] = '', '0.0', [ valorIR ]) as decimal(19,2)) [ValorIR],  cast(IIF([ valor inss ] = '', '0.0', [ valor inss ])as decimal(19,2))  [ValorINSS]
FROM dbo.indicadores  A