 
/*
	Autor: Andre Anselmo
	Data Criação: 21/03/2016

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereCorrespondente_CBN
	Descrição: Procedimento que realiza a inserção de cadastro de Correspondente Bancário no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


	select max(id) from dados.correspondente where id < 50656
	select * from dados.correspondente where id < 50656


	select count(*), matricula from dados.correspondente group by matricula having count(*) > 1

	rollback
	select * from dados.correspondente  where cpfcnpj is null and nomearquivo = 'D160309.DC0701_CBN_EMPRESARIO.txt'
	
	with c as (select cast(matricula as bigint) as matricula  from dados.correspondente )


	select count(*) as total, cpfcnpj into #temp from dados.correspondente  group by cpfcnpj having count(*) > 1

	select * from dados.correspondente as c where exists (select * from #temp as t where t.cpfcnpj=c.cpfcnpj) order by cpfcnpj

	select * from controledados.pontoparada where NomeEntidade = 'CADASTRO_CBN_SIGDC'

	SELECT @@TRANCOUNT

	ROLLBACK


	SELECT * FROM  [dbo].[CORRESPONDENTE_TEMP]

	BEGIN TRAN 

OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereCorrespondente_CBN_SIGDC_2] 
AS

BEGIN TRY		
  --  BEGIN TRAN
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CORRESPONDENTE_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[CORRESPONDENTE_TEMP];

CREATE TABLE [dbo].[CORRESPONDENTE_TEMP](
    [Codigo] [bigint] NOT NULL,
	[NomeArquivo] [nvarchar](100) NULL,
	[DataArquivo] [date] NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[NumeroMatricula] [numeric](15, 0) NULL,
	[CPFCNPJ] [varchar](20) NULL,
	[Nome] [varchar](40) NULL,
	[CodigoBanco] [smallint] NULL,
	[CodigoAgencia] [smallint] NULL,
	[CodigoOperacao] [smallint] NULL,
	[NumeroConta] [varchar](22) NULL,
	[Cidade] [varchar](70) NULL,
	[UF] [varchar](2) NULL,
	[PontoVenda] [smallint] NULL,
	IDTipoCorrespondente tinyint not null default(1),
	IDTipoProduto tinyint not null default(1),
	Endereco VARCHAR(200),
	Bairro VARCHAR(200),
	Complemento VARCHAR(200),
	Email VARCHAR(200),
	CEP VARCHAR(10),
	DDD  VARCHAR(3),
	Telefone  VARCHAR(15),
	DDDFax  VARCHAR(3),
	Fax  VARCHAR(15),
	ICSituacao  VARCHAR(2),
	TipoCorrespondente  VARCHAR(50),
	RamoAtividade  VARCHAR(20),
	Equipe VARCHAR(20),
	NomeEquipe VARCHAR(200)

);

 /*Cria alguns índices para facilitar a busca*/  
CREATE NONCLUSTERED INDEX idx_CORRESPONDENTE_TEMP_NumeroPropost ON [dbo].[CORRESPONDENTE_TEMP]
( 
	NumeroMatricula ASC,
	[DataArquivo] DESC
)


CREATE NONCLUSTERED INDEX IDX_CORRESPONDENTE_TEMP_PontoVenda ON [dbo].[CORRESPONDENTE_TEMP] 
(
	[CodigoAgencia]
)


SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'CADASTRO_CBN_SIGDC'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
  
    SET @COMANDO =
    '
  INSERT INTO dbo.CORRESPONDENTE_TEMP
       ( 
		[Codigo],
		[NomeArquivo],
		[DataArquivo],
		[ControleVersao],
		[NumeroMatricula],
		[CPFCNPJ],
		[Nome],
		[CodigoBanco],
		[CodigoAgencia],
		[CodigoOperacao],
		[NumeroConta],
		[Cidade],
		[UF],
		[PontoVenda],
		[Endereco],
		[Bairro],
		[Complemento],
		[Email],
		[CEP],
		[DDD],
		[Telefone],
		[DDDFax],
		[Fax],
		[ICSituacao],
		[TipoCorrespondente],
		[RamoAtividade],
		[Equipe],
		[NomeEquipe]
		)
       SELECT
				[Codigo],
				[NomeArquivo],
				[DataArquivo],
				[ControleVersao],
				Matricula AS NumeroMatricula,
				[CPFCNPJ],
				[Nome],
				[CodigoBanco],
				[CodigoAgencia],
				[CodigoOperacao],
				[NumeroConta],
				[Cidade],
				[UF],
				[PontoVenda],
				[Endereco],
				[Bairro],
				[Complemento],
				[Email],
				[CEP],
				[DDD],
				[Telefone],
				[DDDFax],
				[Fax],
				[ICSituacao],
				[TipoCorrespondente],
				[RamoAtividade],
				[Equipe],
				[NomeEquipe]
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_recuperaCadastro_CBN_SIGDC]''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.CORRESPONDENTE_TEMP PRP                    



