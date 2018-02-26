CREATE PROCEDURE Transacao.proc_InsereFinanciamentoAuto
AS
BEGIN TRY
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)
	DECLARE @TipoTransacao as INT

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.FinanciamentoAuto_TEMP') AND type in (N'U'))
		DROP TABLE dbo.FinanciamentoAuto_TEMP;

	CREATE TABLE FinanciamentoAuto_TEMP(
	    ID	int,
		DataLiberacao	date,
		Agencia	varchar(255),
		NumeroContrato	varchar(255),
		NOME	varchar(255),
		CPF	varchar	(14),
		DataNascimento	date,
		Endereco	varchar(255),
		COMPLEMENTO	varchar(255),
		Cidade	varchar(255),
		UF	varchar(255),
		CEP	varchar(255),
		DDD	INT,
		FONE	varchar(255),
		SEXO	varchar(255),
		EST_CIVIL	varchar(255),
		ANO_FABR	int,
		ANO_MODE	int,
		CHASSI	varchar(255),
		PZ_VENC	int,
		VL_CONTRATO 	decimal(18,2),
		DataArquivo	datetime
		Constraint PK_FinanciamentoAuto_TEMP Primary key Clustered(ID)
	)
	
	--Definir ponto parada correto
	select @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='FinanciamentoAuto')

	--DEFINE O TIPO DE TRANSACAO, Pois financiamento AUTO tem apenas um
	select @TipoTransacao = ID from Transacao.TipoTransacao where Codigo=7044

	SET @Comando = 'Insert into FinanciamentoAuto_TEMP (
					    ID,
						DataLiberacao,
						Agencia,
						NumeroContrato,
						NOME,
						CPF,
						DataNascimento,
						Endereco,
						COMPLEMENTO,
						Cidade,
						UF,
						CEP,
						DDD,
						FONE,
						SEXO,
						EST_CIVIL,
						ANO_FABR,
						ANO_MODE,
						CHASSI,
						PZ_VENC,
						VL_CONTRATO,
						DataArquivo
					)
					SELECT	 ID
							,DT_LIB
							,AG
							,CONT
							,NOME
							,CPF
							,DataNascimento
							,Endereco
							,COMPLEMENTO
							,CID
							,UF
							,CEP
							,DDD
							,FONE
							,SEXO
							,EST_CIVIL
							,ANO_FABR
							,ANO_MODE
							,CHASSI
							,PZ_VENC
							,ValorContrato
							,DataArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.Transacao.proc_Recupera_FinanciamentoAuto ''''' + @PontoParada + ''''''') PRP'
		EXEC(@Comando)

		SELECT @MaiorID=MAx(ID)
		from FinanciamentoAuto_TEMP

		if(@MaiorID IS NOT NULL)
			SET @PontoParada=@MaiorID

		while @MaiorID IS NOT NULL
		BEGIN
			MERGE INTO Transacao.FinanciamentoAuto as C USING
			(
				SELECT  DISTINCT ISNULL(m.ID,(select ID from Transacao.municipioIBGE where codigo=-1)) IDMunicipio,
						ISNULL(uf.ID,1) IDUF,
						ISNULL(U.ID ,1) IDUnidade,
						ISNULL(EST_CIVIL,'') EST_CIVIL,
						ISNULL(DataLiberacao,'1900-01-01') DataLiberacao,
						ISNULL(Agencia,0) Agencia,
						ISNULL(NumeroContrato,'') NumeroContrato,
						ISNULL(c.NOME,'') Nome,
						ISNULL(CPF,'') CPF,
						ISNULL(DataNascimento,'1900-01-01') DataNascimento,
						ISNULL(Endereco,'') Endereco,
						ISNULL(COMPLEMENTO,'') COMPLEMENTO,
						ISNULL(CEP,'') CEP,
						ISNULL(DDD,0) DDD,
						ISNULL(FONE,0) FONE,
						ISNULL(SEXO,'') SEXO,
						ISNULL(ANO_FABR,0) ANO_FABR,
						ISNULL(ANO_MODE,0) ANO_MODE,
						ISNULL(CHASSI,'') CHASSI,
						ISNULL(PZ_VENC,0) PZ_VENC,
						ISNULL(VL_CONTRATO,0) VL_CONTRATO,
						DataArquivo
				from FinanciamentoAuto_TEMP c
				left join Transacao.UF uf
				on uf.Sigla=c.UF
				left join Transacao.MunicipioIBGE m
				on m.Slug = Transacao.fn_GenerateSlug(Cidade)
				AND m.IDUF = uf.ID
				LEFT JOIN Dados.Unidade u
				on u.Codigo=c.Agencia
			)
			AS T
			ON C.NumeroContrato = T.NumeroContrato
			AND C.CPF=T.CPF
			WHEN NOT MATCHED THEN INSERT(IDTipoTransacao,IDMunicipio,IDUF,IDUnidade,EstadoCivil,DataLiberacao,NumeroContrato,Nome,CPF,DataNascimento,Endereco,Complemento,CEP,DDD,Telefone,Sexo,
					AnoFabricacao,AnoModelo,Chassi,PrazoVencimento,ValorContrato,DataImportacao)
				VALUES (@TipoTransacao, IDMunicipio,IDUF,IDUnidade,EST_CIVIL,DataLiberacao,NumeroContrato,NOME,CPF,DataNascimento,Endereco,COMPLEMENTO,CEP,DDD,FONE,SEXO,ANO_FABR,ANO_MODE,CHASSI,
						PZ_VENC,VL_CONTRATO,DataArquivo)
			--WHEN NOT MATCHED BY SOURCE THEN UPDATE SET C.Ativo=0
			;
	
	truncate table FinanciamentoAuto_TEMP
	SET @Comando = 'Insert into FinanciamentoAuto_TEMP (
					    ID,
						DataLiberacao,
						Agencia,
						NumeroContrato,
						NOME,
						CPF,
						DataNascimento,
						Endereco,
						COMPLEMENTO,
						Cidade,
						UF,
						CEP,
						DDD,
						FONE,
						SEXO,
						EST_CIVIL,
						ANO_FABR,
						ANO_MODE,
						CHASSI,
						PZ_VENC,
						VL_CONTRATO,
						DataArquivo
					)
					SELECT	 ID
							,DT_LIB
							,AG
							,CONT
							,NOME
							,CPF
							,DataNascimento
							,Endereco
							,COMPLEMENTO
							,CID
							,UF
							,CEP
							,DDD
							,FONE
							,SEXO
							,EST_CIVIL
							,ANO_FABR
							,ANO_MODE
							,CHASSI
							,PZ_VENC
							,ValorContrato
							,DataArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.Transacao.proc_Recupera_FinanciamentoAuto ''''' + @PontoParada + ''''''') PRP'
			
			EXEC(@Comando)

			SELECT @MaiorID=MAx(ID)
			from FinanciamentoAuto_TEMP

			IF(@MaiorID IS NOT NULL)
				SET @PontoParada = @MaiorID

		END
		if(@PontoParada IS NOT NULL)
			--Atualiza o ponto de parada
			update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='FinanciamentoAuto'
		--DROP Data tabela temporária
		--DROP TABLE FinanciamentoAuto_TEMP
		--Verifica se contratos foram deletados na origem para desativar no corporativo
		--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.FinanciamentoAuto_TEMP') AND type in (N'U'))
		--	DROP TABLE dbo.FinanciamentoAuto_TEMP;

		--CREATE TABLE FinanciamentoAuto_TEMP(
		--   NumeroContrato		varchar(20)			 null,
		--   CpfCnpj				varchar(20)
		--)
		--SET @Comando = 'Insert into FinanciamentoAuto_TEMP (
		--				   NumeroContrato,
		--				   CpfCnpj
		--				)
		--				SELECT 
		--					CONT
		--					,CPF
		--					FROM OPENQUERY ([OBERON],
		--					''EXEC FENAE.Transacao.proc_Contrato_FinanciamentoAuto'') PRP'
		--EXEC(@Comando)
		--MERGE INTO Transacao.FinanciamentoAuto as C USING
		--	(
		--		SELECT 
		--			   NumeroContrato,
		--				   CpfCnpj
		--		from FinanciamentoAuto_TEMP c
		--	)
		--	AS T
		--	ON C.NumeroContrato = T.NumeroContrato
		--	AND C.CPF=T.CPFCNPJ
		--	WHEN NOT MATCHED BY SOURCE THEN UPDATE SET C.Ativo=0
		--	;
		--DROP Data tabela temporária
		DROP TABLE FinanciamentoAuto_TEMP
END TRY                
BEGIN CATCH
	PRINT ERROR_MESSAGE ( )   
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH

--exec Transacao.proc_InsereFinanciamentoAuto