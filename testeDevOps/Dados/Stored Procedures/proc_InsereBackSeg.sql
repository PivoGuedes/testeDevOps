
/*
	Autor: Luan Moreno M. Maciel
	Data Criação: 15/04/2014
*/

/*******************************************************************************
Nome: Corporativo.Dados.proc_InsereBackSeg	
--*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereBackSeg] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400) = 0
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BACKSEG_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[BACKSEG_TEMP];

CREATE TABLE [dbo].[BACKSEG_TEMP]
(
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[DataArquivo] [date] NULL,
	[NomeArquivo] [varchar](300) NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[Cod_Cliente] [varchar](20) NULL,
	[NumeroTitulo] [char](25) NULL,
	[DataVigencia] [date] NULL,
	[CPF] [char](14) NULL,
	[NomeDevedor] [varchar](80) NULL,
	[UF] [char](10) NULL,
	[DateTime_Contato_Efetivo] [datetime] NULL,
	[TipoFone] [varchar](20) NULL,
	[num_fone] [varchar](20) NULL,
	[Fone_1] [varchar](20) NULL,
	[Fone_2] [varchar](20) NULL,
	[Fone_3] [varchar](20) NULL,
	[Fone_4] [varchar](20) NULL,
	[Fone_5] [varchar](20) NULL,
	[email1] [varchar](80) NULL,
	[email2] [varchar](80) NULL,
	[TipoDoador] [varchar](80) NULL,
	[TipoAcao] [varchar](80) NULL,
	[TipoSubAcao] [varchar](80) NULL,
	[APPL] [varchar](80) NULL,
	[TipoCliente] [varchar](20) NOT NULL
) ON [PRIMARY]

 /*Cria Índices */  
CREATE CLUSTERED INDEX idx_BACKSEG_TEMP 
ON [dbo].BACKSEG_TEMP
( 
  ID ASC
)   

CREATE NONCLUSTERED INDEX idx_NDX_NumeroProposta_BACKSEG_TEMP
ON [dbo].BACKSEG_TEMP
( 
  CPF ASC
)       

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'BACKSEG'

/*********************************************************************************************************************/               
/*Recuperação do Maior Código*/
/*********************************************************************************************************************/
SET @COMANDO =
'
INSERT INTO [dbo].[BACKSEG_TEMP]
(
	[DataArquivo],
	[NomeArquivo],
	[ControleVersao],
	[Cod_Cliente],
	[NumeroTitulo],
	[DataVigencia],
	[CPF],
	[NomeDevedor],
	[UF],
	[DateTime_Contato_Efetivo],
	[TipoFone],
	[num_fone],
	[Fone_1],
	[Fone_2],
	[Fone_3],
	[Fone_4],
	[Fone_5],
	[email1],
	[email2],
	[TipoDoador],
	[TipoAcao],
	[TipoSubAcao],
	[APPL],
	[TipoCliente]
)
SELECT 	
	[DataArquivo],
	[NomeArquivo],
	[ControleVersao],
	[Cod_Cliente],
	[NumeroTitulo],
	[DataVigencia],
	[CPF],
	[NomeDevedor],
	[UF],
	[DateTime_Contato_Efetivo],
	[TipoFone],
	[num_fone],
	[Fone_1],
	[Fone_2],
	[Fone_3],
	[Fone_4],
	[Fone_5],
	[email1],
	[email2],
	[TipoDoador],
	[TipoAcao],
	[TipoSubAcao],
	[APPL],
	[TipoCliente]
FROM OPENQUERY ([OBERON], ''EXEC [Fenae].[Corporativo].[proc_RecuperaBackSeg] ''''' + @PontoDeParada + ''''''') PRP'	   

EXEC (@COMANDO)  
		   
SELECT @MaiorCodigo = MAX(ID)
FROM [dbo].[BACKSEG_TEMP]

SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN


/**********************************************************************
Inserção dos Dados - Tipo de Fone
***********************************************************************/             
MERGE INTO Dados.TipoFone AS T
USING 
(
	SELECT DISTINCT TipoFone AS Nome
	FROM [dbo].[BACKSEG_TEMP]
	WHERE TipoFone IS NOT NULL
) AS S
ON T.Nome = S.Nome
WHEN NOT MATCHED THEN
	INSERT (Nome)
	VALUES (S.Nome);

/**********************************************************************
Inserção dos Dados - Tipo de Doador
***********************************************************************/             
MERGE INTO Dados.TipoDoador AS T
USING 
(
	SELECT DISTINCT TipoDoador AS Nome
	FROM [dbo].[BACKSEG_TEMP]
	WHERE TipoDoador IS NOT NULL
) AS S
ON T.Nome = S.Nome
WHEN NOT MATCHED THEN
	INSERT (Nome)
	VALUES (S.Nome);

/**********************************************************************
Inserção dos Dados - Tipo de Ação
***********************************************************************/             
MERGE INTO Dados.TipoAcao AS T
USING 
(
	SELECT DISTINCT TipoAcao AS Nome
	FROM [dbo].[BACKSEG_TEMP]
	WHERE TipoAcao IS NOT NULL
) AS S
ON T.Nome = S.Nome
WHEN NOT MATCHED THEN
	INSERT (Nome)
	VALUES (S.Nome);

/**********************************************************************
Inserção dos Dados - Tipo de Sub Ação
***********************************************************************/             
MERGE INTO Dados.TipoSubAcao AS T
USING 
(
	SELECT DISTINCT TipoSubAcao AS Nome
	FROM [dbo].[BACKSEG_TEMP]
	WHERE TipoSubAcao IS NOT NULL
) AS S
ON T.Nome = S.Nome
WHEN NOT MATCHED THEN
	INSERT (Nome)
	VALUES (S.Nome);

/**********************************************************************
Inserção dos Dados - Tipo de Cliente
***********************************************************************/             
MERGE INTO Dados.TipoCliente AS T
USING 
(
	SELECT DISTINCT TipoCliente AS Nome
	FROM [dbo].[BACKSEG_TEMP]
	WHERE TipoCliente IS NOT NULL
) AS S
ON T.Nome = S.Nome
WHEN NOT MATCHED THEN
	INSERT (Nome)
	VALUES (S.Nome);

--SELECT *
--FROM Dados.TipoFone

--SELECT *
--FROM Dados.TipoDoador

--SELECT *
--FROM Dados.TipoAcao

--SELECT *
--FROM Dados.TipoSubAcao

--SELECT *
--FROM Dados.TipoCliente

/**********************************************************************
Inserção dos Dados - Dados de Atendimento de Contatos
***********************************************************************/   
MERGE INTO Dados.AtendimentoContatos AS T
USING
(
	SELECT DISTINCT Telefone_Contato_Efetivo AS TelefoneEmail
	FROM
		(
			SELECT DISTINCT num_fone AS Telefone_Contato_Efetivo
			FROM [dbo].[BACKSEG_TEMP]
			WHERE num_fone IS NOT NULL
			UNION ALL
			SELECT DISTINCT ISNULL(fone_1, fone_2)
			FROM [dbo].[BACKSEG_TEMP] 
			WHERE ISNULL(fone_1, fone_2) IS NOT NULL
			UNION ALL
			SELECT DISTINCT ISNULL(fone_3, fone_4)
			FROM [dbo].[BACKSEG_TEMP] 
			WHERE ISNULL(fone_3, fone_4) IS NOT NULL
			UNION ALL
			SELECT DISTINCT fone_5
			FROM [dbo].[BACKSEG_TEMP]
			WHERE fone_5 IS NOT NULL
			UNION ALL
			SELECT DISTINCT Email1 
			FROM [dbo].[BACKSEG_TEMP]
			WHERE Email1 IS NOT NULL
			UNION ALL
			SELECT DISTINCT Email2
			FROM [dbo].[BACKSEG_TEMP]
			WHERE Email2 IS NOT NULL
		) AS Dados
) AS S
ON T.TelefoneEmail = S.TelefoneEmail
WHEN NOT MATCHED THEN
	INSERT (TelefoneEmail)
	VALUES (S.TelefoneEmail)

WHEN MATCHED THEN
	UPDATE 
		SET TelefoneEmail = COALESCE(S.TelefoneEmail, T.TelefoneEmail);

--SELECT TelefoneEmail
--FROM Dados.AtendimentoContatos
--GROUP BY TelefoneEmail
--HAVING COUNT(*) > 1

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
--SELECT *
--FROM [dbo].[BACKSEG_TEMP]
 
MERGE INTO Dados.Atendimento AS T
USING 
(
	SELECT *
	FROM 
	(
		SELECT  ROW_NUMBER() OVER(PARTITION BY NumeroTitulo, CPF, DateTime_Contato_Efetivo, TF.ID, TD.ID, TA.ID, TSA.ID, TC.ID ORDER BY NomeArquivo) AS ID,
				T.Cod_Cliente, 
				T.NumeroTitulo,
				T.DataVigencia AS Termino_Vigencia,
				T.CPF,
				T.NomeDevedor AS Nome,
				TE.ID AS IDTelefoneEfetivo,
				TEL.ID AS IDTelefone,
				EM.ID AS IDEmail,
				T.UF,
				T.DateTime_Contato_Efetivo,
				T.APPL,
				T.NomeArquivo,
				TF.ID AS IDTipoFone,
				TD.ID AS IDTipoDoador,
				TA.ID AS IDTipoAcao,
				TSA.ID AS IDTipoSubAcao,
				TC.ID AS IDTipoCliente
		FROM [dbo].[BACKSEG_TEMP] AS T
		LEFT OUTER JOIN Dados.AtendimentoContatos AS TE
		ON TE.TelefoneEmail = T.num_fone
		LEFT OUTER JOIN  Dados.AtendimentoContatos AS TEL
		ON TEL.TelefoneEmail = ISNULL(ISNULL(ISNULL(ISNULL(T.fone_1, T.fone_2),T.fone_3),T.fone_4),fone_5)
		LEFT OUTER JOIN  Dados.AtendimentoContatos AS EM
		ON EM.TelefoneEmail = T.Email1
		LEFT OUTER JOIN Dados.TipoFone AS TF
		ON TF.Nome = T.TipoFone
		LEFT OUTER JOIN Dados.TipoDoador AS TD
		ON TD.Nome = T.TipoDoador
		LEFT OUTER JOIN Dados.TipoAcao AS TA
		ON TA.Nome = T.TipoAcao
		LEFT OUTER JOIN Dados.TipoSubAcao AS TSA
		ON TSA.Nome = T.TipoSubAcao
		LEFT OUTER JOIN Dados.TipoCliente AS TC
		ON TC.Nome = T.TipoCliente
	) AS T
	WHERE T.ID = 1
	--	AND CPF = '000.001.776-38'
	--ORDER BY DateTime_Contato_Efetivo DESC
	--ORDER BY Nome DESC
) AS S
ON T.NumeroTitulo = S.NumeroTitulo
	AND T.CPF = S.CPF
	AND T.DateTime_Contato_Efetivo = S.DateTime_Contato_Efetivo
	AND T.IDTipoFone = S.IDTipoFone
	AND T.IDTipoDoador = S.IDTipoDoador
	AND T.IDTipoAcao = S.IDTipoAcao
	AND T.IDTipoSubAcao = S.IDTipoSubAcao

WHEN MATCHED THEN
	UPDATE
		SET Cod_Cliente = COALESCE(S.Cod_Cliente, T.Cod_Cliente),
		    Termino_Vigencia = COALESCE(S.Termino_Vigencia, T.Termino_Vigencia),
			CPF = COALESCE(S.CPF, T.CPF),
			Nome = COALESCE(S.Nome, T.Nome),
			IDTelefoneEfetivo = COALESCE(S.IDTelefoneEfetivo, T.IDTelefoneEfetivo),
			IDTelefone = COALESCE(S.IDTelefone, T.IDTelefone),
			IDEmail = COALESCE(S.IDEmail, T.IDEmail),
			UF = COALESCE(S.UF, T.UF),
			APPL = COALESCE(S.APPL, T.APPL),
			NomeArquivo = COALESCE(S.NomeArquivo, T.NomeArquivo)
WHEN NOT MATCHED THEN

	INSERT ( NumeroTitulo, DateTime_Contato_Efetivo, Cod_Cliente, Termino_Vigencia, CPF, Nome, IDTelefoneEfetivo, IDTelefone, IDEmail, UF,
		     APPL, NomeArquivo, IDTipoFone, IDTipoDoador, IDTipoAcao, IDTipoSubAcao, IDTipoCliente )
	VALUES ( NumeroTitulo, DateTime_Contato_Efetivo, Cod_Cliente, Termino_Vigencia, CPF, Nome, IDTelefoneEfetivo, IDTelefone, IDEmail, UF,
		     APPL, NomeArquivo, IDTipoFone, IDTipoDoador, IDTipoAcao, IDTipoSubAcao, IDTipoCliente ) ;

--SELECT *
--FROM Dados.Atendimento
--9.983

/*****************************************************************************************/
/*Ponto de Parada*/
/*****************************************************************************************/
SET @PontoDeParada = @MaiorCodigo
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @MaiorCodigo
WHERE NomeEntidade = 'BACKSEG'

TRUNCATE TABLE [dbo].[BACKSEG_TEMP]

/*Recuperação do Maior Código do Retorno*/
SET @COMANDO =
'
INSERT INTO [dbo].[BACKSEG_TEMP]
(
	[DataArquivo],
	[NomeArquivo],
	[ControleVersao],
	[Cod_Cliente],
	[NumeroTitulo],
	[DataVigencia],
	[CPF],
	[NomeDevedor],
	[UF],
	[DateTime_Contato_Efetivo],
	[TipoFone],
	[num_fone],
	[Fone_1],
	[Fone_2],
	[Fone_3],
	[Fone_4],
	[Fone_5],
	[email1],
	[email2],
	[TipoDoador],
	[TipoAcao],
	[TipoSubAcao],
	[APPL],
	[TipoCliente]
)
SELECT 	
	[DataArquivo],
	[NomeArquivo],
	[ControleVersao],
	[Cod_Cliente],
	[NumeroTitulo],
	[DataVigencia],
	[CPF],
	[NomeDevedor],
	[UF],
	[DateTime_Contato_Efetivo],
	[TipoFone],
	[num_fone],
	[Fone_1],
	[Fone_2],
	[Fone_3],
	[Fone_4],
	[Fone_5],
	[email1],
	[email2],
	[TipoDoador],
	[TipoAcao],
	[TipoSubAcao],
	[APPL],
	[TipoCliente]
FROM OPENQUERY ([OBERON], ''EXEC [Fenae].[Corporativo].[proc_RecuperaBackSeg] ''''' + @PontoDeParada + ''''''') PRP'	   
	   

EXEC (@COMANDO)  

SELECT @MaiorCodigo = MAX(ID)
FROM [dbo].[BACKSEG_TEMP]
                    
END

 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BACKSEG_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[BACKSEG_TEMP]				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH

--	EXEC [Dados].[proc_InsereBackSeg] 

--SELECT *
--FROM Dados.Atendimento
--12.149