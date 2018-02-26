CREATE PROCEDURE [Marketing].[proc_InsereRetencaoAuto]
AS
BEGIN TRY
	--BEGIN TRAN
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Retencao_TEMP') AND type in (N'U'))
		DROP TABLE dbo.Retencao_TEMP;


	CREATE TABLE Retencao_TEMP
	(
		 Codigo bigint not null
		,CodigoProduto int
		,NomeProduto varchar(100)
		,NumeroApolice varchar(20)
		,NumeroEndosso varchar(20)
		,AgenciaVenda int
		,NomeCliente varchar(200)
		,DataNascimento date
		,CPFCNPJ varchar(20)
		,InicioVigencia date
		,FimVigencia date
		,Parcela int
		,DataSelecao date
		,DataCancelamento date
		,AnoFabricacao int
		,AnoModelo int
		,Placa varchar(15)
		,TelefoneComercial varchar(20)
		,TelefoneResidencial varchar(20)
		,TelefoneCelular varchar(20)
		,Email varchar(200)
		,DataArquivo Date
		,NomeArquivo Varchar(200)
	)

	create clustered index idx_ApoliceCliente on Retencao_TEMP(NumeroApolice,CpfCnpj)

	--Definir ponto parada correto
	select @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='RetencaoAuto')
	SET @Comando = 'Insert into Retencao_TEMP (
					    Codigo
						,CodigoProduto
						,NomeProduto
						,NumeroApolice
						,NumeroEndosso
						,AgenciaVenda
						,NomeCliente
						,DataNascimento
						,CPFCNPJ
						,InicioVigencia
						,FimVigencia
						,Parcela
						,DataSelecao
						,DataCancelamento
						,AnoFabricacao
						,AnoModelo
						,Placa
						,TelefoneComercial
						,TelefoneResidencial
						,TelefoneCelular
						,Email
						,DataArquivo
						,NomeArquivo
					)
					SELECT  Codigo
						,CodigoProduto
						,NomeProduto
						,NumeroApolice
						,NumeroEndosso
						,AgenciaVenda
						,NomeCliente
						,DataNascimento
						,CPFCNPJ
						,InicioVigencia
						,FimVigencia
						,Parcela
						,DataSelecao
						,DataCancelamento
						,AnoFabricacao
						,AnoModelo
						,Placa
						,TelefoneComercial
						,TelefoneResidencial
						,TelefoneCelular
						,Email
						,DataArquivo
						,NomeArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_RetencaoAuto ''''' + @PontoParada + ''''''') PRP'
	EXEC(@Comando)

	SELECT @MaiorID=MAx(Codigo)
	from Retencao_TEMP

	SET @PontoParada = @MaiorID
	WHILE @MaiorID IS NOT NULL
	BEGIN
		--Verifica existencia da apolice na tabela Dados.Contrato
		MERGE INTO Dados.Contrato AS C USING
		(
			SELECT DISTINCT 
				1 IdSeguradora
				,NumeroApolice
				,DataCancelamento
				,DataArquivo
				,NomeArquivo
			FROM Retencao_TEMP
		) AS T
		ON T.NumeroApolice=C.NumeroContrato
		WHEN NOT MATCHED THEN INSERT (IdSeguradora,NumeroContrato,DataCancelamento,DataArquivo,Arquivo)
			VALUES (IdSeguradora,NumeroApolice,DataCancelamento,DataArquivo,NomeArquivo);



		--Por questões de performance crio uma tabela temporária com o contrato e o IDContrato
		--Query de 17Hrs rodando em 0 segundos
		select ID,NumeroContrato
		into #CNTContrato
		from dados.contrato
		where numerocontrato in (
			select numeroapolice from Retencao_TEMP
		)

		create clustered index idx_ContratoTemp on #CNTContrato(Id,NumeroContrato)

		--Insere o endosso na tabela dados.endosso
		MERGE INTO Dados.Endosso AS C USING
		(
			SELECT  DISTINCT
				c.ID as IDCOntrato
				,p.Id as IDPROduto
				,NumeroEndosso
				,t.DataArquivo
				,NomeArquivo
			FROM Retencao_TEMP t
			INNER JOIN Dados.Contrato c
			ON NumeroContrato=NumeroApolice
			inner join dados.produto p
			on p.CodigoComercializado = cast(t.codigoproduto as varchaR(5))
		) AS T
		ON T.NumeroEndosso=C.NumeroEndosso
		AND T.IdContrato=C.IdContrato
		WHEN NOT MATCHED THEN INSERT (IDContrato,IDPRoduto,NumeroEndosso,DataArquivo,Arquivo)
			VALUES (IDContrato,IDProduto,NumeroEndosso,DataArquivo,NomeArquivo);

			
		MERGE INTO Dados.ContratoCliente as C USING
		(
			SELECT DISTINCT
				c.Id IDContrato
				,LEFT(NomeCliente,140) Nomecliente
				,DataNascimento
				,RIGHT(LTRIM(RTRIM(CPFCNPJ)),18) CPFCNPJ
				,LEFT(TelefoneResidencial,2) DDD
				,RIGHT(TelefoneResidencial,8) Telefone
				,ISNULL(t.DataArquivo,getdate()) DataArquivo
				,LEFT(NomeArquivo,80) NomeArquivo
			from Retencao_TEMP as t
			INNER JOIN Dados.Contrato c
			ON NumeroContrato=NumeroApolice
		) as T
		ON t.IDContrato=C.IDContrato
		AND C.CPFCNPJ=T.CPFCNPJ
		WHEN NOT MATCHED THEN INSERT (IDCOntrato,TipoPessoa,CPFCNPJ,NomeCliente,DDD,Telefone,DataArquivo,Arquivo)
			VALUES (IDCOntrato,'Pessoa Física',CPFCNPJ,NomeCliente,DDD,Telefone,DataArquivo,NomeArquivo);

		--Cadastra os dados na Tabela Retenção Auto
		MERGE INTO Marketing.RetencaoAuto AS C USING
		(
			select  DISTINCT
					c.Id IdContrato
					,COALESCE(CodigoCliente,0) CodigoCliente
					,p.ID IDProduto
					,e.Id IdEndosso
					,u.Id IdAgencia
					,Parcela
					,l.DataCancelamento
					,DataSelecao
					,AnoFabricacao
					,AnoModelo
					,Placa
					,TelefoneComercial
					,TelefoneResidencial
					,TelefoneCelular
					,Email
					,l.DataArquivo
			from Retencao_TEMP l
			inner join #CNTContrato c
			on c.numerocontrato = l.NumeroApolice
			--inner join dados.endosso e
			--on e.numeroendosso = l.NumeroEndosso
			--and e.IDContrato=c.ID
			--and e.ID=(select max(ID) from dados.Endosso where NumeroEndosso=e.NumeroEndosso and IDContrato=e.IDContrato)
			inner join dados.produto p
			on p.CodigoComercializado = cast(l.codigoproduto as varchaR(5))
			inner join dados.unidade u
			on u.codigo = l.AgenciaVenda
			outer apply(
				select CodigoCliente
				from dados.contratocliente
				where cpfcnpj = l.cpfcnpj
				and c.id=IDContrato
			) cc
			outer apply (
				select top 1 ID
				from dados.endosso
				where numeroendosso = l.NumeroEndosso
				and IDContrato=c.ID
				order by ID desc
			) e
		)
		AS T
		ON C.IdContrato = T.IdContrato
		AND C.CodigoCliente = T.CodigoCliente
		AND ISNULL(C.IdEndosso,0) = ISNULL(T.IdEndosso,0)
		WHEN NOT MATCHED THEN INSERT(IdContrato,CodigoCliente,IdPRoduto,IDEndosso,IDAgencia,Parcela,DataCancelamento,DataSelecao,AnoFabricacao,AnoModelo,Placa,TelefoneComercial,
			TelefoneResidencial,TelefoneCelular,Email,DataArquivo)
			VALUES (IdContrato,CodigoCliente,IdPRoduto,IDEndosso,IDAgencia,Parcela,DataCancelamento,DataSelecao,AnoFabricacao,AnoModelo,Placa,TelefoneComercial,
			TelefoneResidencial,TelefoneCelular,Email,DataArquivo)
		;

		truncate table Retencao_TEMP
		
	SET @Comando = 'Insert into Retencao_TEMP (
					    Codigo
						,CodigoProduto
						,NomeProduto
						,NumeroApolice
						,NumeroEndosso
						,AgenciaVenda
						,NomeCliente
						,DataNascimento
						,CPFCNPJ
						,InicioVigencia
						,FimVigencia
						,Parcela
						,DataSelecao
						,DataCancelamento
						,AnoFabricacao
						,AnoModelo
						,Placa
						,TelefoneComercial
						,TelefoneResidencial
						,TelefoneCelular
						,Email
					)
					SELECT  Codigo
						,CodigoProduto
						,NomeProduto
						,NumeroApolice
						,NumeroEndosso
						,AgenciaVenda
						,NomeCliente
						,DataNascimento
						,CPFCNPJ
						,InicioVigencia
						,FimVigencia
						,Parcela
						,DataSelecao
						,DataCancelamento
						,AnoFabricacao
						,AnoModelo
						,Placa
						,TelefoneComercial
						,TelefoneResidencial
						,TelefoneCelular
						,Email
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_RetencaoAuto ''''' + @PontoParada + ''''''') PRP'
		EXEC(@Comando)

		SELECT @MaiorID=MAx(Codigo)
		from Retencao_TEMP

		IF(@MaiorID IS NOT NULL)
			SET @PontoParada = @MaiorID
	END

	if(@PontoParada IS NOT NULL)
		--Atualiza o ponto de parada
		update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='RetencaoAuto'
	
	--DROP Data tabela temporária
	DROP TABLE Retencao_TEMP;
	--Commit;
END TRY                
BEGIN CATCH
	--ROLLBACK
	PRINT ERROR_MESSAGE ( )   
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH

--exec Marketing.proc_InsereRetencaoAuto

--select * from ControleDados.PontoParada where nomeentidade='RetencaoAuto'
--insert into ControleDados.PontoParada values ('RetencaoAuto',0)


