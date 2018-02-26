

/*
	Autor: Pedro Guedes
	Data Criação: 10/02/2015

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: [Corporativo].[Dados].[proc_InsereLarMais_ODS]
	
	Descrição: Procedimento que realiza a inserção das propostas Bem Família no ODS

	Parâmetros de entrada:
	
	Retorno:


*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereLarMais_ODS]
AS

BEGIN TRY		
	    
DECLARE @PontoDeParada AS VARCHAR(400) 
DECLARE @MaiorCodigo AS BIGINT
DECLARE @COMANDO AS NVARCHAR(max) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LarMais_ODS_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[LarMais_ODS_TEMP];
--SSD.[NUM_PROPOSTA_TRATADO] [NumeroProposta], SSD.[ID_SEGURADORA] [IDSeguradora], SSD.[TIPO_DADO] [TipoDado], SSD.[DATA_ATUALIZACAO] [DataArquivo]
CREATE TABLE [dbo].[LarMais_ODS_TEMP]
(
	[ID] [int]  NOT NULL,
	[idContrato] [varchar](50) NULL,
	[CPFCGCMutuario] [varchar](70) NULL,
	[nomeMutuario] [varchar](250) NULL,
	[idCodigoCCA] [varchar](50) NULL,
	[idUnidadeOperacional] [varchar](80) NULL,
	[idApoliceSeguro] [varchar](50) NULL,
	[dscApoliceSeguro] [varchar](60) NULL,
	[idSolicitante] [varchar](50) NULL,
	[DataArquivo] [date] NULL,
	[NomeArquivo] [varchar](150) NULL,
	[CPFTRATADO]  [varchar] (50) not null,


) 



 /*Cria Índices*/  

CREATE NONCLUSTERED INDEX idx_LarMaisCPFSegurado_TEMP ON [dbo].[LarMais_ODS_TEMP] ([CPFTRATADO] ASC)  



/*********************************************************************************************************************/               
/*Recupera ponto de parada*/
/*********************************************************************************************************************/

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'LarMais'


/*********************************************************************************************************************/               
/*Carrega tabela temporária*/
/*********************************************************************************************************************/
--declare @comando nvarchar(max)

