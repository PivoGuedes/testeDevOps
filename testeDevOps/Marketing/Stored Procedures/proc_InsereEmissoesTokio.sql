CREATE PROCEDURE Marketing.proc_InsereEmissoesTokio
AS
BEGIN TRY
	BEGIN TRAN
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.EmissoesTokio_TEMP') AND type in (N'U'))
		DROP TABLE dbo.EmissoesTokio_TEMP;


	CREATE TABLE EmissoesTokio_TEMP(
	   ID INT NOT NULL 
	   ,Produto VARCHAR(200)
	   ,NomeCliente VARCHAR(200)
	   ,CPFCNPJ VARCHAR(20)
	   ,Email VARCHAR(200)
	   ,ApoliceAnterior VARCHAR(50)
	   ,NomeEmpresaParceira VARCHAR(200)
	   ,DescricaoItem VARCHAR(200)
	   ,Placa VARCHAR(30)
	   ,Chassi VARCHAR(50)
	   ,Cep VARCHAR(20)
	   ,InicioVigencia Date
	   ,Bonus Varchar(10)
	   ,RenovacaoFacilitada VARCHAR(2)
	   ,DataArquivo Date
	)

	--Definir ponto parada correto
	select @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='EmissoesTokio')
	SET @Comando = 'Insert into EmissoesTokio_TEMP (
					    ID,Produto,NomeCliente,CPFCNPJ,Email,ApoliceAnterior,NomeEmpresaParceira,DescricaoItem
						,Placa,Chassi,Cep,InicioVigencia,Bonus,RenovacaoFacilitada,DataArquivo
					)
					SELECT  Codigo
							,Produto
							,NomeCliente
							,CPFCNPJ
							,Email
							,ApoliceAnterior
							,NomeEmpresaParceira
							,DescricaoItem
							,Placa
							,Chassi
							,Cep
							,InicioVigencia
							,Bonus
							,RenovacaoFacilitada
							,DataArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_EmissaoTokio ''''' + @PontoParada + ''''''') PRP'
	EXEC(@Comando)

	SELECT @MaiorID=MAx(ID)
	from EmissoesTokio_TEMP

	SET @PontoParada = @MaiorID
	WHILE @MaiorID IS NOT NULL
	BEGIN
		MERGE INTO Marketing.EmissaoMsTokio as C USING
		(
			SELECT *
			FROM (
			SELECT  DISTINCT Produto,NomeCliente,CPFCNPJ,Email,ApoliceAnterior,NomeEmpresaParceira,DescricaoItem,Placa,Chassi
					,Cep,InicioVigencia,Bonus,RenovacaoFacilitada,DataArquivo
					,ROW_NUMBER() OVER(PARTITION BY CPFCNPJ Order by DataArquivo desc) Ordem
			from EmissoesTokio_TEMP
			)as X
			where Ordem=1
		)
		AS T
		ON C.ApoliceAnterior = T.ApoliceAnterior
		AND C.CPFCNPJ=T.CPFCNPJ
		WHEN NOT MATCHED THEN INSERT(Produto,NomeCliente,CPFCNPJ,Email,ApoliceAnterior,NomeEmpresaParceira,Descricao,Placa,Chassi,Cep
				,InicioVigencia,Bonus,RenovacaoFacilitada,DataArquivo)
			VALUES (Produto,NomeCliente,CPFCNPJ,Email,ApoliceAnterior,NomeEmpresaParceira,DescricaoItem,Placa,Chassi,Cep
				,InicioVigencia,Bonus,REPLACE(RenovacaoFacilitada,';',''),DataArquivo)
		WHEN MATCHED THEN UPDATE SET C.Email=T.Email,C.Descricao=T.DescricaoItem,C.InicioVigencia=T.InicioVigencia
			,C.RenovacaoFacilitada=REPLACE(T.RenovacaoFacilitada,';','')
		;
		truncate table EmissoesTokio_TEMP
		SET @Comando = 'Insert into EmissoesTokio_TEMP (
					    ID,Produto,NomeCliente,CPFCNPJ,Email,ApoliceAnterior,NomeEmpresaParceira,DescricaoItem,Placa,Chassi
						,Cep,InicioVigencia,Bonus,RenovacaoFacilitada,DataArquivo
					)
					SELECT  Codigo
							,Produto
							,NomeCliente
							,CPFCNPJ
							,Email
							,ApoliceAnterior
							,NomeEmpresaParceira
							,DescricaoItem
							,Placa
							,Chassi
							,Cep
							,InicioVigencia
							,Bonus
							,RenovacaoFacilitada
							,DataArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.dbo.proc_Recupera_EmissaoTokio ''''' + @PontoParada + ''''''') PRP'
		EXEC(@Comando)

		SELECT @MaiorID=MAx(ID)
		from EmissoesTokio_TEMP

		IF(@MaiorID IS NOT NULL)
			SET @PontoParada = @MaiorID

	END

	if(@PontoParada IS NOT NULL)
	--Atualiza o ponto de parada
	update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='EmissoesTokio'
	
	--DROP Data tabela temporária
	DROP TABLE EmissoesTokio_TEMP;
	COMMIT;

END TRY                
BEGIN CATCH
	ROLLBACK;
	PRINT ERROR_MESSAGE ( )   
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH

--exec Marketing.proc_InsereEmissoesTokio