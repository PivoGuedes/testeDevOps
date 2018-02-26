/*
	Autor: Luan Moreno M. Maciel
	Data de Criação: 24/03/2013
*/

/*******************************************************************************
Nome: Corporativo.Dados.proc_InsereFuncionario_CaixaSeguros
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereFuncionario_CaixaSeguros]
AS
BEGIN TRY		
 
DECLARE @PontoDeParada AS VARCHAR(400) = '0' 
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX)

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FuncionarioCaixaSeguros_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].FuncionarioCaixaSeguros_TEMP;

CREATE TABLE [dbo].FuncionarioCaixaSeguros_TEMP
(
	[Codigo] BIGINT NOT NULL,
	[ControleVersao] DECIMAL(16, 8) NOT NULL,
	[NomeArquivo] [varchar](300) NULL,
	[DataArquivo] [date] NULL,
	[Empresa] [varchar](5) NULL,
	[Matricula] [varchar](15) NULL,
	[Endereco] [varchar](100) NULL,
	[Bairro] [varchar](50) NULL,
	[CEP] [varchar](10) NULL,
	[TelefoneComercial] [varchar](15) NULL,
	[TelefoneCelular] [varchar](15) NULL,
	[Nome] [varchar](150) NULL,
	[CPF] [varchar](15) NULL,
	[Sexo] [varchar](15) NULL,
	[EstadoCivil] [varchar] (12) NULL,
	[EmailComercial] [varchar](70) NULL,
	[DataNascimento] [date] NULL,
    [DescricaoLotacao] [varchar](70) NULL,	
	[ClasseCargo] [int] NULL,	
	[Cargo] [varchar](70) NULL
) 

 /*Criação de Índices*/  
CREATE CLUSTERED INDEX idx_FuncionarioSRH_TEMP ON [dbo].FuncionarioCaixaSeguros_TEMP
( 
  Codigo ASC
)       

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Funcionario_CaixaSeguros'


/*********************************************************************************************************************/               
/*Recuperação do Maior Código do Retorno*/
/*********************************************************************************************************************/
SET @COMANDO = 'INSERT INTO [dbo].[FuncionarioCaixaSeguros_TEMP] 
						( 
                        	[Codigo],
							[ControleVersao],
							[NomeArquivo],
							[DataArquivo],
							[Empresa],
							[Matricula],
							[Endereco],
							[Bairro],
							[CEP],
							[TelefoneComercial],
							[TelefoneCelular],
							[Nome],
							[CPF],
							[Sexo],
							[EstadoCivil],
							[EmailComercial],
							[DataNascimento],
							[DescricaoLotacao],
							[ClasseCargo],
							[Cargo]
					   )
                SELECT 
                        [Codigo],
						[ControleVersao],
						[NomeArquivo],
						[DataArquivo],
						[Empresa],
						[Matricula],
						[Endereco],
						[Bairro],
						[CEP],
						[TelefoneComercial],
						[TelefoneCelular],
						[Nome],
						[CPF],
						[Sexo],
						[EstadoCivil],
						[EmailComercial],
						[DataNascimento],
						[DescricaoLotacao],
						[ClasseCargo],
						[Cargo]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [FENAE].[Corporativo].[proc_RecuperaFuncionario_CaixaSeguros] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)     

SELECT @MaiorCodigo = MAX(Codigo)
FROM dbo.FuncionarioCaixaSeguros_TEMP

/*********************************************************************************************************************/

WHILE @MaiorCodigo IS NOT NULL
BEGIN 

--Carga de Dados
	--Funcionário.Cargo
	--Funcionário.Lotação
	--Funcionário.Funcionário - Empresa, Matrícula, Nome, CPF, Sexo, EstadoCivil, DataNascimento
	--Funcionário.Endereço
	--Funcionários.Telefone

--SELECT *
--FROM FuncionarioCaixaSeguros_TEMP


/***********************************************************************
Carregar Cargo do Funcionário
***********************************************************************/
MERGE INTO Dados.Cargo AS T
USING 
(
	SELECT DISTINCT ClasseCargo, Cargo
	FROM FuncionarioCaixaSeguros_TEMP
	WHERE Cargo IS NOT NULL
) AS S
ON T.Cargo = S.Cargo

WHEN NOT MATCHED THEN
	INSERT (ClasseCargo, Cargo)
	VALUES (S.ClasseCargo, S.Cargo)

WHEN MATCHED THEN
	UPDATE 
		SET T.ClasseCargo = S.ClasseCargo;

/***********************************************************************
Carregar Lotação do Funcionário
***********************************************************************/
MERGE INTO Dados.Lotacao AS T
USING 
(
	SELECT DISTINCT DescricaoLotacao
	FROM FuncionarioCaixaSeguros_TEMP
	WHERE DescricaoLotacao IS NOT NULL
) AS S
ON T.Descricao = S.DescricaoLotacao

WHEN NOT MATCHED THEN
	INSERT (Descricao)
	VALUES (S.DescricaoLotacao);

