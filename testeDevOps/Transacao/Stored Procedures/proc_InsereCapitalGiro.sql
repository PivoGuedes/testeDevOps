
CREATE PROCEDURE Transacao.proc_InsereCapitalGiro
AS
BEGIN TRY
	BEGIN TRAN
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.CapitalGiro_TEMP') AND type in (N'U'))
		DROP TABLE dbo.CapitalGiro_TEMP;

	CREATE TABLE CapitalGiro_TEMP(
		ID                   int                  not null,
	    NumeroContrato       varchar(40)          null,
		CodigoModalidade     int                  null,
		CodigoSituacao       int                  null,
		CodigoAgencia        int                  null,
		CodigoOperacao       int                  null,
		DataLiberacao        datetime             null,
		ValorConcessao       decimal(18,2)        null,
		NumeroCnpj           varchar(40)          null,
		TaxaJuros            decimal(18,4)        null,
		Prazo                int                  null,
		DataImportacao		Datetime			 not null default getdate()
		CONSTRAINT PK_TempoCapital Primary Key clustered(ID)
	)

	--Definir ponto parada correto
	select @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='CapitalGiro')

	SET @Comando = 'Insert into CapitalGiro_TEMP (
						ID,
						NumeroContrato,
						CodigoModalidade,
						CodigoSituacao,
						CodigoAgencia,
						CodigoOperacao,
						DataLiberacao,
						ValorConcessao,
						NumeroCnpj,
						TaxaJuros,
						Prazo,
						DataImportacao
					)
					SELECT ID,
						NumeroContrato,
						CodigoModalidade,
						CodigoSituacao,
						CodigoAgencia,
						CodigoOperacao,
						DataLiberacao,
						ValorConcessao,
						NumeroCnpj,
						TaxaJuros,
						Prazo,
						DataArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.Transacao.proc_Recupera_Capital_Giro ''''' + @PontoParada + ''''''') PRP'

		EXEC(@Comando)

		SELECT @MaiorID=MAx(ID)
		from CapitalGiro_TEMP

		while @MaiorID IS NOT NULL
		BEGIN
			MERGE INTO Transacao.TipoTransacao as C
			USING (
				Select DISTINCT CodigoOperacao,IDGrupoTransacao,Prioridade,JanelaInicio,JanelaFim,FlTipoCliente
				from CapitalGiro_TEMP
				CROSS APPLY(
					SELECT TOP 1 IDGrupoTransacao,Prioridade,JanelaInicio,JanelaFim,FlTipoCliente
					from Transacao.TipoTransacao
					where idGrupoTransacao=7
				) as g
			)
			as T
			ON C.Codigo=T.CodigoOperacao
			AND C.IDGrupoTransacao=7
			WHEN NOT MATCHED THEN INSERT (IDGrupoTransacao,Codigo,JanelaInicio,JanelaFim,Descricao,FlTipoCliente,Prioridade)
				values (IDGrupoTransacao,CodigoOperacao,JanelaInicio,JanelaFim,'Não Identificado',FlTipoCliente,Prioridade)
			;

			MERGE INTO Transacao.DmTipoTransacao as C
			USING (
				Select DISTINCT t.Id IdTipoTransacao,t.Codigo CdTransacao,CASE t.FlTipoCliente WHEN 1 THEN 'Pessoa Fisica' ELSE 'Pessoa Juridica' END DsTipoTransacao
					,g.Descricao DsTransacaoGrupo,t.Descricao DsTransacao
				from CapitalGiro_TEMP c
				inner join Transacao.TipoTransacao t
				on t.Codigo=c.CodigoModalidade
				Inner join Transacao.GrupoTipoTransacao g
				on g.Id=t.IDGrupoTransacao
				where IDGrupoTransacao=7
			)
			as T
			ON C.CdTransacao=T.CdTransacao
			AND C.IDTipoTransacao=T.IDTipoTransacao
			WHEN NOT MATCHED THEN INSERT (IdTipoTransacao,CdTransacao,DsTipoTransacao,DsTransacaoGrupo,DsTransacao)
				values (IdTipoTransacao,CdTransacao,DsTipoTransacao,DsTRansacaoGrupo,DsTransacao)
			;

			MERGE INTO Transacao.CapitalGiro as C USING
			(
				SELECT  Distinct t.ID IDTipoTransacao,
						u.ID IDUnidade,
						NumeroContrato,
						CodigoModalidade,
						ISNULL(CodigoSituacao,0) CodigoSituacao,
						DataLiberacao,
						ValorConcessao,
						NumeroCnpj,
						TaxaJuros,
						ISNULL(Prazo,0) Prazo,
						DataImportacao
				from CapitalGiro_TEMP c
				LEFT JOIN Transacao.TipoTransacao t
				on t.Codigo = C.CodigoOperacao
				and t.IdGrupoTransacao=7
				LEFT JOIN Dados.Unidade u
				on u.Codigo = CodigoAgencia
			)
			AS T
			ON C.NumeroContrato = T.NumeroContrato
			AND ISNULL(C.NumeroCnpj,'')    = ISNULL(T.NumeroCnpj,'')
			WHEN NOT MATCHED THEN INSERT(IDTipoTransacao,IDUnidade,NumeroContrato,CodigoModalidade,CodigoSituacao,DataLiberacao,
						ValorConcessao,NumeroCnpj,TaxaJuros,Prazo,DataImportacao)
				VALUES (IDTipoTransacao,IDUnidade, NumeroContrato,CodigoModalidade,CodigoSituacao,DataLiberacao,ValorConcessao,NumeroCnpj,TaxaJuros,
						Prazo,DataImportacao)
			--WHEN NOT MATCHED BY SOURCE THEN UPDATE SET C.Ativo=0
			;
			truncate table CapitalGiro_TEMP;
			
			SET @Comando = 'Insert into CapitalGiro_TEMP (
						ID,
						NumeroContrato,
						CodigoModalidade,
						CodigoSituacao,
						CodigoAgencia,
						CodigoOperacao,
						DataLiberacao,
						ValorConcessao,
						NumeroCnpj,
						TaxaJuros,
						Prazo,
						DataImportacao
					)
					SELECT ID,
						NumeroContrato,
						CodigoModalidade,
						CodigoSituacao,
						CodigoAgencia,
						CodigoOperacao,
						DataLiberacao,
						ValorConcessao,
						NumeroCnpj,
						TaxaJuros,
						Prazo,
						DataArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.Transacao.proc_Recupera_Capital_Giro ''''' + @PontoParada + ''''''') PRP'

			EXEC(@Comando)

			SELECT @MaiorID=MAx(ID)
			from CapitalGiro_TEMP

			IF(@MaiorID IS NOT NULL)
				SET @PontoParada = @MaiorID
	
		END
		--Atualiza o ponto de parada
		update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='CapitalGiro'
		--DROP Data tabela temporária
		DROP TABLE CapitalGiro_TEMP
		
		--CREATE TABLE CapitalGiro_TEMP(
		--	NumeroContrato       varchar(40)          null,
		--	NumeroCnpj           varchar(40)          null
		--)

		--SET @Comando = 'Insert into CapitalGiro_TEMP (
		--				NumeroContrato,
		--				NumeroCnpj
		--			)
		--			SELECT 
		--				NumeroContrato,
		--				Cnpj
		--				FROM OPENQUERY ([OBERON],
		--				''EXEC FENAE.Transacao.proc_NumeroContratro_Capital_Giro'') PRP'
		--EXEC(@Comando)

		--MERGE INTO Transacao.CapitalGiro as C USING
		--(
		--	SELECT  NumeroContrato,
		--			NumeroCnpj
		--	from CapitalGiro_TEMP
		--)
		--AS T
		--ON C.NumeroContrato = T.NumeroContrato
		--AND C.NumeroCnpj    = T.NumeroCnpj
		--WHEN NOT MATCHED BY SOURCE THEN UPDATE SET C.Ativo=0;

		--DROP Data tabela temporária
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.CapitalGiro_TEMP') AND type in (N'U'))
			DROP TABLE dbo.CapitalGiro_TEMP;

		COMMIT;
END TRY                
BEGIN CATCH
	ROLLBACK;
	print ERROR_MESSAGE()
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH

--exec Transacao.proc_InsereCapitalGiro