SET @COMANDO = '
INSERT INTO [dbo].[LarMais_ODS_TEMP]
				(		[id]
      ,[idContrato]
      ,[CPFCGCMutuario]
      ,[nomeMutuario]
      ,[idCodigoCCA]
      ,[idUnidadeOperacional]
       , [idApoliceSeguro]
      ,[dscApoliceSeguro]
      ,[idSolicitante]
      ,[DataArquivo]
      ,[NomeArquivo]
      ,[CPFTRATADO]


				)
				SELECT 
				[id]
			  ,[idContrato]
			  ,[CPFCGCMutuario]
			  ,[nomeMutuario]
			  ,[idCodigoCCA]
			  ,[idUnidadeOperacional]
			  ,[idApoliceSeguro]
			  ,[dscApoliceSeguro]
			  ,[idSolicitante]
			  ,[DataArquivo]
			  ,[NomeArquivo]
			  ,[CPFTRATADO]
	
	FROM OPENQUERY ([OBERON], ''EXEC [Desep].[dbo].[proc_RecuperaLarMais_ODS] ''''' + @PontoDeParada + ''''''') PRP '	
EXEC (@COMANDO)     

SELECT @MaiorCodigo = MAX(PRP.ID)
FROM [dbo].[LarMais_ODS_TEMP] PRP

SET @COMANDO = ''     

WHILE @MaiorCodigo IS NOT NULL
BEGIN 




/**********************************************************************
Inserção dos Dados - Contrato
select * from Dados.Proposta where IDPRodutoSIGPF = 68
select @@trancount
select top 1 * from Dados.UnidadeHistorico
rollback
select DataEmissao from Dados.Proposta where  NumeroProposta = '294756'
***********************************************************************/ 



MERGE INTO [Dados].[Contrato] as t
	USING
	(SELECT * FROM (SELECT 		t.[id]
      ,[idContrato] as NumeroContrato
      --,[CPFCGCMutuario] 
      --,[nomeMutuario]
      --,[idCodigoCCA]
      --,[idUnidadeOperacional]
      -- , [idApoliceSeguro]
      --,[dscApoliceSeguro]
      --,[idSolicitante]
      ,t.[DataArquivo]
      ,t.[NomeArquivo] as Arquivo
      --,[CPFTRATADO]
	  ,c.ID as IDContrato

		,ROW_NUMBER() OVER (PARTITION BY [idContrato] ORDER BY t.DataArquivo DESC) as linha
		FROM dbo.LarMais_ODS_TEMP t
	--		
	left JOIN Dados.Contrato c on c.NumeroContrato = t.IDContrato and c.IDSeguradora = 1
		--left join Dados.UnidadeHistorico uh on  uh.Nome = t.AGENCIA
		--left join Dados.Unidade u on u.ID = uh.IDUnidade
		
	) X WHERE LINHA = 1 
	--and NumeroContrato = '144440496801'
		) as s
	
		on s.IDContrato = t.ID 
		WHEN NOT MATCHED THEN INSERT (NumeroContrato,DataArquivo,Arquivo,IDSeguradora)
					Values(s.NumeroContrato,s.DataArquivo,s.Arquivo,1)
			WHEN MATCHED THEN UPDATE SET --t.NumeroContrato = s.NumeroContrato,
										t.DataArquivo = s.DataArquivo,	
										t.Arquivo = s.Arquivo	
									;




/**********************************************************************
Inserção dos Dados - Proposta

select * from Dados.Proposta where TipoDado like 'CaixaSeguros_CTR_ApoliceSeguro%'
select * from Dados.Produto where Descricao like '%LAR%'	
select @@trancount
select top 1 * from Dados.UnidadeHistorico
rollback
select DataEmissao from Dados.Proposta where  NumeroProposta = '294756'
***********************************************************************/ 

	MERGE INTO [Dados].[Proposta] as t
	USING 
	(SELECT * FROM (SELECT  c.ID as IDContrato
      ,t.[idContrato] as NumeroProposta
      --,[CPFCGCMutuario] 
      --,[nomeMutuario]
      --,[idCodigoCCA]
      --,[idUnidadeOperacional]
      -- , [idApoliceSeguro]
      --,[dscApoliceSeguro]
      --,[idSolicitante]
      
        ,[NomeArquivo] as TipoDado
        ,t.[DataArquivo]
		,p.ID as IDProposta
	    --,c.ID as IDContrato
		,ROW_NUMBER() OVER (PARTITION BY t.[idContrato] ORDER BY t.DataArquivo DESC) as linha
		FROM dbo.LarMais_ODS_TEMP t
		INNER JOIN Dados.Contrato c on c.NumeroContrato = t.[idContrato]
		left  JOIN Dados.Proposta p on p.NumeroProposta = t.IDContrato
		
		
	) X WHERE LINHA = 1 --and NumeroProposta = '294756'
		) as s
		on s.IDProposta = t.ID 
		WHEN NOT MATCHED THEN INSERT (NumeroProposta,DataArquivo,TipoDado,IDContrato,IDProdutoSIGPF,IDSeguradora,IDProduto)
					Values(s.NumeroProposta,s.DataArquivo,s.TipoDado,s.IDContrato,68,1,328)
			WHEN MATCHED THEN UPDATE SET-- t.NumeroProposta = s.NumeroProposta,
										t.DataArquivo = s.DataArquivo,
										t.TipoDado= s.TipoDado,
										t.IDProduto = 328;










/**********************************************************************
Atualiza IDProposta no Contrato
select @@trancount
***********************************************************************/ 

	MERGE INTO [Dados].[Contrato] as t
	USING
	(SELECT * FROM (SELECT c.ID as IDProposta
			,t.[idContrato] as NumeroProposta
			,ROW_NUMBER() OVER (PARTITION BY t.[idContrato] ORDER BY t.DataArquivo DESC) as linha
		FROM dbo.LarMais_ODS_TEMP t
		INNER JOIN Dados.Proposta c on c.NumeroProposta = t.[idContrato] 
		) X WHERE LINHA = 1
		) as s
		on s.NumeroProposta = t.NumeroContrato 
		WHEN MATCHED THEN UPDATE SET t.IDProposta = s.IDProposta;





/**********************************************************************
Insere PropostaFinanceiro
select @@trancount
***********************************************************************/ 


MERGE INTO [Dados].[PropostaFinanceiro] as t
	USING 
	(SELECT * FROM (SELECT t.[idContrato] as NumeroProposta        
						,[NomeArquivo] as TipoDado
						,t.[DataArquivo]
						,p.ID as IDProposta
						--,c.ID as IDContrato
		,ROW_NUMBER() OVER (PARTITION BY t.[idContrato] ORDER BY t.DataArquivo DESC) as linha
		FROM dbo.LarMais_ODS_TEMP t
		INNER  JOIN Dados.Proposta p on p.NumeroProposta = t.IDContrato
		
		
	) X WHERE LINHA = 1 --and NumeroProposta = '294756'
		) as s
		on s.IDProposta = t.ID 
		WHEN NOT MATCHED THEN INSERT (IDProposta,DataArquivo,Arquivo)
					Values(s.IDProposta,s.DataArquivo,s.TipoDado);
		


/**********************************************************************
Inserção dos Dados - PropostaCliente
select @@trancount
***********************************************************************/ 
MERGE INTO Dados.PropostaCliente as T USING
(
	SELECT  * FROM (SELECT 
		   p.ID as [IDProposta]
		     ,O.[idContrato] as NumeroProposta
      ,[CPFCGCMutuario]  as CPFCNPJ
      ,[nomeMutuario] as Nome
      --,[idCodigoCCA]
      --,[idUnidadeOperacional]
      -- , [idApoliceSeguro]
      --,[dscApoliceSeguro]
      --,[idSolicitante]
      
        ,[NomeArquivo] as TipoDado
        ,O.[DataArquivo]
		 ,ROW_NUMBER() OVER (PARTITION BY O.[idContrato]  ORDER BY o.DataArquivo DESC) as linha
FROM [dbo].[LarMais_ODS_TEMP] O
INNER JOIN Dados.Proposta p on O.[idContrato]  = p.NumeroProposta
--INNER JOIN Dados.Unidade u on O.NUMERO_AGENCIA = u.Codigo
	) x  where linha =1 
) as S on S.IDProposta = T.IDProposta
	WHEN NOT MATCHED THEN INSERT (IDProposta,CPFCNPJ,Nome,TipoPessoa,TipoDado,DataArquivo)
	VALUES(s.IDProposta,CPFCNPJ,Nome,'Pessoa Física',TipoDado,DataArquivo);



/**********************************************************************
Inserção dos Dados - PropostaoMeioPagamento
select @@trancount
select * from Dados.PropostaCLiente where IDProposta = 61324099
***********************************************************************/ 
--MERGE INTO Dados.PropostaMeioPagamento as T USING
--(
--	SELECT  * FROM (SELECT 
--       p.ID as [IDProposta]
	  
--      ,[NUMERO_PROPOSTA]
--      ,[FORMA_PAGAMENTO]
--      ,[DATA_ARQUIVO] as DataArquivo
--      ,[NOME_ARQUIVO] as TipoDado
--		--,NUMERO_AGENCIA
--		 ,ROW_NUMBER() OVER (PARTITION BY [NUMERO_PROPOSTA] ORDER BY DataArquivo DESC) as linha
--FROM [dbo].[LarMais_ODS_TEMP] O
--INNER JOIN Dados.EstadoCivil e on e.Descricao = O.ESTADO_CIVIL
--INNER JOIN Dados.Proposta p on O.[NUMERO_PROPOSTA] = p.NumeroProposta and p.IDSeguradora = 18
----INNER JOIN Dados.Unidade u on O.NUMERO_AGENCIA = u.Codigo
--where GRAU_PARENTESCO = 'TITULAR') x  where linha =1 
--) as S on S.IDProposta = T.IDProposta
--	WHEN NOT MATCHED THEN INSERT ([IDProposta],[DiaVencimento],[DiaCorte],[FormaPagamento],[Banco],[Agencia],[Conta],[OperacaoConta])
--	VALUES(s.IDProposta,CPFCNPJ,Nome,DataNascimento,'Pessoa Física',IDSexo,IDEstadoCivil,Email,TipoDado,DataArquivo);



						



/*****************************************************************************************/
/*Atualização do Ponto de Parada, igualando-o ao Maior Código Trabalhado no comando acima*/
/*****************************************************************************************/

SET @PontoDeParada =  Cast(@MaiorCodigo as varchar(20))
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @PontoDeParada
WHERE NomeEntidade = 'LarMais'

TRUNCATE TABLE [dbo].[LarMais_ODS_TEMP]

    
/*********************************************************************************************************************/               
/*Carrega tabela temporária*/ 
/*********************************************************************************************************************/
--declare @comando nvarchar(max)

SET @COMANDO = '
INSERT INTO [dbo].[LarMais_ODS_TEMP]
				(		[id]
      ,[idContrato]
      ,[CPFCGCMutuario]
      ,[nomeMutuario]
      ,[idCodigoCCA]
      ,[idUnidadeOperacional]
       , [idApoliceSeguro]
      ,[dscApoliceSeguro]
      ,[idSolicitante]
      ,[DataArquivo]
      ,[NomeArquivo]
      ,[CPFTRATADO]


				)
				SELECT 
				[id]
			  ,[idContrato]
			  ,[CPFCGCMutuario]
			  ,[nomeMutuario]
			  ,[idCodigoCCA]
			  ,[idUnidadeOperacional]
			  ,[idApoliceSeguro]
			  ,[dscApoliceSeguro]
			  ,[idSolicitante]
			  ,[DataArquivo]
			  ,[NomeArquivo]
			  ,[CPFTRATADO]
	
	FROM OPENQUERY ([OBERON], ''EXEC [Desep].[dbo].[proc_RecuperaLarMais_ODS] ''''' + @PontoDeParada + ''''''') PRP '	
EXEC (@COMANDO)

--print '-----antes------'
--print @maiorcodigo

SELECT @MaiorCodigo = MAX(PRP.ID)
FROM [dbo].[LarMais_ODS_TEMP] PRP

--print '-----depois------'
--print @maiorcodigo                      
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LarMais_ODS_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[LarMais_ODS_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH
