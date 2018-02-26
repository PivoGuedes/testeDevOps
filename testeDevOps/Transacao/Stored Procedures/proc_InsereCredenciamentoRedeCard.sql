
CREATE PROCEDURE Transacao.proc_InsereCredenciamentoRedeCard
AS
BEGIN TRY
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.CredenciamentoRede_TEMP') AND type in (N'U'))
		DROP TABLE dbo.CredenciamentoRede_TEMP;

	CREATE TABLE CredenciamentoRede_TEMP(
		ID                   int                  not null,
	   CodigoSn             int                  null,
	   NomeSn               varchar(10)          null,
	   CodigoSr             int                  null,
	   NomeSr               varchar(70)          null,
	   AnoMes               varchar(7)           null,
	   CpfCnpj              varchar(20)          null,
	   PontoVenda           bigint               null,
	   Agencia              int                  null,
	   DataInstalacao       datetime             null,
	   Credenciadora        varchar(10)          null,
	   DataImportacao		Datetime			 not null default getdate()
	   Constraint PK_CredenciamentoRede_TEMP Primary key Clustered(ID)
	)

	--Definir ponto parada correto
	select @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='CredenciamentoRedecard')

	SET @Comando = 'Insert into CredenciamentoRede_TEMP (
						ID
					   ,CodigoSn
					   ,NomeSn
					   ,CodigoSr
					   ,NomeSr
					   ,AnoMes
					   ,CpfCnpj
					   ,PontoVenda
					   ,Agencia
					   ,DataInstalacao
					   ,Credenciadora
					   ,DataImportacao
					)
					SELECT ID
					   ,CodigoSn
					   ,NomeSn
					   ,CodigoSr
					   ,NomeSr
					   ,AnoMes
					   ,CpfCnpj
					   ,PontoVenda
					   ,Agencia
					   ,DataInstalacao
					   ,Credenciadora
					   ,DataImportacao
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.Transacao.proc_Recupera_Credenciamento ''''' + @PontoParada + ''''''') PRP'

		EXEC(@Comando)

		SELECT @MaiorID=MAx(ID)
		from CredenciamentoRede_TEMP


		if(@MaiorID IS NOT NULL)
			SET @PontoParada = @MaiorID

		while @MaiorID IS NOT NULL
		BEGIN
			MERGE INTO Transacao.Credenciamento as C USING
			(
				SELECT  DISTINCT u.ID IDUnidade
						,AnoMes
					   ,CpfCnpj
					   ,DataInstalacao
					   ,Credenciadora
					   ,DataImportacao
				from CredenciamentoRede_TEMP c
				left join Dados.Unidade u
				on u.Codigo = c.Agencia
			)
			AS T
			ON C.CpfCnpj = T.CpfCnpj
			AND C.Credenciadora = T.Credenciadora
			AND C.AnoMes=T.AnoMes
			WHEN NOT MATCHED THEN INSERT(IDUnidade,AnoMes,CpfCnpj,DataInstalacao,Credenciadora,DataImportacao)
				VALUES (IDUnidade,AnoMes,CpfCnpj,DataInstalacao,Credenciadora,DataImportacao)
			--WHEN NOT MATCHED BY SOURCE THEN UPDATE SET C.Ativo=0
			;

			truncate table CredenciamentoRede_TEMP
			
			SET @Comando = 'Insert into CredenciamentoRede_TEMP (
						ID
					   ,CodigoSn
					   ,NomeSn
					   ,CodigoSr
					   ,NomeSr
					   ,AnoMes
					   ,CpfCnpj
					   ,PontoVenda
					   ,Agencia
					   ,DataInstalacao
					   ,Credenciadora
					   ,DataImportacao
					)
					SELECT ID
					   ,CodigoSn
					   ,NomeSn
					   ,CodigoSr
					   ,NomeSr
					   ,AnoMes
					   ,CpfCnpj
					   ,PontoVenda
					   ,Agencia
					   ,DataInstalacao
					   ,Credenciadora
					   ,DataImportacao
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.Transacao.proc_Recupera_Credenciamento ''''' + @PontoParada + ''''''') PRP'

			EXEC(@Comando)

			SELECT @MaiorID=MAx(ID)
			from CredenciamentoRede_TEMP

			IF(@MaiorID IS NOT NULL)
				SET @PontoParada = @MaiorID

		END

		if(@PontoParada IS NOT NULL)
			--Atualiza o ponto de parada
			update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='CredenciamentoRedecard'
		----DROP Data tabela temporária
		--DROP TABLE CredenciamentoRede_TEMP
		----Verifica se contratos foram deletados na origem para desativar no corporativo
		--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.CredenciamentoRede_TEMP') AND type in (N'U'))
		--	DROP TABLE dbo.CredenciamentoRede_TEMP;

		--CREATE TABLE CredenciamentoRede_TEMP(
		--	CpfCnpj					 VARCHAR(15)		  NOT NULL
		--)
		--SET @Comando = 'Insert into CredenciamentoRede_TEMP (
		--					CpfCnpj
		--				)
		--				SELECT 
		--					CpfCnpj
		--					FROM OPENQUERY ([OBERON],
		--					''EXEC FENAE.Transacao.proc_Contrato_Credenciamento'') PRP'
		--EXEC(@Comando)
		--MERGE INTO Transacao.credenciamento as C USING
		--(
		--	SELECT  CPFCNPJ
		--	from CredenciamentoRede_TEMP c
		--)
		--AS T
		--ON C.CpfCnpj = T.CPFCNPJ
		--WHEN NOT MATCHED BY SOURCE THEN UPDATE SET C.Ativo=0
		--;
		--DROP Data tabela temporária
		DROP TABLE CredenciamentoRede_TEMP
END TRY                
BEGIN CATCH
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH
--exec Transacao.proc_InsereCredenciamentoRedeCard