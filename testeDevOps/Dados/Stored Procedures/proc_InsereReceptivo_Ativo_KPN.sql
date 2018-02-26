
/*
	Autor: Luan Moreno M. Maciel
	Data Criação: 08/04/2014
*/

/*******************************************************************************
	Nome: Corporativo.Dados.proc_InsereReceptivo_Ativo_KPN	
--*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereReceptivo_Ativo_KPN] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400) = 0
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReceptivoAtivo_KPN_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[ReceptivoAtivo_KPN_TEMP];


CREATE TABLE [dbo].[ReceptivoAtivo_KPN_TEMP]
(
	[NewIDDados] [bigint] NULL,
	[ID] [int] NOT NULL,
	[DataArquivo] [date] NULL,
	[NomeArquivo] [varchar](300) NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[CPF] [char](20) NULL,
	[CPF_Solicitante] [char](20) NULL,
	[Telefone_Contato_Efetivo] [char](20) NULL,
	[Nome_Contato_Retorno] [varchar](100) NULL,
	[Tipo_Seguro] [varchar](100) NULL,
	[Status_Final] [varchar](100) NULL,
	[Status_Ligacao] [varchar](100) NULL,
	[Protocolo] [char](100) NULL,
	[Contatante] [varchar](100) NULL,
	[AgenciaLotacao] [char](100) NULL,
	[MotivoContato] [varchar](100) NULL,
	[Contato_Retorno] [varchar](100) NULL,
	[Cliente_Interessado] [varchar](100) NULL,
	[Realizacao_Calculo_Solicitada] [varchar](100) NULL,
	[Telefone_1] [char](20) NULL,
	[Telefone_2] [char](20) NULL,
	[Telefone_3] [char](20) NULL,
	[Email] [varchar](100) NULL,
	[TipoArquivo] [varchar](30) NOT NULL
)

 /*Cria Índices */  
CREATE CLUSTERED INDEX idx_ReceptivoAtivo_KPN_TEMP_ID 
ON [dbo].ReceptivoAtivo_KPN_TEMP
( 
  [NewIDDados] ASC
)   

CREATE NONCLUSTERED INDEX idxNCL_ReceptivoAtivo_KPN_TEMP_CPF
ON [dbo].ReceptivoAtivo_KPN_TEMP
( 
  CPF ASC
)       

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'ReceptivoAtivo_KPN'

/*********************************************************************************************************************/               
/*Recuperação do Maior Código*/
/*********************************************************************************************************************/
SET @COMANDO =
'
INSERT INTO [dbo].[ReceptivoAtivo_KPN_TEMP]
(
	[NewIDDados],
	[ID],
	[DataArquivo],
	[NomeArquivo],
	[ControleVersao],
	[CPF],
	[CPF_Solicitante],
	[Telefone_Contato_Efetivo],
	[Nome_Contato_Retorno],
	[Tipo_Seguro],
	[Status_Final],
	[Status_Ligacao],
	[Protocolo],
	[Contatante],
	[AgenciaLotacao],
	[MotivoContato],
	[Contato_Retorno],
	[Cliente_Interessado],
	[Realizacao_Calculo_Solicitada],
	[Telefone_1],
	[Telefone_2],
	[Telefone_3],
	[Email],
	[TipoArquivo]
)
SELECT 	
	[NewIDDados],
	[ID],
	[DataArquivo],
	[NomeArquivo],
	[ControleVersao],
	[CPF],
	[CPF_Solicitante],
	[Telefone_Contato_Efetivo],
	[Nome_Contato_Retorno],
	[Tipo_Seguro],
	[Status_Final],
	[Status_Ligacao],
	[Protocolo],
	[Contatante],
	[AgenciaLotacao],
	[MotivoContato],
	[Contato_Retorno],
	[Cliente_Interessado],
	[Realizacao_Calculo_Solicitada],
	[Telefone_1],
	[Telefone_2],
	[Telefone_3],
	[Email],
	[TipoArquivo]
