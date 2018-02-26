CREATE PROCEDURE Marketing.proc_InsereLastChance
AS
BEGIN TRY
	BEGIN TRAN
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.LastChance_TEMP') AND type in (N'U'))
		DROP TABLE dbo.LastChance_TEMP;

	CREATE TABLE LastChance_TEMP
	(
		 Codigo Bigint
		,CPF VARCHAR(20)
		,Proposta varchar(20)
		,Telefone VARCHAR(20)
		,TelefoneAlternativo varchar(200)
		,Motivo varchar(200)
		,Interacao varchaR(200)
		,RenovacaoAutomatica varchar(200)
		,MotivosRecusas varchaR(200)
		,IsContaCorreta varchar(200)
		,ContaCorreta varchar(200)
		,DataArquivo Date
	)

	--Definir ponto parada correto
	select @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='LastChance')
	SET @Comando = 'Insert into LastChance_TEMP (
					    Codigo
						,CPF
						,Proposta
						,Telefone
						,TelefoneAlternativo
						,Motivo
						,Interacao
						,RenovacaoAutomatica
						,MotivosRecusas
						,IsContaCorreta
						,ContaCorreta
						,DataArquivo
					)
					SELECT  Codigo
							,CPF
							,Proposta
							,Telefone
							,TelefoneAlternativo
							,Motivo
							,Interacao
							,RenovacaoAutomatica
							,MotivosRecusas
							,IsContaCorreta
							,ContaCorreta
							,DataArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_LastChance ''''' + @PontoParada + ''''''') PRP'
	EXEC(@Comando)

	SELECT @MaiorID=MAx(Codigo)
	from LastChance_TEMP

	SET @PontoParada = @MaiorID
	WHILE @MaiorID IS NOT NULL
	BEGIN
		
		MERGE INTO Dados.Proposta AS C USING
		(
			select *
			from (
			select DISTINCT 
				Proposta
				,DataArquivo
				,ROW_NUMBER() OVER (PARTITION BY Proposta order by DataArquivo desc) Ordem
			from LastChance_TEMP l
			where proposta not like '%conta%'
			) as x
			where Ordem=1
			
		) as T
		ON RIGHT(T.Proposta,12) = RIGHT(C.NumeroProposta,12)
		WHEN NOT MATCHED THEN INSERT (NumeroProposta,IdProduto,IdCanalVendaPAR,TipoDado,DataArquivo)
			values (T.Proposta,-1,-1,'LastChance',T.DataArquivo)
		;

		MERGE INTO Dados.PropostaCliente AS C USING
		(
			select DISTINCT 
				 p.ID IDProposta
				,CPF
				,LEFT(Telefone,2) DDD
				,RIGHT(Telefone,8) Telefone
				,LEFT(TelefoneAlternativo,2) DDDCelular
				,Right(TelefoneAlternativo,8) TelefoneCelular
				,l.DataArquivo
			from LastChance_TEMP l
			inner join Dados.Proposta p
			on RIGHT(p.NumeroProposta,12) = RIGHT(l.Proposta,12)
		) as T
		ON C.CPFCNPJ=T.CPF
		AND C.IDProposta=T.IDProposta
		WHEN NOT MATCHED THEN INSERT (IDProposta,CPFCNPJ,TipoPessoa,DDDResidencial,TelefoneResidencial,DDDCelular,TelefoneCelular,TipoDado,DataArquivo)
			values (IDProposta,CPF,'Pessoa Física',DDD,Telefone,DDDCelular,TelefoneCelular,'Lastchance',DataArquivo)
		;

		--Cadastra os dados na Tabela VendasPrevidencia
		MERGE INTO Marketing.LastChance AS C USING
		(
			select Distinct 
				 p.ID IDCliente
				,pr.ID IDProposta
				,Telefone
				,TelefoneAlternativo
				,Motivo
				,Interacao
				,l.RenovacaoAutomatica
				,MotivosRecusas
				,IsContaCorreta
				,ContaCorreta
			from LastChance_TEMP l
			inner join dados.PropostaCliente p
			on l.CPF=p.CPFCNPJ
			inner join dados.Proposta pr
			on pr.ID=p.IDProposta
			and RIGHT(pr.NumeroProposta,12)=RIGHT(l.Proposta,12)
		)
		AS T
		ON C.IDProposta = T.IDProposta
		AND C.IDCliente = T.IDCliente
		WHEN NOT MATCHED THEN INSERT(IDCliente,IDProposta,Telefone,TelefoneAlternativo,Motivo,Interacao,RenovacaoAutomatica,MotivosRecusas,IscontaCorreta,ContaCorreta)
			VALUES (IDCliente,IDProposta,Telefone,TelefoneAlternativo,Motivo,Interacao,RenovacaoAutomatica,MotivosRecusas,IscontaCorreta,ContaCorreta)
		;

		truncate table LastChance_TEMP
		SET @Comando = 'Insert into LastChance_TEMP (
					    Codigo
						,CPF
						,Proposta
						,Telefone
						,TelefoneAlternativo
						,Motivo
						,Interacao
						,RenovacaoAutomatica
						,MotivosRecusas
						,IsContaCorreta
						,ContaCorreta
						,DataArquivo
					)
					SELECT  Codigo
							,CPF
							,Proposta
							,Telefone
							,TelefoneAlternativo
							,Motivo
							,Interacao
							,RenovacaoAutomatica
							,MotivosRecusas
							,IsContaCorreta
							,ContaCorreta
							,DataArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_LastChance ''''' + @PontoParada + ''''''') PRP'
		EXEC(@Comando)

		SELECT @MaiorID=MAx(Codigo)
		from LastChance_TEMP

		IF(@MaiorID IS NOT NULL)
			SET @PontoParada = @MaiorID

	END

	if(@PontoParada IS NOT NULL)
		--Atualiza o ponto de parada
		update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='LastChance'
	
	--DROP Data tabela temporária
	DROP TABLE LastChance_TEMP
	Commit
END TRY                
BEGIN CATCH
	ROLLBACK
	PRINT ERROR_MESSAGE ( )   
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH

--exec Marketing.proc_InsereLastChance

--select * from ControleDados.PontoParada where nomeentidade='LastChance'
--insert into ControleDados.PontoParada values ('LastChance',0)