/***********************************************************************
 Carregar Funcionários Caixa Seguros
***********************************************************************/
MERGE INTO Dados.Funcionario AS T
USING 
(
	SELECT *
	FROM
	(
	SELECT Nome, 
		   CPF, 
		   EmailComercial AS Email,
		   Matricula,
		   2 AS IDEmpresa,
		   TelefoneComercial AS Telefone,
		   S.ID AS IDSexo,
		   EC.ID AS IDEstadoCivil,
		   DataNascimento,
		   NomeArquivo,
		   DataArquivo,
		   CARG.ID AS IDCargo,
		   LOT.ID AS IDLotacao,
					ROW_NUMBER() OVER(PARTITION BY T.matricula ORDER BY T.[DataArquivo] DESC)  [ORDER]
	FROM FuncionarioCaixaSeguros_TEMP AS T
	INNER JOIN Dados.Sexo AS S
	ON T.Sexo = S.Descricao
	INNER JOIN Dados.EstadoCivil AS EC
	ON EC.Descricao = T.EstadoCivil
	LEFT OUTER JOIN Dados.Cargo AS CARG
	ON CARG.Cargo = T.Cargo
	LEFT OUTER JOIN Dados.Lotacao AS LOT
	ON LOT.Descricao = T.DescricaoLotacao
	) A
	WHERE [ORDER] = 1
) AS S

ON S.Matricula = T.Matricula
	AND S.IDEmpresa = T.IDEmpresa

WHEN MATCHED AND S.DataArquivo >= ISNULL(T.DataArquivo, '0001-01-01') THEN 
	UPDATE	
		SET T.Nome = COALESCE(S.Nome, T.Nome),
			T.[CPF] = COALESCE(S.CPF, T.CPF),
			T.[Email] = COALESCE(S.Email, T.Email),
			T.[Telefone] = COALESCE(S.Telefone, T.Telefone),
			T.[IDSexo] = COALESCE(S.IDSexo, T.IDSexo),
			T.[IDEstadoCivil] = COALESCE(S.IDEstadoCivil, T.IDEstadoCivil),
			T.[DataNascimento] = COALESCE(S.DataNascimento, T.DataNascimento),
			T.[NomeArquivo] = COALESCE(S.NomeArquivo, T.NomeArquivo),
			T.[IDCargo] = COALESCE(S.IDCargo, T.IDCargo),
			T.[IDLotacao] = COALESCE(S.IDLotacao, T.IDLotacao)

WHEN NOT MATCHED THEN 
	INSERT 
	(
		[Nome],[CPF],[Email],[Matricula],[IDEmpresa],[Telefone],[IDSexo],
		[IDEstadoCivil],[DataNascimento],[NomeArquivo],[IDCargo],[IDLotacao]
     )
	 VALUES
	 (
		S.Nome, S.CPF, S.Email, S.Matricula, S.IDEmpresa, S.Telefone, S.IDSexo,
		S.IDEstadoCivil, S.DataNascimento, S.NomeArquivo, S.IDCargo, S.IDLotacao
	 );


/***********************************************************************
Apaga a Marcação do LastValue do Histórico do Funcionário Recebido
para Atualização da Última Posição, Após a Inserção do Funcionário
***********************************************************************/	  
UPDATE Dados.FuncionarioHistorico 
	SET LastValue = 0
FROM Dados.FuncionarioHistorico FH 
INNER JOIN Dados.Funcionario F
ON FH.IDFuncionario = F.ID	
INNER JOIN FuncionarioCaixaSeguros_TEMP T
ON F.Matricula = T.Matricula
	AND F.IDEmpresa = 2
WHERE FH.LastValue = 1												

/***********************************************************************
Carrega Dados do Funcionário Histórico
***********************************************************************/  
;MERGE INTO Dados.FuncionarioHistorico AS T
USING 
(
	SELECT EM.ID AS IDFuncionario,
		   EM.Nome, 
		   EM.NomeArquivo,
		   T.DataArquivo,
		   CG.Cargo,
		   LOT.Descricao AS Lotacao,
		   0 LastValue

	FROM FuncionarioCaixaSeguros_TEMP AS T
	INNER JOIN Dados.Funcionario AS EM
	ON T.Matricula = EM.Matricula
		AND EM.IDEmpresa = 2
	INNER JOIN Dados.Cargo AS CG
	ON CG.ID = EM.IDCargo
	INNER JOIN Dados.Lotacao AS LOT
	ON LOT.ID = EM.IDLotacao
				 

) AS S
ON ISNULL(S.IDFuncionario, -1) = ISNULL(T.IDFuncionario, -1)
	AND ISNULL(S.Nome, '') = ISNULL(T.Nome,'')
	AND S.[Cargo] = COALESCE(S.[Cargo], T.[Cargo])
	AND S.[Lotacao] = COALESCE(S.Cargo, T.Lotacao)
	AND S.[DataArquivo] >= T.[DataArquivo]