FROM OPENQUERY ([OBERON], ''EXEC Fenae.Corporativo.proc_RecuperaHotline_Ativo_Receptivo ''''' + @PontoDeParada + ''''''') PRP'	   

EXEC (@COMANDO)  
		   
SELECT @MaiorCodigo = MAX(ID)
FROM [dbo].[ReceptivoAtivo_KPN_TEMP]

SET @COMANDO = '' 


WHILE @MaiorCodigo IS NOT NULL
BEGIN

/**********************************************************************
Inserção dos Dados - Motivo do Contato
***********************************************************************/ 
MERGE INTO Dados.Motivo_Contato AS T
USING 
(
	SELECT DISTINCT MotivoContato AS Nome
	FROM [dbo].ReceptivoAtivo_KPN_TEMP
	WHERE MotivoContato IS NOT NULL
) AS S
ON T.Nome = S.Nome
WHEN NOT MATCHED THEN
	INSERT (Nome)
	VALUES (S.Nome);


/**********************************************************************
Inserção dos Dados - Tipos de Prospecção de Vendas --Tipo de Seguro
***********************************************************************/ 
MERGE INTO Dados.ProspectOferta AS T
USING
(
	SELECT DISTINCT (T.Tipo_Seguro) AS Nome
	FROM [dbo].ReceptivoAtivo_KPN_TEMP AS T
	WHERE T.Tipo_Seguro IS NOT NULL
) AS S
ON T.Nome = S.Nome
WHEN NOT MATCHED THEN
	INSERT (Nome)
	VALUES (S.Nome);

/**********************************************************************
Inserção dos Dados - Status de Ligação
***********************************************************************/ 
MERGE INTO Dados.Status_Ligacao AS T
USING 
(
	SELECT DISTINCT Status_Ligacao AS Nome
	FROM [dbo].ReceptivoAtivo_KPN_TEMP
	WHERE Status_Ligacao IS NOT NULL
) AS S
ON T.Nome = S.Nome
WHEN NOT MATCHED THEN
	INSERT (Nome)
	VALUES (S.Nome);

/**********************************************************************
Inserção dos Dados - Status Final
***********************************************************************/             
MERGE INTO Dados.Status_Final AS T
USING 
(
	SELECT DISTINCT Status_Final AS Nome
	FROM [dbo].ReceptivoAtivo_KPN_TEMP
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
			FROM [dbo].ReceptivoAtivo_KPN_TEMP
			WHERE Telefone_Contato_Efetivo IS NOT NULL
			UNION ALL
			SELECT DISTINCT ISNULL(ISNULL(Telefone_1, Telefone_2),Telefone_3)
			FROM [dbo].ReceptivoAtivo_KPN_TEMP 
			WHERE ISNULL(ISNULL(Telefone_1, Telefone_2),Telefone_3) IS NOT NULL
			UNION ALL
			SELECT DISTINCT Email
			FROM [dbo].ReceptivoAtivo_KPN_TEMP
			WHERE Email IS NOT NULL

		) AS Dados
) AS S
ON T.TelefoneEmail = S.TelefoneEmail
WHEN NOT MATCHED THEN
	INSERT (TelefoneEmail)
	VALUES (S.TelefoneEmail)

WHEN MATCHED THEN
	UPDATE 
		SET TelefoneEmail = COALESCE(S.TelefoneEmail, T.TelefoneEmail);

/**********************************************************************
Inserção dos Dados - Dados de Atendimento
***********************************************************************/    
MERGE INTO Dados.Atendimento AS T
USING 
(
SELECT DISTINCT
	   T.Protocolo,
	   T.CPF,
	   T.CPF_Solicitante,
	   T.Nome_Contato_Retorno AS Nome,
	   SL.ID AS IDStatus_Ligacao,
	   SF.ID AS IDStatus_Final,
	   TE.ID AS IDTelefoneEfetivo,
	   TEL.ID AS IDTelefone,
	   EM.ID AS IDEmail,
	   UN1.ID AS IDAgenciaLotacao,
	   PO.ID AS IDProspectOferta,
	   T.Contatante,
	   T.Contato_Retorno,
	   T.Cliente_Interessado,
	   T.Realizacao_Calculo_Solicitada,
	   T.TipoArquivo,
	   MOT.ID AS IDMotivo
FROM dbo.ReceptivoAtivo_KPN_TEMP AS T
LEFT OUTER JOIN Dados.Status_Ligacao AS SL
ON T.Status_Ligacao = SL.Nome
LEFT OUTER JOIN Dados.Status_Final AS SF
ON T.Status_Final = SF.Nome
LEFT OUTER JOIN Dados.Unidade AS UN1
ON T.AgenciaLotacao = UN1.Codigo
INNER JOIN Dados.AtendimentoContatos AS TE
ON TE.TelefoneEmail = T.Telefone_Contato_Efetivo
LEFT OUTER JOIN  Dados.AtendimentoContatos AS TEL
ON TEL.TelefoneEmail = ISNULL(ISNULL(T.Telefone_1, T.Telefone_2),Telefone_3)
LEFT OUTER JOIN  Dados.AtendimentoContatos AS EM
ON EM.TelefoneEmail = Email
LEFT OUTER JOIN Dados.ProspectOferta AS PO
ON PO.Nome = T.Tipo_Seguro
LEFT OUTER JOIN Dados.Motivo_Contato AS MOT
ON MOT.Nome = T.MotivoContato
) AS S
ON T.Protocolo = S.Protocolo
	AND T.CPF = S.CPF
WHEN MATCHED THEN
	UPDATE
		SET CPF_Solicitante = COALESCE(S.CPF_Solicitante, T.CPF_Solicitante),
		    Nome = COALESCE(S.Nome, T.Nome),
			IDStatus_Ligacao = COALESCE(S.IDStatus_Ligacao, T.IDStatus_Ligacao),
			IDStatus_Final = COALESCE(S.IDStatus_Final, T.IDStatus_Final),
			IDTelefoneEfetivo = COALESCE(S.IDTelefoneEfetivo, T.IDTelefoneEfetivo),
			IDTelefone = COALESCE(S.IDTelefone, T.IDTelefone),
			IDEmail = COALESCE(S.IDEmail, T.IDEmail),
			IDAgenciaLotacao = COALESCE(S.IDAgenciaLotacao, T.IDAgenciaLotacao),
			IDProspectOferta = COALESCE(S.IDProspectOferta, T.IDProspectOferta),
			Contatante = COALESCE(S.Contatante, T.Contatante),
			Contato_Retorno = COALESCE(S.Contato_Retorno, T.Contato_Retorno),
			Cliente_Interessado = COALESCE(S.Cliente_Interessado, T.Cliente_Interessado),
			Realizacao_Calculo_Solicitada = COALESCE(S.Realizacao_Calculo_Solicitada, T.Realizacao_Calculo_Solicitada),
			TipoArquivo = COALESCE(S.TipoArquivo, T.TipoArquivo),
			IDMotivo = COALESCE(S.IDMotivo, T.IDMotivo)
WHEN NOT MATCHED THEN
	INSERT ( Protocolo, CPF, CPF_Solicitante, Nome, IDStatus_Ligacao, IDStatus_Final, IDTelefoneEfetivo, IDTelefone, IDEmail, IDAgenciaLotacao, 
		     IDProspectOferta, Contatante, Contato_Retorno, Cliente_Interessado, Realizacao_Calculo_Solicitada, TipoArquivo, IDMotivo)

	VALUES (Protocolo, CPF, CPF_Solicitante, Nome, IDStatus_Ligacao, IDStatus_Final, IDTelefoneEfetivo, IDTelefone, IDEmail, IDAgenciaLotacao, 
		     IDProspectOferta, Contatante, Contato_Retorno, Cliente_Interessado, Realizacao_Calculo_Solicitada, TipoArquivo, IDMotivo );


/*****************************************************************************************/
/*Ponto de Parada*/
/*****************************************************************************************/
SET @PontoDeParada = @MaiorCodigo
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @MaiorCodigo
WHERE NomeEntidade = 'ReceptivoAtivo_KPN'

TRUNCATE TABLE [dbo].ReceptivoAtivo_KPN_TEMP

/*Recuperação do Maior Código do Retorno*/
SET @COMANDO =
'
INSERT INTO [dbo].[ReceptivoAtivo_KPN_TEMP]
(
	[NewIDDados],
	[ID],
	[DataArquivo],
	[NomeArquivo],
	[ControleVersao],
	[CPF],
	[CPF_Solicitante],
	[Telefone_Contato_Efetivo],
	[Nome_Contato_Retorno],
	[Tipo_Seguro],
	[Status_Final],
	[Status_Ligacao],
	[Protocolo],
	[Contatante],
	[AgenciaLotacao],
	[MotivoContato],
	[Contato_Retorno],
	[Cliente_Interessado],
	[Realizacao_Calculo_Solicitada],
	[Telefone_1],
	[Telefone_2],
	[Telefone_3],
	[Email],
	[TipoArquivo]
)
SELECT 	
	[NewIDDados],
	[ID],
	[DataArquivo],
	[NomeArquivo],
	[ControleVersao],
	[CPF],
	[CPF_Solicitante],
	[Telefone_Contato_Efetivo],
	[Nome_Contato_Retorno],
	[Tipo_Seguro],
	[Status_Final],
	[Status_Ligacao],
	[Protocolo],
	[Contatante],
	[AgenciaLotacao],
	[MotivoContato],
	[Contato_Retorno],
	[Cliente_Interessado],
	[Realizacao_Calculo_Solicitada],
	[Telefone_1],
	[Telefone_2],
	[Telefone_3],
	[Email],
	[TipoArquivo]
FROM OPENQUERY ([OBERON], ''EXEC Fenae.Corporativo.proc_RecuperaHotline_Ativo_Receptivo ''''' + @PontoDeParada + ''''''') PRP'	   

EXEC (@COMANDO)  		   

SELECT @MaiorCodigo = MAX(ID)
FROM [dbo].ReceptivoAtivo_KPN_TEMP
                    
END

 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ReceptivoAtivo_KPN_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].ReceptivoAtivo_KPN_TEMP				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	

END CATCH

--SELECT *
--FROM Dados.Atendimento

--	EXEC [Dados].[proc_InsereReceptivo_Ativo_KPN] 