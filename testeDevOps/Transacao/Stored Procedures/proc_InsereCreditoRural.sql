CREATE PROCEDURE Transacao.proc_InsereCreditoRural
AS
BEGIN TRY
	DECLARE @PontoParada as VARCHAR(400)
	DECLARE @MaiorID as BigInt
	DECLARE @Comando as NVarchar(max)
	DECLARE @IDTipoTransacao as int

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.CreditoRural_TEMP') AND type in (N'U'))
		DROP TABLE dbo.CreditoRural_TEMP;

	CREATE TABLE CreditoRural_TEMP(
	   ID                   int                  not null,
	   SUAT					VARCHAR(100)		 null,
	   CodigoSr             int                  null,
	   NomeSr               varchar(70)          null,
	   Agencia				int				     null,
	   NomePV				varchar(200)		 null,
	   NumeroContrato		varchar(20)			 null,
	   RazaoSocial			varchar(300)		 null,
	   TipoCliente			int,
	   CpfCnpj				varchar(20),
	   Datacontratacao		Date,
	   DataEncerramento		Date,
	   ValorFinanciado		decimal(18,2),
	   NomeProduto			varchar(200),
	   Atividade			varchar(200),
	   Finalidade			varchar(200),
	   EmpregoProduto		varchar(200),
	   ValorLiberado		decimal(18,2),
	   AguardandoLiberacao  decimal(18,2),
	   LiberacaoFutura		decimal(18,2),
	   Negado				decimal(18,2),
	   DiasAtraso			int,
	   TotalAtraso			decimal(18,2),
	   Situacao				varchar(100),
	   UFEmpreendimento		varchar(2),
	   CodMunicipio			int,
	   OrigemRecurso		varchar(100),
	   NumeroProposta		varchar(50)
	)

	--Definir ponto parada correto
	select @PontoParada = (select ISNULL(PontoParada,0) from ControleDados.PontoParada where NomeEntidade='CreditoRural')

	--Seleciona o IDTipoTransacao, uma vez que Credito rural possui apenas um codigo
	select @IDTipoTransacao=ID from Transacao.TipoTransacao where codigo=6200

	SET @Comando = 'Insert into CreditoRural_TEMP (
					   ID,
					   SUAT,
					   CodigoSr,
					   NomeSr,
					   Agencia,
					   NomePV,
					   NumeroContrato,
					   RazaoSocial,
					   TipoCliente,
					   CpfCnpj,
					   Datacontratacao,
					   DataEncerramento,
					   ValorFinanciado,
					   NomeProduto,
					   Atividade,
					   Finalidade,
					   EmpregoProduto,
					   ValorLiberado,
					   AguardandoLiberacao,
					   LiberacaoFutura,
					   Negado,
					   DiasAtraso,
					   TotalAtraso,
					   Situacao,
					   UFEmpreendimento,
					   CodMunicipio,
					   OrigemRecurso,
					   NumeroProposta
					)
					SELECT ID
						  ,SUAT
						  ,SR
						  ,NOMESR
						  ,Agencia
						  ,NOMEPV
						  ,NUMERO_CONTRATO
						  ,NOME_RAZAO_SOCIAL
						  ,TIPO_CLIENTE
						  ,CPF_CNPJ_CLIENTE
						  ,DATA_CONTRATACAO
						  ,DATA_ENCERRAMENTO
						  ,ValorFinanciado
						  ,NOMEPRODUTO
						  ,ATIVIDADE
						  ,FINALIDADE
						  ,EMPR_PRODUTO
						  ,ValorLiberado
						  ,AguardandoLiberacao
						  ,LiberacaoFutura
						  ,Negado
						  ,DiasAtraso
						  ,TotalAtraso
						  ,Situacao
						  ,COD_UF_IBGE
						  ,CodigoMunicipio
						  ,ORIGEM_RECURSO
						  ,NUMERO_PROPOSTA
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.Transacao.proc_Recupera_CreditoRural ''''' + @PontoParada + ''''''') PRP'

		EXEC(@Comando)

		SELECT @MaiorID=MAx(ID)
		from CreditoRural_TEMP

		SET @PontoParada = @MaiorID

		while @MaiorID IS NOT NULL
		BEGIN
			MERGE INTO Transacao.CreditoRural as C USING
			(
				SELECT DISTINCT
					   ISNULL(m.ID,(select ID from Transacao.municipioIBGE where codigo=-1))  IDMunicipio,
					   ISNULL(uf.ID,1) IDUF,
					   ISNULL(tc.ID,1) IDTipoPessoa,
					   ISNULL(s.ID,1) IDSituacao,
					   ISNULL(u.ID,-1) IDUnidade,
					   ISNULL(NumeroContrato,'') NumeroContrato,
					   ISNULL(RazaoSocial,'') RazaoSocial,
					   ISNULL(TipoCliente,-1) TipoCliente,
					   ISNULL(CpfCnpj,'') CpfCnpj,
					   ISNULL(Datacontratacao,'1900-01-01') Datacontratacao,
					   ISNULL(DataEncerramento,'9999-12-31') DataEncerramento,
					   ISNULL(ValorFinanciado,0) ValorFinanciado,
					   ISNULL(NomeProduto,'') NomeProduto,
					   ISNULL(Atividade,'') Atividade,
					   ISNULL(Finalidade,'') Finalidade,
					   ISNULL(EmpregoProduto,'') EmpregoProduto,
					   ISNULL(ValorLiberado,0) ValorLiberado,
					   ISNULL(AguardandoLiberacao,0) AguardandoLiberacao,
					   ISNULL(LiberacaoFutura,0) LiberacaoFutura,
					   ISNULL(Negado,0) Negado,
					   ISNULL(DiasAtraso,0) DiasAtraso,
					   ISNULL(TotalAtraso,0) TotalAtraso,
					   ISNULL(UFEmpreendimento,'') UFEmpreendimento,
					   ISNULL(CodMunicipio,0) CodMunicipio,
					   ISNULL(OrigemRecurso,'') OrigemRecurso,
					   ISNULL(NumeroProposta,'') NumeroProposta,
					   Getdate() as DataImportacao
				from CreditoRural_TEMP c
				left join Transacao.UF uf
				on uf.codigoIBGE=c.UFEmpreendimento
				left join Transacao.MunicipioIBGE m
				on c.CodMunicipio = RIGHT(m.codigo,5)
				and m.IDUF = uf.id
				left join Transacao.TipoPessoa tc
				on tc.Codigo = ISNULL(TipoCliente,1)
				left join Transacao.Situacao s
				on s.Nome = c.Situacao
				left join Dados.Unidade u
				on u.Codigo = c.Agencia
			)
			AS T
			ON C.NumeroContrato = T.NumeroContrato
			AND C.CPFCNPJ=T.CPFCNPJ
			WHEN NOT MATCHED THEN INSERT(IDTIPOTRANSACAO,IDTIPOCLIENTE,IDSITUACAO,IDUFEMPREENDIMENTO,IDMUNICIPIOIBGE,IDUnidade,NUMEROCONTRATO,RAZAOSOCIAL,
								CPFCNPJ,DATACONTRATACAO,DATAENCERRAMENTO,VALORFINANCIADO,NOMEPRODUTO,ATIVIDADE,FINALIDADE,EMPREGOPRODUTO,VALORLIBERADO,VALORLIBERAR,CRONOGRAMALIBERACAO,
								VALORNEGADO,DIASATRASO,ValorTotalAtraso,ORIGEMRECURSO,NUMEROPROPOSTA)
			VALUES (@IDTipoTransacao,T.IDTipoPessoa,T.IDSituacao,T.IDUF,T.IDMunicipio,T.IDUnidade,T.NumeroContrato,T.RazaoSocial,
				T.CPFCNPJ,T.DataContratacao,T.DataEncerramento,T.ValorFinanciado,T.NomeProduto,T.Atividade,T.Finalidade,T.EmpregoProduto,T.ValorLiberado,T.AguardandoLiberacao,
				T.LiberacaoFutura,T.Negado,T.DiasAtraso,T.TotalAtraso,T.OrigemRecurso,T.NumeroProposta)
			--WHEN NOT MATCHED BY SOURCE THEN UPDATE SET C.Ativo=0
			;
	truncate table CreditoRural_TEMP
	SET @Comando = 'Insert into CreditoRural_TEMP (
					   ID,
					   SUAT,
					   CodigoSr,
					   NomeSr,
					   Agencia,
					   NomePV,
					   NumeroContrato,
					   RazaoSocial,
					   TipoCliente,
					   CpfCnpj,
					   Datacontratacao,
					   DataEncerramento,
					   ValorFinanciado,
					   NomeProduto,
					   Atividade,
					   Finalidade,
					   EmpregoProduto,
					   ValorLiberado,
					   AguardandoLiberacao,
					   LiberacaoFutura,
					   Negado,
					   DiasAtraso,
					   TotalAtraso,
					   Situacao,
					   UFEmpreendimento,
					   CodMunicipio,
					   OrigemRecurso,
					   NumeroProposta
					)
					SELECT ID
						  ,SUAT
						  ,SR
						  ,NOMESR
						  ,Agencia
						  ,NOMEPV
						  ,NUMERO_CONTRATO
						  ,NOME_RAZAO_SOCIAL
						  ,TIPO_CLIENTE
						  ,CPF_CNPJ_CLIENTE
						  ,DATA_CONTRATACAO
						  ,DATA_ENCERRAMENTO
						  ,ValorFinanciado
						  ,NOMEPRODUTO
						  ,ATIVIDADE
						  ,FINALIDADE
						  ,EMPR_PRODUTO
						  ,ValorLiberado
						  ,AguardandoLiberacao
						  ,LiberacaoFutura
						  ,Negado
						  ,DiasAtraso
						  ,TotalAtraso
						  ,Situacao
						  ,COD_UF_IBGE
						  ,CodigoMunicipio
						  ,ORIGEM_RECURSO
						  ,NUMERO_PROPOSTA
						FROM OPENQUERY ([OBERON],
						''EXEC FENAE.Transacao.proc_Recupera_CreditoRural ''''' + @PontoParada + ''''''') PRP'

			EXEC(@Comando)

			SELECT @MaiorID=MAx(ID)
			from CreditoRural_TEMP

			IF(@MaiorID IS NOT NULL)
				SET @PontoParada = @MaiorID

		END
		if(@PontoParada is not null)
			--Atualiza o ponto de parada
			update ControleDados.PontoParada set PontoParada=@PontoParada where NomeEntidade='CreditoRural'
		--DROP Data tabela temporária
		DROP TABLE CreditoRural_TEMP
		--Verifica se contratos foram deletados na origem para desativar no corporativo
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.CreditoRural_TEMP') AND type in (N'U'))
			DROP TABLE dbo.CreditoRural_TEMP;

		CREATE TABLE CreditoRural_TEMP(
		   NumeroContrato		varchar(20)			 null,
		   CpfCnpj				varchar(20),
		   NumeroProposta		varchar(50)
		)
		SET @Comando = 'Insert into CreditoRural_TEMP (
						   NumeroContrato,
						   CpfCnpj,
						   NumeroProposta
						)
						SELECT 
							NUMERO_CONTRATO
							,CPF_CNPJ_CLIENTE
							,NUMERO_PROPOSTA
							FROM OPENQUERY ([OBERON],
							''EXEC FENAE.Transacao.proc_Contrato_CreditoRural'') PRP'
		EXEC(@Comando)
		MERGE INTO Transacao.CreditoRural as C USING
			(
				SELECT 
					   NumeroContrato,
						   CpfCnpj,
						   ISNULL(NumeroProposta,'') NumeroProposta
				from CreditoRural_TEMP c
			)
			AS T
			ON C.NumeroContrato = T.NumeroContrato
			AND C.CPFCNPJ=T.CPFCNPJ
			AND C.NumeroProposta=T.NumeroPRoposta
			WHEN NOT MATCHED BY SOURCE THEN UPDATE SET C.Ativo=0
			;
		--DROP Data tabela temporária
		DROP TABLE CreditoRural_TEMP
END TRY                
BEGIN CATCH
	PRINT ERROR_MESSAGE ( )   
	RETURN @@ERROR
  --EXEC CleansingKit.dbo.proc_RethrowError	
END CATCH
--exec Transacao.proc_InsereCreditoRural