CREATE PROCEDURE Marketing.proc_InsereProrej
AS
BEGIN TRY
	BEGIN TRAN
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Prorej_TEMP') AND type in (N'U'))
		DROP TABLE dbo.Prorej_TEMP;

	CREATE TABLE Prorej_TEMP
	(
		 ID BIGINT
		,PropostaSIvPF VARCHAR(20)
		,CDProduto INT
		,EndossoProv VARCHAR(5)
		,CdCorretor INT
		,CPFCNPJ VARCHAR(20)
		,DtEmissao date
		,CdErro int
		,Erro varchar(150)
		,DtRecusa date
		,ApoliceProv varchar(20)
		,DescRecusa varchar(200)
		,NuPropostaSIVPF varchar(20)
		,CodFilial int
		,CdAgencia int
		,DescAgencia varchar(200)
		,Recusa varchar(20)
		,Mensagem varchar(200)
		,Descricao varchar(150)
		,NomeArquivo varchar(200)
		,DataArquivo Date
	)

	--Definir ponto parada correto
	select @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='Prorej')
	SET @Comando = 'Insert into Prorej_TEMP (
					    ID
						,PropostaSIvPF
						,CDProduto
						,EndossoProv
						,CdCorretor
						,CPFCNPJ
						,DtEmissao
						,CdErro
						,Erro
						,DtRecusa
						,ApoliceProv
						,DescRecusa
						,NuPropostaSIVPF
						,CodFilial
						,CdAgencia
						,DescAgencia
						,Recusa
						,Mensagem
						,Descricao
						,NomeArquivo
						,DataArquivo
					)
					SELECT  ID
						,PropostaSIvPF
						,CDProduto
						,EndossoProv
						,CdCorretor
						,CPFCNPJ
						,DtEmissao
						,CdErro
						,Erro
						,DtRecusa
						,ApoliceProv
						,DescRecusa
						,NuPropostaSIVPF
						,CodFilial
						,CdAgencia
						,DescAgencia
						,Recusa
						,Mensagem
						,Descricao
						,NomeArquivo
						,DataArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_PROREJ ''''' + @PontoParada + ''''''') PRP'
	EXEC(@Comando)

	SELECT @MaiorID=MAx(ID)
	from Prorej_TEMP

	SET @PontoParada = @MaiorID
	WHILE @MaiorID IS NOT NULL
	BEGIN
		
		MERGE INTO Marketing.TipoErro AS E USING
		(
			select distinct 
				CdErro
				,Erro
			from Prorej_TEMP
		)
		as T
		ON T.CdErro = E.codigo
		WHEN NOT MATCHED THEN INSERT (Codigo,Descricao) VALUES (CdErro,Erro);


		MERGE INTO Dados.Proposta AS C USING
		(
			select DISTINCT 
				PropostaSivPF
				,prd.Id IdProduto
				,(select ID from corporativo.dados.situacaoproposta where Sigla='REJ') IdSituacaoProposta
				,DtEmissao
				,DtRecusa
				,DataArquivo
				,'Prorej' TipoDado
			from Prorej_TEMP l
			left join Dados.Produto prd
			on prd.codigocomercializado=RIGHT('0000' + CAST(l.CdPRoduto as varchar(4)),4)
			where l.dataarquivo = (select max(DataArquivo) from prorej_TEMP where propostasivpf=l.propostasivpf)
		) as T
		ON T.PropostaSIVPF = C.NumeroProposta
			WHEN NOT MATCHED THEN INSERT (NumeroProposta,IdProduto,DataEmissao,DataSituacao,IDSituacaoProposta,DataArquivo,TipoDado)
				values (T.PropostaSIVPF,T.IdProduto,T.DtEmissao,T.DtRecusa,T.IdSituacaoProposta,T.DataArquivo,TipoDado)
		;

		MERGE INTO Dados.PropostaCliente AS C USING
		(
			select DISTINCT 
				 p.ID IDProposta
				,CPFCNPJ
				,CASE WHEN CHARINDEX('/',CPFCNPJ,1) > 0 then 'Pessoa Jurídica' ELSE 'Pessoa Física' END TipoPessoa
				,'PROREJ' as TipoDado
				,l.DataArquivo
			from Prorej_TEMP l
			inner join Dados.Proposta p
			on p.NumeroProposta = l.PropostaSIVPF
			where l.dataarquivo = (select max(DataArquivo) from prorej_TEMP where propostasivpf=l.propostasivpf)
		) as T
		ON C.CPFCNPJ=T.CPFCNPJ
		AND C.IDProposta=T.IDProposta
		WHEN NOT MATCHED THEN INSERT (IDProposta,CPFCNPJ,TipoPessoa,TipoDado,DataArquivo)
			values (IDProposta,T.CPFCNPJ,T.TipoPessoa,T.TipoDado,T.DataArquivo)
		;


		--Cadastra os dados na Tabela VendasPrevidencia
		MERGE INTO Marketing.Prorej AS C USING
		(
			select Distinct 
				 p.ID IDCliente
				,pr.ID IDProposta
				,u.ID idAgencia
				,t.Id IdTipoErro
				,EndossoProv
				,CdCorretor
				,DtRecusa
				,ApoliceProv
				,Recusa
				,null CdCorretorVC
				,Mensagem
				,l.Descricao
				,l.DataArquivo
			from Prorej_TEMP l
			inner join dados.PropostaCliente p
			on l.CPFCNPJ=p.CPFCNPJ
			inner join dados.Proposta pr
			on pr.ID=p.IDProposta
			and RIGHT(pr.NumeroProposta,14)=RIGHT(l.PropostaSIVPF,14)
			inner join Dados.Unidade u
			on u.Codigo=l.CdAgencia
			inner join Marketing.TipoErro t
			on t.Codigo=l.CdErro
		)
		AS T
		ON C.IDProposta = T.IDProposta
		AND C.IDCliente = T.IDCliente
		WHEN NOT MATCHED THEN INSERT(IDCliente,IDProposta,IDAgencia,IdTipoErro,EndossoProv,CdCorretor,DtRecusa,ApoliceProv,Recusa,CdCorretorVC,Mensagem,Descricao,DataArquivo)
			VALUES (IDCliente,IDProposta,IDAgencia,IdTipoErro,EndossoProv,CdCorretor,DtRecusa,ApoliceProv,Recusa,CdCorretorVC,Mensagem,Descricao,DataArquivo)
		;

		truncate table Prorej_TEMP
		SET @Comando = 'Insert into Prorej_TEMP (
					    ID
						,PropostaSIvPF
						,CDProduto
						,EndossoProv
						,CdCorretor
						,CPFCNPJ
						,DtEmissao
						,CdErro
						,Erro
						,DtRecusa
						,ApoliceProv
						,DescRecusa
						,NuPropostaSIVPF
						,CodFilial
						,CdAgencia
						,DescAgencia
						,Recusa
						,Mensagem
						,Descricao
						,NomeArquivo
						,DataArquivo
					)
					SELECT  ID
						,PropostaSIvPF
						,CDProduto
						,EndossoProv
						,CdCorretor
						,CPFCNPJ
						,DtEmissao
						,CdErro
						,Erro
						,DtRecusa
						,ApoliceProv
						,DescRecusa
						,NuPropostaSIVPF
						,CodFilial
						,CdAgencia
						,DescAgencia
						,Recusa
						,Mensagem
						,Descricao
						,NomeArquivo
						,DataArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_PROREJ ''''' + @PontoParada + ''''''') PRP'
		EXEC(@Comando)

		SELECT @MaiorID=MAx(ID)
		from Prorej_TEMP

		IF(@MaiorID IS NOT NULL)
			SET @PontoParada = @MaiorID

	END

	if(@PontoParada IS NOT NULL)
		--Atualiza o ponto de parada
		update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='Prorej'
	
	--DROP Data tabela temporária
	DROP TABLE Prorej_TEMP;
	Commit;
END TRY                
BEGIN CATCH
	ROLLBACK
	PRINT ERROR_MESSAGE ( )   
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH

--exec Marketing.proc_InsereProrej

--select * from ControleDados.PontoParada where nomeentidade='Prorej'
--insert into ControleDados.PontoParada values ('Prorej',0)