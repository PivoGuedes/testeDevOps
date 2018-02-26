
CREATE PROCEDURE Transacao.proc_InsereContaCorrentePJ
AS
BEGIN TRY
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.ContaCorrentePJ_TEMP') AND type in (N'U'))
		DROP TABLE dbo.ContaCorrentePJ_TEMP;

	CREATE TABLE ContaCorrentePJ_TEMP(
		ID                   int                  not null,
	    CPF					 VARCHAR(15)		  NOT NULL,
		CDPRODUTO			 INT				  NOT NULL,
		CDUNIDADE			 INT				  NOT NULL,
		NUMEROCONTRATO		 VARCHAR(50)		  NOT NULL,
		DTCONTRATO			 DATETIME			  NOT NULL,
		DTNASCIMENTO		 DATETIME			  NULL,
	    DataImportacao		Datetime			 not null default getdate()
		Constraint PK_ContaCorrentePJ_Temp Primary key Clustered(ID)
	)

	--Definir ponto parada correto
	select @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='ContaCorrentePJ')

	SET @Comando = 'Insert into ContaCorrentePJ_TEMP (
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
						''EXEC FENAE.Transacao.proc_Recupera_ContaCorrentePJ ''''' + @PontoParada + ''''''') PRP'

		EXEC(@Comando)

		SELECT @MaiorID=MAx(ID)
		from ContaCorrentePJ_TEMP

		if(@MaiorID IS NOT NULL)
			SET @PontoParada = @MaiorID

		while @MaiorID IS NOT NULL
		BEGIN
			MERGE INTO Transacao.contacorrentePJ as C USING
			(
				SELECT  DISTINCT u.ID IDUnidade
						,t.ID IDTipoTransacao
						,NumeroContrato
					   ,CPF
					   ,DTContrato
					   ,DataImportacao
				from ContaCorrentePJ_TEMP c
				left join Dados.Unidade u
				on u.Codigo = c.cdunidade
				inner join transacao.tipotransacao t
				on t.Codigo = c.CDPRODUTO
				AND t.Descricao in ('Conta Corrente PJ')
			)
			AS T
			ON C.NumeroCNPJ = T.CPF
			AND C.NumeroContrato = T.NumeroContrato
			AND C.DataContrato=T.DTContrato
			WHEN NOT MATCHED THEN INSERT(IDUnidade,IDTipoTransacao,NumeroContrato,NumeroCNPJ,Datacontrato,DataImportacao)
				VALUES (IDUnidade,IDTipoTransacao,NumeroContrato,CPF,DTContrato,DataImportacao)
			--WHEN NOT MATCHED BY SOURCE THEN UPDATE SET C.Ativo=0
			;

			truncate table ContaCorrentePJ_TEMP
			
			SET @Comando = 'Insert into ContaCorrentePJ_TEMP (
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
						''EXEC FENAE.Transacao.proc_Recupera_ContaCorrentePJ ''''' + @PontoParada + ''''''') PRP'

			EXEC(@Comando)

			SELECT @MaiorID=MAx(ID)
			from ContaCorrentePJ_TEMP

			IF(@MaiorID IS NOT NULL)
				SET @PontoParada = @MaiorID

		END

		if(@PontoParada IS NOT NULL)
			--Atualiza o ponto de parada
			update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='ContaCorrentePJ'
		
		----DROP Data tabela temporária
		--DROP TABLE ContaCorrentePJ_TEMP
		----Verifica se contratos foram deletados na origem para desativar no corporativo
		--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.ContaCorrentePJ_TEMP') AND type in (N'U'))
		--	DROP TABLE dbo.ContaCorrentePJ_TEMP;

		--CREATE TABLE ContaCorrentePJ_TEMP(
		--	CNPJ					 VARCHAR(15)		  NOT NULL,
		--	NUMEROCONTRATO		 VARCHAR(50)		  NOT NULL
		--)
		--SET @Comando = 'Insert into ContaCorrentePJ_TEMP (
		--					NumeroContrato,
		--					CNPJ
		--				)
		--				SELECT 
		--					NumeroContrato,
		--					CNPJ
		--					FROM OPENQUERY ([OBERON],
		--					''EXEC FENAE.Transacao.proc_Contrato_ContaCorrentePJ'') PRP'
		--EXEC(@Comando)
		--MERGE INTO Transacao.contacorrentePj as C USING
		--(
		--	SELECT  NumeroContrato
		--			,CNPJ
		--	from ContaCorrentePJ_TEMP c
		--)
		--AS T
		--ON C.NumeroCnpj = T.CNPJ
		--AND C.NumeroContrato = T.NumeroContrato
		--WHEN NOT MATCHED BY SOURCE THEN UPDATE SET C.Ativo=0
		--;
		--DROP Data tabela temporária
		DROP TABLE ContaCorrentePJ_TEMP
END TRY                
BEGIN CATCH
	PRINT ERROR_MESSAGE()
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH
--exec Transacao.proc_InsereContaCorrentePJ