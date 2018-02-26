












CREATE PROCEDURE [Dados].[proc_InsereSQGImob]
AS
BEGIN TRY
	--BEGIN TRAN
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.SQGImob_TEMP') AND type in (N'U'))
		DROP TABLE dbo.SQGImob_TEMP;
	
	CREATE TABLE #TempPRodutosSQG(
		Codigo varchar(4)
		,Apolice BIGINT
		,Descricao varchar(20)
		,Percentual decimal(18,2)
	)

	insert into #TempProdutosSQG values
	(9982	,1480000001,  'IMOBILIÁRIO',0.25),
	(9982	,6000000004,  'IMOBILIÁRIO',0.25),
	(9982	,4800000054,  'IMOBILIÁRIO',0.25),
	(9982	,4800000053,  'IMOBILIÁRIO',0.25),
	(9981	,4800000058,	'MOTO',0.30),
	(9981	,1480000002,	'MOTO',0.30),
	(9980	,1480000003,	'AUTO',0.21),
	(9980	,4800000052,	'AUTO',0.21),
	(9980	,4800000055,	'AUTO',0.21);


	CREATE TABLE SQGImob_TEMP
	(
		[Codigo] [bigint] NOT NULL,
		[Grupo] [varchar](6) NULL,
		[Cota] [varchar](9) NULL,
		[Prazo] [int] NULL,
		[Assembleia] [varchar](3) NULL,
		[InicioVigencia] [date] NULL,
		[Nome] [varchar](35) NULL,
		[Sexo] [varchar](1) NULL,
		[DataNascimeto] [date] NULL,
		[CPFCNPJ] [varchar](20) NULL,
		[TipoMovimento] [varchar](1) NULL,
		[Beneficiario] [varchar](35) NULL,
		[Bem] [varchar](35) NULL,
		[TipoCobertura] [varchar](2) NULL,
		[Capital] [decimal](18, 2) NULL,
		[NumeroPrestacaoPaga] [int] NULL,
		[AnoMes] [int] NULL,
		[PrestacaoPagaRemessa] [int] NULL,
		[AnoMesPrestacao] [int] NULL,
		[DataPagamentoPremio] [date] NULL,
		[PremioSqg] [decimal](18, 2) NULL,
		[PrazoGrupo] [int] NULL,
		[Contrato] [varchar](15) NULL,
		[PercentualTA] [decimal](18, 4) NULL,
		[PercentualFundoReserva] [decimal](18, 4) NULL,
		[ValorPagoSemMulta] [decimal](18, 2) NULL,
		[ValorParcela] [decimal](18, 2) NULL,
		[PercentualSqg] [decimal](18, 4) NULL,
		[DataArquivo] [date] NOT NULL,
		[NomeArquivo] [varchar](250) NOT NULL
	)

	create clustered index idxSqlImob_Temp on SQGImob_TEMP(Contrato);
		
	If IndexProperty(Object_ID('Dados.Comissao_Partitioned'), 'idxComissaoSQG','IndexId') Is Null
		create index idxComissaoSQG on Dados.Comissao_Partitioned(NumeroRecibo,ValorComissaoPAR)

	--Definir ponto parada correto
	select @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='SQGImob')
	SET @Comando = 'Insert into SQGImob_TEMP (
					    Codigo
						,Grupo
						,Cota
						,Prazo
						,Assembleia
						,InicioVigencia
						,Nome
						,Sexo
						,DataNascimeto
						,CPFCNPJ
						,TipoMovimento
						,Beneficiario
						,Bem
						,TipoCobertura
						,Capital
						,NumeroPrestacaoPaga
						,AnoMes
						,PrestacaoPagaRemessa
						,AnoMesPrestacao
						,DataPagamentoPremio
						,PremioSqg
						,PrazoGrupo
						,Contrato
						,PercentualTA
						,PercentualFundoReserva
						,ValorPagoSemMulta
						,ValorParcela
						,PercentualSqg
						,DataArquivo
						,NomeArquivo
					)
					SELECT  Codigo
							,Grupo
							,Cota
							,Prazo
							,Assembleia
							,InicioVigencia
							,Nome
							,Sexo
							,DataNascimeto
							,CPFCNPJ
							,TipoMovimento
							,Beneficiario
							,Bem
							,TipoCobertura
							,Capital
							,NumeroPrestacaoPaga
							,AnoMes
							,PrestacaoPagaRemessa
							,AnoMesPrestacao
							,DataPagamentoPremio
							,PremioSqg
							,PrazoGrupo
							,Contrato
							,PercentualTA
							,PercentualFundoReserva
							,ValorPagoSemMulta
							,ValorParcela
							,PercentualSqg
							,DataArquivo
							,NomeArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.[dbo].[proc_Recupera_SQGImob] ''''' + @PontoParada + ''''''') PRP'
	EXEC(@Comando)

	SELECT @MaiorID=MAx(Codigo)
	from SQGImob_TEMP

	SET @PontoParada = @MaiorID
	WHILE @MaiorID IS NOT NULL
	BEGIN
		--Insere os bens na tabela
		MERGE INTO Dados.ObjetoContratoSQG AS C USING
		(
			select distinct RTRIM(LTRIM(Bem)) Descricao
			from SQGImob_TEMP
		) AS T
		ON T.Descricao=C.Descricao
		WHEN NOT MATCHED THEN INSERT (Descricao) VALUES (T.Descricao);
		
		--Garante que a proposta esteja cadastrada
		MERGE INTO Dados.Proposta AS C USING
		(
			select *
			from (
				select DISTINCT p.ID IDProduto
					,1 IDSeguradora
					,v.Contrato NumeroProposta
					,InicioVigencia
					,Capital Valor
					,PremioSqg ValorPremioTotal
					,'SQG Imob' TipoDado
					,DataArquivo
					,ROW_NUMBER() OVER (PARTITION BY Contrato Order by DataArquivo desc) Ordem
				from SQGImob_TEMP v
				inner join #TempProdutosSQG t
				on t.Apolice = CAST(RIGHT(REPLACE(nomeArquivo,'.txt',''),10) as bigint)
				inner join Dados.Produto p
				on p.CodigoComercializado = t.Codigo COLLATE SQL_Latin1_General_CP1_CI_AS
			) as x
			where Ordem =1
		)
		AS T
		ON C.NumeroProposta = T.NumeroProposta
		WHEN NOT MATCHED THEN INSERT(NumeroProposta,IDSeguradora,IDProduto,DataProposta,DataInicioVigencia,Valor,ValorPremioTotal,TipoDado,DataArquivo)
			VALUES (NumeroProposta,IDSeguradora,IDProduto,InicioVigencia,InicioVigencia,Valor,ValorPremioTotal,TipoDado,DataArquivo)
		;

		--Cadastra o Cliente na Base de Proposta cliente caso não exista
		MERGE INTO Dados.PropostaCliente AS C USING
		(
			select *
			from (
			select p.ID IDProposta
					,s.ID IDSexo
				   ,CPFCNPJ
				   ,RTRIM(LTRIM(Nome)) NomeCliente
				   ,DataNascimeto
				   ,ROW_NUMBER() OVER (PARTITION BY p.ID ORDER BY v.DataArquivo Desc) Ordem
			from SQGImob_TEMP v
			inner join Dados.Proposta p
			on p.NumeroProposta = Contrato
			inner join Dados.Sexo s
			on Left(s.Descricao,1) = v.Sexo
			) as x
			where Ordem=1
		)
		AS T
		ON C.CPFCNPJ = T.CPFCNPJ
		AND C.IDProposta = T.IDProposta
		WHEN NOT MATCHED THEN INSERT(IDProposta,IDSexo,CPFCNPJ,DataNascimento,Nome)
			VALUES (IDProposta,IDSexo,CPFCNPJ,DataNascimeto,Nomecliente)
		;
		
		--INSERTE NO CONTRATO
		MERGE INTO dados.Contrato AS C USING
		(
			SELECT *
			FROM (
				select DISTINCT p.ID IDProposta
					   ,1 IDSeguradora
					   ,12 IDRamo
					   ,v.Contrato
					   ,v.InicioVigencia DataEmissao
					   ,v.InicioVigencia DataInicioVigencia
					   ,DATEADD(MONTH,Prazo,InicioVigencia) DataFimVigencia
					   ,PremioSqg ValorPremioTotal
					   ,Prazo QuantidadeParcelas
					   ,v.DataArquivo
					   ,v.NomeArquivo
					   ,ROW_NUMBER() OVER (PARTITION BY Contrato ORDER BY v.DataArquivo Desc) Ordem
				from SQGImob_TEMP v
				inner join Dados.Proposta p
				on p.NumeroProposta = Contrato
			) as x
			where Ordem=1
		) AS T
		ON T.Contrato = C.NumeroContrato
		AND T.IDProposta=C.IDProposta
		WHEN NOT MATCHED THEN INSERT (IDPRoposta,IDSeguradora,IDRamo,NumeroContrato,DataEmissao,DataInicioVigencia,DataFimVigencia,ValorPremioTotal,QuantidadeParcelas,DataArquivo,Arquivo)
			VALUES (IDPRoposta,IDSeguradora,IDRamo,Contrato,DataEmissao,DataInicioVigencia,DataFimVigencia,ValorPremioTotal,QuantidadeParcelas,DataArquivo,NomeArquivo);

		
		--Cadastra o Cliente na Base de Proposta cliente caso não exista
		MERGE INTO Dados.ContratoCliente AS C USING
		(
			select *
			from (
			select p.ID IDContrato
				   ,Case LEN(CPFCNPJ) WHEN 14 THEN 'Pessoa Física' ELSE 'Pessoa Jurídica' END TipoPessoa
				   ,CPFCNPJ
				   ,RTRIM(LTRIM(Nome)) NomeCliente
				   ,v.NomeArquivo
				   ,v.DataArquivo
				   ,ROW_NUMBER() OVER (PARTITION BY p.ID ORDER BY v.DataArquivo Desc) Ordem
			from SQGImob_TEMP v
			inner join Dados.Contrato p
			on p.NumeroContrato = Contrato
			) as x
			where Ordem=1
		)
		AS T
		ON C.CPFCNPJ = T.CPFCNPJ
		AND C.IDContrato = T.IDContrato
		WHEN NOT MATCHED THEN INSERT(IDContrato,TipoPessoa,CPFCNPJ,Nomecliente,DataArquivo,Arquivo)
			VALUES (IDContrato,TipoPessoa,CPFCNPJ,Nomecliente,DataArquivo,NomeArquivo)
		;
		
		--Insere Comissão
		MERGE INTO Dados.Comissao as C USING
		(
			select IDRamo
				  ,t.Percentual PercentualCorretagem
				  ,(case WHEN TipoMovimento = 'E' THEN -1 * PremioSqg ELSE  CASE WHEN PremioSqg < 1 THEN PremioSqg ELSE PremioSqg/1.0738 END END) * t.Percentual ValorCorretagem
				  ,(case WHEN TipoMovimento = 'E' THEN -1 * PremioSqg ELSE  CASE WHEN PremioSqg < 1 THEN PremioSqg ELSE PremioSqg/1.0738 END END)   ValorBase
				  ,(case WHEN TipoMovimento = 'E' THEN -1 * PremioSqg ELSE  CASE WHEN PremioSqg < 1 THEN PremioSqg ELSE PremioSqg/1.0738 END END) * t.Percentual ValorComissaoPAR
				  ,v.DataArquivo DataPagamentoPremio
				  ,v.DataArquivo DataRecibo
				  ,CAST(CAST(Contrato as BIGINT) as varchar(10)) + RIGHT('0000' + cast(PrestacaoPagaRemessa as varchar(4)),4) NumeroRecibo
				  ,0 NumeroEndosso
				  ,PrestacaoPagaRemessa NumeroParcela
				  ,v.DataArquivo DataCalculo
				  ,DataPagamentoPremio DataQuitacaoParcela
				  ,1 TipoCorretagem
				  ,p.ID IDContrato
				  ,case WHEN TipoMovimento = 'E' THEN 4 ELSE 1 END IDOperacao
				  ,pf.IDFatPar IDFilialFaturamento
				  ,0 CodigoSubgrupoRamoVida
				  ,630 IDUnidadeVenda
				  ,p.IDProposta 
				  ,450 IDCanalVendaPAR
				  ,pp.CodigoComercializado CodigoProduto
				  ,0 LancamentoManual 
				  ,v.NomeArquivo 
				  ,v.DataArquivo
				  ,52 IDEmpresa
				  ,'NA' CanalCodigo
				  ,'01' CanalCodigoHierarquico
				  ,'NÃO DEFINIDO' CanalNome
				  ,'0001-01-01' CanalDataInicio
				  ,'0001-01-01' CanalDataFim
				  ,0 CanalVinculador
				  ,0 CanalDigitoIdentificador
				  ,0 CanalProdutoIdentificador
				  ,0 CanalVendaAgencia
				  ,pp.CodigoComercializado
				  ,pp.id IDProduto
				  ,v.Contrato NumeroProposta
				  ,1 LancamentoProvisao
				  ,120716 IDProdutor
				  ,24988 CodigoProdutor
			from SQGImob_TEMP v
			inner join Dados.Contrato p
			on p.NumeroContrato = Contrato
			inner join #TempProdutosSQG t
			on t.Apolice = CAST(RIGHT(REPLACE(nomeArquivo,'.txt',''),10) as bigint)
			inner join Dados.Produto pp
			on pp.CodigoComercializado = t.Codigo COLLATE SQL_Latin1_General_CP1_CI_AS
			inner join dbo.produto_filial pf on pf.NumeroProduto = pp.CodigoComercializado
			--select * from dbo.produto_filial
		) as T
		ON T.NumeroRecibo=C.NumeroRecibo
		AND T.ValorcomissaoPAR=C.ValorcomissaoPAR
			WHEN NOT MATCHED THEN INSERT (PercentualCorretagem,ValorCorretagem,ValorBase,ValorComissaoPAR,DataCompetencia,DataRecibo,NumeroRecibo,NumeroEndosso,NumeroParcela
					,DataCalculo,DataQuitacaoParcela,TipoCorretagem,IDContrato,IDOperacao,IDFilialFaturamento,IDProposta,IDCanalVendaPAR,CodigoPRoduto,LancamentoManual,Arquivo
					,DataArquivo,IDEmpresa,IDSeguradora,NumeroReciboOriginal,CanalCodigo,CanalCodigoHierarquico,CanalNome,CanalDataInicio,CanalDataFim,CanalVinculador,CanalDigitoIdentificador
					,CanalProdutoIdentificador,CanalVendaAgencia,IDProduto,CodigoComercializado,NumeroProposta,LancamentoProvisao,IDProdutor,CodigoProdutor)
			VALUES (PercentualCorretagem,ValorCorretagem,ValorBase,ValorcomissaoPAR,DataPagamentoPremio,DataRecibo,NumeroRecibo,NumeroEndosso,NumeroParcela,DataCalculo,DataQuitacaoParcela
			,TipoCorretagem,IDContrato,IDOperacao,IDFilialFaturamento,IDProposta,IDCanalVendaPAR,CodigoProduto,LancamentoManual,NomeArquivo,DataArquivo,IDEmpresa,1,NumeroRecibo,CanalCodigo
			,CanalCodigoHierarquico,CanalNome,CanalDataInicio,CanalDataFim,CanalVinculador,CanalDigitoIdentificador,CanalProdutoIdentificador,CanalVendaAgencia,IDPRoduto,CodigoComercializado
			,NumeroProposta,LancamentoProvisao,IDProdutor,CodigoProdutor)
		;

		;MERGE INTO ControleDados.ExportacaoFaturamento AS T  
	     USING (  
			SELECT DISTINCT DataArquivo DataRecibo,CAST(CAST(Contrato as BIGINT) as varchar(10)) + RIGHT('0000' + cast(PrestacaoPagaRemessa as varchar(4)),4) NumeroRecibo, DataArquivo [DataCompetencia],52 IDEmpresa
			FROM SQGImob_TEMP
			  ) AS X  
		ON  X.DataRecibo = T.DataRecibo  
		AND X.NumeroRecibo = T.NumeroRecibo  
		AND X.DataCompetencia = T.DataCompetencia  
		AND X.IDEmpresa = T.IDEmpresa  
		   WHEN NOT MATCHED    
			THEN INSERT            
				  (     
				   DataRecibo,  
				   NumeroRecibo,  
				   DataCompetencia,  
		  IDEmpresa  
				  )  
			  VALUES (     
					  X.DataRecibo,  
					  X.NumeroRecibo,  
					  X.DataCompetencia,  
		  X.IDEmpresa);   
		
		MERGE INTO Dados.SQGImob as C USING(
			select c.ID IDContrato
				,s.CPFCNPJ
				,o.ID IDObjetoContratoSQG
				,t.ID IDTipoMovimentoSQG
				,tc.ID IDTipoCoberturaSQG
				,Grupo
				,Cota
				,Prazo
				,Assembleia
				,NumeroPrestacaoPaga
				,AnoMes
				,PrestacaoPagaRemessa
				,AnoMesPrestacao
				,DataPagamentoPremio
				,PremioSqg
				,PrazoGrupo
				,PercentualTA
				,PercentualFundoReserva
				,ValorPagoSemMulta
				,PercentualSqg
				,ValorParcela
				,s.DataArquivo
				,s.NomeArquivo
			from SQGImob_TEMP s
			inner join Dados.Contrato c
			on c.NumeroContrato = s.Contrato
			inner join Dados.TipoMovimentoSQG t
			on t.Codigo = s.TipoMovimento
			inner join Dados.TipoCoberturaSQG tc
			on tc.codigo = s.TipoCobertura
			inner join Dados.ObjetoContratoSQG o
			on o.Descricao = RTRIM(LTRIM(Bem))
		) as T
		ON T.IDContrato = C.IDContrato
		AND T.IDTipoMovimentoSQG = C.IDTipoMovimentoSQG
		AND T.NumeroPrestacaoPaga = C.NumeroPrestacaoPaga
			WHEN NOT MATCHED THEN INSERT (IDContrato,CPFCNPJ,IDObjetoContratoSQG,IDTipoMovimentoSQG,IDTipoCoberturaSQG,Grupo,Cota,Prazo,Assembleia,NumeroPrestacaoPaga
				,AnoMes,PrestacaoPagaRemessa,AnoMesPrestacao,DataPagamentoPremio,PremioSqg,PrazoGrupo,PercentualTA,PercentualFundoReserva,ValorPagoSemMulta,PercentualSqg
				,DataArquivo,NomeArquivo,ValorParcela)
			VALUES (IDContrato,CPFCNPJ,IDObjetoContratoSQG,IDTipoMovimentoSQG,IDTipoCoberturaSQG,Grupo,Cota,Prazo,Assembleia,NumeroPrestacaoPaga
				,AnoMes,PrestacaoPagaRemessa,AnoMesPrestacao,DataPagamentoPremio,PremioSqg,PrazoGrupo,PercentualTA,PercentualFundoReserva,ValorPagoSemMulta,PercentualSqg
				,DataArquivo,NomeArquivo,ValorParcela)
			;


		truncate table SQGImob_TEMP;
		SET @Comando = 'Insert into SQGImob_TEMP (
					    Codigo
						,Grupo
						,Cota
						,Prazo
						,Assembleia
						,InicioVigencia
						,Nome
						,Sexo
						,DataNascimeto
						,CPFCNPJ
						,TipoMovimento
						,Beneficiario
						,Bem
						,TipoCobertura
						,Capital
						,NumeroPrestacaoPaga
						,AnoMes
						,PrestacaoPagaRemessa
						,AnoMesPrestacao
						,DataPagamentoPremio
						,PremioSqg
						,PrazoGrupo
						,Contrato
						,PercentualTA
						,PercentualFundoReserva
						,ValorPagoSemMulta
						,ValorParcela
						,PercentualSqg
						,DataArquivo
						,NomeArquivo
					)
					SELECT  Codigo
							,Grupo
							,Cota
							,Prazo
							,Assembleia
							,InicioVigencia
							,Nome
							,Sexo
							,DataNascimeto
							,CPFCNPJ
							,TipoMovimento
							,Beneficiario
							,Bem
							,TipoCobertura
							,Capital
							,NumeroPrestacaoPaga
							,AnoMes
							,PrestacaoPagaRemessa
							,AnoMesPrestacao
							,DataPagamentoPremio
							,PremioSqg
							,PrazoGrupo
							,Contrato
							,PercentualTA
							,PercentualFundoReserva
							,ValorPagoSemMulta
							,ValorParcela
							,PercentualSqg
							,DataArquivo
							,NomeArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.[dbo].[proc_Recupera_SQGImob] ''''' + @PontoParada + ''''''') PRP'
		EXEC(@Comando)

		SELECT @MaiorID=MAx(Codigo)
		from SQGImob_TEMP

		IF(@MaiorID IS NOT NULL)
			SET @PontoParada = @MaiorID

	END

	if(@PontoParada IS NOT NULL)
		--Atualiza o ponto de parada
		update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='SQGImob'

	If IndexProperty(Object_ID('Dados.Comissao_Partitioned'), 'idxComissaoSQG','IndexId') Is not Null
		drop index idxComissaoSQG on Dados.Comissao_Partitioned;

	--DROP Data tabela temporária
	DROP TABLE SQGImob_TEMP
	--Commit
END TRY                
BEGIN CATCH
	--ROLLBACK
	PRINT ERROR_MESSAGE ( )   
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH

--exec Marketing.proc_InsereVendasPrevidencia

--select * from ControleDados.PontoParada where nomeentidade='VendasPrevidencia'

--insert into ControleDados.PontoParada values ('VendasPrevidencia',0)


