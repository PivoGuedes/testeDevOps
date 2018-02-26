CREATE PROCEDURE Marketing.proc_InsereEmissoesSompo
AS
BEGIN TRY
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.EmissoesSompo_TEMP') AND type in (N'U'))
		DROP TABLE dbo.EmissoesSompo_TEMP;


	CREATE TABLE EmissoesSompo_TEMP(
	   ID INT NOT NULL
	   ,NumeroApolice varchar(20)
		,NomeSegurado varchar(200)
		,InicioVigencia Date
		,FimVigencia Date
		,ValorPremio decimal(18,2)
		,DataArquivo Date
	)

	--Definir ponto parada correto
	select @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='EmissoesSompo')
	SET @Comando = 'Insert into EmissoesSompo_TEMP (
					    ID,NumeroApolice,NomeSegurado,InicioVigencia,FimVigencia,ValorPremio,DataArquivo
					)
					SELECT  Codigo,NumeroApolice,NomeSegurado,InicioVigencia,FimVigencia,ValorPremio,DataArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_EmissaoSompo  ''''' + @PontoParada + ''''''') PRP'
	EXEC(@Comando)

	SELECT @MaiorID=MAx(ID)
	from EmissoesSompo_TEMP

	SET @PontoParada = @MaiorID
	WHILE @MaiorID IS NOT NULL
	BEGIN
		MERGE INTO Marketing.EmissaoMsSompo as C USING
		(
			SELECT *
			FROM (
			SELECT DISTINCT NumeroApolice,NomeSegurado,InicioVigencia,FimVigencia,ValorPremio,DataArquivo
			,ROW_NUMBER() OVER(PARTITION BY NumeroApolice Order by DataArquivo desc) Ordem
			from EmissoesSompo_TEMP
			) AS X
			WHERE Ordem=1
		)
		AS T
		ON C.Apolice = T.NumeroApolice
		WHEN NOT MATCHED THEN INSERT(Apolice,InicioVigencia,FimVigencia ,NomeSegurado,ValorPremio)
			VALUES (NumeroApolice,InicioVigencia,FimVigencia,NomeSegurado,ValorPremio)
		;
		truncate table EmissoesSompo_TEMP
		SET @Comando = 'Insert into EmissoesSompo_TEMP (
					    ID,NumeroApolice,NomeSegurado,InicioVigencia,FimVigencia,ValorPremio,DataArquivo
					)
					SELECT  Codigo,NumeroApolice,NomeSegurado,InicioVigencia,FimVigencia,ValorPremio,DataArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_EmissaoSompo ''''' + @PontoParada + ''''''') PRP'
		EXEC(@Comando)

		SELECT @MaiorID=MAx(ID)
		from EmissoesSompo_TEMP

		IF(@MaiorID IS NOT NULL)
			SET @PontoParada = @MaiorID

	END

	if(@PontoParada IS NOT NULL)
		--Atualiza o ponto de parada
		update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='EmissoesSompo'
	
	--DROP Data tabela temporária
	DROP TABLE EmissoesSompo_TEMP
END TRY                
BEGIN CATCH
	PRINT ERROR_MESSAGE ( )   
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH

--exec Marketing.proc_InsereEmissoesSompo