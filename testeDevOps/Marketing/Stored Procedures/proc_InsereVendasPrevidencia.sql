CREATE PROCEDURE Marketing.proc_InsereVendasPrevidencia
AS
BEGIN TRY
	BEGIN TRAN
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.VendasPrevidencia_TEMP') AND type in (N'U'))
		DROP TABLE dbo.VendasPrevidencia_TEMP;


	CREATE TABLE VendasPrevidencia_TEMP
	(
		 Codigo INT NOT NULL
		,Cod_Cuenta INT
		,Proposta VARCHAR(20)
		,Dt_Proposta Date
		,Cod_Producto varchar(20)
		,Cod_Agencia INT
		,Cod_Sr INT
		,Sobrevida_Contratado_Pm decimal(18,2)
		,Risco_Contratado_Pm decimal(18,2)
		,SobreVida_Contratado_PU decimal(18,2)
		,Risco_Contratado_PU decimal(18,2)
		,Prazo int
		,Sexo varchar(1)
		,Data_Nascimento Date
		,Renda_Participante int
		,CPFCNPJ varchar(20)
		,DT_Emissao date
	)

	--Definir ponto parada correto
	select @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='VendasPrevidencia')
	SET @Comando = 'Insert into VendasPrevidencia_TEMP (
					    Codigo
							,Cod_Cuenta
							,Proposta
							,Dt_Proposta
							,Cod_Producto
							,Cod_Agencia
							,Cod_Sr
							,Sobrevida_Contratado_Pm
							,Risco_Contratado_Pm
							,SobreVida_Contratado_PU
							,Risco_Contratado_PU
							,Prazo
							,Sexo
							,Data_Nascimento
							,Renda_Participante
							,CPFCNPJ
							,DT_Emissao
					)
					SELECT  Codigo
							,Cod_Cuenta
							,Proposta
							,Dt_Proposta
							,Cod_Producto
							,Cod_Agencia
							,Cod_Sr
							,Sobrevida_Contratado_Pm
							,Risco_Contratado_Pm
							,SobreVida_Contratado_PU
							,Risco_Contratado_PU
							,Prazo
							,Sexo
							,Data_Nascimento
							,Renda_Participante
							,CPFCNPJ
							,DT_Emissao
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_VendasPrevidencia ''''' + @PontoParada + ''''''') PRP'
	EXEC(@Comando)

	SELECT @MaiorID=MAx(Codigo)
	from VendasPrevidencia_TEMP

	SET @PontoParada = @MaiorID
	WHILE @MaiorID IS NOT NULL
	BEGIN
		--Garante que a proposta esteja cadastrada
		MERGE INTO Dados.Proposta AS C USING
		(
			select p.ID IDProduto
				,p.IdSeguradora
				,Proposta
				,Dt_Proposta
				,u.ID idAgencia
				,'Vendas_Previdencia' TipoDado
				,getdate() DataArquivo
			from VendasPrevidencia_TEMP v
			inner join Dados.Produto p
			on p.CodigoComercializado = v.Cod_Producto
			inner join Dados.Unidade u
			on u.Codigo = v.Cod_Agencia
		)
		AS T
		ON C.NumeroProposta = T.Proposta
		WHEN NOT MATCHED THEN INSERT(NumeroProposta,IDSeguradora,IDProduto,DataProposta,IDAgenciaVenda,TipoDado,DataArquivo)
			VALUES (Proposta,IdSeguradora,IdProduto,Dt_Proposta,IDAgencia,TipoDado,DataArquivo)
		;

		--Cadastra o Cliente na Base de Proposta cliente caso não exista
		MERGE INTO Dados.PropostaCliente AS C USING
		(
			select p.ID IDProposta
				   ,s.ID IDSexo
				   ,CPFCNPJ
				   ,Data_Nascimento
			from VendasPrevidencia_TEMP v
			inner join Dados.Proposta p
			on p.NumeroProposta = Proposta
			inner join Dados.Sexo s
			on Left(s.Descricao,1) = v.Sexo
		)
		AS T
		ON C.CPFCNPJ = T.CPFCNPJ
		AND C.IDProposta = T.IDProposta
		WHEN NOT MATCHED THEN INSERT(IDProposta,IDSexo,CPFCNPJ,DataNascimento)
			VALUES (IDProposta,IDSexo,CPFCNPJ,Data_Nascimento)
		;
		
		--Cadastra os dados na Tabela VendasPrevidencia
		MERGE INTO Marketing.VendasPrevidencia AS C USING
		(
			select p.ID IDProposta
				   ,p.IDAgenciaVenda
				   ,SobreVida_Contratado_Pm
				   ,Risco_Contratado_Pm
				   ,SobreVida_COntratado_Pu
				   ,Risco_Contratado_Pu
				   ,Prazo
				   ,Renda_Participante
				   ,Dt_Emissao
			from VendasPrevidencia_TEMP v
			inner join Dados.Proposta p
			on p.NumeroProposta = Proposta
		)
		AS T
		ON C.IDPRoposta = T.IdProposta
		WHEN NOT MATCHED THEN INSERT(IDProposta,IDUnidade,SobreVidaContratadoPm,RiscoContratadoPm,SobreVidaContratadoPu,RiscoContratadoPu,Prazo,RendaParticipante,DtEmissao)
			VALUES (IDProposta,IDAgenciaVenda,SobreVida_Contratado_Pm,Risco_Contratado_Pm,SobreVida_COntratado_Pu,Risco_Contratado_Pu,Prazo,Renda_Participante,Dt_Emissao)
		;


		truncate table VendasPrevidencia_TEMP
		SET @Comando = 'Insert into VendasPrevidencia_TEMP (
					    Codigo
							,Cod_Cuenta
							,Proposta
							,Dt_Proposta
							,Cod_Producto
							,Cod_Agencia
							,Cod_Sr
							,Sobrevida_Contratado_Pm
							,Risco_Contratado_Pm
							,SobreVida_Contratado_PU
							,Risco_Contratado_PU
							,Prazo
							,Sexo
							,Data_Nascimento
							,Renda_Participante
							,CPFCNPJ
							,DT_Emissao
					)
					SELECT  Codigo
							,Cod_Cuenta
							,Proposta
							,Dt_Proposta
							,Cod_Producto
							,Cod_Agencia
							,Cod_Sr
							,Sobrevida_Contratado_Pm
							,Risco_Contratado_Pm
							,SobreVida_Contratado_PU
							,Risco_Contratado_PU
							,Prazo
							,Sexo
							,Data_Nascimento
							,Renda_Participante
							,CPFCNPJ
							,DT_Emissao
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_VendasPrevidencia ''''' + @PontoParada + ''''''') PRP'
		EXEC(@Comando)

		SELECT @MaiorID=MAx(Codigo)
		from VendasPrevidencia_TEMP

		IF(@MaiorID IS NOT NULL)
			SET @PontoParada = @MaiorID

	END

	if(@PontoParada IS NOT NULL)
		--Atualiza o ponto de parada
		update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='VendasPrevidencia'
	
	--DROP Data tabela temporária
	DROP TABLE VendasPrevidencia_TEMP
	Commit
END TRY                
BEGIN CATCH
	ROLLBACK
	PRINT ERROR_MESSAGE ( )   
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH

--exec Marketing.proc_InsereVendasPrevidencia

--select * from ControleDados.PontoParada where nomeentidade='VendasPrevidencia'

--insert into ControleDados.PontoParada values ('VendasPrevidencia',0)