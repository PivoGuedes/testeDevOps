
CREATE PROCEDURE proc_Recupera_EmissaoAllianz
	@PontoParada as Varchar(400)
AS
  SELECT top 5000
	    Codigo
		,Apolice
		,CPF
		,Nome
		,Filler
		,ISNULL(Item,0) Item
		,ISNULL(Ramo,0) Ramo
		,TRY_PARSE(RIGHT(FimVigencia,4) + '-' + SUBSTRING(FimVigencia,4,2) + '-' + LEFT(FimVigencia,2) as Date) FimVigencia
		,TRY_PARSE(RIGHT(PrazoRenovacao,4) + '-' + SUBSTRING(PrazoRenovacao,4,2) + '-' + LEFT(PrazoRenovacao,2) as Date) PrazoRenovacao
		,TRY_PARSE(REPLACE(REPLACE(REPLACE(PremioAtual,'R$',''),'.',''),',','.') as decimal(18,2)) ValorPremio
		,TRY_PARSE(REPLACE(REPLACE(REPLACE(PremioLiquidoAnterior,'R$',''),'.',''),',','.') as decimal(18,2)) PremioLiquido
  from Emissoes_MS_Allianz c
  WHERE Codigo > CAST(@PontoParada as BIGINT)
  AND ISNULL(LTRIM(RTRIM(Apolice)),'') <> ''
  ORDER BY Codigo
