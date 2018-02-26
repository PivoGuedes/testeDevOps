
CREATE PROCEDURE Transacao.proc_InsereContaCorrentePF
AS
BEGIN TRY
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.ContaCorrentePF_TEMP') AND type in (N'U'))
		DROP TABLE dbo.ContaCorrentePF_TEMP;

	CREATE TABLE ContaCorrentePF_TEMP(
		ID                   int                  not null,
	    CPF					 VARCHAR(15)		  NOT NULL,
		CDPRODUTO			 INT				  NOT NULL,
		CDUNIDADE			 INT				  NOT NULL,
		NUMEROCONTRATO		 VARCHAR(50)		  NOT NULL,
		DTCONTRATO			 DATETIME			  NOT NULL,
		DTNASCIMENTO		 DATETIME			  NULL,
	    DataImportacao		Datetime			 not null default getdate()
		Constraint PK_ContaCorrente_Temp Primary key Clustered(ID)
	)

	--Definir ponto parada correto
	select @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='ContaCorrentePF')

	SET @Comando = 'Insert into ContaCorrentePF_TEMP (
						ID
					   ,CPF
					   ,CDPRODUTO
					   ,CDUNIDADE
					   ,NUMEROCONTRATO
					   ,DTCONTRATO
					   ,DTNASCIMENTO
					)
					SELECT ID
					   ID
					   ,CPF
					   ,CDPRODUTO
					   ,CDUNIDADE 
					   ,NUMEROCONTRATO
					   ,DTCONTRATO
					   ,DTNASCIMENTO
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.Transacao.proc_Recupera_ContaCorrentePF ''''' + @PontoParada + ''''''') PRP'

		EXEC(@Comando)

		SELECT @MaiorID=MAx(ID)
		from ContaCorrentePF_TEMP

		if(@MaiorID IS NOT NULL)
			SET @PontoParada = @MaiorID

		print @MaiorID

		while @MaiorID IS NOT NULL
		BEGIN
			MERGE INTO Transacao.contacorrentePF as C USING
			(
				SELECT  DISTINCT u.ID IDUnidade
						,t.ID IDTipoTransacao
						,NumeroContrato
					   ,CPF
					   ,DTContrato
					   ,DataImportacao
					   ,DTNASCIMENTO
				from ContaCorrentePF_TEMP c
				left join Dados.Unidade u
				on u.Codigo = c.cdunidade
				inner join transacao.tipotransacao t
				on t.Codigo = c.CDPRODUTO
				AND t.Descricao in ('Conta Corrente PF','Conta Fácil','Conta Poupança')
			)
			AS T
			ON C.NumeroCPF = T.CPF
			AND C.NumeroContrato = T.NumeroContrato
			AND C.DataContrato=T.DTContrato
			WHEN NOT MATCHED THEN INSERT(IDUnidade,IDTipoTransacao,NumeroContrato,NumeroCPF,Datacontrato,DataImportacao,DataNascimento)
				VALUES (IDUnidade,IDTipoTransacao,NumeroContrato,CPF,DTContrato,DataImportacao,DTNASCIMENTO)
			--WHEN NOT MATCHED BY SOURCE THEN UPDATE SET C.Ativo=0
			;

			truncate table ContaCorrentePF_TEMP
			
			SET @Comando = 'Insert into ContaCorrentePF_TEMP (
						ID
					   ,CPF
					   ,CDPRODUTO
					   ,CDUNIDADE
					   ,NUMEROCONTRATO
					   ,DTCONTRATO
					   ,DTNASCIMENTO
					)
					SELECT ID
					   ID
					   ,CPF
					   ,CDPRODUTO
					   ,CDUNIDADE 
					   ,NUMEROCONTRATO
					   ,DTCONTRATO
					   ,DTNASCIMENTO
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.Transacao.proc_Recupera_ContaCorrentePF ''''' + @PontoParada + ''''''') PRP'

			EXEC(@Comando)

			SELECT @MaiorID=MAx(ID)
			from ContaCorrentePF_TEMP

			print @MaiorID
			print 'ponto de parada'
			print @PontoParada
			IF(@MaiorID IS NOT NULL)
				SET @PontoParada = @MaiorID

		END

		IF(@PontoParada IS NOT NULL)
			--Atualiza o ponto de parada
			update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='ContaCorrentePF'

		----DROP Data tabela temporária
		--DROP TABLE ContaCorrentePF_TEMP
		----Verifica se contratos foram deletados na origem para desativar no corporativo
		--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.ContaCorrentePF_TEMP') AND type in (N'U'))
		--	DROP TABLE dbo.ContaCorrentePF_TEMP;

		--CREATE TABLE ContaCorrentePF_TEMP(
		--	CPF					 VARCHAR(15)		  NOT NULL,
		--	NUMEROCONTRATO		 VARCHAR(50)		  NOT NULL
		--)
		--SET @Comando = 'Insert into ContaCorrentePF_TEMP (
		--					NumeroContrato,
		--					CPF
		--				)
		--				SELECT 
		--					NumeroContrato,
		--					CPF
		--					FROM OPENQUERY ([OBERON],
		--					''EXEC FENAE.Transacao.proc_Contrato_ContaCorrentePF'') PRP'
		--EXEC(@Comando)
		--MERGE INTO Transacao.contacorrentePF as C USING
		--(
		--	SELECT  NumeroContrato
		--			,CPF
		--	from ContaCorrentePF_TEMP c
		--)
		--AS T
		--ON C.NumeroCPF = T.CPF
		--AND C.NumeroContrato = T.NumeroContrato
		--WHEN NOT MATCHED BY SOURCE THEN UPDATE SET C.Ativo=0
		--;
		--DROP Data tabela temporária
		DROP TABLE ContaCorrentePF_TEMP
END TRY                
BEGIN CATCH
	PRINT ERROR_MESSAGE()
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH
--exec Transacao.proc_InsereContaCorrentePF