/*********************************************************************************************************************/
                           
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN
--print @MaiorCodigo

	 UPDATE ControleDados.PontoParada 
	 SET PontoParada = @PontoDeParada
	 WHERE NomeEntidade = 'CADASTRO_CBN_SIGDC'
	/***********************************************************************
		   Carregar as agencias desconhecidas
	***********************************************************************/

	/*INSERE PVs NÃO LOCALIZADOS*/
	;INSERT INTO Dados.Unidade(Codigo)

	SELECT DISTINCT CAD.PontoVenda
	FROM dbo.[CORRESPONDENTE_TEMP] CAD
	WHERE  CAD.PontoVenda IS NOT NULL 
	  AND NOT EXISTS (
					  SELECT     *
					  FROM  Dados.Unidade U
					  WHERE U.Codigo = CAD.PontoVenda)                                                                        

	INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)

	SELECT DISTINCT U.ID, 
					'UNIDADE COM DADOS INCOMPLETOS' [Unidade], 
					-1 [CodigoNaFonte], 
					'CADASTRO_CBN' [TipoDado], 
					MAX(EM.DataArquivo) [DataArquivo], 
					'CADASTRO_CBN' [Arquivo]

	FROM dbo.[CORRESPONDENTE_TEMP] EM
	INNER JOIN Dados.Unidade U
	ON EM.PontoVenda = U.Codigo
	WHERE 
		NOT EXISTS (
					SELECT     *
					FROM Dados.UnidadeHistorico UH
					WHERE UH.IDUnidade = U.ID)    
	GROUP BY U.ID 
        

		
		           
     /***********************************************************************
       Carrega os dados do Correspondente
     ***********************************************************************/             
    ;MERGE INTO Dados.Correspondente AS T
		USING (
				SELECT *
				FROM
				(
					SELECT  
							C.[Codigo],
							[NomeArquivo],
							[DataArquivo],
							[ControleVersao],
							[NumeroMatricula],
							[CPFCNPJ],
							[Nome],
							[Cidade],
							[UF],
							--[PontoVenda],
							U.ID [IDUnidade],
							IDTipoCorrespondente,
							[Endereco],
							[Bairro],
							[Complemento],
							[Email],
							[CEP],
							[DDD],
							[Telefone],
							[DDDFax],
							[Fax],
							[ICSituacao],
							[TipoCorrespondente],
							[RamoAtividade],
							Equipe,
							NomeEquipe,
						   ROW_NUMBER() OVER(PARTITION BY NumeroMatricula, CPFCNPJ ORDER BY DataArquivo DESC) ORDEM            
					FROM dbo.CORRESPONDENTE_TEMP C
         				INNER JOIN Dados.Unidade U
						ON C.PontoVenda = U.Codigo
					--	where [NumeroMatricula] = 50016
				 ) A 
				 WHERE A.ORDEM = 1
          ) AS X
    ON X.[NumeroMatricula] = T.[Matricula]  
   AND X.IDTipoCorrespondente = T.IDTipoCorrespondente
    WHEN MATCHED AND X.DataArquivo >= T.DataArquivo
			 THEN UPDATE
			 SET [Nome] = COALESCE(X.[Nome], T.[Nome])
				, IDUnidade = COALESCE(X.[IDUnidade], T.[IDUnidade])     
				, IDTipoCorrespondente = COALESCE(X.IDTipoCorrespondente, T.IDTipoCorrespondente)  
				, CPFCNPJ = COALESCE(X.CPFCNPJ, T.CPFCNPJ)  
				, UF = COALESCE(X.UF, T.UF)  
				, Cidade = COALESCE(X.Cidade, T.Cidade)
				, Endereco = COALESCE(X.Endereco, T.Endereco)
				, Bairro = COALESCE(X.Bairro, T.Bairro)
				, Complemento = COALESCE(X.Complemento, T.Complemento)
				, Email = COALESCE(X.Email, T.Email)
				, CEP = COALESCE(X.CEP, T.CEP)
				, DDD = COALESCE(X.DDD, T.DDD)
				, Telefone = COALESCE(X.Telefone, T.Telefone)
				, DDDFax = COALESCE(X.DDDFax, T.DDDFax)
				, Fax = COALESCE(X.Fax, T.Fax)
				, ICSituacao = COALESCE(X.ICSituacao, T.ICSituacao)
				, TipoCorrespondente = COALESCE(X.TipoCorrespondente, T.TipoCorrespondente)
				, RamoAtividade = COALESCE(X.RamoAtividade, T.RamoAtividade)
				, Equipe = COALESCE(X.Equipe, T.Equipe)
				, NomeEquipe = COALESCE(X.NomeEquipe, T.NomeEquipe)
				, NomeArquivo = COALESCE(X.NomeArquivo, T.NomeArquivo)              
				, DataArquivo = COALESCE(X.DataArquivo, T.DataArquivo)   
    WHEN NOT MATCHED
			    THEN INSERT          
              (	 
					Matricula
					, CPFCNPJ
					, Nome 
					, IDUnidade     
					, IDTipoCorrespondente   
					, UF
					, Cidade 
					, NomeArquivo              
					, DataArquivo   
					, Endereco
					, Bairro
					, Complemento
					, Email
					, CEP
					, DDD
					, Telefone
					, DDDFax
					, Fax
					, ICSituacao
					, TipoCorrespondente
					, RamoAtividade
					, Equipe
					, NomeEquipe
             )
          VALUES (
					X.[NumeroMatricula]
					,X.CPFCNPJ
					,X.[Nome]
					,X.[IDUnidade]
					,X.IDTipoCorrespondente
					,X.UF
					,X.Cidade
					,X.NomeArquivo
					,X.DataArquivo
					,X.Endereco
					,X.Bairro
					,X.Complemento
					,X.Email
					,X.CEP
					,X.DDD
					,X.Telefone
					,X.DDDFax
					,X.Fax
					,X.ICSituacao
					,X.TipoCorrespondente
					,X.RamoAtividade
					,X.Equipe
					,X.NomeEquipe
                 );    
                            
                     
	   /***********************************************************************
       Carrega os dados bancários do Correspondente
     ***********************************************************************/             
    ;MERGE INTO Dados.CorrespondenteDadosBancarios AS T
		USING (
				SELECT *
				FROM
				(
					SELECT  
						   CC.ID [IDCorrespondente],
						   [CodigoBanco],
						   [CodigoAgencia],
						   [CodigoOperacao],
						   [NumeroConta],
						   IDTipoProduto,		
						   CC.IDTipoCorrespondente,
						   C.DataArquivo,
						   C.NomeArquivo,
						   ROW_NUMBER() OVER(PARTITION BY C.NumeroMatricula, C.CPFCNPJ ORDER BY C.DataArquivo DESC) ORDEM            
					FROM dbo.CORRESPONDENTE_TEMP C
					    INNER JOIN Dados.Correspondente	CC
						ON 	C.[NumeroMatricula] = CC.[Matricula] 
				 	--	AND	C.[CPFCNPJ] = CC.[CPFCNPJ]
						AND C.IDTipoCorrespondente = CC.IDTipoCorrespondente
				 ) A 					
				 WHERE A.ORDEM = 1
          ) AS X
    ON X.[IDCorrespondente] = T.[IDCorrespondente] 
	AND X.IDTipoProduto = T.IDTipoProduto
    
    WHEN MATCHED AND X.DataArquivo >= T.DataArquivo
			    THEN UPDATE	SET				    
                 Banco = COALESCE(X.[CodigoBanco], T.Banco)
               , Agencia = COALESCE(X.[CodigoAgencia], T.Agencia)
               , Operacao = COALESCE(X.[CodigoOperacao], T.Operacao)
			   , ContaCorrente = COALESCE(X.[NumeroConta], T.ContaCorrente)
			   , NomeArquivo = COALESCE(X.NomeArquivo, T.NomeArquivo)              
               , DataArquivo = COALESCE(X.DataArquivo, T.DataArquivo)   
    WHEN NOT MATCHED
			    THEN INSERT          
              (	 IDCorrespondente
			   , IDTipoProduto
               , Banco 
               , Agencia 
               , Operacao 
			   , ContaCorrente
			   , NomeArquivo              
               , DataArquivo              
             )
          VALUES (X.IDCorrespondente
                 ,X.IDTipoProduto
                 ,X.[CodigoBanco]
                 ,X.[CodigoAgencia]
                 ,X.[CodigoOperacao]
                 ,X.[NumeroConta]
                 ,X.NomeArquivo
                 ,X.DataArquivo
                 );  
				       
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
 SET @PontoDeParada = @MaiorCodigo--LEFT(DATEADD(MM, 1, Cast(@PontoDeParada + '-01' as date)), 7)
  /*************************************************************************************/
 print @PontoDeParada

  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[CORRESPONDENTE_TEMP]	   
  /*********************************************************************************************************************/                  
    
    SET @COMANDO =
    '
  INSERT INTO dbo.CORRESPONDENTE_TEMP
       ( 
		[Codigo],
		[NomeArquivo],
		[DataArquivo],
		[ControleVersao],
		[NumeroMatricula],
		[CPFCNPJ],
		[Nome],
		[CodigoBanco],
		[CodigoAgencia],
		[CodigoOperacao],
		[NumeroConta],
		[Cidade],
		[UF],
		[PontoVenda],
		[Endereco],
		[Bairro],
		[Complemento],
		[Email],
		[CEP],
		[DDD],
		[Telefone],
		[DDDFax],
		[Fax],
		[ICSituacao],
		[TipoCorrespondente],
		[RamoAtividade],
		[Equipe],
		[NomeEquipe]
		)
       SELECT
				[Codigo],
				[NomeArquivo],
				[DataArquivo],
				[ControleVersao],
				Matricula AS NumeroMatricula,
				[CPFCNPJ],
				[Nome],
				[CodigoBanco],
				[CodigoAgencia],
				[CodigoOperacao],
				[NumeroConta],
				[Cidade],
				[UF],
				[PontoVenda],
				[Endereco],
				[Bairro],
				[Complemento],
				[Email],
				[CEP],
				[DDD],
				[Telefone],
				[DDDFax],
				[Fax],
				[ICSituacao],
				[TipoCorrespondente],
				[RamoAtividade],
				[Equipe],
				[NomeEquipe]
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_recuperaCadastro_CBN_SIGDC]''''' + @PontoDeParada + ''''''') PRP
         '
  exec (@COMANDO) 
                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM dbo.CORRESPONDENTE_TEMP PRP    
                    
  /*********************************************************************************************************************/
                    
  /*********************************************************************************************************************/
  
END
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CORRESPONDENTE_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[CORRESPONDENTE_TEMP];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     


--EXEC [Dados].[proc_InsereCorrespondente_CBN] 


