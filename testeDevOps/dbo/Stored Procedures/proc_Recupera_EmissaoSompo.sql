
CREATE PROCEDURE proc_Recupera_EmissaoSompo
	@PontoParada as Varchar(400)
AS
  SELECT top 5000
	    Codigo
		,NumeroApolice
		,NomeSegurado
		,TRY_PARSE(RIGHT(VigenciaInicio,4) + '-' + SUBSTRING(VigenciaInicio,4,2) + '-' + LEFT(VigenciaInicio,2) as Date) InicioVigencia
		,TRY_PARSE(RIGHT(VigenciaFim,4) + '-' + SUBSTRING(VigenciaFim,4,2) + '-' + LEFT(VigenciaFim,2) as Date) FimVigencia
		,TRY_PARSE(REPLACE(REPLACE(REPLACE(ValorPremio,'R$',''),'.',''),',','.') as decimal(18,2)) ValorPremio
  from Emissoes_MS_Sompo c
  WHERE Codigo > CAST(@PontoParada as BIGINT)
  AND ISNULL(LTRIM(RTRIM(NumeroApolice)),'') <> ''
  ORDER BY Codigo
