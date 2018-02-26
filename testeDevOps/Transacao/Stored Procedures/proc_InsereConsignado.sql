
CREATE PROCEDURE Transacao.proc_InsereConsignado
AS
BEGIN TRY
	BEGIN TRAN
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.Consignado_TEMP') AND type in (N'U'))
		DROP TABLE dbo.Consignado_TEMP;

	CREATE TABLE Consignado_TEMP(
	   ID INT NOT NULL
	   ,COD_SUREG INT NULL
	   ,CONTRATO VARCHAR(20)
	   ,CPF VARCHAR(20)
	   ,COD_AGENCIA INT
	   ,COD_CANAL INT 
	   ,COD_TIPO_CONTRATACAO INT
	   ,VALOR_CONTRATO DECIMAL(18,2)
	   ,VALOR_SEGURO DECIMAL(18,2)
	   ,DATA_LIBERACAO Date
	   ,COD_CONVENENTE INT
	   ,COD_CORRESPONDENTE INT
	   ,MATRICULA  VARCHAR(20)
	   ,NOME_FUNCIONARIO VARCHAR(255)
	   ,TIPO_VENDA VARCHAR(255)
	   ,SEGURO VARCHAR(50)
	   Constraint PK_Consignado_TEMP Primary key Clustered(ID)
	)

	--Definir ponto parada correto
	select @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='Consignado')
	SET @Comando = 'Insert into Consignado_TEMP (
					    ID
					   ,COD_SUREG
					   ,CONTRATO
					   ,CPF
					   ,COD_AGENCIA
					   ,COD_CANAL
					   ,COD_TIPO_CONTRATACAO
					   ,VALOR_CONTRATO
					   ,VALOR_SEGURO
					   ,DATA_LIBERACAO
					   ,COD_CONVENENTE
					   ,COD_CORRESPONDENTE
					   ,MATRICULA
					   ,NOME_FUNCIONARIO
					   ,TIPO_VENDA
					   ,SEGURO
					)
					SELECT  ID
							,COD_SUREG
						   ,CONTRATO
						   ,CPFNOMASK
						   ,COD_AGENCIA
						   ,COD_CANAL
						   ,COD_TIPO_CONTRATACAO
						   ,VALOR_CONTRATO
						   ,VALOR_SEGURO
						   ,DATA_LIBERACAO
						   ,COD_CONVENENTE
						   ,COD_CORRESPONDENTE
						   ,MATRICULA
						   ,NOME_FUNCIONARIO
						   ,TIPO_VENDA
						   ,SEGURO
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.Transacao.proc_Recupera_Consignado ''''' + @PontoParada + ''''''') PRP'
	EXEC(@Comando)

	SELECT @MaiorID=MAx(ID)
	from Consignado_TEMP

	SET @PontoParada = @MaiorID
	WHILE @MaiorID IS NOT NULL
	BEGIN
		MERGE INTO Transacao.Consignado as C USING
		(
			SELECT   DISTINCT
					CASE COD_CONVENENTE WHEN 10605 THEN 6 ELSE 7 END IDTipoTransacao
					,u.ID IDUnidade
					,COD_CANAL
					,COD_TIPO_CONTRATACAO
					,COD_CONVENENTE
					,COD_CORRESPONDENTE
					,CPF
					,CONTRATO NumeroContrato
					,VALOR_CONTRATO
					,Valor_SEGURO
					,DATA_LIBERACAO
					,MATRICULA
					,NOME_FUNCIONARIO
					,TIPO_VENDA
					,CASE LTRIM(RTRIM(SEGURO)) WHEN 'FINANCIADO' THEN 1 ELSE 0 END IsFinanciado
			from Consignado_TEMP c
			left join Dados.Unidade u
			on u.Codigo = c.COD_AGENCIA
		)
		AS T
		ON C.NumeroContrato = T.NumeroContrato
		AND C.CPF=T.CPF
		AND C.DataLiberacao=T.DATA_LIBERACAO
		AND C.CodigoTipoTransacao=T.Cod_Tipo_CONTRATACAO
		AND C.ValorContrato=T.VALOR_CONTRATO
		WHEN NOT MATCHED THEN INSERT(IDTipoTransacao,IDUnidade,CodigoCanal,CodigoTipoTransacao,CodigoConvenente,CodCorrespondente,CPF,NumeroContrato,ValorContrato,ValorSeguro
					,DataLiberacao,Matricula,NomeFuncionario,TipoVenda,DataImportacao,Isfinanciado)
		VALUES (IDTipoTransacao,IDUnidade,COD_CANAL,COD_TIPO_CONTRATACAO,COD_CONVENENTE,COD_CORRESPONDENTE,CPF,NumeroContrato,VALOR_CONTRATO,Valor_SEGURO
					,DATA_LIBERACAO,MATRICULA,NOME_FUNCIONARIO,TIPO_VENDA,GETDATE(),IsFinanciado)
		--WHEN NOT MATCHED BY SOURCE THEN UPDATE SET C.Ativo=0
		;
		truncate table Consignado_TEMP
		SET @Comando = 'Insert into Consignado_TEMP (
					    ID
					   ,CONTRATO
					   ,CPF
					   ,COD_AGENCIA
					   ,COD_CANAL
					   ,COD_TIPO_CONTRATACAO
					   ,VALOR_CONTRATO
					   ,VALOR_SEGURO
					   ,DATA_LIBERACAO
					   ,COD_CONVENENTE
					   ,COD_CORRESPONDENTE
					   ,MATRICULA
					   ,NOME_FUNCIONARIO
					   ,TIPO_VENDA
					   ,SEGURO
					)
					SELECT  ID
						   ,CONTRATO
						   ,CPFNOMASK
						   ,COD_AGENCIA
						   ,COD_CANAL
						   ,COD_TIPO_CONTRATACAO
						   ,VALOR_CONTRATO
						   ,VALOR_SEGURO
						   ,DATA_LIBERACAO
						   ,COD_CONVENENTE
						   ,COD_CORRESPONDENTE
						   ,MATRICULA
						   ,NOME_FUNCIONARIO
						   ,TIPO_VENDA
						   ,SEGURO
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.Transacao.proc_Recupera_Consignado ''''' + @PontoParada + ''''''') PRP'		
		EXEC(@Comando)

		SELECT @MaiorID=MAx(ID)
		from Consignado_TEMP

		IF(@MaiorID IS NOT NULL)
			SET @PontoParada = @MaiorID

	END
	if(@PontoParada is not null)
		--Atualiza o ponto de parada
		update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='Consignado'
	
	--drop table Consignado_TEMP
	--CREATE TABLE Consignado_TEMP(
	--	Contrato VARCHAR(50)
	--	,CPF VARCHAR(20)
	--)
	
	--SET @Comando = 'Insert into Consignado_TEMP (
	--					CONTRATO
	--					,CPF
	--				)
	--				SELECT  CONTRATO
	--						,CPF
	--					FROM OPENQUERY ([OBERON],
	--					''EXEC FENAE.Transacao.proc_Contrato_Consignado'') PRP'
	--EXEC(@Comando)
	--MERGE INTO Transacao.Consignado as C USING
	--	(
	--		SELECT CONTRATO
	--			  ,CPF
	--		from Consignado_TEMP c
	--	)
	--	AS T
	--	ON C.NumeroContrato = T.CONTRATO
	--	AND C.CPF=T.CPF
	--	WHEN NOT MATCHED BY SOURCE THEN UPDATE SET C.Ativo=0
	--	;
	--DROP Data tabela temporária
	DROP TABLE Consignado_TEMP;
	COMMIT;
END TRY                
BEGIN CATCH
	ROLLBACK
	PRINT ERROR_MESSAGE ( )   
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH

--exec Transacao.proc_InsereConsignado
