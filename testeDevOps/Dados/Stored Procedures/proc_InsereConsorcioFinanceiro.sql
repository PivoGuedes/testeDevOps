


CREATE PROCEDURE [Dados].[proc_InsereConsorcioFinanceiro]
AS
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)

	select @PontoParada=COALESCE(PontoParada,0)
	from ControleDados.PontoParada
	where NomeEntidade='ConsorcioFinanceiro'

	DROP TABLE IF EXISTS [dbo].[Consorcio_Temp];

	CREATE TABLE [dbo].[Consorcio_Temp](
		ID BIGINT ,
		[Periodo] [date] NULL,
		[Venda] [date] NULL,
		[DataQuitacaoParcela] [date] NULL,
		[Contrato] [varchar](50) NULL,
		[NumeroParcela] [int] NULL,
		[LancamentoManual] [int] NOT NULL,
		[PercentualComissao] [numeric](18, 2) NULL,
		[ValorBase] [numeric](18, 6) NULL,
		[ValorComissaoPAR] [numeric](18, 2) NULL,
		[ValorCorretagem] [numeric](18, 6) NULL,
		[NomeArquivo] [varchar](200) NULL,
		[IDProdutor] [int] NOT NULL,
		[CodigoProdutor] [int] NOT NULL,
		[IDProduto] [int] NOT NULL,
		[CodigoProduto] [int] NOT NULL,
		[IDEmpresa] [int] NOT NULL,
		[IDOperacao] [int] NOT NULL,
		[NumeroRecibo] [varchar](50) NULL,
		[DataArquivo] [date] NULL
	)

	create clustered index idxTemp on Consorcio_Temp(NumeroRecibo);

	SET @Comando = 'Insert into Consorcio_Temp (
					    ID,
						[Periodo],
						[Venda],
						[DataQuitacaoParcela],
						[Contrato],
						[NumeroParcela],
						[LancamentoManual],
						[PercentualComissao],
						[ValorBase],
						[ValorComissaoPAR],
						[ValorCorretagem],
						[NomeArquivo],
						[IDProdutor],
						[CodigoProdutor],
						[IDProduto],
						[CodigoProduto],
						[IDEmpresa],
						[IDOperacao],
						[NumeroRecibo],
						[DataArquivo]
					)
					SELECT  ID,
						[Venda],
						[Periodo],
						[DataQuitacaoParcela],
						[Contrato],
						[NumeroParcela],
						[LancamentoManual],
						[PercentualComissao],
						[ValorBase],
						[ValorComissaoPAR],
						[ValorCorretagem],
						[NomeArquivo],
						[IDProdutor],
						[CodigoProdutor],
						[IDProduto],
						[CodigoProduto],
						[IDEmpresa],
						[IDOperacao],
						[NumeroRecibo],
						[DataArquivo]
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.[dbo].[proc_Recupera_ConsorcioFinanceiro] ''''' + @PontoParada + ''''''') PRP'
	EXEC(@Comando)


	SELECT @MaiorID=MAx(ID)
	from Consorcio_Temp;

	SET @PontoParada = @MaiorID

	WHILE @MaiorID IS NOT NULL
	BEGIN
		--Insere na tabela Dados.Comissao
		Merge into Dados.Comissao as C
		USING (
			select [Periodo],
					[Venda],
					[DataQuitacaoParcela],
					[Contrato],
					[NumeroParcela],
					[LancamentoManual],
					[PercentualComissao],
					[ValorBase],
					[ValorComissaoPAR],
					[ValorCorretagem],
					[NomeArquivo],
					[IDProdutor],
					[CodigoProdutor],
					[IDProduto],
					[CodigoProduto],
					[IDEmpresa],
					[IDOperacao],
					[NumeroRecibo],
					[DataArquivo],
					pf.IDFatPar IDFilialFaturamento
					,450 IDCanalVendaPAR
			from Consorcio_Temp t
			inner join dbo.produto_filial pf 
			on pf.NumeroProduto = CodigoProduto
		) as T
		ON T.NumeroRecibo=C.NumeroRecibo
		and T.IdOperacao=C.IdOperacao
		and T.Periodo=C.DataCompetencia
		and T.Venda=C.DataRecibo
		WHEN NOT MATCHED THEN INSERT (DataCompetencia,DataRecibo,DataQuitacaoParcela,NumeroProposta,NumeroParcela,LancamentoManual,
			PercentualCorretagem,ValorBase,ValorComissaoPAR,ValorCorretagem,Arquivo,IDProdutor,CodigoProdutor,IDPRoduto,CodigoComercializado,IDEmpresa,IDOperacao,NumeroRecibo,DataArquivo
			,IDFilialFaturamento,IDCanalVendaPAR,DataCalculo)
		VALUES (Periodo,Venda,DataQuitacaoParcela,Contrato,NumeroParcela,LancamentoManual,PercentualComissao,ValorBase,ValorComissaoPAR,ValorCorretagem,NomeArquivo,IDProdutor,CodigoProdutor,Idproduto,
			CodigoProduto,IDEmpresa,IDOperacao,NumeroRecibo,DataArquivo,IDFilialFaturamento,IDCanalVendaPAR,DataArquivo);

		;MERGE INTO ControleDados.ExportacaoFaturamento AS T  
		   USING (  
				SELECT DISTINCT DataRecibo, NumeroRecibo, DataRecibo [DataCompetencia], IDEmpresa
				FROM dados.comissao
				where idproduto in (804,803,802) 
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


			truncate table Consorcio_Temp;

			SET @Comando = 'Insert into Consorcio_Temp (
					    ID,
						[Periodo],
						[Venda],
						[DataQuitacaoParcela],
						[Contrato],
						[NumeroParcela],
						[LancamentoManual],
						[PercentualComissao],
						[ValorBase],
						[ValorComissaoPAR],
						[ValorCorretagem],
						[NomeArquivo],
						[IDProdutor],
						[CodigoProdutor],
						[IDProduto],
						[CodigoProduto],
						[IDEmpresa],
						[IDOperacao],
						[NumeroRecibo],
						[DataArquivo]
					)
					SELECT  ID,
						[Periodo],
						[Venda],
						[DataQuitacaoParcela],
						[Contrato],
						[NumeroParcela],
						[LancamentoManual],
						[PercentualComissao],
						[ValorBase],
						[ValorComissaoPAR],
						[ValorCorretagem],
						[NomeArquivo],
						[IDProdutor],
						[CodigoProdutor],
						[IDProduto],
						[CodigoProduto],
						[IDEmpresa],
						[IDOperacao],
						[NumeroRecibo],
						[DataArquivo]
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.[dbo].[proc_Recupera_ConsorcioFinanceiro] ''''' + @PontoParada + ''''''') PRP'
			EXEC(@Comando)


			SELECT @MaiorID=MAx(ID)
				from Consorcio_Temp

			IF(@MaiorID IS NOT NULL)
				SET @PontoParada = @MaiorID

	END

	if(@PontoParada IS NOT NULL)
		--Atualiza o ponto de parada
		update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='ConsorcioFinanceiro'
	
	--DROP Data tabela temporária
	DROP TABLE Consorcio_Temp;

