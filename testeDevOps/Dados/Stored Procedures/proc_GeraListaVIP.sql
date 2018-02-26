/*
Created by: André Anselmo
Date: 2014-12-17
*/

CREATE PROCEDURE [Dados].[proc_GeraListaVIP]
AS

BEGIN

	-- INSERIR AQUI SELECT POR SIGLA DA LOTAÇÃO DA CEF

	-- INSERIR AQUI SELECT PARA FUNCEF. OBS: Não existe registro de funcionário FUNCEF na tabela Dados.Funcionario na data 17/12/2014.
	-- INSERIR AQUI SELECT PARA PAR Tecnologia. OBS: Não existe registro de funcionário PAR Tecnologia na tabela Dados.Funcionario na data 17/12/2014.
	-- INSERIR AQUI SELECT PARA FENAE. OBS: Não existe registro de funcionário FENAE na tabela Dados.Funcionario na data 17/12/2014.
	-- INSERIR AQUI SELECT PARA PAR Relacionamento. OBS: Não existe registro de funcionário PAR Relacionamento na tabela Dados.Funcionario na data 17/12/2014.
	-- INSERIR AQUI SELECT PARA Caixa Crescer. OBS: Não existe registro de funcionário Caixa Crescer na tabela Dados.Funcionario na data 17/12/2014.
	
	-- LIMPA A TABELA Dados.ListaVIPDiario
	TRUNCATE TABLE Dados.ListaVIPDiario

--8249314226661

	-- SELECIONA OS VIPS
	;WITH C AS (
		-- CEF - LOTAÇÃO
		SELECT F.IDEmpresa, F.Nome, F.CPF,CAST(GETDATE() AS DATE) AS DataSistema, 'Lotação' AS RegraVIP
		FROM Dados.Funcionario AS F
		INNER JOIN Dados.FuncionarioHistorico AS FH 
		ON F.ID=FH.IDFuncionario
		INNER JOIN [ConfiguracaoDados].[VIP_Sigla_Lotacao] AS S
		ON S.Descricao=FH.LotacaoSigla
		WHERE LastValue=1
		AND LotacaoSigla <> '' AND LotacaoSigla IS NOT NULL AND F.IDEmpresa=1

		UNION ALL

		-- CEF - FUNÇÃO
		SELECT F.IDEmpresa, Nome, CPF, CAST(GETDATE() AS DATE) AS DataSistema, 'Função' AS RegraVIP
		FROM Dados.Funcionario AS F
		INNER JOIN Dados.Funcao as FC
		ON F.IDUltimaFuncao=FC.ID
		INNER JOIN [ConfiguracaoDados].[VIP_Funcao] as V
		ON CAST(V.Codigo AS INT)=CAST(FC.Codigo AS INT)

		UNION ALL

		-- CAIXA SEGUROS - CARGO
		SELECT F.IDEmpresa, Nome, CPF, CAST(GETDATE() AS DATE) AS DataSistema, 'Cargo' AS RegraVIP
		FROM Dados.Funcionario AS F
		INNER JOIN Dados.Cargo AS C
		ON F.IDCargo=C.ID
		INNER JOIN [ConfiguracaoDados].[VIP_Cargo] AS VC
		ON C.Cargo=RTRIM(LTRIM(VC.Descricao))
		WHERE F.IDEmpresa=2

		UNION ALL

		--PAR Corretora - Cargo
		SELECT DISTINCT F.IDEmpresa, Nome, CPF, CAST(GETDATE() AS DATE) AS DataSistema, 'Cargo' AS RegraVIP
		FROM Dados.CargoPropay AS CP
		INNER JOIN [ConfiguracaoDados].[VIP_Cargo] AS VP
		ON CP.Descricao=VP.Descricao
		INNER JOIN Dados.Funcionario AS F
		ON F.IDCargoPropay=CP.ID
		
	)
	INSERT INTO Dados.ListaVIPDiario (IDEmpresa, Nome, CPF, DataSistema, RegraVIP)
	SELECT IDEmpresa, Nome, CPF, DataSistema, RegraVIP FROM C

END

--EXEC [Dados].[proc_GeraListaVIP]

--SELECT * FROM Dados.ListaVIPDiario ORDER BY Nome

