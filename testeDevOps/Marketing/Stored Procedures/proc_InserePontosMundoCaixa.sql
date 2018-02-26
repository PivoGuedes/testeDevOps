CREATE PROCEDURE Marketing.proc_InserePontosMundoCaixa
AS
BEGIN TRY
	BEGIN TRAN
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.PontosMundoCaixa_TEMP') AND type in (N'U'))
		DROP TABLE dbo.PontosMundoCaixa_TEMP;

	CREATE TABLE PontosMundoCaixa_TEMP
	(
		 Codigo BIGINT NOT NULL,
			CPF varchar(20) Not null,
			SaldoMesAnterior decimal (18,2) not null default 0,
			CreditosMesAtual decimal (18,2) not null default 0,
			ResgateMesAtual decimal (18,2) not null default 0,
			PontosExpirar decimal (18,2) not null default 0,
			SaldoAtual decimal (18,2) not null default 0,
			DataArquivo Date not null,
			DataHoraSistema Datetime2 not null default getdate()
	)

	--Definir ponto parada correto
	select @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='PontosMundoCaixa')
	SET @Comando = 'Insert into PontosMundoCaixa_TEMP (
					    Codigo
						,CPF
						,SaldoMesAnterior
						,CreditosMesAtual
						,ResgateMesAtual
						,PontosExpirar
						,SaldoAtual
						,DataArquivo
						,DataHoraSistema
					)
					SELECT  Codigo
							,CPF
							,SaldoMesAnterior
							,CreditosMesAtual
							,ResgateMesAtual
							,PontosExpirar
							,SaldoAtual
							,DataArquivo
							,DataHoraSistema
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_CaixaNews ''''' + @PontoParada + ''''''') PRP'
	EXEC(@Comando)

	SELECT @MaiorID=MAx(Codigo)
	from PontosMundoCaixa_TEMP

	SET @PontoParada = @MaiorID
	WHILE @MaiorID IS NOT NULL
	BEGIN
		
		--Cadastra os dados na Tabela VendasPrevidencia
		MERGE INTO Marketing.PontosMundoCaixa AS C USING
		(
			select Distinct 
				 f.ID IDFuncionario
				,SaldoMesAnterior
				,CreditosMesAtual
				,ResgateMesAtual
				,PontosExpirar
				,SaldoAtual
				,l.DataArquivo
				,DataHoraSistema
			from PontosMundoCaixa_TEMP l
			inner join Dados.Funcionario f
			on f.cpf=l.cpf
		)
		AS T
		ON C.IdFuncionario=T.IDFuncionario
		AND C.DataArquivo = T.DataArquivo
		WHEN NOT MATCHED THEN INSERT(IdFuncionario,SaldoMesanterior,CreditosMesAtual,ResgateMesAtual,PontosExpirar,SaldoAtual,DataArquivo,DataHoraSistema)
			VALUES (IDFuncionario,SaldoMesanterior,CreditosMesAtual,ResgateMesAtual,PontosExpirar,SaldoAtual,DataArquivo,DataHoraSistema)
		;

		truncate table PontosMundoCaixa_TEMP
		SET @Comando = 'Insert into PontosMundoCaixa_TEMP (
					    Codigo
						,CPF
						,SaldoMesAnterior
						,CreditosMesAtual
						,ResgateMesAtual
						,PontosExpirar
						,SaldoAtual
						,DataArquivo
						,DataHoraSistema
					)
					SELECT  Codigo
							,CPF
							,SaldoMesAnterior
							,CreditosMesAtual
							,ResgateMesAtual
							,PontosExpirar
							,SaldoAtual
							,DataArquivo
							,DataHoraSistema
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_CaixaNews ''''' + @PontoParada + ''''''') PRP'
		EXEC(@Comando)

		SELECT @MaiorID=MAx(Codigo)
		from PontosMundoCaixa_TEMP

		IF(@MaiorID IS NOT NULL)
			SET @PontoParada = @MaiorID

	END

	if(@PontoParada IS NOT NULL)
		--Atualiza o ponto de parada
		update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='PontosMundoCaixa'
	
	--DROP Data tabela temporária
	DROP TABLE PontosMundoCaixa_TEMP;
	Commit;
END TRY                
BEGIN CATCH
	ROLLBACK
	PRINT ERROR_MESSAGE ( )   
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH

--exec Marketing.proc_InserePontosMundoCaixa

--select * from ControleDados.PontoParada where nomeentidade='PontosMundoCaixa'
--insert into ControleDados.PontoParada values ('PontosMundoCaixa',0)