
/*
	Autor: Luan Moreno M. Maciel
	Data Criação: 27/03/2014
*/

/*******************************************************************************
Nome: Corporativo.Dados.proc_InsereVida_KPN	
--*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereVida_KPN] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400) = 0
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Vida_KPN_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Vida_KPN_TEMP];

CREATE TABLE [dbo].[Vida_KPN_TEMP]
(
	ID BIGINT IDENTITY(1,1) NOT NULL,
	DataArquivo DATE NULL,
	NomeArquivo VARCHAR(300) NULL,
	ControleVersao CHAR(15) NULL,
	Protocolo CHAR(10) NULL,
	TMA SMALLINT NULL,
	Nome VARCHAR(100) NULL,
	CPF CHAR(14) NULL,
	DataNascimento DATE NULL,
	Status_Ligacao VARCHAR(100) NULL,
	Status_Final VARCHAR(100) NULL,
	Telefone_Contato_Efetivo CHAR(20) NULL,
	Tel_Contato_1 CHAR(20) NULL,
	Tel_Contato_2 CHAR(20) NULL,
	Email1 VARCHAR(200) NULL,
	DateTime_Contato_Efetivo DATETIME NULL,
	TipoProduto INT NULL,
	Contato_Mkt_Direto VARCHAR(200) NULL,
	ProdutosAdquiridos VARCHAR(200) NULL,
	Banco VARCHAR(200) NULL,
	ProdutoOferta VARCHAR(200) NULL,
	ProdutoEfetivado VARCHAR(200) NULL,
	Premio_Atual DECIMAL(18,2) NULL,
	FormaPagamento VARCHAR(200) NULL,
	Proposta CHAR(40) NULL,
	Importancia_Assegurada VARCHAR(200) NULL,
	Cod_Campanha VARCHAR(200) NULL,
	Nome_Campanha VARCHAR(200) NULL,
	Cod_Mailing VARCHAR(200) NULL,
	Produto_Efetivado VARCHAR(200) NULL
) ON [PRIMARY]

 /*Cria Índices */  
CREATE CLUSTERED INDEX idx_Vida_KPN_TEMP 
ON [dbo].Vida_KPN_TEMP
( 
  ID ASC
)   

CREATE NONCLUSTERED INDEX idx_NDX_NumeroProposta_Vida_KPN_TEMP
ON [dbo].Vida_KPN_TEMP
( 
  CPF ASC
)       

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Vida_KPN'

/*********************************************************************************************************************/               
/*Recuperação do Maior Código*/
/*********************************************************************************************************************/
SET @COMANDO =
'
INSERT INTO [dbo].[Vida_KPN_TEMP]
(
	DataArquivo,
	NomeArquivo,
	ControleVersao,
	Protocolo,
	TMA,
	Nome,
	CPF,
	DataNascimento,
	Status_Ligacao,
	Status_Final,
	Telefone_Contato_Efetivo,
	Tel_Contato_1,
	Tel_Contato_2,
	Email1,
	DateTime_Contato_Efetivo,
	TipoProduto,
	Contato_Mkt_Direto,
	ProdutosAdquiridos,
	Banco,
	ProdutoOferta,
	ProdutoEfetivado,
	Premio_Atual,
	FormaPagamento,
	Proposta,
	Importancia_Assegurada,
	Cod_Campanha,
	Nome_Campanha,
	Cod_Mailing,
	Produto_Efetivado
)
SELECT 	
	DataArquivo,
	NomeArquivo,
	ControleVersao,
	Protocolo,
	TMA,
	Nome,
	CPF,
	DataNascimento,
	Status_Ligacao,
	Status_Final,
	Telefone_Contato_Efetivo,
	Tel_Contato_1,
	Tel_Contato_2,
	Email1,
	DateTime_Contato_Efetivo,
	TipoProduto,
	Contato_Mkt_Direto,
	ProdutosAdquiridos,
	Banco,
	ProdutoOferta,
	ProdutoEfetivado,
	Premio_Atual,
	FormaPagamento,
	Proposta,
	Importancia_Assegurada,
	Cod_Campanha,
	Nome_Campanha,
	Cod_Mailing,
	Produto_Efetivado
