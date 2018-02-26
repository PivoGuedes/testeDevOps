
/*
	Autor: Pedro Guedes
	Data Criação: 03/12/2014

		Descrição: Proc que insere atendimentos vindos no arquivo PARIndica

*/

/*******************************************************************************
	Nome: Dados.proc_InsereAtendimentoPARIndica
	Descrição: Procedimento que realiza a inserção de propostas no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:



	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereAtendimentoPARIndica]
AS

BEGIN TRY	
    

 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AtendimentoPARIndica_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[AtendimentoPARIndica_TEMP]

--PROTOCOLO as Protocolo,CPFCNPJ as CPF,NOME_CLIENTE as NomeCliente,NUMERO_PROPOSTA_1 as NumeroProposta,VALOR_PREMIO_FINAL_1 AS ValorPremioFinal,VALOR_PREMIO_SEM_DESCONTO_1  as ValorPremioSemDesconto
CREATE TABLE [dbo].[AtendimentoPARIndica_TEMP](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Protocolo] varchar(20) NULL,
	[NomeCliente] [varchar](150) NULL,
	[CPF] [varchar](18) NOT NULL,
	[NumeroProposta] [varchar](20) NULL,
	[ValorPremioFinal] [decimal](18, 6) NULL,
	[ValorPremioSemDesconto] [decimal](18, 6) NULL,
	[DataNascimento] [Date],
	[DataProposta]  [Date],
	[NomeArquivo] [varchar] (100),
	[IDFenae] [int]

 CONSTRAINT [PK_AtendimentoPARIndicaTEMP_ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80)
)

 /*Cria alguns índices para facilitar a busca*/  
CREATE NONCLUSTERED INDEX idx_NDX_AtendimentoPARIndica_TEMP ON [dbo].AtendimentoPARIndica_TEMP
( 
  NumeroProposta ASC
)       





DECLARE @MaiorCodigo AS BIGINT
DECLARE @PontoDeParada AS varchar(400)
DECLARE @COMANDO AS NVARCHAR(MAX) 


	SELECT @PontoDeParada = PontoParada
	FROM ControleDados.PontoParada
	WHERE NomeEntidade = 'AQAUTSIS'
	--print @PontoDeParada
/*********************************************************************************************************************/               
/*INSERE REGISTROS NA TABELA TEMPORÁRIA*/
/*********************************************************************************************************************/
	--declare @COMANDO varchar(max)
	--declare @PontoDeParada VARCHAR(400) =  '0'
	SET @COMANDO =
	'INSERT into [dbo].[AtendimentoPARIndica_TEMP] ( 
					[Protocolo],
					[CPF],
					[NomeCliente],
					[NumeroProposta],
					[ValorPremioFinal],
					[ValorPremioSemDesconto],
					[DataNascimento],
					[IDFenae]

				
				)  
				SELECT [Protocolo],
					[CPF],
					[NomeCliente],
					[NumeroProposta],
					[ValorPremioFinal],
					[ValorPremioSemDesconto],
					[DataNascimento],
					[ID]
				
	 FROM OPENQUERY ([OBERON], ''exec [Corporativo].[proc_RecuperaAtendimentoPARIndica] ''''' + @PontoDeParada + ''''''') PRP
	'

	EXEC (@COMANDO)    

	SELECT @MaiorCodigo = MAX(PRP.IDFenae)
	FROM dbo.[AtendimentoPARIndica_TEMP] AS PRP     
	print @MaiorCodigo
	SET @COMANDO = '' 

	WHILE @MaiorCodigo IS NOT NULL
	BEGIN
--INSERT into [dbo].[AtendimentoPARIndica_TEMP] ( 
--					[Protocolo],
--					[CPF],
--					[NomeCliente],
--					[NumeroProposta],
--					[ValorPremioFinal],
--					[ValorPremioSemDesconto],
--					[DataNascimento]
				
--				)  exec [Dados].[proc_RecuperaAtendimentoPARIndica]
					
			   ----EXEC [dados].[proc_recuperaproposta_saude] 

/*********************************************************************************************************************/               
/*INSERE REGISTROS NA TABELA DE PROPOSTAS - select TRY_PARSE(ltrim(rtrim(NumeroProposta)) as int),* from dbo.[AtendimentoPARIndica_TEMP] where NumeroProposta <> ''	 AND charindex('.',NumeroProposta) =  0 and NumeroProposta <> '0'  AND NumeroProposta not in ('C','FI') AND NomeCliente = 'LEONILA MARIA GONCALVES SAMPAIO'*/
/*********************************************************************************************************************/
;MERGE INTO Dados.Proposta as T
	USING
	(	
		select  p.ID,
				IDProduto,
				DataProposta,
				[ValorPremioFinal],
				[ValorPremioSemDesconto],
				NumeroPropostaTratado
				from (SELECT /*TRY_PARSE(Replace(Replace(Replace(Replace(Replace(Replace(c.NumeroProposta,'>',''),'C',''),'FI',''),'.',''),' ',''),'I','') AS BIGINT) as NumeroPropostaTratado,	*/
				CleansingKit.dbo.fn_TrataNumeroPropostaZeroExtra(NumeroProposta) as NumeroPropostaTratado,			
				[ValorPremioFinal],
				[ValorPremioSemDesconto] FROM (SELECT distinct
				[ValorPremioFinal],
				[ValorPremioSemDesconto],
				NumeroProposta
		FROM [dbo].[AtendimentoPARIndica_TEMP] t where isnumeric(NumeroProposta) = 1 and NumeroProposta IS NOT NULL) c )pqp  
		left join Dados.Proposta p on p.NumeroProposta = NumeroPropostaTratado AND p.IDSeguradora = 1
		where  NumeroPropostaTratado <> '0' and NumeroPropostaTratado IS NOT NULL 
	) AS X
		ON X.NumeroPropostaTratado = T.NumeroProposta and T.IDSeguradora = 1

	--WHEN MATCHED AND TipoDado = 'AQAUTSIS' THEN UPDATE SET 
	WHEN NOT MATCHED  THEN INSERT
	(	
							    [NumeroProposta]
							   ,[NumeroPropostaEMISSAO]
							   ,[Valor]
							   ,[DataArquivo]
							   ,[ValorPremioBrutoEmissao]
							   ,[ValorPremioTotal],
								[TipoDado]
							   
							)

     VALUES (			X.[NumeroPropostaTratado],
						X.[NumeroPropostaTratado],
					    X.[ValorPremioFinal], 
					    GetDate(),
					    X.[ValorPremioFinal], 
					    X.[ValorPremioSemDesconto],
						'AQAUTSIS'
					    );


/*********************************************************************************************************************/               
/*INSERE REGISTROS NA TABELA DE PROPOSTAS - select TRY_PARSE(ltrim(rtrim(NumeroProposta)) as int),* from dbo.[AtendimentoPARIndica_TEMP] where NumeroProposta <> ''	 AND charindex('.',NumeroProposta) =  0 and NumeroProposta <> '0'  AND NumeroProposta not in ('C','FI') AND NomeCliente = 'LEONILA MARIA GONCALVES SAMPAIO'*/
/*********************************************************************************************************************/
;MERGE INTO Dados.PropostaCliente as T
	USING
	(	
		select  p.ID as IDProposta,
				CPF,NomeCliente, DataNascimento,
				p.NumeroProposta
				from (SELECT /*TRY_PARSE(Replace(Replace(Replace(Replace(Replace(Replace(c.NumeroProposta,'>',''),'C',''),'FI',''),'.',''),' ',''),'I','') AS BIGINT) as NumeroPropostaTratado,	*/
				CleansingKit.dbo.fn_TrataNumeroPropostaZeroExtra(NumeroProposta) as NumeroPropostaTratado,			
				CleansingKit.dbo.fn_FormataCPF(RIGHT(CPF, 11)) as CPF,
				NomeCliente, DataNascimento FROM (SELECT distinct
				CPF,NomeCliente, DataNascimento,NumeroProposta
		FROM [dbo].[AtendimentoPARIndica_TEMP] t where isnumeric(NumeroProposta) = 1 and NumeroProposta IS NOT NULL) c )pqp  
		inner join Dados.Proposta p on p.NumeroProposta = NumeroPropostaTratado AND p.IDSeguradora = 1
		where  NumeroPropostaTratado <> '0' and NumeroPropostaTratado IS NOT NULL and TipoDado = 'AQAUTSIS'
	) AS X
		ON X.IDProposta = T.IDProposta
	WHEN MATCHED THEN UPDATE SET CPFCNPJ = COALESCE(X.CPF,T.CPFCNPJ),
								Nome = COALESCE(X.NomeCliente,T.Nome),
								DataNascimento = COALESCE(X.DataNascimento,T.DataNascimento)
	WHEN NOT MATCHED  THEN INSERT
	(	
							    [IDProposta]
							   ,[CPFCNPJ]
							   ,[Nome]
							   ,[DataNascimento]
							   
							   
							)

     VALUES (			X.[IDProposta],
						X.[CPF],
					    X.[NomeCliente], 
					    X.[DataNascimento]
					    );



			   
/*********************************************************************************************************************/               
/*INSERE REGISTROS NA TABELA DE ATENDIMENTOS*/
/*********************************************************************************************************************/


;MERGE INTO Dados.AtendimentoPARIndica as X USING

(
SELECT		distinct		 [Protocolo],
					[CPF],
					[NomeCliente],
					CleansingKit.dbo.fn_TrataNumeroPropostaZeroExtra(TRY_PARSE(Replace(Replace(Replace(Replace(Replace(Replace([NumeroProposta],'>',''),'C',''),'FI',''),'.',''),' ',''),'I','') as bigint) ) NumeroProposta,
					[ValorPremioFinal],
					[ValorPremioSemDesconto]
FROM [dbo].[AtendimentoPARIndica_TEMP]
) AS T
ON T.NumeroProposta = X.NumeroProposta and T.Protocolo = X.Protocolo
WHEN MATCHED THEN UPDATE SET [PROTOCOLO] = COALESCE(T.PROTOCOLO,X.PROTOCOLO),
						[CPF] = COALESCE(T.CPF,X.CPF),
						[Nome] = COALESCE(T.NomeCliente,X.Nome),
						[NumeroProposta] = COALESCE(T.NumeroProposta,X.NumeroProposta),
						[Premio_Atual] = COALESCE(T.[ValorPremioFinal],X.[Premio_Atual]),
						[Premio_Sem_Desconto] = Coalesce(T.[ValorPremioSemDesconto],X.Premio_Sem_Desconto)

WHEN NOT MATCHED THEN INSERT
(						[PROTOCOLO],
						[CPF],
						[Nome],
						[NumeroProposta],
						[Premio_Atual],
						[Premio_Sem_Desconto]
)
	VALUES
(	
	T.Protocolo,
	T.CPF,
	T.NomeCliente,
	T.[NumeroProposta],
	T.[ValorPremioFinal],
	T.[ValorPremioSemDesconto]	
	
	
);
--print 'teste!!!!!!'
--print @PontoDeParada  + ' ponto de parada'
--print @MaiorCodigo  + ' maiorcodigo'
/***********************************************************************
	***********************************************************************/  			                             
                         
	/*Atualização do Ponto de Parada, igualando-o ao maior Código Trabalhado no Comando Acima*/
	/*************************************************************************************/
	/*************************************************************************************/
	SET @PontoDeParada = @MaiorCodigo
  	print 'antes de atualizar ponto parada'
	UPDATE ControleDados.PontoParada 
	SET PontoParada = @MaiorCodigo
	WHERE NomeEntidade = 'AQAUTSIS'
		print 'atualizou ponto parada'
	TRUNCATE TABLE [dbo].[AtendimentoPARIndica_TEMP]
	print 'exec 2'
	SET @COMANDO =
	'INSERT into [dbo].[AtendimentoPARIndica_TEMP] ( 
					[Protocolo],
					[CPF],
					[NomeCliente],
					[NumeroProposta],
					[ValorPremioFinal],
					[ValorPremioSemDesconto],
					[DataNascimento],
					[IDFenae]
				
				)  SELECT [Protocolo],
					[CPF],
					[NomeCliente],
					[NumeroProposta],
					[ValorPremioFinal],
					[ValorPremioSemDesconto],
					[DataNascimento]
					[ID]
	 FROM OPENQUERY ([OBERON], ''exec [Corporativo].[proc_RecuperaAtendimentoPARIndica] ''''' + @PontoDeParada + ''''''') PRP
	'

	EXEC (@COMANDO)    

	SELECT @MaiorCodigo = MAX(PRP.IDFenae)
	FROM dbo.[AtendimentoPARIndica_TEMP] AS PRP    

	END

END TRY
BEGIN CATCH
	EXEC CleansingKit.dbo.proc_RethrowError	
	RETURN @@ERROR	
END CATCH  

















--select * from ControleDados.PontoParada where ID = 77