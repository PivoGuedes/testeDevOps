CREATE PROCEDURE Marketing.proc_InsereEmissoesAllianz
AS
BEGIN TRY
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.EmissoesAllianz_TEMP') AND type in (N'U'))
		DROP TABLE dbo.EmissoesAllianz_TEMP;


	CREATE TABLE EmissoesAllianz_TEMP(
	   ID INT NOT NULL
	   ,CPF VARCHAR(20) NOT NULL
	   ,Apolice VARCHAR(20)
	   ,Item VARCHAR(20)
	   ,Nome VARCHAR(200)
	   ,Filler VARCHAR(200)
	   ,Ramo INT
	   ,FimVigencia Date
	   ,PrazoRenovacao Date
	   ,PremioAtual decimal(18,2)
	   ,PremioLiquidoAnterior decimal(18,2)
	   ,DataArquivo Date
	)

	--Definir ponto parada correto
	select @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='EmissoesAllianz')
	SET @Comando = 'Insert into EmissoesAllianz_TEMP (
					    ID
					   ,CPF
					   ,Apolice
					   ,Item
					   ,Nome
					   ,Filler
					   ,Ramo
					   ,FimVigencia
					   ,PrazoRenovacao
					   ,PremioAtual
					   ,PremioLiquidoAnterior
					   ,DataArquivo
					)
					SELECT  Codigo
							,CPF
							,Apolice
							,Item
							,Nome
							,Filler
							,Ramo
							,FimVigencia
							,PrazoRenovacao
							,ValorPremio
							,PremioLiquido
							,Dataarquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_EmissaoAllianz ''''' + @PontoParada + ''''''') PRP'
	EXEC(@Comando)

	SELECT @MaiorID=MAx(ID)
	from EmissoesAllianz_TEMP

	SET @PontoParada = @MaiorID
	WHILE @MaiorID IS NOT NULL
	BEGIN
		MERGE INTO Marketing.EmissaoMsAllianz as C USING
		(
			SELECT *
			from (
			SELECT  DISTINCT CPF
					,Apolice
					,Item
					,Nome
					,Filler
					,Ramo
					,FimVigencia
					,PrazoRenovacao
					,PremioAtual
					,PremioLiquidoAnterior
					,DataArquivo
					,ROW_NUMBER() OVER (PARTITION BY CPF Order by DataArquivo desc) Numero
			from EmissoesAllianz_TEMP
			) as x
			where Numero = 1
		)
		AS T
		ON C.Apolice = T.Apolice
		AND C.CPF=T.CPF
		WHEN NOT MATCHED THEN INSERT(CPF,Apolice,Item,Nome,Filler,Ramo,FimVigencia,PrazoRenovacao,PremioAtual,PremioLiquidoAnterior,DataArquivo)
			VALUES (CPF,apolice,Item,Nome,Filler,Ramo,FimVigencia,PrazoRenovacao,PremioAtual,PremioLiquidoAnterior,DataArquivo)
		WHEN MATCHED THEN UPDATE SET C.Item=T.Item,C.Nome=T.Nome,C.Ramo=T.Ramo
		;
		truncate table EmissoesAllianz_TEMP
		SET @Comando = 'Insert into EmissoesAllianz_TEMP (
					    ID
					   ,CPF
					   ,Apolice
					   ,Item
					   ,Nome
					   ,Filler
					   ,Ramo
					   ,FimVigencia
					   ,PrazoRenovacao
					   ,PremioAtual
					   ,PremioLiquidoAnterior
					   ,DataArquivo
					)
					SELECT  Codigo
							,CPF
							,Apolice
							,Item
							,Nome
							,Filler
							,Ramo
							,FimVigencia
							,PrazoRenovacao
							,ValorPremio
							,PremioLiquido
							,DataArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_EmissaoAllianz ''''' + @PontoParada + ''''''') PRP'
		EXEC(@Comando)

		SELECT @MaiorID=MAx(ID)
		from EmissoesAllianz_TEMP

		IF(@MaiorID IS NOT NULL)
			SET @PontoParada = @MaiorID

	END

	if(@PontoParada IS NOT NULL)
		--Atualiza o ponto de parada
		update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='EmissoesAllianz'
	
	--DROP Data tabela temporária
	DROP TABLE EmissoesAllianz_TEMP
END TRY                
BEGIN CATCH
	PRINT ERROR_MESSAGE ( )   
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH

--exec Marketing.proc_InsereEmissoesAllianz