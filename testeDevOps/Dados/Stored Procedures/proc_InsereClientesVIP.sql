
CREATE PROCEDURE [Dados].[proc_InsereClientesVIP]
AS
BEGIN TRY
	--BEGIN TRAN
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.BaseVIP_Temp') AND type in (N'U'))
		DROP TABLE dbo.BaseVIP_Temp;
	

	CREATE TABLE BaseVIP_Temp
	(
		Codigo int not null
		,Empresa varchar(200)
		,CPF varchar(20)
		,NomeFuncionario varchar(200)
		,DataNascimento date
		,NivelFuncao varchar(100)
		,DataBaseVip date
		,EmailProfissional varchar(200)
		,SituacaoVip varchar(20)
		,NomeArquivo varchar(200)
		,DataArquivo date
	)

	create clustered index idxBaseVIP_Temp on BaseVIP_Temp(Codigo);
		
	--Definir ponto parada correto
	select @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='BaseVIP')
	SET @Comando = 'Insert into BaseVIP_Temp (
					    Codigo
						,Empresa
						,CPF
						,NomeFuncionario
						,DataNascimento
						,NivelFuncao
						,DataBaseVip
						,EmailProfissional
						,SituacaoVip
						,NomeArquivo
						,DataArquivo
					)
					SELECT  Codigo
							,Empresa1
							,CPF
							,Nome_funcionario
							,DataNascimento
							,NIVEL_FUNCAO
							,DataBaseVip
							,EMAIL_PROFISSIONAL
							,SITUACAO_VIP
							,NomeArquivo
							,DataArquivo
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.[dbo].[proc_Recupera_ClientesVIP] ''''' + @PontoParada + ''''''') PRP'
	EXEC(@Comando)

	SELECT @MaiorID=MAx(Codigo)
	from BaseVIP_Temp

	SET @PontoParada = @MaiorID

	MERGE into Dados.FuncionarioVIP as T
	USING(
		select Empresa,CPF,NomeFuncionario,DataNascimento,NivelFuncao,DataBaseVip,EmailProfissional,SituacaoVip,NomeArquivo,DataArquivo
		from BaseVIP_Temp
	) as B
	ON B.CPF=T.CPF
	and B.DataBaseVip=T.DataBaseVip
		WHEN NOT MATCHED THEN INSERT (Empresa,CPF,NomeFuncionario,DataNascimento,NivelFuncao,DataBaseVip,EmailProfissional,SituacaoVip,NomeArquivo,DataArquivo)
			values (Empresa,CPF,NomeFuncionario,DataNascimento,NivelFuncao,DataBaseVip,EmailProfissional,SituacaoVip,NomeArquivo,DataArquivo);

	if(@PontoParada IS NOT NULL)
		--Atualiza o ponto de parada
		update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='BaseVIP'
	
	--DROP Data tabela temporária
	DROP TABLE BaseVIP_Temp;
	--Commit
END TRY                
BEGIN CATCH
	--ROLLBACK
	PRINT ERROR_MESSAGE ( )   
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH
