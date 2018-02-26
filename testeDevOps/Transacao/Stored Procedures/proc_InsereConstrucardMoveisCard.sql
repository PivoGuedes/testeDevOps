
CREATE PROCEDURE Transacao.proc_InsereConstrucardMoveisCard
AS
BEGIN TRY
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Construcard_TEMP') AND type in (N'U'))
		DROP TABLE dbo.Construcard_TEMP;

	CREATE TABLE Construcard_TEMP(
	    id	int,
		RazaoSocial	varchar(150),
		CPFCNPJ	varchar(20),
		CodigoOperacao	int,
		NumeroContrato	varchar(50),
		DataConcessao	date,
		ValorContratado	decimal(18,2),
		PrazoFinanciamento	smallint,
		CodigoStatus	varchar(20),
		Telefone	varchar(50),
		UF	varchar(2),
		DataArquivo	date
	)

	--Definir ponto parada correto
	select @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='Contrucard')

	SET @Comando = 'Insert into Construcard_TEMP (
					    id,
						RazaoSocial,
						CPFCNPJ,
						CodigoOperacao,
						NumeroContrato,
						DataConcessao,
						ValorContratado,
						PrazoFinanciamento,
						CodigoStatus,
						Telefone,
						UF,
						DataArquivo
					)
					SELECT id
							,RazaoSocial
							,CPFCNPJ
							,CodigoOperacao
							,NumeroContrato
							,DataConcessao
							,ValorContratado
							,PrazoFinanciamento
							,CodigoStatus
							,Telefone
							,UF
							,DataArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.Transacao.proc_Recupera_ConstrucardMoveisCard ''''' + @PontoParada + ''''''') PRP'

		EXEC(@Comando)

		SELECT @MaiorID=MAx(ID)
		from Construcard_TEMP

		print @MaiorID

		while @MaiorID IS NOT NULL
		BEGIN
			MERGE INTO Transacao.ConstruCard as C USING
			(
				SELECT DISTINCT
					    t.ID IDTipoTransacao,
					    uf.ID IDUF,
						RazaoSocial,
						CPFCNPJ,
						NumeroContrato,
						DataConcessao,
						ValorContratado,
						PrazoFinanciamento,
						CodigoStatus,
						Telefone,
						DataArquivo
				from Construcard_TEMP c
				left join Transacao.UF uf
				on uf.Sigla=c.UF
				left join Transacao.TipoTransacao t
				on t.Codigo = c.CodigoOperacao
			)
			AS T
			ON C.NumeroContrato = T.NumeroContrato
			AND C.CPFCNPJ=T.CPFCNPJ
			WHEN NOT MATCHED THEN INSERT(IDTipoTransacao,IDUF,RazaoSocial,CPFCNPJ,NumeroContrato,DataConcessao,ValorContratado,PrazoFinanciamento,CodigoStatus,Telefone
					,DataImportacao)
				VALUES (T.IDTipoTransacao,T.IDUF,T.RazaoSocial,T.CPFCNPJ,T.NumeroContrato,T.DataConcessao,T.ValorContratado,T.PrazoFinanciamento,T.CodigoStatus,T.Telefone
					,T.DataArquivo)
			--WHEN NOT MATCHED BY SOURCE THEN UPDATE SET C.Ativo=0
			;

	truncate table Construcard_TEMP
	SET @Comando = 'Insert into Construcard_TEMP (
					    id,
						RazaoSocial,
						CPFCNPJ,
						CodigoOperacao,
						NumeroContrato,
						DataConcessao,
						ValorContratado,
						PrazoFinanciamento,
						CodigoStatus,
						Telefone,
						UF,
						DataArquivo
					)
					SELECT id
							,RazaoSocial
							,CPFCNPJ
							,CodigoOperacao
							,NumeroContrato
							,DataConcessao
							,ValorContratado
							,PrazoFinanciamento
							,CodigoStatus
							,Telefone
							,UF
							,DataArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.Transacao.proc_Recupera_ConstrucardMoveisCard ''''' + @PontoParada + ''''''') PRP'

			EXEC(@Comando)

			SELECT @MaiorID=MAx(ID)
			from Construcard_TEMP

			IF(@MaiorID IS NOT NULL)
				SET @PontoParada = @MaiorID

		END
		--Atualiza o ponto de parada
		update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='Contrucard'

		----Verifica se contratos foram deletados na origem para desativar no corporativo
		--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Construcard_TEMP') AND type in (N'U'))
		--	DROP TABLE dbo.Construcard_TEMP;

		--CREATE TABLE Construcard_TEMP(
		--	CPFCNPJ	varchar(20),
		--	NumeroContrato	varchar(50)
		--)

		--SET @Comando = 'Insert into Construcard_TEMP (
		--				NumeroContrato,
		--				CPFCNPJ
		--			)
		--			SELECT 
		--				NumeroContrato,
		--				CPFCNPJ
		--				FROM OPENQUERY ([OBERON],
		--				''EXEC FENAE.Transacao.proc_Contrato_ConstrucardMoveisCard'') PRP'
		--EXEC(@Comando)
		--MERGE INTO Transacao.ConstruCard as C USING
		--	(
		--		SELECT 
		--			    CPFCNPJ,
		--				NumeroContrato
		--		from Construcard_TEMP c
		--	)
		--	AS T
		--	ON C.NumeroContrato = T.NumeroContrato
		--	AND C.CPFCNPJ=T.CPFCNPJ
		--	WHEN NOT MATCHED BY SOURCE THEN UPDATE SET C.Ativo=0
		--	;
		----DROP Data tabela temporária
		DROP TABLE Construcard_TEMP;
END TRY                
BEGIN CATCH
	PRINT ERROR_MESSAGE ( )   
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH

--exec Transacao.proc_InsereConstrucardMoveisCard