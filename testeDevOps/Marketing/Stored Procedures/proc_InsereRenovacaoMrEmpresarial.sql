CREATE PROCEDURE Marketing.proc_InsereRenovacaoMrEmpresarial
AS
BEGIN TRY
	--BEGIN TRAN
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.RenovacaoMrEmpresarial_TEMP') AND type in (N'U'))
		DROP TABLE dbo.RenovacaoMrEmpresarial_TEMP;


	CREATE TABLE RenovacaoMrEmpresarial_TEMP
	(
		 Codigo BIGINT
		,CODIGOPRODUTO INT
		,CENTROCUSTO INT
		,DIAPROTECAO varchar(200)
		,NOMESEGURADO  varchar(200)
		,Telefone varchar(20)
		,NUMCPFCNPJ varchar(20)
		,NUMRG varchar(20)
		,ORGAORG varchar(50)
		,DataEmissao Date
		,ENDSEGURADO varchar(200)
		,BAIRROSEGURADO varchar(200) 
		,CIDADESEGURADO varchar(200) 
		,ESTADOSEGURADO varchar(200)
		,RENOVAPOLICE  varchar(20)
		,VIGENCIA Date
		,COBERTURA01  varchar(200)
		,VALORINDENIZA01 decimal(18,2)
		,COBERTURA02 varchar(200)
		,VALORINDENIZA02 decimal(18,2)
		,COBERTURA03  varchar(200)
		,VALORINDENIZA03 decimal(18,2)
		,COBERTURA04  varchar(200)
		,VALORINDENIZA04 decimal(18,2)
		,COBERTURA05  varchar(200)
		,VALORINDENIZA05 decimal(18,2)
		,COBERTURA06  varchar(200)
		,VALORINDENIZA06 decimal(18,2)
		,COBERTURA07  varchar(200)
		,VALORINDENIZA07 decimal(18,2)
		,COBERTURA08  varchar(200)
		,VALORINDENIZA08 decimal(18,2)
		,COBERTURA09  varchar(200)
		,VALORINDENIZA09 decimal(18,2)
		,COBERTURA10  varchar(200)
		,VALORINDENIZA10 decimal(18,2)
		,COBERTURA11  varchar(200)
		,VALORINDENIZA11 decimal(18,2)
		,COBERTURA12  varchar(200)
		,VALORINDENIZA12 decimal(18,2)
		,COBERTURA13  varchar(200)
		,VALORINDENIZA13 decimal(18,2)
		,COBERTURA14  varchar(200)
		,VALORINDENIZA14 decimal(18,2)
		,COBERTURA15  varchar(200)
		,VALORINDENIZA15 decimal(18,2)
		,COBERTURA16  varchar(200)
		,VALORINDENIZA16 decimal(18,2)
		,COBERTURA17  varchar(200)
		,VALORINDENIZA17 decimal(18,2)
		,COBERTURA18  varchar(200)
		,VALORINDENIZA18 decimal(18,2)
		,COBERTURA19  varchar(200)
		,VALORINDENIZA19 decimal(18,2)
		,COBERTURA20  varchar(200)
		,VALORINDENIZA20 decimal(18,2)
		,COBERTURA21  varchar(200)
		,VALORINDENIZA21 decimal(18,2)
		,COBERTURA22  varchar(200)
		,VALORINDENIZA22 decimal(18,2)
		,COBERTURA23  varchar(200)
		,VALORINDENIZA23 decimal(18,2)
		,PRMLIQUIDO decimal(18,2)
		,PRMIOF decimal(18,2)
		,PRMTOTAL decimal(18,2)
		,PAGENTRADA decimal(18,2)
		,PARCELA int
		,PAGPARCELAS decimal(18,2)
		,NUMCDBARRA  varchar(200)
		,LOCALDEPAGAMENTO  varchar(200)
		,DTVENCTO Date
		,NCEDENTE  varchar(200)
		,CEDENTE  varchar(200)
		,DTDOCTO Date
		,NUMDOCTO  varchar(200)
		,DTPROCESS Date
		,NSNUMERO  varchar(200)
		,VALDOCTO decimal(18,2)
		,MENSA1  varchar(200)
		,MENSA2  varchar(200)
		,MENSA3  varchar(200)
		,MENSA4  varchar(200)
		,MENSA5  varchar(200)
		,MENSA6  varchar(200)
		,MENSA7  varchar(200)
		,VALCOBRADO decimal(18,2)
		,CODBARRA  varchar(200)
		,SACADOR  varchar(200)
		,END_SAC  varchar(200)
		,CEP_SAC  varchar(200)
		,CGCCPFSUB  varchar(200)
		,DTPOSTAGEM  varchar(200)
		,NUMOBJETO  varchar(200)
		,DESTINATARIO  varchar(200)
		,ENDERECO  varchar(200)
		,BAIRRO  varchar(200)
		,CIDADE  varchar(200)
		,UF  varchar(200)
		,CEP  varchar(200)
		,VLDESCONTO decimal(18,2)
		,CUSTOAPOLICE  decimal(18,2)
		,ENCARGOS  decimal(18,2)
		,DESCONTO decimal(18,2)
		,DataArquivo Date
		,NomeArquivo varchar(200)
	)

	--Definir ponto parada correto
	select @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='RenovacaoMrEmpresarial')
	SET @Comando = 'Insert into RenovacaoMrEmpresarial_TEMP (
					    Codigo
						,CODIGOPRODUTO
						,CENTROCUSTO
						,DIAPROTECAO
						,NOMESEGURADO
						,Telefone
						,NUMCPFCNPJ
						,NUMRG
						,ORGAORG
						,DataEmissao
						,ENDSEGURADO
						,BAIRROSEGURADO
						,CIDADESEGURADO
						,ESTADOSEGURADO
						,RENOVAPOLICE
						,VIGENCIA
						,COBERTURA01
						,VALORINDENIZA01
						,COBERTURA02
						,VALORINDENIZA02
						,COBERTURA03
						,VALORINDENIZA03
						,COBERTURA04
						,VALORINDENIZA04
						,COBERTURA05
						,VALORINDENIZA05
						,COBERTURA06
						,VALORINDENIZA06
						,COBERTURA07
						,VALORINDENIZA07
						,COBERTURA08
						,VALORINDENIZA08
						,COBERTURA09
						,VALORINDENIZA09
						,COBERTURA10
						,VALORINDENIZA10
						,COBERTURA11
						,VALORINDENIZA11
						,COBERTURA12
						,VALORINDENIZA12
						,COBERTURA13
						,VALORINDENIZA13
						,COBERTURA14
						,VALORINDENIZA14
						,COBERTURA15
						,VALORINDENIZA15
						,COBERTURA16
						,VALORINDENIZA16
						,COBERTURA17
						,VALORINDENIZA17
						,COBERTURA18
						,VALORINDENIZA18
						,COBERTURA19
						,VALORINDENIZA19
						,COBERTURA20
						,VALORINDENIZA20
						,COBERTURA21
						,VALORINDENIZA21
						,COBERTURA22
						,VALORINDENIZA22
						,COBERTURA23
						,VALORINDENIZA23
						,PRMLIQUIDO
						,PRMIOF
						,PRMTOTAL
						,PAGENTRADA
						,PARCELA
						,PAGPARCELAS
						,NUMCDBARRA
						,LOCALDEPAGAMENTO
						,DTVENCTO
						,NCEDENTE
						,CEDENTE
						,DTDOCTO
						,NUMDOCTO
						,DTPROCESS
						,NSNUMERO
						,VALDOCTO
						,MENSA1
						,MENSA2
						,MENSA3
						,MENSA4
						,MENSA5
						,MENSA6
						,MENSA7
						,VALCOBRADO
						,CODBARRA
						,SACADOR
						,END_SAC
						,CEP_SAC
						,CGCCPFSUB
						,DTPOSTAGEM
						,NUMOBJETO
						,DESTINATARIO
						,ENDERECO
						,BAIRRO
						,CIDADE
						,UF
						,CEP
						,VLDESCONTO
						,CUSTOAPOLICE
						,ENCARGOS
						,DESCONTO
						,DataArquivo
						,NomeArquivo
					)
					SELECT  Codigo
							,CODIGOPRODUTO
							,CENTROCUSTO
							,DIAPROTECAO
							,NOMESEGURADO
							,Telefone
							,NUMCPFCNPJ
							,NUMRG
							,ORGAORG
							,DataEmissao
							,ENDSEGURADO
							,BAIRROSEGURADO
							,CIDADESEGURADO
							,ESTADOSEGURADO
							,RENOVAPOLICE
							,VIGENCIA
							,COBERTURA01
							,VALORINDENIZA01
							,COBERTURA02
							,VALORINDENIZA02
							,COBERTURA03
							,VALORINDENIZA03
							,COBERTURA04
							,VALORINDENIZA04
							,COBERTURA05
							,VALORINDENIZA05
							,COBERTURA06
							,VALORINDENIZA06
							,COBERTURA07
							,VALORINDENIZA07
							,COBERTURA08
							,VALORINDENIZA08
							,COBERTURA09
							,VALORINDENIZA09
							,COBERTURA10
							,VALORINDENIZA10
							,COBERTURA11
							,VALORINDENIZA11
							,COBERTURA12
							,VALORINDENIZA12
							,COBERTURA13
							,VALORINDENIZA13
							,COBERTURA14
							,VALORINDENIZA14
							,COBERTURA15
							,VALORINDENIZA15
							,COBERTURA16
							,VALORINDENIZA16
							,COBERTURA17
							,VALORINDENIZA17
							,COBERTURA18
							,VALORINDENIZA18
							,COBERTURA19
							,VALORINDENIZA19
							,COBERTURA20
							,VALORINDENIZA20
							,COBERTURA21
							,VALORINDENIZA21
							,COBERTURA22
							,VALORINDENIZA22
							,COBERTURA23
							,VALORINDENIZA23
							,PRMLIQUIDO
							,PRMIOF
							,PRMTOTAL
							,PAGENTRADA
							,PARCELA
							,PAGPARCELAS
							,NUMCDBARRA
							,LOCALDEPAGAMENTO
							,DTVENCTO
							,NCEDENTE
							,CEDENTE
							,DTDOCTO
							,NUMDOCTO
							,DTPROCESS
							,NSNUMERO
							,VALDOCTO
							,MENSA1
							,MENSA2
							,MENSA3
							,MENSA4
							,MENSA5
							,MENSA6
							,MENSA7
							,VALCOBRADO
							,CODBARRA
							,SACADOR
							,END_SAC
							,CEP_SAC
							,CGCCPFSUB
							,DTPOSTAGEM
							,NUMOBJETO
							,DESTINATARIO
							,ENDERECO
							,BAIRRO
							,CIDADE
							,UF
							,CEP
							,VLDESCONTO
							,CUSTOAPOLICE
							,ENCARGOS
							,DESCONTO
							,DataArquivo
							,NomeArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_RenovacaoMREmpresarial ''''' + @PontoParada + ''''''') PRP'
	EXEC(@Comando)

	SELECT @MaiorID=MAx(Codigo)
	from RenovacaoMrEmpresarial_TEMP

	SET @PontoParada = @MaiorID
	WHILE @MaiorID IS NOT NULL
	BEGIN
		--Verifica existencia da apolice na tabela Dados.Contrato
		MERGE INTO Dados.Contrato AS C USING
		(
			SELECT DISTINCT 
				RENOVAPOLICE
				,DataEmissao
				,VIGENCIA
				,PRMLIQUIDO
				,PRMTOTAL
				,PARCELA
				,NOMESEGURADO
				,ENDSEGURADO
				,BAIRROSEGURADO
				,CIDADESEGURADO
				,ESTADOSEGURADO
				,DataArquivo
				,NomeArquivo
			FROM RenovacaoMrEmpresarial_TEMP
		) AS T
		ON T.RENOVAPOLICE=C.NumeroContrato
		WHEN NOT MATCHED THEN INSERT (NumeroContrato,DataEmissao,DataFimVigencia,ValorPremioLiquido,ValorPremioTotal,QuantidadeParcelas,NomeTomador,EnderecoLocalRisco
			,BairroLocalRisco,CidadeLocalRisco,UFLocalRisco,DataArquivo,Arquivo)
			VALUES (RENOVAPOLICE,DataEmissao,VIGENCIA,PRMLIQUIDO,PRMTOTAL,PARCELA,NOMESEGURADO,ENDSEGURADO,BAIRROSEGURADO,CIDADESEGURADO,ESTADOSEGURADO,DataArquivo,NomeArquivo);

		--Contrato Cliente
		MERGE INTO Dados.ContratoCliente as C USING
		(
			SELECT DISTINCT
				c.Id IDContrato
				,LEFT(NOMESEGURADO,140) NOMESEGURADO
				,NUMCPFCNPJ
				,LEFT(ENDSEGURADO,40) ENDSEGURADO
				,LEFT(BAIRROSEGURADO,20) BAIRROSEGURADO
				,LEFT(CIDADESEGURADO,20) CIDADESEGURADO
				,ESTADOSEGURADO
				,LEFT(Telefone,2) DDD
				,RIGHT(Telefone,8) Telefone
				,CASE WHEN LEN(NUMCPFCNPJ) = 18 THEN 'Pessoa Jurídica' ELSE 'Pessoa Física' END TipoPessoa
				,ISNULL(t.DataArquivo,getdate()) DataArquivo
				,ISNULL(NomeArquivo,'PRD.SIES.PI34606.DBM') NomeArquivo
			from RenovacaoMrEmpresarial_TEMP as t
			INNER JOIN Dados.Contrato c
			ON NumeroContrato=RENOVAPOLICE
		) as T
		ON t.IDContrato=C.IDContrato
		AND C.CPFCNPJ=T.NUMCPFCNPJ
		WHEN NOT MATCHED THEN INSERT (IDCOntrato,TipoPessoa,CPFCNPJ,NomeCliente,DDD,Telefone,Endereco,Bairro,Cidade,UF,DataArquivo,Arquivo,CodigoCliente)
			VALUES (IDContrato,TipoPessoa,NUMCPFCNPJ,NOMESEGURADO,DDD,Telefone,ENDSEGURADO,BAIRROSEGURADO,CIDADESEGURADO,ESTADOSEGURADO,DataArquivo,NomeArquivo,
				(select MAX(CodigoCliente) + 1 from dados.contratoCliente));

		--Cadastra os dados na Tabela Retenção Auto
		MERGE INTO Marketing.RenovacaoMrEmpresarial AS C USING
		(
			select Distinct 
					c.Id IdContrato
					,ISNULL(cc.CodigoCliente,0) CodigoCliente
					,p.ID IDProduto
					,DIAPROTECAO
					,NUMRG
					,ORGAORG
					,PRMIOF
					,NUMCDBARRA
					,LOCALDEPAGAMENTO
					,DTVENCTO
					,NCEDENTE
					,CEDENTE
					,DTDOCTO
					,NUMDOCTO
					,DTPROCESS
					,NSNUMERO
					,VALDOCTO
					,VALCOBRADO
					,VLDESCONTO
					,CUSTOAPOLICE
					,ENCARGOS
					,DESCONTO
			from RenovacaoMrEmpresarial_TEMP l
			inner join dados.contrato c
			on c.numerocontrato = l.RENOVAPOLICE
			inner join dados.contratocliente cc
			on cc.cpfcnpj = l.NUMCPFCNPJ
			and c.id=cc.IDContrato
			inner join dados.produto p
			on p.CodigoComercializado = cast(l.codigoproduto as varchaR(5))
		)
		AS T
		ON C.IdContrato = T.IdContrato
		AND C.CodigoCliente = T.CodigoCliente
		WHEN NOT MATCHED THEN INSERT(IdContrato,CodigoCliente,IdPRoduto,DiaProtecao,NumeroRg,OrgaoRg,ValorIof,NumeroCodigoBarra,LocalPagamento,DataVencimento,NomeCedente,
				Cedente,DataDocumento,NumeroDocumento,DataPRocessamento,NossoNumero,ValorDocumento,ValorCobrado,ValorDesconto,CustoApolice,Encargos,Desconto)
			VALUES (IdContrato,CodigoCliente,IdPRoduto,DIAPROTECAO,NUMRG,ORGAORG,PRMIOF,NUMCDBARRA,LOCALDEPAGAMENTO,DTVENCTO,NCEDENTE,CEDENTE,DTDOCTO,NUMDOCTO,DTPROCESS,NSNUMERO
				,VALDOCTO,VALCOBRADO,VLDESCONTO,CUSTOAPOLICE,ENCARGOS,DESCONTO)
		;

		declare @numeroCobertura int=1;
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.CoberturasRenovacaoMrEmpresarial_TEMP') AND type in (N'U'))
			DROP TABLE dbo.CoberturasRenovacaoMrEmpresarial_TEMP;

		CREATE TABLE CoberturasRenovacaoMrEmpresarial_TEMP
		(
			IDRenovacao Bigint not null
			,Descricao varchar(200) not null
			,ValorIS Decimal(18,2) not null
		)

		WHILE @numeroCobertura<24
		BEGIN
			SET @comando = 'insert into CoberturasRenovacaoMrEmpresarial_TEMP
							select DISTINCT r.Codigo IDRenovacao
								,COBERTURA' + RIGHT('00' + CAST(@numeroCobertura as varchar(2)),2) + '
								,VALORINDENIZA' + RIGHT('00' + CAST(@numeroCobertura as varchar(2)),2) + '
							from Marketing.RenovacaoMrEmpresarial r
							inner join Dados.Contrato c
							on c.Id=r.IdContrato
							inner join RenovacaoMrEmpresarial_TEMP t
							on t.RENOVAPOLICE=c.NumeroContrato
							Where COBERTURA' + RIGHT('00' + CAST(@numeroCobertura as varchar(2)),2) + ' IS NOT NULL
							AND VALORINDENIZA' + RIGHT('00' + CAST(@numeroCobertura as varchar(2)),2) + ' IS NOT NULL'
			EXEC(@Comando)
			SET @numeroCobertura = @numeroCobertura + 1
		END;

		MERGE INTO Marketing.CoberturaMrEmpresarial AS C
		USING (
			select DISTINCT IDRenovacao,Descricao,ValorIS
			from CoberturasRenovacaoMrEmpresarial_TEMP
		) as T
		ON T.IDRenovacao=c.CodigoRenovacao
		AND T.Descricao=C.Descricao
		WHEN NOT MATCHED THEN INSERT (CodigoRenovacao,Descricao,ValorIS)
			VALUES (IDRenovacao,Descricao,ValorIS);

		truncate table RenovacaoMrEmpresarial_TEMP
		
		SET @Comando = 'Insert into RenovacaoMrEmpresarial_TEMP (
					    Codigo
						,CODIGOPRODUTO
						,CENTROCUSTO
						,DIAPROTECAO
						,NOMESEGURADO
						,Telefone
						,NUMCPFCNPJ
						,NUMRG
						,ORGAORG
						,DataEmissao
						,ENDSEGURADO
						,BAIRROSEGURADO
						,CIDADESEGURADO
						,ESTADOSEGURADO
						,RENOVAPOLICE
						,VIGENCIA
						,COBERTURA01
						,VALORINDENIZA01
						,COBERTURA02
						,VALORINDENIZA02
						,COBERTURA03
						,VALORINDENIZA03
						,COBERTURA04
						,VALORINDENIZA04
						,COBERTURA05
						,VALORINDENIZA05
						,COBERTURA06
						,VALORINDENIZA06
						,COBERTURA07
						,VALORINDENIZA07
						,COBERTURA08
						,VALORINDENIZA08
						,COBERTURA09
						,VALORINDENIZA09
						,COBERTURA10
						,VALORINDENIZA10
						,COBERTURA11
						,VALORINDENIZA11
						,COBERTURA12
						,VALORINDENIZA12
						,COBERTURA13
						,VALORINDENIZA13
						,COBERTURA14
						,VALORINDENIZA14
						,COBERTURA15
						,VALORINDENIZA15
						,COBERTURA16
						,VALORINDENIZA16
						,COBERTURA17
						,VALORINDENIZA17
						,COBERTURA18
						,VALORINDENIZA18
						,COBERTURA19
						,VALORINDENIZA19
						,COBERTURA20
						,VALORINDENIZA20
						,COBERTURA21
						,VALORINDENIZA21
						,COBERTURA22
						,VALORINDENIZA22
						,COBERTURA23
						,VALORINDENIZA23
						,PRMLIQUIDO
						,PRMIOF
						,PRMTOTAL
						,PAGENTRADA
						,PARCELA
						,PAGPARCELAS
						,NUMCDBARRA
						,LOCALDEPAGAMENTO
						,DTVENCTO
						,NCEDENTE
						,CEDENTE
						,DTDOCTO
						,NUMDOCTO
						,DTPROCESS
						,NSNUMERO
						,VALDOCTO
						,MENSA1
						,MENSA2
						,MENSA3
						,MENSA4
						,MENSA5
						,MENSA6
						,MENSA7
						,VALCOBRADO
						,CODBARRA
						,SACADOR
						,END_SAC
						,CEP_SAC
						,CGCCPFSUB
						,DTPOSTAGEM
						,NUMOBJETO
						,DESTINATARIO
						,ENDERECO
						,BAIRRO
						,CIDADE
						,UF
						,CEP
						,VLDESCONTO
						,CUSTOAPOLICE
						,ENCARGOS
						,DESCONTO
						,DataArquivo
						,NomeArquivo
					)
					SELECT  Codigo
							,CODIGOPRODUTO
							,CENTROCUSTO
							,DIAPROTECAO
							,NOMESEGURADO
							,Telefone
							,NUMCPFCNPJ
							,NUMRG
							,ORGAORG
							,DataEmissao
							,ENDSEGURADO
							,BAIRROSEGURADO
							,CIDADESEGURADO
							,ESTADOSEGURADO
							,RENOVAPOLICE
							,VIGENCIA
							,COBERTURA01
							,VALORINDENIZA01
							,COBERTURA02
							,VALORINDENIZA02
							,COBERTURA03
							,VALORINDENIZA03
							,COBERTURA04
							,VALORINDENIZA04
							,COBERTURA05
							,VALORINDENIZA05
							,COBERTURA06
							,VALORINDENIZA06
							,COBERTURA07
							,VALORINDENIZA07
							,COBERTURA08
							,VALORINDENIZA08
							,COBERTURA09
							,VALORINDENIZA09
							,COBERTURA10
							,VALORINDENIZA10
							,COBERTURA11
							,VALORINDENIZA11
							,COBERTURA12
							,VALORINDENIZA12
							,COBERTURA13
							,VALORINDENIZA13
							,COBERTURA14
							,VALORINDENIZA14
							,COBERTURA15
							,VALORINDENIZA15
							,COBERTURA16
							,VALORINDENIZA16
							,COBERTURA17
							,VALORINDENIZA17
							,COBERTURA18
							,VALORINDENIZA18
							,COBERTURA19
							,VALORINDENIZA19
							,COBERTURA20
							,VALORINDENIZA20
							,COBERTURA21
							,VALORINDENIZA21
							,COBERTURA22
							,VALORINDENIZA22
							,COBERTURA23
							,VALORINDENIZA23
							,PRMLIQUIDO
							,PRMIOF
							,PRMTOTAL
							,PAGENTRADA
							,PARCELA
							,PAGPARCELAS
							,NUMCDBARRA
							,LOCALDEPAGAMENTO
							,DTVENCTO
							,NCEDENTE
							,CEDENTE
							,DTDOCTO
							,NUMDOCTO
							,DTPROCESS
							,NSNUMERO
							,VALDOCTO
							,MENSA1
							,MENSA2
							,MENSA3
							,MENSA4
							,MENSA5
							,MENSA6
							,MENSA7
							,VALCOBRADO
							,CODBARRA
							,SACADOR
							,END_SAC
							,CEP_SAC
							,CGCCPFSUB
							,DTPOSTAGEM
							,NUMOBJETO
							,DESTINATARIO
							,ENDERECO
							,BAIRRO
							,CIDADE
							,UF
							,CEP
							,VLDESCONTO
							,CUSTOAPOLICE
							,ENCARGOS
							,DESCONTO
							,DataArquivo
							,NomeArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_RenovacaoMREmpresarial ''''' + @PontoParada + ''''''') PRP'
		EXEC(@Comando)

		SELECT @MaiorID=MAx(Codigo)
		from RenovacaoMrEmpresarial_TEMP

		IF(@MaiorID IS NOT NULL)
			SET @PontoParada = @MaiorID
	END

	if(@PontoParada IS NOT NULL)
		--Atualiza o ponto de parada
		update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='RenovacaoMrEmpresarial'
	
	--DROP Data tabela temporária
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.RenovacaoMrEmpresarial_TEMP') AND type in (N'U'))
		DROP TABLE dbo.RenovacaoMrEmpresarial_TEMP;
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.CoberturasRenovacaoMrEmpresarial_TEMP') AND type in (N'U'))
		DROP TABLE dbo.CoberturasRenovacaoMrEmpresarial_TEMP;
	--Commit;
END TRY                
BEGIN CATCH
	--ROLLBACK
	PRINT ERROR_MESSAGE ( )   
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH

--exec Marketing.proc_InsereRenovacaoMrEmpresarial

--select * from ControleDados.PontoParada where nomeentidade='RenovacaoMrEmpresarial'
--insert into ControleDados.PontoParada values ('RenovacaoMrEmpresarial',0)