FROM OPENQUERY ([OBERON], ''EXEC [Fenae].[Corporativo].[proc_RecuperaVida_KPN] ''''' + @PontoDeParada + ''''''') PRP'	   

EXEC (@COMANDO)  
		   
SELECT @MaiorCodigo = MAX(ID)
FROM [dbo].[Vida_KPN_TEMP]

SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN

/**********************************************************************
Inserção dos Dados - Status de Ligação
***********************************************************************/             
MERGE INTO Dados.Status_Ligacao AS T
USING 
(
	SELECT DISTINCT Status_Ligacao AS Nome
	FROM [dbo].[Vida_KPN_TEMP]
	WHERE Status_Ligacao IS NOT NULL
) AS S
ON T.Nome = S.Nome
WHEN NOT MATCHED THEN
	INSERT (Nome)
	VALUES (S.Nome);

/**********************************************************************
Inserção dos Dados - Status de Ligação
***********************************************************************/             
MERGE INTO Dados.Status_Final AS T
USING 
(
	SELECT DISTINCT Status_Final AS Nome
	FROM [dbo].[Vida_KPN_TEMP]
	WHERE Status_Final IS NOT NULL
) AS S
ON T.Nome = S.Nome
WHEN NOT MATCHED THEN
	INSERT (Nome)
	VALUES (S.Nome);

/**********************************************************************
Inserção dos Dados - Dados de Atendimento de Contatos
***********************************************************************/   
MERGE INTO Dados.AtendimentoContatos AS T
USING
(
	SELECT DISTINCT Telefone_Contato_Efetivo AS TelefoneEmail
	FROM
		(
			SELECT DISTINCT Telefone_Contato_Efetivo
			FROM [dbo].[Vida_KPN_TEMP]
			WHERE Telefone_Contato_Efetivo IS NOT NULL
			UNION ALL
			SELECT DISTINCT ISNULL(Tel_Contato_1, Tel_Contato_2)
			FROM [dbo].[Vida_KPN_TEMP] 
			WHERE ISNULL(Tel_Contato_1, Tel_Contato_2) IS NOT NULL
			UNION ALL
			SELECT DISTINCT Email1 
			FROM [dbo].[Vida_KPN_TEMP]
			WHERE Email1 IS NOT NULL
		) AS Dados
) AS S
ON T.TelefoneEmail = S.TelefoneEmail
WHEN NOT MATCHED THEN
	INSERT (TelefoneEmail)
	VALUES (S.TelefoneEmail)

WHEN MATCHED THEN
	UPDATE 
		SET TelefoneEmail = COALESCE(S.TelefoneEmail, T.TelefoneEmail);

--UPDATE Dados.Atendimento
--	SET IDTelefoneEfetivo = NULL,
--		IDTelefone = NULL,
--		IDTelefoneAdicional = NULL,
--		IDEmail = NULL

--DELETE
--FROM Dados.AtendimentoContatos 

/**********************************************************************
Inserção dos Dados - Dados de Atendimento
***********************************************************************/  
MERGE INTO Dados.Atendimento AS T
USING 
(
SELECT DISTINCT
		T.Protocolo, 
		T.TMA,
		T.CPF,
		T.DataNascimento,
		T.Nome,
		SL.ID AS IDStatus_Ligacao,
		SF.ID AS IDStatus_Final,
		TE.ID AS IDTelefoneEfetivo,
		TEL.ID AS IDTelefone,
		EM.ID AS IDEmail,
		PROD.ID AS IDProduto,
		T.ProdutosAdquiridos,
		T.Contato_Mkt_Direto,
		T.Produto_Efetivado,
		T.DateTime_Contato_Efetivo,
		T.ProdutosAdquiridos AS Produto,
		T.ProdutoOferta AS ProdutoOferta,
		T.Premio_Atual,
		T.FormaPagamento,
		T.Cod_Campanha AS NomeCampanha, 
		T.Cod_Mailing AS NomeMailing,
		NomeArquivo,
		Banco,
		Importancia_Assegurada
FROM [dbo].[Vida_KPN_TEMP] AS T
LEFT OUTER JOIN Dados.Status_Ligacao AS SL
ON T.Status_Ligacao = SL.Nome
LEFT OUTER JOIN Dados.Status_Final AS SF
ON T.Status_Final = SF.Nome
INNER JOIN Dados.AtendimentoContatos AS TE
ON TE.TelefoneEmail = T.Telefone_Contato_Efetivo
LEFT OUTER JOIN  Dados.AtendimentoContatos AS TEL
ON TEL.TelefoneEmail = ISNULL(T.Tel_Contato_1, T.Tel_Contato_2)
LEFT OUTER JOIN  Dados.AtendimentoContatos AS EM
ON EM.TelefoneEmail = T.Email1
LEFT OUTER JOIN Dados.Produto AS PROD
ON CAST(T.TipoProduto AS CHAR(8)) = PROD.CodigoComercializado 
--WHERE Protocolo = 5736180
) AS S
ON T.Protocolo = S.Protocolo
	AND T.CPF = S.CPF
WHEN MATCHED THEN
	UPDATE
		SET TMA = COALESCE(S.TMA, T.TMA),
		    DataNascimento = COALESCE(S.DataNascimento, T.DataNascimento),
			IDStatus_Ligacao = COALESCE(S.IDStatus_Ligacao, T.IDStatus_Ligacao),
			IDStatus_Final = COALESCE(S.IDStatus_Final, T.IDStatus_Final),
			IDTelefoneEfetivo = COALESCE(S.IDTelefoneEfetivo, T.IDTelefoneEfetivo),
			IDTelefone = COALESCE(S.IDTelefone, T.IDTelefone),
			Nome = COALESCE(S.Nome, T.Nome),
			IDEmail = COALESCE(S.IDEmail, T.IDEmail),
			IDProduto = COALESCE(S.IDProduto, T.IDProduto),
			DateTime_Contato_Efetivo = COALESCE(S.DateTime_Contato_Efetivo, T.DateTime_Contato_Efetivo),
			ProdutosAdquiridos = COALESCE(S.ProdutosAdquiridos, T.ProdutosAdquiridos),
			Contato_Mkt_Direto = COALESCE(S.Contato_Mkt_Direto, T.Contato_Mkt_Direto),
			Produto_Efetivado = COALESCE(S.Produto_Efetivado, T.Produto_Efetivado),
			ProdutoOferta = COALESCE(S.ProdutoOferta, T.ProdutoOferta),
			Premio_Atual = COALESCE(S.Premio_Atual, T.Premio_Atual),
			FormaPagamento = COALESCE(S.FormaPagamento, T.FormaPagamento),
			NomeCampanha = COALESCE(S.NomeCampanha, T.NomeCampanha),
			NomeMailing = COALESCE(S.NomeMailing, T.NomeMailing),
			NomeArquivo = COALESCE(S.NomeArquivo, T.NomeArquivo),
			Banco = COALESCE(S.Banco, T.Banco),
			Importancia_Assegurada = COALESCE(S.Importancia_Assegurada, T.Importancia_Assegurada)
WHEN NOT MATCHED THEN
	INSERT ( Protocolo, TMA, CPF, DataNascimento, IDStatus_Ligacao, IDStatus_Final, IDTelefoneEfetivo, IDTelefone, IDEmail,
		     IDProduto, ProdutosAdquiridos, Contato_Mkt_Direto, Produto_Efetivado, DateTime_Contato_Efetivo,
			 ProdutoOferta, Premio_Atual, FormaPagamento, Nome, NomeArquivo, Importancia_Assegurada, NomeMailing , NomeCampanha, Banco )
	VALUES ( Protocolo, TMA, CPF, DataNascimento, IDStatus_Ligacao, IDStatus_Final, IDTelefoneEfetivo, IDTelefone, IDEmail,
		     IDProduto, ProdutosAdquiridos, Contato_Mkt_Direto, Produto_Efetivado, DateTime_Contato_Efetivo,
			 ProdutoOferta, Premio_Atual, FormaPagamento, Nome, NomeArquivo, Importancia_Assegurada, NomeMailing , NomeCampanha, Banco ) ;

--SELECT Protocolo, COUNT(*) AS QTD
--FROM Dados.Atendimento
--GROUP BY Protocolo
--HAVING COUNT(*) > 1

--SELECT *
--FROM Dados.Atendimento
--WHERE Protocolo = 5736180   

--DELETE 
--FROM Dados.AtendimentoClientePropostas

--DELETE 
--FROM Dados.Atendimento

/**********************************************************************
Inserção dos Dados - Dados de Atendimento Proposta de Clientes
***********************************************************************/    
MERGE INTO Dados.AtendimentoClientePropostas AS T
USING
	(
		SELECT DA.ID AS IDAtendimento,
			   P.ID AS IDProposta
		FROM [dbo].[Vida_KPN_TEMP] AS T
		INNER JOIN Dados.Proposta AS P
		ON T.Proposta = P.NumeroProposta
		INNER JOIN Dados.Atendimento AS DA
		ON DA.Protocolo = T.Protocolo
			AND DA.CPF = T.CPF
	) AS S
ON T.IDAtendimento = S.IDAtendimento
WHEN NOT MATCHED THEN
	INSERT (IDAtendimento, IDProposta)
	VALUES (IDAtendimento, IDProposta);

/*****************************************************************************************/
/*Ponto de Parada*/
/*****************************************************************************************/
SET @PontoDeParada = @MaiorCodigo
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @MaiorCodigo
WHERE NomeEntidade = 'Vida_KPN'

TRUNCATE TABLE [dbo].[Vida_KPN_TEMP]

/*Recuperação do Maior Código do Retorno*/
SET @COMANDO =
'
INSERT INTO [dbo].[Vida_KPN_TEMP]
(
	DataArquivo,
	NomeArquivo,
	ControleVersao,
	Protocolo,
	TMA,
	Nome,
	CPF,
	DataNascimento,
	Status_Ligacao,
	Status_Final,
	Telefone_Contato_Efetivo,
	Tel_Contato_1,
	Tel_Contato_2,
	Email1,
	DateTime_Contato_Efetivo,
	TipoProduto,
	Contato_Mkt_Direto,
	ProdutosAdquiridos,
	Banco,
	ProdutoOferta,
	ProdutoEfetivado,
	Premio_Atual,
	FormaPagamento,
	Proposta,
	Importancia_Assegurada,
	Cod_Campanha,
	Nome_Campanha,
	Cod_Mailing,
	Produto_Efetivado
)
SELECT 	
	DataArquivo,
	NomeArquivo,
	ControleVersao,
	Protocolo,
	TMA,
	Nome,
	CPF,
	DataNascimento,
	Status_Ligacao,
	Status_Final,
	Telefone_Contato_Efetivo,
	Tel_Contato_1,
	Tel_Contato_2,
	Email1,
	DateTime_Contato_Efetivo,
	TipoProduto,
	Contato_Mkt_Direto,
	ProdutosAdquiridos,
	Banco,
	ProdutoOferta,
	ProdutoEfetivado,
	Premio_Atual,
	FormaPagamento,
	Proposta,
	Importancia_Assegurada,
	Cod_Campanha,
	Nome_Campanha,
	Cod_Mailing,
	Produto_Efetivado
FROM OPENQUERY ([OBERON], ''EXEC [Fenae].[Corporativo].[proc_RecuperaVida_KPN] ''''' + @PontoDeParada + ''''''') PRP'	   

EXEC (@COMANDO)  

SELECT @MaiorCodigo = MAX(ID)
FROM [dbo].[Vida_KPN_TEMP]
                    
END

 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Vida_KPN_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Vida_KPN_TEMP]				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH

--	EXEC [Dados].[proc_InsereVida_KPN] 0

--SELECT *
--FROM Dados.Atendimento