CREATE PROCEDURE Marketing.proc_InsereEmissoesHDI
AS
BEGIN TRY
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.EmissoesHDI_TEMP') AND type in (N'U'))
		DROP TABLE dbo.EmissoesHDI_TEMP;


	CREATE TABLE EmissoesHDI_TEMP(
	   ID INT NOT NULL
	   ,Cliente varchar(200)
	   ,InicioVigencia Date
	   ,FimVigencia Date
	   ,Emissao Date
	   ,Operacao varchar(100)
	   ,ModeloLocal varchar(100)
	   ,Chassi varchar(100)
	   ,Placa varchar(20)
	   ,UF VARCHAR(2)
	   ,AnoFabricacao int
	   ,AnoModelo int
	   ,DataArquivo Date
	)

	--Definir ponto parada correto
	select @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='EmissoesHDI')
	SET @Comando = 'Insert into EmissoesHDI_TEMP (
					    ID,Cliente,InicioVigencia,FimVigencia,Emissao,Operacao,ModeloLocal,Chassi,Placa,UF,AnoFabricacao,AnoModelo,DataArquivo
					)
					SELECT  Codigo
							,Cliente
							,InicioVigencia
							,FimVigencia
							,Emissao
							,Operacao
							,ModeloLocal
							,Chassi
							,Placa
							,UF
							,AnoFabricacao
							,AnoModelo
							,DataArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_EmissaoHdi ''''' + @PontoParada + ''''''') PRP'
	EXEC(@Comando)

	SELECT @MaiorID=MAx(ID)
	from EmissoesHDI_TEMP

	SET @PontoParada = @MaiorID
	WHILE @MaiorID IS NOT NULL
	BEGIN
		MERGE INTO Marketing.EmissaoMsHdi as C USING
		(
			SELECT *
			FROM (
			SELECT DISTINCT Cliente
				  ,InicioVigencia
				  ,FimVigencia
				  ,Emissao
				  ,Operacao
				  ,ModeloLocal
				  ,Chassi
				  ,Placa
				  ,UF
				  ,AnoFabricacao
				  ,AnoModelo
				  ,DataArquivo
				  ,ROW_NUMBER() OVER (PARTITION BY CLiente Order by dataArquivo desc) Ordem
			from EmissoesHDI_TEMP
			) as X
			Where Ordem=1
		)
		AS T
		ON C.Chassi = T.Chassi
		WHEN NOT MATCHED THEN INSERT(Nome,InicioVigencia,FimVigencia ,Emissao,Operacao,ModeloLocal,Chassi,Placa,UF,AnoFabricacao,AnoModelo,Dataarquivo)
			VALUES (Cliente,InicioVigencia,FimVigencia ,Emissao,Operacao,ModeloLocal,Chassi,Placa,UF,AnoFabricacao,AnoModelo,Dataarquivo)
		;
		truncate table EmissoesHDI_TEMP
		SET @Comando = 'Insert into EmissoesHDI_TEMP (
					    ID,Cliente,InicioVigencia,FimVigencia,Emissao,Operacao,ModeloLocal,Chassi,Placa,UF,AnoFabricacao,AnoModelo,DataArquivo
					)
					SELECT  Codigo
							,Cliente
							,InicioVigencia
							,FimVigencia
							,Emissao
							,Operacao
							,ModeloLocal
							,Chassi
							,Placa
							,UF
							,AnoFabricacao
							,AnoModelo
							,DataArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_EmissaoHdi ''''' + @PontoParada + ''''''') PRP'
		EXEC(@Comando)

		SELECT @MaiorID=MAx(ID)
		from EmissoesHDI_TEMP

		IF(@MaiorID IS NOT NULL)
			SET @PontoParada = @MaiorID

	END

	if(@PontoParada IS NOT NULL)
		--Atualiza o ponto de parada
		update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='EmissoesHDI'
	
	--DROP Data tabela temporária
	DROP TABLE EmissoesHDI_TEMP
END TRY                
BEGIN CATCH
	PRINT ERROR_MESSAGE ( )   
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH

--exec Marketing.proc_InsereEmissoesHDI