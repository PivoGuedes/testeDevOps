
CREATE FUNCTION [Dados].[fn_GeraNumeroRecibo](@Data DATE, @idEmpresa SMALLINT)
RETURNS BIGINT
AS
BEGIN

--DECLARE @Data DATE = '2016-06-09'
DECLARE @NumeroReciboNovo BIGINT
SET @Data = RIGHT(YEAR(@Data),4) + '-' + RIGHT('00' + MONTH(@Data),2) + '-' + '01'
--SELECT Cast(RIGHT(YEAR(@Data),4) + RIGHT('00' + Cast(MONTH(@Data) AS VARCHAR(2)),2) + '0001' as bigint)

;WITH CTE
AS
(
SELECT MAX(NumeroRecibo) + 1 NovoNumeroRecibo FROM 
       [Dados].[Comissao_Partitioned]
WHERE   LancamentoManual = 1 
	AND DataCompetencia >= @Data AND DataCompetencia <= EOMONTH(@Data)
	AND IDEmpresa = @idEmpresa
	--AND ID = (SELECT MAX(ID) FROM[Dados].[Comissao_Partitioned]) ORDER BY ID
UNION 
SELECT Cast(RIGHT(YEAR(@Data),4) + RIGHT('00' + Cast(MONTH(@Data) AS VARCHAR(2)), 2) + '0001' as bigint) NovoNumeroRecibo
)
SELECT TOP 1 @NumeroReciboNovo = NovoNumeroRecibo
FROM CTE
ORDER BY NovoNumeroRecibo DESC
		
RETURN @NumeroReciboNovo
END