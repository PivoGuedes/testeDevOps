
CREATE PROCEDURE Transacao.proc_InsereHabitacional
AS
BEGIN TRY
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)
	BEGIN TRAN
	truncate table Transacao.Habitacional;

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Habitacional_TEMP') AND type in (N'U'))
		DROP TABLE dbo.Habitacional_TEMP;

	CREATE TABLE Habitacional_TEMP(
	   ID INT NOT NULL
		,NU_CONTRATO VARCHAR(20) NOT NULL
		,CO_UNIDADE_OPERACIONAL INT NOT NULL
		,CO_PRODUTO_GESTAO_PRODUTIVIDADE INT
		,DT_CONTRATACAO_ORIGINAL DATETIME
		,VR_FINANCIAMENTO DECIMAL(18,2)
		,CPF VARCHAR(max)
		,ICCCA INT
		,CO_CCA INT
		,NU_CNPJ_CCA VARCHAR(20)
		,NO_CCA VARCHAR(200)
		Constraint PK_Habitacional_TEMP Primary key Clustered(ID)
	)

	--Definir ponto parada correto
	select @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='Habitacional')
	SET @Comando = 'Insert into Habitacional_TEMP (
					    ID 
						,NU_CONTRATO
						,CO_UNIDADE_OPERACIONAL
						,CO_PRODUTO_GESTAO_PRODUTIVIDADE
						,DT_CONTRATACAO_ORIGINAL
						,VR_FINANCIAMENTO
						,CPF
						,ICCCA
						,CO_CCA
						,NU_CNPJ_CCA
						,NO_CCA
					)
					SELECT  ID 
							,NU_CONTRATO
							,CO_UNIDADE_OPERACIONAL
							,CO_PRODUTO_GESTAO_PRODUTIVIDADE
							,DT_CONTRATACAO_ORIGINAL
							,VR_FINANCIAMENTO
							,CPF
							,IC_CCA
							,CO_CCA
							,NU_CNPJ_CCA
							,NO_CCA
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.Transacao.proc_Recupera_HbGestaoProdutividade ''''' + @PontoParada + ''''''') PRP'
	EXEC(@Comando)

	SELECT @MaiorID=MAx(ID)
	from Habitacional_TEMP

	if(@MaiorID IS NOT NULL)
		SET @PontoParada = @MaiorID

	WHILE @MaiorID IS NOT NULL
	BEGIN
		MERGE INTO Transacao.DmCca as C USING
		(
			SELECT DISTINCT CO_CCA, NU_CNPJ_CCA, NO_CCA
			FROM Habitacional_TEMP
			where ICCCA=1
		)
		AS T
		ON C.CdCca=T.CO_CCA
		AND C.CdCcaCliente=T.NU_CNPJ_CCA
			WHEN NOT MATCHED THEN INSERT (CdCCa,CdCCACliente,NmCCA)
				VALUES (CO_CCA,NU_CNPJ_CCA,NO_CCA);

		MERGE INTO Transacao.Habitacional as C USING
		(
			SELECT  DISTINCT
					tt.ID IDTipoTransacao
					,u.ID IDUnidade
					,NU_CONTRATO NumeroContrato
					,ISNULL(RIGHT('00000000000' + replace(sp.SplitColumn,' ',''),11),CPF) CPF
					,VR_FINANCIAMENTO ValorFinanciamento
					,DT_CONTRATACAO_ORIGINAL DataContrato
					,ICCCA
					,ISNULL(cca.ID,1) IdCca
			from Habitacional_TEMP c
			left join Transacao.DimUnidade u
			on u.cdAgencia = c.CO_UNIDADE_OPERACIONAL
			inner join Transacao.TipoTransacao tt
			on tt.Codigo=c.CO_PRODUTO_GESTAO_PRODUTIVIDADE
			OUTER APPLY Transacao.UDF_Split(CPF,',') sp
			LEFT JOIN Transacao.DmCCA cca
			on cca.CdCca=c.CO_CCA
			where tt.codigo in  (1,2,3)
			and tt.descricao in ('Financiamento Habitacional - FGTS','Financiamento Habitacional - MCMV','Financiamento Habitacional - SBPE')
		)
		AS T
		ON C.NumeroContrato = T.NumeroContrato
		AND C.CPF=T.CPF
		WHEN NOT MATCHED THEN INSERT(IDTipoTransacao,IDUnidade,NumeroContrato,CPF,ValorFinanciamento,DataContrato,DataImportacao,ICCCA,IDCca)
		VALUES (T.IDTipoTransacao,T.IDUnidade,T.NumeroContrato,T.CPF,T.ValorFinanciamento,T.DataContrato,Getdate(),ICCCA,IdCca)
			--WHEN MATCHED THEN UPDATE SET DataContrato=T.Datacontrato
		;
		truncate table Habitacional_TEMP
		SET @Comando = 'Insert into Habitacional_TEMP (
					    ID 
						,NU_CONTRATO
						,CO_UNIDADE_OPERACIONAL
						,CO_PRODUTO_GESTAO_PRODUTIVIDADE
						,DT_CONTRATACAO_ORIGINAL
						,VR_FINANCIAMENTO
						,CPF
						,ICCCA
						,CO_CCA
						,NU_CNPJ_CCA
						,NO_CCA
					)
					SELECT  ID 
							,NU_CONTRATO
							,CO_UNIDADE_OPERACIONAL
							,CO_PRODUTO_GESTAO_PRODUTIVIDADE
							,DT_CONTRATACAO_ORIGINAL
							,VR_FINANCIAMENTO
							,CPF
							,IC_CCA
							,CO_CCA
							,NU_CNPJ_CCA
							,NO_CCA
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.Transacao.proc_Recupera_HbGestaoProdutividade ''''' + @PontoParada + ''''''') PRP'
		
		EXEC(@Comando)

		SELECT @MaiorID=MAx(ID)
		from Habitacional_TEMP

		IF(@MaiorID IS NOT NULL)
			SET @PontoParada = @MaiorID
	END

	if(@PontoParada IS NOT NULL)
		--Atualiza o ponto de parada
		update ControleDados.PontoParada set PontoParada=0 where NomeEntidade='Habitacional'
	--TRUNCATE Data tabela temporária
	DROP TABLE Habitacional_TEMP
	
	CREATE TABLE Habitacional_TEMP(
	   NU_CONTRATO VARCHAR(20) NOT NULL
	  ,CPF VARCHAR(max)

	)
	
	SET @Comando = 'Insert into Habitacional_TEMP (
						NU_CONTRATO
						,CPF
					)
					SELECT  NU_CONTRATO
							,CPF
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.Transacao.proc_Contrato_HbGestaoProdutividade'') PRP'
	EXEC(@Comando)
	MERGE INTO Transacao.Habitacional as C USING
		(
			SELECT DISTINCT NU_CONTRATO
				  ,RIGHT('00000000000' + replace(sp.SplitColumn,' ',''),11) CPF
			from Habitacional_TEMP c
			CROSS APPLY Transacao.UDF_Split(CPF,',') sp
		)
		AS T
		ON C.NumeroContrato = T.NU_CONTRATO
		AND C.CPF=T.CPF
		WHEN NOT MATCHED BY SOURCE THEN UPDATE SET C.Ativo=0
		;
	--DROP Data tabela temporária
	DROP TABLE Habitacional_TEMP;
	COMMIT;
END TRY                
BEGIN CATCH
	ROLLBACK;
	PRINT ERROR_MESSAGE ( )   
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH

--exec Transacao.proc_InsereHabitacional