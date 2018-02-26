
CREATE PROCEDURE proc_Recupera_EmissaoHdi
	@PontoParada as Varchar(400)
AS
  SELECT top 5000
	    Codigo
		,Cliente
		,TRY_PARSE(RIGHT(InicioVigencia,4) + '-' + SUBSTRING(InicioVigencia,4,2) + '-' + LEFT(InicioVigencia,2) as Date) InicioVigencia
		,TRY_PARSE(RIGHT(FimVigencia,4) + '-' + SUBSTRING(FimVigencia,4,2) + '-' + LEFT(FimVigencia,2) as Date) FimVigencia
		,TRY_PARSE(RIGHT(Emissao,4) + '-' + SUBSTRING(Emissao,4,2) + '-' + LEFT(Emissao,2) as Date) Emissao
		,Operacao
		,ModeloLocal
		,Chassi
		,CASE WHEN CHARINDEX('-',Placa)= 0 THEN Placa ELSE SUBSTRING(Placa,1,CHARINDEX('-',Placa) - 1) END Placa
		,CASE WHEN CHARINDEX('-',Placa)=0 THEN '' ELSE SUBSTRING(Placa,CHARINDEX('-',Placa) + 1,2) END  UF
		,TRY_PARSE(AnoFabricacao as int) AnoFabricacao
		,TRY_PARSE(AnoModelo as int) AnoModelo
  from Emissoes_MS_HDI c
  WHERE Codigo > CAST(@PontoParada as BIGINT)
  AND ISNULL(LTRIM(RTRIM(Cliente)),'') <> ''
  AND ISNULL(LTRIM(RTRIM(Chassi)),'') <> ''
  ORDER BY Codigo