--WHEN MATCHED AND S.[DataArquivo] >= T.[DataArquivo] THEN  
--	UPDATE
--		SET 
--			[Nome] =  COALESCE(S.[Nome], T.[Nome]),
--			[NomeArquivo] = COALESCE(S.[NomeArquivo], T.[NomeArquivo]),
--			[CargoCaixaSeguros] = COALESCE(S.Cargo, T.[CargoCaixaSeguros]),
--			[Lotacao] = COALESCE(S.[Lotacao], T.[Lotacao]),
--			[DataArquivo] = S.DataArquivo,
--			[LastValue] = S.LastValue
WHEN NOT MATCHED THEN 
	INSERT 
		(
			[IDFuncionario],[Nome],[NomeArquivo],[DataArquivo],[LastValue], [CargoCaixaSeguros], [Lotacao]
		)
     VALUES 
		(	S.[IDFuncionario],S.[Nome],S.[NomeArquivo],S.[DataArquivo],S.[LastValue], [Cargo], [Lotacao]
		);

/***********************************************************************
Atualização das Marcação do LastValoue dos registros de funcionários processados
para Atualizar a Última Posição
***********************************************************************/ 	 
	/*Atualiza a marcação LastValue das propostas recebidas para atualizar a última posição*/
	/*Egler - Data: 10/07/2014 */		 
    UPDATE Dados.FuncionarioHistorico SET LastValue = 1
    FROM Dados.FuncionarioHistorico PE
	INNER JOIN (
				SELECT ID,   ROW_NUMBER() OVER (PARTITION BY  FH.IDFuncionario
											    ORDER BY FH.DataArquivo DESC, FH.[DataAtualizacaoCargo] DESC, FH.[FuncaoDataInicio] DESC ) [ORDEM]
				FROM  Dados.FuncionarioHistorico FH
				WHERE FH.IDFuncionario in (SELECT F.ID
										   FROM [dbo].FuncionarioCaixaSeguros_TEMP A
											inner join Dados.Funcionario F
												on F.Matricula = A.Matricula
												AND F.IDEmpresa = 2
											) 
											--AND IDFUNCIONARIO = 5007
											--ORDER BY FH.DataArquivo DESC, FH.[DataAtualizacaoCargo] DESC, FH.[FuncaoDataInicio] DESC
				) A
	 ON A.ID = PE.ID 
	 AND A.ORDEM = 1		
/***********************************************************************
Marcação do Registro Mais Recente
***********************************************************************/ 
UPDATE [Corporativo].[Dados].Funcionario
SET 
	Nome = FH.Nome
FROM [Corporativo].[Dados].[FuncionarioHistorico] FH
	INNER JOIN [Corporativo].[Dados].Funcionario F
ON (FH.IDFuncionario = F.ID)		
	AND F.IDEmpresa = 2
WHERE FH.LASTVALUE = 1 
AND EXISTS ( SELECT * FROM [dbo].FuncionarioCaixaSeguros_TEMP AS T WHERE F.Matricula = T.Matricula)


/*************************************************************************************/
/*Atualização do Ponto de Parada, Maior Código*/
/*************************************************************************************/
SET @PontoDeParada = @MaiorCodigo
  
UPDATE ControleDados.PontoParada 
SET PontoParada = @MaiorCodigo
WHERE NomeEntidade = 'Funcionario_CaixaSeguros'


TRUNCATE TABLE [dbo].FuncionarioCaixaSeguros_TEMP 
    
/*********************************************************************************************************************/               
/*Recuperação do Maior Código*/
/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[FuncionarioCaixaSeguros_TEMP] 
						( 
                        	[Codigo],
							[ControleVersao],
							[NomeArquivo],
							[DataArquivo],
							[Empresa],
							[Matricula],
							[Endereco],
							[Bairro],
							[CEP],
							[TelefoneComercial],
							[TelefoneCelular],
							[Nome],
							[CPF],
							[Sexo],
							[EstadoCivil],
							[EmailComercial],
							[DataNascimento],
							[DescricaoLotacao],
							[ClasseCargo],
							[Cargo]
					   )
                SELECT 
                        [Codigo],
						[ControleVersao],
						[NomeArquivo],
						[DataArquivo],
						[Empresa],
						[Matricula],
						[Endereco],
						[Bairro],
						[CEP],
						[TelefoneComercial],
						[TelefoneCelular],
						[Nome],
						[CPF],
						[Sexo],
						[EstadoCivil],
						[EmailComercial],
						[DataNascimento],
						[DescricaoLotacao],
						[ClasseCargo],
						[Cargo]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [FENAE].[Corporativo].[proc_RecuperaFuncionario_CaixaSeguros] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)     

SELECT @MaiorCodigo = MAX(Codigo)
FROM dbo.FuncionarioCaixaSeguros_TEMP
                
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FuncionarioCaixaSeguros_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].FuncionarioCaixaSeguros_TEMP;			

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
  RETURN @@ERROR	

END CATCH


--	EXEC Corporativo.Dados.proc_InsereFuncionario_CaixaSeguros