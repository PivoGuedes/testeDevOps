CREATE PROCEDURE Marketing.proc_InsereVincendosMensalAuto
AS
BEGIN TRY
	BEGIN TRAN
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Vincendos_TEMP') AND type in (N'U'))
		DROP TABLE dbo.Vincendos_TEMP;


	CREATE TABLE Vincendos_TEMP
	(
		 Codigo bigint not null
		,Agencia int
		,Ter_Vig Date
		,Apolice varchar(20)
		,CGCCPF VARCHAR(20)
		,Segurado VARCHAR(200)
		,Endereco VARCHAR(200)
		,Bairro VARCHAR(100)
		,Cidade VARCHAR(100)
		,UF VARCHAR(2)
		,CEP VARCHAR(10)
		,DDD varchar(3)
		,Fone varchar(10)
		,Email varchar(200)
		,Veiculo varchar(200)
		,AnoModelo int
		,Placa Varchar(10)
		,Chassi varchar(150)
		,FormaCobr varchar(200)
		,AgenciaDebito int
		,OperacaoDebito int 
		,ContaDebito int
		,DvConta varchar(1)
		,Produto varchar(200)
		,BonusConceder int
		,App decimal(18,2)
		,RCDM decimal(18,2)
		,RCDP decimal(18,2)
		,VL_Mercado varchar(1)
		,Economiario varchar(200)
		,Matricula varchar(20)
		,DDDUnidade varchar(3)
		,FoneUnidade varchar(10)
		,Tem_Sinistro varchar(1)
		,TP_Franquia varchar(100)
		,Tem_Endosso varchar(1)
		,Tem_Parc_Pend varchar(1)
		,DDDCelular varchar(3)
		,Celular varchar(10)
		,DDDComercial varchar(3)
		,TELComercial varchar(10)
		,DataArquivo Date
		,NomeArquivo Varchar(200)
		CONSTRAINT PK_VincendosAuto_TEMP PRIMARY KEY CLUSTERED(codigo)
	)
	--Definir ponto parada correto
	set @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='VincendosMensalAuto')
	SET @Comando = 'Insert into Vincendos_TEMP (
								Codigo
								,Agencia
								,Ter_Vig
								,Apolice
								,CGCCPF
								,Segurado
								,Endereco
								,Bairro
								,Cidade
								,UF
								,CEP
								,DDD
								,Fone
								,Email
								,Veiculo
								,AnoModelo
								,Placa
								,Chassi
								,FormaCobr
								,AgenciaDebito
								,OperacaoDebito
								,ContaDebito
								,DvConta
								,Produto
								,BonusConceder
								,App
								,RCDM
								,RCDP
								,VL_Mercado
								,Economiario
								,Matricula
								,DDDUnidade
								,FoneUnidade
								,Tem_Sinistro
								,TP_Franquia
								,Tem_Endosso
								,Tem_Parc_Pend
								,DDDCelular
								,Celular
								,DDDComercial
								,TELComercial
								,DataArquivo
								,NomeArquivo
					)
					SELECT  Codigo
						,Agencia
						,Ter_Vig
						,Apolice
						,CGCCPF
						,Segurado
						,Endereco
						,Bairro
						,Cidade
						,UF
						,CEP
						,DDD
						,Fone
						,Email
						,Veiculo
						,AnoModelo
						,Placa
						,Chassi
						,FormaCobr
						,AgenciaDebito
						,OperacaoDebito
						,ContaDebito
						,DvConta
						,Produto
						,BonusConceder
						,App
						,RCDM
						,RCDP
						,VL_Mercado
						,Economiario
						,Matricula
						,DDDUnidade
						,FoneUnidade
						,Tem_Sinistro
						,TP_Franquia
						,Tem_Endosso
						,Tem_Parc_Pend
						,DDDCelular
						,Celular
						,DDDComercial
						,TELComercial
						,DataArquivo
						,NomeArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_VincendosMensal ''''' + @PontoParada + ''''''') PRP'
	EXEC(@Comando)

	SELECT @MaiorID=MAx(Codigo)
	from Vincendos_TEMP

	SET @PontoParada = @MaiorID
	WHILE @MaiorID IS NOT NULL
	BEGIN
		--Verifica existencia da apolice na tabela Dados.Contrato
		MERGE INTO Dados.Contrato AS C USING
		(
			SELECT DISTINCT 
				Apolice
				,Ter_Vig
				,DataArquivo
				,NomeArquivo
			FROM Vincendos_TEMP
		) AS T
		ON T.Apolice=C.NumeroContrato
		WHEN NOT MATCHED THEN INSERT (NumeroContrato,DataFimVigencia,DataArquivo,Arquivo)
			VALUES (Apolice,Ter_Vig,DataArquivo,NomeArquivo);

		
		MERGE INTO Dados.ContratoCliente as C USING
		(
			SELECT DISTINCT
				c.Id IDContrato
				,CGCCPF
				,LEFT(Segurado,140) Segurado
				,LEFT(Endereco,40) Endereco
				,LEFT(Bairro,20) Bairro
				,LEFT(Cidade,20) Cidade
				,UF
				,CEP
				,DDD
				,Fone
				,Email
				,Case WHEN CHARINDEX('/',CGCCPF) > 0 THEN 'Pessoa Jurídica' ELSE 'Pessoa Física' END TipoPessoa
				,ISNULL(t.DataArquivo,getdate()) DataArquivo
				,NomeArquivo
			from Vincendos_TEMP as t
			INNER JOIN Dados.Contrato c
			ON NumeroContrato=Apolice
		) as T
		ON t.IDContrato=C.IDContrato
		AND C.CPFCNPJ=T.CGCCPF
		WHEN NOT MATCHED THEN INSERT (IDCOntrato,TipoPessoa,CPFCNPJ,NomeCliente,DDD,Telefone,Endereco,Bairro,Cidade,UF
			,CEP,DataArquivo,Arquivo,Codigocliente)
			VALUES (IDCOntrato,TipoPessoa,CGCCPF,Segurado,DDD,Fone,Endereco,Bairro,Cidade,UF,CEP
			,T.DataArquivo,T.NomeArquivo,
			(select MAX(CodigoCliente) + 1 from Dados.ContratoCliente));

		--Cadastra os dados na Tabela Retenção Auto
		MERGE INTO Marketing.VincendosAuto AS C USING
		(
			select Distinct 
					c.Id IdContrato
					,ISNULL(cc.CodigoCliente,0) CodigoCliente
					,u.Id IdAgencia
					,Email
					,Veiculo
					,AnoModelo
					,Placa
					,Chassi
					,FormaCobr
					,AgenciaDebito
					,OperacaoDebito
					,ContaDebito
					,DvConta
					,Produto
					,BonusConceder
					,App
					,RCDM
					,RCDP
					,VL_Mercado
					,Economiario
					,Matricula
					,DDDUnidade
					,FoneUnidade
					,Tem_Sinistro
					,TP_Franquia
					,Tem_Endosso
					,Tem_Parc_Pend
					,DDDCelular
					,Celular
					,DDDComercial
					,TELComercial
					,l.NomeArquivo
					,l.DataArquivo
			from Vincendos_TEMP l
			inner join dados.contrato c
			on c.numerocontrato = l.Apolice
			inner join dados.contratocliente cc
			on cc.cpfcnpj = l.cgccpf
			and c.id=cc.IDContrato
			inner join dados.unidade u
			on u.codigo = l.Agencia
		)
		AS T
		ON C.IdContrato = T.IdContrato
		AND C.CodigoCliente = T.CodigoCliente
		AND C.Chassi = T.Chassi
		WHEN NOT MATCHED THEN INSERT(IdContrato,CodigoCliente,IDAgencia,Email,Veiculo,Anomodelo,Placa,Chassi,FormaCobranca,AgenciaDebito
				,OperacaoConta,ContaDebito,DvConta,Produto,ClasseBonus,App,Rcdm,Rcdp,IsValorMercado,Economiario,Matricula,DddUnidade,
				FoneUnidade,TemSinistro,TipoFranquia,PossuiEndosso,PossuiParcelaPendente,DddCelular,Celular,DddComercial,TelefoneComercial
				,NomeArquivo,DataArquivo)
			VALUES (IdContrato,CodigoCliente,IdAgencia,Email,Veiculo,AnoModelo,Placa,Chassi,FormaCobr,AgenciaDebito,OperacaoDebito
					,ContaDebito,DvConta,Produto,BonusConceder,App,RCDM,RCDP,VL_Mercado,Economiario,Matricula,DDDUnidade,FoneUnidade
					,Tem_Sinistro,TP_Franquia,Tem_Endosso,Tem_Parc_Pend,DDDCelular,Celular,DDDComercial,TELComercial,NomeArquivo,DataArquivo)
		;

		truncate table Vincendos_TEMP
		
	SET @Comando = 'Insert into Vincendos_TEMP (
								Codigo
								,Agencia
								,Ter_Vig
								,Apolice
								,CGCCPF
								,Segurado
								,Endereco
								,Bairro
								,Cidade
								,UF
								,CEP
								,DDD
								,Fone
								,Email
								,Veiculo
								,AnoModelo
								,Placa
								,Chassi
								,FormaCobr
								,AgenciaDebito
								,OperacaoDebito
								,ContaDebito
								,DvConta
								,Produto
								,BonusConceder
								,App
								,RCDM
								,RCDP
								,VL_Mercado
								,Economiario
								,Matricula
								,DDDUnidade
								,FoneUnidade
								,Tem_Sinistro
								,TP_Franquia
								,Tem_Endosso
								,Tem_Parc_Pend
								,DDDCelular
								,Celular
								,DDDComercial
								,TELComercial
								,DataArquivo
								,NomeArquivo
					)
					SELECT  Codigo
						,Agencia
						,Ter_Vig
						,Apolice
						,CGCCPF
						,Segurado
						,Endereco
						,Bairro
						,Cidade
						,UF
						,CEP
						,DDD
						,Fone
						,Email
						,Veiculo
						,AnoModelo
						,Placa
						,Chassi
						,FormaCobr
						,AgenciaDebito
						,OperacaoDebito
						,ContaDebito
						,DvConta
						,Produto
						,BonusConceder
						,App
						,RCDM
						,RCDP
						,VL_Mercado
						,Economiario
						,Matricula
						,DDDUnidade
						,FoneUnidade
						,Tem_Sinistro
						,TP_Franquia
						,Tem_Endosso
						,Tem_Parc_Pend
						,DDDCelular
						,Celular
						,DDDComercial
						,TELComercial
						,DataArquivo
						,NomeArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_VincendosMensal ''''' + @PontoParada + ''''''') PRP'
		EXEC(@Comando)

		SELECT @MaiorID=MAx(Codigo)
		from Vincendos_TEMP

		IF(@MaiorID IS NOT NULL)
			SET @PontoParada = @MaiorID

		print @PontoParada
	END

	if(@PontoParada IS NOT NULL)
		--Atualiza o ponto de parada
		update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='VincendosMensalAuto'
	
	--DROP Data tabela temporária
	DROP TABLE Vincendos_TEMP;
	Commit;
END TRY                
BEGIN CATCH
	ROLLBACK
	PRINT ERROR_MESSAGE ( )   
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH
