CREATE PROCEDURE Marketing.proc_InsereMundoCaixa
AS
BEGIN TRY
	BEGIN TRAN
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.MundoCaixa_TEMP') AND type in (N'U'))
		DROP TABLE dbo.MundoCaixa_TEMP;

	CREATE TABLE MundoCaixa_TEMP
	(
		  Codigo bigint
		  ,Nome varchar(500)
		  ,CPFCNPJ VARCHAR(50)
		  ,DataNascimento Date
		  ,Matricula int
		  ,Empresa varchar(300)
		  ,TelefoneComercial varchar(50)
		  ,TelefonePessoal varchar(50)
		  ,Celular varchar(50)
		  ,UnidadeLotacao varchar(500)
		  ,EnderecoPessoal varchaR(500)
		  ,UFPessoal varchar(2)
		  ,EnderecoComercial varchar(500)
		  ,UFComercial varchar(2)
		  ,CARGO varchar(100)
		  ,Sexo varchar(1)
		  ,Tipo varchar(100)
		  ,EstadoCivil varchar(100)
		  ,QuantidadeFilhos int
		  ,Escolaridade varchar(200)
		  ,Formacao varchar(250)
		  ,EmailPessoal varchar(300)
		  ,EmailComercial varchar(300)
		  ,AssociadoFENAE varchar(3)
		  ,AssociadoFUNCEF varchar(3)
		  ,DataultimoLogin Date
		  ,Aposentado varchar(3)
		  ,Pensionista varchar(3)
		  ,BloqueadoResgate varchar(3)
		  ,Positivado varchar(3)
		  ,Ativo varchar(3)
		  ,Senhaexpirada varchar(3)
		  ,ExigeCodigoSMS varchar(3)
		  ,DataUltimaAtualizacao Date
		  ,NomeArquivo varchar(250)
		  ,DataArquivo date
	)

	--Definir ponto parada correto
	select @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='BaseMundoCaixa')
	SET @Comando = 'Insert into MundoCaixa_TEMP (
					    [Codigo]
					  ,[Nome]
					  ,[CPFCNPJ]
					  ,[DataNascimento]
					  ,[Matricula]
					  ,[Empresa]
					  ,[TelefoneComercial]
					  ,[TelefonePessoal]
					  ,[Celular]
					  ,[UnidadeLotacao]
					  ,[EnderecoPessoal]
					  ,[UFPessoal]
					  ,[EnderecoComercial]
					  ,[UFComercial]
					  ,[CARGO]
					  ,[Sexo]
					  ,[Tipo]
					  ,[EstadoCivil]
					  ,[QuantidadeFilhos]
					  ,[Escolaridade]
					  ,[Formacao]
					  ,[EmailPessoal]
					  ,[EmailComercial]
					  ,[AssociadoFENAE]
					  ,[AssociadoFUNCEF]
					  ,[DataultimoLogin]
					  ,[Aposentado]
					  ,[Pensionista]
					  ,[BloqueadoResgate]
					  ,[Positivado]
					  ,[Ativo]
					  ,[Senhaexpirada]
					  ,[ExigeCodigoSMS]
					  ,[DataUltimaAtualizacao]
					  ,[NomeArquivo]
					  ,[DataArquivo]
					)
					SELECT  [Codigo]
						  ,[Nome]
						  ,[CPFCNPJ]
						  ,[DataNascimento]
						  ,[Matricula]
						  ,[Empresa]
						  ,[TelefoneComercial]
						  ,[TelefonePessoal]
						  ,[Celular]
						  ,[UnidadeLotacao]
						  ,[EnderecoPessoal]
						  ,[UFPessoal]
						  ,[EnderecoComercial]
						  ,[UFComercial]
						  ,[CARGO]
						  ,[Sexo]
						  ,[Tipo]
						  ,[EstadoCivil]
						  ,[QuantidadeFilhos]
						  ,[Escolaridade]
						  ,[Formacao]
						  ,[EmailPessoal]
						  ,[EmailComercial]
						  ,[AssociadoFENAE]
						  ,[AssociadoFUNCEF]
						  ,[DataultimoLogin]
						  ,[Aposentado]
						  ,[Pensionista]
						  ,[BloqueadoResgate]
						  ,[Positivado]
						  ,[Ativo]
						  ,[Senhaexpirada]
						  ,[ExigeCodigoSMS]
						  ,[DataUltimaAtualizacao]
						  ,[NomeArquivo]
						  ,[DataArquivo]
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_RecuperaBaseMundoCaixa ''''' + @PontoParada + ''''''') PRP'
	EXEC(@Comando)

	SELECT @MaiorID=MAx(Codigo)
	from MundoCaixa_TEMP

	SET @PontoParada = @MaiorID
	WHILE @MaiorID IS NOT NULL
	BEGIN
		--Garante que a Empresa esteja cadastrada
		MERGE INTO Dados.Empresa AS C USING
		(
			select Distinct 
				CASE ISNULL(Empresa,'')
					WHEN 'CAIXA' THEN 'CAIXA Economica'
					WHEN 'Caixa Seguradora' THEN 'CAIXA Seguros'
					WHEN 'Fenae Federação' THEN 'FENAE'
					ELSE ISNULL(Empresa,'') 
				END Nome
			from MundoCaixa_TEMP 
		)
		AS T
		ON C.Nome = T.Nome
		WHEN NOT MATCHED THEN INSERT(Nome,Descricao)
			VALUES (T.Nome,'')
		;
		print 'Empresa Deu merge'
		--Garante que o Cargo esteja cadastrado
		MERGE INTO Dados.Cargo AS C USING
		(
			select Distinct 
				UPPER(Cargo) Cargo
			from MundoCaixa_TEMP 
		)
		AS T
		ON C.Cargo = T.Cargo
		WHEN NOT MATCHED THEN INSERT(Cargo,DataCadastro)
			VALUES (T.Cargo,getdate())
		;
		print 'Cargo Deu merge'
		--Garante que o Estado Civil esteja cadastrado
		MERGE INTO Dados.EstadoCivil AS C USING
		(
			select Distinct 
				CASE 
					WHEN ISNULL(EstadoCivil,'')='' THEN 'Não Informado'
					ELSE EstadoCivil
				END EstadoCivil
			from MundoCaixa_TEMP 
		)
		AS T
		ON C.Descricao = T.EstadoCivil
		WHEN NOT MATCHED THEN INSERT(ID,Descricao)
			VALUES ((SELECT MAX(ID) + 1 FROM Dados.EstadoCivil),EstadoCivil)
		;
		print 'Estado Civil Deu merge'
		--Garante que UnidadeLotacao esteja cadastrado
		MERGE INTO Marketing.UnidadeLotacao AS C USING
		(
			select Distinct 
				UnidadeLotacao
			from MundoCaixa_TEMP 
		)
		AS T
		ON C.Descricao = T.UnidadeLotacao
		WHEN NOT MATCHED THEN INSERT(Descricao)
			VALUES (UnidadeLotacao)
		;
		print 'Unidade de Lotação Deu merge'
		--Cadastra os dados na Tabela FuncionarioMundoCaixa
		--select * from Marketing.FuncionarioMundoCaixa
		--select top 1 * from MundoCaixa_TEMP v
		MERGE INTO Marketing.FuncionarioMundoCaixa AS C USING
		(
			select *
			from ( 
				Select p.ID IDEmpresa,c.ID IDCargo,e.ID IDEstadoCivil,s.ID IDSexo,u.ID IDUnidadeLotacao,v.Nome,v.CPFCNPJ,DataNascimento,Matricula,TelefoneComercial,TelefonePessoal,Celular, Tipo, Escolaridade
					,Formacao,EmailPessoal,EmailComercial, CASE AssociadoFENAE WHEN 'NÃO' THEN 0 ELSE 1 END IsAssociadoFENAE, CASE AssociadoFUNCEF WHEN 'NÃO' THEN 0 ELSE 1 END IsAssociadoFUNCEF
					,DataUltimoLogin, CASE Aposentado WHEN 'NÃO' THEN 0 ELSE 1 END IsAposentado,  CASE Pensionista WHEN 'NÃO' THEN 0 ELSE 1 END IsPensionista,
					CASE BloqueadoResgate WHEN 'NÃO' THEN 0 ELSE 1 END IsBloqueado, CASE Positivado WHEN 'NÃO' THEN 0 ELSE 1 END IsPositivado,CASE Ativo WHEN 'NÃO' THEN 0 ELSE 1 END IsAtivo,
					CASE SenhaExpirada WHEN 'NÃO' THEN 0 ELSE 1 END SenhaExpirada, CASE ExigeCodigoSMS WHEN 'NÃO' THEN 0 ELSE 1 END ExigeCodigoSMS,DataUltimaAtualizacao, DataArquivo
					,ROW_NUMBER() OVER(PARTITION BY CPFCNPJ Order by DataArquivo Desc) Ordem
				from MundoCaixa_TEMP v
				inner join Dados.Empresa p
				on CASE ISNULL(Empresa,'')
						WHEN 'CAIXA' THEN 'CAIXA Economica'
						WHEN 'Caixa Seguradora' THEN 'CAIXA Seguros'
						WHEN 'Fenae Federação' THEN 'FENAE'
						ELSE ISNULL(Empresa,'') 
					END = p.Nome
				inner join Dados.Cargo c
				on c.Cargo=UPPER(v.Cargo)
				inner join Dados.EstadoCivil e
				on e.Descricao = CASE 
						WHEN ISNULL(EstadoCivil,'')='' THEN 'Não Informado'
						ELSE EstadoCivil
					END
				inner join dados.Sexo s
				on s.Sigla=v.Sexo
				inner join Marketing.UnidadeLotacao u
				on u.Descricao=v.UnidadeLotacao
			) as x
			where Ordem=1
		)
		AS T
		ON C.CPF = T.CPFCNPJ
		WHEN NOT MATCHED THEN INSERT(IDEmpresa,IDCargo,IDEstadoCivil,IDSexo,IDUnidadeLotacao,Nome,CPF,DataNascimento,Matricula,TelefoneComercial,TelefonePessoal,TelefoneCelular,TipoPessoa
				,Escolaridade,Formacao,EmailPessoal,EmailComercial,IsAssociadoFenae,IsAssociadoFuncef,DataUltimoLogin,IsAposentado,IsPensionista,IsBloqueadoResgate,IsPositivado,IsAtivo,IsSenhaexpirada
				,ExigeCodigoSms,DataUltimaAtualizacao,DataArquivo)
			VALUES (IDEmpresa,IDCargo,IDEstadoCivil,IDSexo,IDUnidadeLotacao,Nome,CPFCNPJ,DataNascimento,Matricula,TelefoneComercial,TelefonePessoal,Celular, Tipo, Escolaridade
					,Formacao,EmailPessoal,EmailComercial,IsAssociadoFENAE,IsAssociadoFUNCEF,DataUltimoLogin,IsAposentado,IsPensionista,IsBloqueado,IsPositivado,IsAtivo,
					SenhaExpirada,ExigeCodigoSMS,DataUltimaAtualizacao, DataArquivo)
		;
		print 'Funcionário mundo Caixa Deu merge'
		--select * from dados.tipoendereco
		--Insere o Endereco Pessoal do funcionario
		MERGE INTO Marketing.Endereco AS C USING
		(
			select Distinct 
				f.ID IDFuncionario
				,1 IDTipoEndereco
				,EnderecoPessoal
				,UFPessoal
			from MundoCaixa_TEMP m
			inner join Marketing.FuncionarioMundoCaixa f
			on m.CPFCNPJ=f.CPF
		)
		AS T
		ON C.IDFuncionarioMundoCaixa = T.IDFuncionario
		AND C.IDTipoEndereco=T.IDTipoEndereco
		WHEN NOT MATCHED THEN INSERT(IDFuncionarioMundoCaixa,IDTipoEndereco,Endereco,UF)
			VALUES (IDFuncionario,IDTipoEndereco,EnderecoPessoal,UFPessoal)
		;
		print 'Endereço Pessoal Deu merge'
		--Insere o Endereco Pessoal do funcionario
		MERGE INTO Marketing.Endereco AS C USING
		(
			select Distinct 
				f.ID IDFuncionario
				,6 IDTipoEndereco
				,EnderecoComercial
				,UFComercial
			from MundoCaixa_TEMP m
			inner join Marketing.FuncionarioMundoCaixa f
			on m.CPFCNPJ=f.CPF
		)
		AS T
		ON C.IDFuncionarioMundoCaixa = T.IDFuncionario
		AND C.IDTipoEndereco=T.IDTipoEndereco
		WHEN NOT MATCHED THEN INSERT(IDFuncionarioMundoCaixa,IDTipoEndereco,Endereco,UF)
			VALUES (IDFuncionario,IDTipoEndereco,EnderecoComercial,UFComercial)
		;
		print 'Endereço Comercial Deu merge'
		truncate table MundoCaixa_TEMP
		SET @Comando = 'Insert into MundoCaixa_TEMP (
					    [Codigo]
					  ,[Nome]
					  ,[CPFCNPJ]
					  ,[DataNascimento]
					  ,[Matricula]
					  ,[Empresa]
					  ,[TelefoneComercial]
					  ,[TelefonePessoal]
					  ,[Celular]
					  ,[UnidadeLotacao]
					  ,[EnderecoPessoal]
					  ,[UFPessoal]
					  ,[EnderecoComercial]
					  ,[UFComercial]
					  ,[CARGO]
					  ,[Sexo]
					  ,[Tipo]
					  ,[EstadoCivil]
					  ,[QuantidadeFilhos]
					  ,[Escolaridade]
					  ,[Formacao]
					  ,[EmailPessoal]
					  ,[EmailComercial]
					  ,[AssociadoFENAE]
					  ,[AssociadoFUNCEF]
					  ,[DataultimoLogin]
					  ,[Aposentado]
					  ,[Pensionista]
					  ,[BloqueadoResgate]
					  ,[Positivado]
					  ,[Ativo]
					  ,[Senhaexpirada]
					  ,[ExigeCodigoSMS]
					  ,[DataUltimaAtualizacao]
					  ,[NomeArquivo]
					  ,[DataArquivo]
					)
					SELECT  [Codigo]
						  ,[Nome]
						  ,[CPFCNPJ]
						  ,[DataNascimento]
						  ,[Matricula]
						  ,[Empresa]
						  ,[TelefoneComercial]
						  ,[TelefonePessoal]
						  ,[Celular]
						  ,[UnidadeLotacao]
						  ,[EnderecoPessoal]
						  ,[UFPessoal]
						  ,[EnderecoComercial]
						  ,[UFComercial]
						  ,[CARGO]
						  ,[Sexo]
						  ,[Tipo]
						  ,[EstadoCivil]
						  ,[QuantidadeFilhos]
						  ,[Escolaridade]
						  ,[Formacao]
						  ,[EmailPessoal]
						  ,[EmailComercial]
						  ,[AssociadoFENAE]
						  ,[AssociadoFUNCEF]
						  ,[DataultimoLogin]
						  ,[Aposentado]
						  ,[Pensionista]
						  ,[BloqueadoResgate]
						  ,[Positivado]
						  ,[Ativo]
						  ,[Senhaexpirada]
						  ,[ExigeCodigoSMS]
						  ,[DataUltimaAtualizacao]
						  ,[NomeArquivo]
						  ,[DataArquivo]
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_RecuperaBaseMundoCaixa ''''' + @PontoParada + ''''''') PRP'
		EXEC(@Comando)

		SELECT @MaiorID=MAx(Codigo)
		from MundoCaixa_TEMP

		IF(@MaiorID IS NOT NULL)
			SET @PontoParada = @MaiorID

	END

	if(@PontoParada IS NOT NULL)
		--Atualiza o ponto de parada
		update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='BaseMundoCaixa'
	
	--DROP Data tabela temporária
	DROP TABLE MundoCaixa_TEMP
	Commit
END TRY                
BEGIN CATCH
	ROLLBACK
	PRINT ERROR_MESSAGE ( )   
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH

--exec Marketing.proc_InsereMundoCaixa

--select * from ControleDados.PontoParada where nomeentidade='BaseMundoCaixa'

--insert into ControleDados.PontoParada values ('BaseMundoCaixa',0)