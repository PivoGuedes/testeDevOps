---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



/*
	Autor: Diego Lima
	Data Criação: 08/10/2013

	Descrição: 
	
	Última alteração : Egler - 07/08/2014 - Reescrita do processo de carga da tabela Funcionário Histórico
	Última alteração : André - 14/01/2015 - Inclusão da regra de classificação de funcionários VIP. (Função e Lotação)

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereFuncionario_SRH
	Descrição: Procedimento que realiza a inserção de funcionários no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InsereFuncionario_SRH] as
BEGIN TRY		
 
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max)

 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FuncionarioSRH_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].FuncionarioSRH_TEMP;

CREATE TABLE [dbo].FuncionarioSRH_TEMP(
	[Codigo] bigint NOT NULL,
	[ControleVersao] decimal(16, 8) NOT NULL,
	[DataMovimentacao] date NOT NULL,
	[NomeArquivo] VARCHAR(100) NOT NULL,
	[DataArquivo] date NOT NULL,
	[Nome]VARCHAR(60) NULL,
	[CPF] VARCHAR(15) NULL,
	[DataNascimento] DATE NULL,
	[EstadoCivil] VARCHAR(30) NULL,
	[SexoCodigo] bigint NULL,
	[Sexo] VARCHAR(10) NULL,
	[Profissao] VARCHAR(60) NULL,
	[RendaIndividual] numeric(15, 5) NULL,
	[RendaFamiliar] numeric(15, 5) NULL,
	[Matricula] VARCHAR(20) NULL,
	[FuncionarioEmail] VARCHAR(60) NULL,
	[ParticipanteEmail] VARCHAR(60) NULL,
	[FuncaoCodigo] VARCHAR(5) NULL,
	[FuncaoDescricao] VARCHAR(60) NULL,
	[FuncaoDataInicio] DATE NULL,
	[FuncaoIndicadorFaixa] VARCHAR(30) NULL,
	[FuncionarioSituacaoCodigo] bigint NULL,
	[FuncionarioSituacao] VARCHAR(30) NULL,
	[IndicadorArea] bigint NULL,
	[UnidadeCodigo] bigint NULL,
	[UnidadeNome]  VARCHAR(60) NULL,
	[LotacaoUF] varchar(5) NULL,
	[LotacaoCidade] VARCHAR(60) NULL,
	[LotacaoSigla] VARCHAR(30) NULL,
	[LotacaoEmail] VARCHAR(60) NULL,
	[LotacaoDataInicio] DATE NULL,
	[LotacaoDDD] varchar(5) NULL,
	[LotacaoTelefone] varchar(10) NULL,
	[Endereco] VARCHAR(100) NULL,
	[Cidade] VARCHAR(60) NULL,
	[UF] varchar(5) NULL,
	[CEP] varchar(10) NULL,
	[Agencia] VARCHAR(15) NULL,
	[Operacao] VARCHAR(30) NULL,
	[Conta] VARCHAR(20) NULL,
	[Vip] BIT
) 

 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_FuncionarioSRH_TEMP ON [dbo].FuncionarioSRH_TEMP
( 
  Codigo ASC
)       

CREATE NONCLUSTERED INDEX IDX_NCL_IndicadorArea_FuncionarioSRH_TEMP	ON [dbo].[FuncionarioSRH_TEMP] 
(
[IndicadorArea]
)

/*
CREATE NONCLUSTERED INDEX [idx_FuncionarioSRH_Funcao_TEMP] ON [dbo].FuncionarioSRH_TEMP
(	
 [FuncaoCodigo] ASC
)
INCLUDE([FuncaoDescricao])
							 */
  
CREATE NONCLUSTERED INDEX IDX_NCL_FuncionarioSRH_TEMP on dbo.FuncionarioSRH_TEMP
(FuncaoCodigo)
INCLUDE (FuncionarioSituacaoCodigo, FuncionarioSituacao, [FuncaoDescricao]);


CREATE NONCLUSTERED INDEX IDX_NCL_FuncionarioSRH_TEMP_FuncionarioSitucao
ON [dbo].[FuncionarioSRH_TEMP] ([FuncionarioSituacaoCodigo])
INCLUDE ([FuncionarioSituacao]);


SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Funcionario_SRH'


/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
--DECLARE @PontoDeParada AS VARCHAR(400)= '81441947'
--DECLARE @COMANDO AS NVARCHAR(max)
SET @COMANDO = 'INSERT INTO [dbo].[FuncionarioSRH_TEMP] ( 
                        [Codigo]
					   ,[ControleVersao]
					   ,[NomeArquivo]
					   ,[DataArquivo]
					   ,[DataMovimentacao]
					   ,[Nome]
					   ,[CPF]
					   ,[DataNascimento]
					   ,[EstadoCivil]
					   ,[SexoCodigo]
					   ,[Sexo]
					   ,[Profissao]
					   ,[RendaIndividual]
					   ,[RendaFamiliar]
					   ,[Matricula]
					   ,[FuncionarioEmail]
					   ,[ParticipanteEmail]
					   ,[FuncaoCodigo]
					   ,[FuncaoDescricao]
					   ,[FuncaoDataInicio]
					   ,[FuncaoIndicadorFaixa]
					   ,[FuncionarioSituacaoCodigo]
					   ,[FuncionarioSituacao]
					   ,[IndicadorArea]
					   ,[UnidadeCodigo]
					   ,[UnidadeNome]
					   ,[LotacaoUF]
					   ,[LotacaoCidade]
					   ,[LotacaoSigla]
					   ,[LotacaoEmail]
					   ,[LotacaoDataInicio]
					   ,[LotacaoDDD]
					   ,[LotacaoTelefone]
					   ,[Endereco]
					   ,[Cidade]
					   ,[UF]
					   ,[CEP]
					   ,[Agencia]
					   ,[Operacao]
					   ,[Conta]
					   )
                SELECT 
                      [Codigo]
					   ,[ControleVersao]
					   ,[NomeArquivo]
					   ,[DataArquivo]
					   ,[DataMovimentacao]
					   ,[Nome]
					   ,[CPF]
					   ,[DataNascimento]
					   ,[EstadoCivil]
					   ,[SexoCodigo]
					   ,[Sexo]
					   ,[Profissao]
					   ,[RendaIndividual]
					   ,[RendaFamiliar]
					   ,[Matricula]
					   ,[FuncionarioEmail]
					   ,[ParticipanteEmail]
					   ,[FuncaoCodigo]
					   ,[FuncaoDescricao]
					   ,[FuncaoDataInicio]
					   ,[FuncaoIndicadorFaixa]
					   ,[FuncionarioSituacaoCodigo]
					   ,[FuncionarioSituacao]
					   ,[IndicadorArea]
					   ,[UnidadeCodigo]
					   ,[UnidadeNome]
					   ,[LotacaoUF]
					   ,[LotacaoCidade]
					   ,[LotacaoSigla]
					   ,[LotacaoEmail]
					   ,[LotacaoDataInicio]
					   ,[LotacaoDDD]
					   ,[LotacaoTelefone]
					   ,[Endereco]
					   ,[Cidade]
					   ,[UF]
					   ,[CEP]
					   ,[Agencia]
					   ,[Operacao]
					   ,[Conta] 
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaFuncionario_SRH] ''''' + @PontoDeParada + ''''''') PRP'

EXEC (@COMANDO)     

                
SELECT @MaiorCodigo= MAX(Codigo)
FROM [dbo].[FuncionarioSRH_TEMP]

/*********************************************************************************************************************/

WHILE @MaiorCodigo IS NOT NULL
BEGIN 


	/************************************************************************
	Classifica funcionários VIPS por Lotação
	*************************************************************************/
	UPDATE [dbo].[FuncionarioSRH_TEMP] SET VIP=1 FROM
	[dbo].[FuncionarioSRH_TEMP] AS F
	INNER JOIN [ConfiguracaoDados].[VIP_Sigla_Lotacao] AS S
	ON F.LotacaoSigla=S.Descricao

	/************************************************************************
	Classifica funcionários VIPS por Função
	*************************************************************************/
	UPDATE [dbo].[FuncionarioSRH_TEMP] SET VIP=1 FROM
	[dbo].[FuncionarioSRH_TEMP] AS F
	INNER JOIN [ConfiguracaoDados].[VIP_Funcao] AS S
	ON F.FuncaoCodigo=S.Codigo

	 /***********************************************************************
     Carregar as FUNÇÃO dos Funcionarios
   ***********************************************************************/

 ; MERGE INTO dados.funcao AS T
      USING (select distinct FuncaoCodigo, FuncaoDescricao 
				from [dbo].FuncionarioSRH_TEMP
             WHERE FuncaoCodigo IS NOT NULL and FuncaoCodigo <> '00000'
            ) X
       ON  T.Codigo = X.FuncaoCodigo
     WHEN NOT MATCHED
	          THEN INSERT (Codigo, Descricao)
	               VALUES (X.FuncaoCodigo, X.FuncaoDescricao)
	WHEN MATCHED
	          THEN UPDATE SET T.Descricao = X.FuncaoDescricao

	; MERGE INTO dados.indicadorArea AS T
      USING (select distinct indicadorarea 
				from [dbo].FuncionarioSRH_TEMP
             WHERE indicadorarea IS NOT NULL 
            ) X
       ON  T.ID = X.indicadorarea
     WHEN NOT MATCHED
	          THEN INSERT (ID)
	               VALUES (X.IndicadorArea)					  
	;

   	 /***********************************************************************
     Carregar as Situação dos Funcionarios
   ***********************************************************************/

   ; MERGE INTO [Dados].[SituacaoFuncionario] AS T
      USING (select distinct FuncionarioSituacaoCodigo, FuncionarioSituacao
						from [dbo].FuncionarioSRH_TEMP
             WHERE FuncionarioSituacaoCodigo IS NOT NULL 
		
) X
       ON  T.Codigo = X.FuncionarioSituacaoCodigo
	   --Verificar se o código é aderente a situações de funcionários de todas as empresas. Se não for, reavaliar a cláusula do MATCH (ACIMA)
     WHEN NOT MATCHED
	          THEN INSERT (Codigo, Descricao)
	          VALUES (X.FuncionarioSituacaoCodigo, X.FuncionarioSituacao)
	--WHEN MATCHED
	--          THEN UPDATE SET T.Descricao = X.FuncionarioSituacao					  
	--;SELECT @@TRANCOUNT
	;
  	 /***********************************************************************
     Carregar os Funcionarios recebidos no arquivo SRH
   ***********************************************************************/
   --BEGIN tran
    MERGE INTO Dados.Funcionario AS T
		USING (
				SELECT TOP 100 PERCENT * 
				FROM
				 ( select  temp.Nome,
					temp.CPF,
					temp.FuncionarioEmail as Email,
					temp.Matricula Matricula,
					1 as IDEmpresa,
					RIGHT('000' + temp.LotacaoDDD,3) as DDD,
					temp.LotacaoTelefone as Telefone,
					/*SEPAR O DDD E O TELEFONE*/
					--null as IDmediaFile,
					--null as IDUsuario,
					--null as Salario,
					--null as IDCentroCusto,
					--null as IDGerenteRegional,
					--null as IDGerenteVenda,
					--null as IDGerenteNacional,
					--null as DataCriacao,
					temp.FuncaoDescricao as UltimoCargo,
					--null as DataAdmissao,
					--null as IDTipoVinculo,
					funcao.ID as IDFuncao,
					situafunc.ID as IDUltimaSituacaoFuncionario,
					--null as DataAtualizacaoCentrocusto,
					DataMovimentacao as DataAtualizacaoCargo,
					--null as DataAtualizacaoVolta,
					temp.SexoCodigo as IDSexo,
					temp.DataNascimento,
					unidade.ID as IDUnidade,
					temp.LotacaoEmail as UltimoLotacaoEmail,
					temp.ParticipanteEmail as UltimoEmailParticipante,
					temp.FuncaoIndicadorFaixa,
					'SRH' as NomeArquivo,
					temp.DataArquivo,
					VIP,
					LotacaoSigla,
					ROW_NUMBER() OVER(PARTITION BY temp.matricula ORDER BY temp.[DataMovimentacao] DESC)  [ORDER]

				from [dbo].FuncionarioSRH_TEMP temp
				left join Dados.Funcao funcao
				on temp.FuncaoCodigo = funcao.Codigo
				left join Dados.SituacaoFuncionario situafunc
				on situafunc.Codigo = temp.FuncionarioSituacaoCodigo
				left join Dados.Unidade unidade
				on unidade.Codigo = temp.UnidadeCodigo) a
				where a.[ORDER] = 1
		  ) X
ON  X.Matricula = T.Matricula
and X.IDEmpresa = T.IDEmpresa
WHEN MATCHED  AND X.DataArquivo >= ISNULL(T.DataArquivo, '0001-01-01')
THEN UPDATE
   SET T.Nome = COALESCE(X.Nome, T.Nome)
      ,t.[CPF] = COALESCE(X.CPF, T.CPF)
      ,t.[Email] = COALESCE(X.Email, T.Email)
     -- ,t.[Matricula] = COALESCE(O.Matricula, T.Matricula)
     -- ,t.[IDEmpresa] = COALESCE(O.IDEmpresa, T.IDEmpresa)
	 -- ,t.[DDD] = COALESCE(X.DDD, T.DDD) --** RETIRADO POIS É ATUALIZADO PASSOS ABAIXO, APÓS O CARREGAMENTO (MERGE) DA TABELA FUNCIONÁRIO HISTÓRICO
     --,t.[Telefone] = COALESCE(X.Telefone, T.Telefone)--** RETIRADO POIS É ATUALIZADO PASSOS ABAIXO, APÓS O CARREGAMENTO (MERGE) DA TABELA FUNCIONÁRIO HISTÓRICO
	  ,t.DataSistema = (getdate())
     -- ,t.[IDMediaFile] = COALESCE(O.IDMediaFile, T.IDMediaFile)
    --  ,t.[IDUsuario] = COALESCE(O.IDUsuario, T.IDUsuario)
     -- ,t.[Salario] = COALESCE(O.Salario, T.Salario)
     -- ,t.[IDCentroCusto] = COALESCE(O.IDCentroCusto, T.IDCentroCusto)
     -- ,t.[IDGerenteRegional] = COALESCE(O.IDGerenteRegional, T.IDGerenteRegional)
      --,t.[IDGerenteVenda] = COALESCE(O.IDGerenteVenda, T.IDGerenteVenda)
      --,t.[IDGerenteNacional] = COALESCE(O.IDGerenteNacional, T.IDGerenteNacional)
     -- ,t.[DataCriacao] = COALESCE(O.DataCriacao, T.DataCriacao)
     -- ,t.[UltimoCargo] = COALESCE(X.UltimoCargo, T.UltimoCargo)--**	RETIRADO POIS É ATUALIZADO PASSOS ABAIXO, APÓS O CARREGAMENTO (MERGE) DA TABELA FUNCIONÁRIO HISTÓRICO
     -- ,t.[DataAdmissao] = COALESCE(O.DataAdmissao, T.DataAdmissao)
      --,t.[IDTipoVinculo] = COALESCE(O.IDTipoVinculo, T.IDTipoVinculo)
      -- ,t.[IDUltimaFuncao] = COALESCE(X.IDFuncao, T.IDUltimaFuncao)--***	 RETIRADO POIS É ATUALIZADO PASSOS ABAIXO, APÓS O CARREGAMENTO (MERGE) DA TABELA FUNCIONÁRIO HISTÓRICO
      --,t.[IDUltimaSituacaoFuncionario] = COALESCE(X.IDUltimaSituacaoFuncionario, T.IDUltimaSituacaoFuncionario)--***  RETIRADO POIS É ATUALIZADO PASSOS ABAIXO, APÓS O CARREGAMENTO (MERGE) DA TABELA FUNCIONÁRIO HISTÓRICO
      --,t.[DataAtualizacaoCentroCusto] = COALESCE(O.DataAtualizacaoCentroCusto, T.DataAtualizacaoCentroCusto)
      ,t.[DataAtualizacaoCargo] = COALESCE(X.DataAtualizacaoCargo, T.DataAtualizacaoCargo)
      --,t.[DataAtualizacaoVolta] = COALESCE(O.DataAtualizacaoVolta, T.DataAtualizacaoVolta)
     -- ,t.[DataSistema]
      ,t.[IDSexo]  = COALESCE(X.IDSexo, T.IDSexo)
      ,t.[DataNascimento] = COALESCE(X.DataNascimento, T.DataNascimento)
      --,t.[IDUltimaUnidade]  = COALESCE(X.IDUnidade, T.IDUltimaUnidade)--***  RETIRADO POIS É ATUALIZADO PASSOS ABAIXO, APÓS O CARREGAMENTO (MERGE) DA TABELA FUNCIONÁRIO HISTÓRICO
      --,t.[UltimoLotacaoEmail]  = COALESCE(X.UltimoLotacaoEmail, T.UltimoLotacaoEmail)--*** RETIRADO POIS É ATUALIZADO PASSOS ABAIXO, APÓS O CARREGAMENTO (MERGE) DA TABELA FUNCIONÁRIO HISTÓRICO
      --,t.[UltimoEmailParticipante]  = COALESCE(X.UltimoEmailParticipante, T.UltimoEmailParticipante) RETIRADO POIS É ATUALIZADO PASSOS ABAIXO, APÓS O CARREGAMENTO (MERGE) DA TABELA FUNCIONÁRIO HISTÓRICO
      ,t.[FuncaoIndicadorFaixa]  = COALESCE(X.FuncaoIndicadorFaixa, T.FuncaoIndicadorFaixa)
      ,t.[NomeArquivo]  = COALESCE(X.NomeArquivo, T.NomeArquivo)
      ,t.[DataArquivo]  = COALESCE(X.DataArquivo, T.DataArquivo)
	  ,T.[VIP] = COALESCE(X.VIP, T.VIP)
	  ,T.[SiglaLotacao] = COALESCE(X.LotacaoSigla, T.SiglaLotacao)
	  WHEN NOT MATCHED
			THEN INSERT ([Nome]
      ,[CPF]
      ,[Email]
      ,[Matricula]
      ,[IDEmpresa]
	  ,[DDD]
      ,[Telefone]
	  ,DataSistema 
      --,[IDMediaFile]
      --,[IDUsuario]
      --,[Salario]
     -- ,[IDCentroCusto]
     -- ,[IDGerenteRegional]
     -- ,[IDGerenteVenda]
     -- ,[IDGerenteNacional]
     -- ,[DataCriacao]
      ,[UltimoCargo]
     -- ,[DataAdmissao]
      --,[IDTipoVinculo]
      ,[IDUltimaFuncao]
      ,[IDUltimaSituacaoFuncionario]
      --,[DataAtualizacaoCentroCusto]
      ,[DataAtualizacaoCargo]
      --,[DataAtualizacaoVolta]
      ,[IDSexo]
      ,[DataNascimento]
      ,[IDUltimaUnidade]
      ,[UltimoLotacaoEmail]
      ,[UltimoParticipanteEmail]
      ,[FuncaoIndicadorFaixa]
      ,[NomeArquivo]
      ,[DataArquivo]
	  ,[VIP])
	  values (X.Nome,X.CPF,X.Email,X.Matricula,X.IDEmpresa,X.DDD,X.Telefone,(getdate()),X.UltimoCargo,X.IDFuncao,
	  X.IDUltimaSituacaoFuncionario,X.DataAtualizacaoCargo,X.IDSexo,X.DataNascimento,X.IDUnidade,
	  X.UltimoLotacaoEmail,X.UltimoEmailParticipante,X.FuncaoIndicadorFaixa,X.NomeArquivo,X.DataArquivo, X.VIP);
	
	
	
     /***********************************************************************

/*Apaga a marcação LastValue do historico funcionario recebidos para atualizar a última posição
-> logo depois da inserção de funcionarios*/

/*Diego Lima - Data: 10/10/2013 */

     ***********************************************************************/	  
--SELECT * FROM  Dados.FuncionarioHistorico	 WHERE IDFuncionario = 	60677
--select * from [dbo].FuncionarioSRH_TEMP  where nome = 'JORGE MULLER DA SILVA                             '

UPDATE Dados.FuncionarioHistorico SET LastValue = 0
--select * --delete  Dados.FuncionarioHistorico
FROM Dados.FuncionarioHistorico FH 
	INNER JOIN Dados.Funcionario F
	ON FH.IDFuncionario = F.ID	
    INNER JOIN [dbo].FuncionarioSRH_TEMP T
	ON    F.Matricula = T.Matricula
	  AND F.IDEmpresa = 1
WHERE FH.LastValue = 1												
   --AND T.DataArquivo >= FH.DataArquivo


   
/***********************************************************************
Carrega os dados na Funcionario historico
***********************************************************************/  
;WITH CTE
AS
(
	select TOP 100 PERCENT
	     A.[IDFuncionario]
		,A.[IDFuncao]
		,A.[IDUnidade]
		,A.[IDSituacaoFuncionario]
		,A.[Nome]
		,A.[DataAdmissao]
		,A.[DataAtualizacaoCargo]
		,A.[DataAtualizacaoVolta]
		,A.[Salario]
		,A.[Cargo]
		,A.[LotacaoUF]
		,A.[LotacaoCidade]
		,A.[LotacaoDataInicio]
		,A.[LotacaoSigla]
		,A.[LotacaoEmail]
		,A.ParticipanteEmail
		,A.LotacaoDDD as [ParticipanteLotacaoDDD]
		,A.LotacaoTelefone as [ParticipanteLotacaoTelefone]
		,A.[FuncaoDataInicio]
		,A.[IndicadorArea]
		,A.[NomeArquivo]
		,A.[DataArquivo]
		,A.[VIP]
		,A.[Persisted]	
	from 
	   (
		select  
			temp.Matricula,
			F.ID as IDFuncionario,
			FC.ID as IDFuncao,
			U.ID as IDUnidade,
			SF.ID as IDSituacaoFuncionario,
			temp.Nome,
			null as DataAdmissao,
			temp.DataMovimentacao as DataAtualizacaoCargo,
			null as DataAtualizacaoVolta,
			null as Salario,
			temp.FuncaoDescricao as Cargo,
			temp.LotacaoUF,
			temp.LotacaoCidade,
			temp.LotacaoDataInicio,
			temp.LotacaoSigla,
			temp.LotacaoEmail,
			temp.ParticipanteEmail,
			RIGHT('000' + temp.LotacaoDDD,3) as LotacaoDDD,
			temp.LotacaoTelefone,
			temp.FuncaoDataInicio,
			'SRH' as NomeArquivo,
			temp.[IndicadorArea],
			temp.DataArquivo,
			temp.VIP,
			0 [Persisted] --select *
		from [dbo].FuncionarioSRH_TEMP temp --WHERE temp.MATRICULA like '%833662%'
		  INNER JOIN Dados.Funcionario F
				on F.Matricula = temp.Matricula
				AND F.IDEmpresa = 1
          LEFT JOIN Dados.Funcao FC
			on temp.FuncaoCodigo = FC.Codigo
			left join Dados.SituacaoFuncionario SF
			on SF.Codigo = temp.FuncionarioSituacaoCodigo
			left join Dados.Unidade U
			on U.Codigo = temp.UnidadeCodigo
		--SELECT * 
		--from [dbo].FuncionarioSRH_TEMP temp
		--WHERE temp.MATRICULA like '%3091'								   
		--WHERE F.ID = 5001
		) as A
	 UNION ALL -- O ALL foi incluído exclusivamente para não pagar um sort (no plano de execução) já que usamos 2 funções de RANK para determinar os registros válidos
	 SELECT FH.[IDFuncionario]						
           ,FH.[IDFuncao]							
           ,FH.[IDUnidade]							
           ,FH.[IDSituacaoFuncionario]				
		   ,FH.[Nome]								
           ,FH.[DataAdmissao]						
           ,FH.[DataAtualizacaoCargo]				
           ,FH.[DataAtualizacaoVolta]				
           ,FH.[Salario]							
           ,FH.[Cargo]								
           ,FH.[LotacaoUF]							
           ,FH.[LotacaoCidade]						
           ,FH.[LotacaoDataInicio]					
           ,FH.[LotacaoSigla]						
           ,FH.[LotacaoEmail]						
           ,FH.[ParticipanteEmail]					
		   ,FH.[ParticipanteLotacaoDDD]				
           ,FH.[ParticipanteLotacaoTelefone]		
           ,FH.[FuncaoDataInicio]					
           ,FH.IDIndicadorArea						
		   ,FH.NomeArquivo           					
		   ,FH.[DataArquivo]
		   ,FH.[VIP]
		   ,1 [Persisted] 	
	 FROM Dados.FuncionarioHistorico FH				
	 INNER JOIN Dados.Funcionario F					 		
	 ON F.ID = FH.IDFuncionario						
	 WHERE EXISTS (SELECT * from [dbo].FuncionarioSRH_TEMP temp
					 WHERE F.Matricula = temp.Matricula
					AND F.IDEmpresa = 1	 )
)
,
CTE_AUX
AS
(
	SELECT 	TOP 100 PERCENT 
			* ,
			--ROW_NUMBER() OVER(PARTITION BY  CTE.IDFuncionario, CTE.[IDFuncao], CTE.IDUnidade 
			--					,CTE.[IDSituacaoFuncionario],CTE.[Nome],  CTE.[Cargo], CTE.[LotacaoCidade]
			--					,CTE.[LotacaoDataInicio], CTE.[LotacaoSigla], CTE.ParticipanteLotacaoTelefone
			--					,CTE.[FuncaoDataInicio], CTE.ParticipanteEmail, CTE.IndicadorArea	ORDER BY CTE.DataArquivo ASC)  [ROW]

		   CASE WHEN 
					   ISNULL(LAG(CTE.IDFuncionario,1) OVER(ORDER BY CTE.IDFuncionario ASC, CTE.DataArquivo ASC),-1) = ISNULL(CTE.IDFuncionario,-1)
				   AND ISNULL(LAG(CTE.[IDFuncao],1) OVER(ORDER BY CTE.IDFuncionario ASC, CTE.DataArquivo ASC),-1) = ISNULL(CTE.[IDFuncao],-1)
				   AND ISNULL(LAG(CTE.IDUnidade,1) OVER(ORDER BY CTE.IDFuncionario ASC, CTE.DataArquivo ASC),-1) = ISNULL(CTE.IDUnidade,-1) 
				   AND ISNULL(LAG(CTE.[IDSituacaoFuncionario],1) OVER(ORDER BY CTE.IDFuncionario ASC, CTE.DataArquivo ASC),-1) = ISNULL(CTE.[IDSituacaoFuncionario],-1)
				   AND ISNULL(LAG(CTE.[Nome],1) OVER(ORDER BY CTE.IDFuncionario ASC, CTE.DataArquivo ASC),'') = ISNULL(CTE.[Nome],'')
				   AND ISNULL(LAG(CTE.[Cargo],1) OVER(ORDER BY CTE.IDFuncionario ASC, CTE.DataArquivo ASC),'') = ISNULL(CTE.[Cargo],'')
				   AND ISNULL(LAG(CTE.[LotacaoCidade],1) OVER(ORDER BY CTE.IDFuncionario ASC, CTE.DataArquivo ASC),'') = ISNULL(CTE.[LotacaoCidade],'')
				   AND ISNULL(LAG(CTE.[LotacaoDataInicio],1) OVER(ORDER BY CTE.IDFuncionario ASC, CTE.DataArquivo ASC),'1900-01-01') = ISNULL(CTE.[LotacaoDataInicio],'1900-01-01')
				   AND ISNULL(LAG(CTE.[LotacaoSigla],1) OVER(ORDER BY CTE.IDFuncionario ASC, CTE.DataArquivo ASC),'') = ISNULL(CTE.[LotacaoSigla],'')
				   AND ISNULL(LAG(CTE.ParticipanteLotacaoTelefone,1) OVER(ORDER BY CTE.IDFuncionario ASC, CTE.DataArquivo ASC),'') = ISNULL(CTE.ParticipanteLotacaoTelefone,'')
				   AND ISNULL(LAG(CTE.[FuncaoDataInicio],1) OVER(ORDER BY CTE.IDFuncionario ASC, CTE.DataArquivo ASC),'1900-01-01') = ISNULL(CTE.[FuncaoDataInicio],'1900-01-01')
				   AND ISNULL(LAG(CTE.ParticipanteEmail,1) OVER(ORDER BY CTE.IDFuncionario ASC, CTE.DataArquivo ASC),'') = ISNULL(CTE.ParticipanteEmail,'') 
				   AND ISNULL(LAG(CTE.IndicadorArea,1) OVER(ORDER BY CTE.IDFuncionario ASC, CTE.DataArquivo ASC),0) = ISNULL(CTE.IndicadorArea,0) 
				   AND ISNULL(LAG(CTE.VIP,1) OVER(ORDER BY CTE.IDFuncionario ASC, CTE.DataArquivo ASC),0) = ISNULL(CTE.VIP,0) 

	         THEN
				0
	      ELSE 1
		  END [ROW]

	FROM CTE
 	ORDER BY CTE.IDFuncionario ASC, CTE.DataArquivo ASC
)								 --SELECT * FROM 	 CTE_AUX
MERGE INTO Dados.FuncionarioHistorico AS T
		USING (	 
				SELECT *
				FROM CTE_AUX  
              )  X
		ON 
				ISNULL(X.IDFuncionario, -1) = ISNULL(T.IDFuncionario,-1) 
			and ISNULL(X.IDfuncao,-1) = ISNULL(T.IDFuncao,-1)
			and ISNULL(X.IDUnidade,-1) = ISNULL(T.IDUnidade,-1) 
			and ISNULL(X.IDSituacaoFuncionario,-1) = ISNULL(T.IDSituacaoFuncionario,-1)
			and ISNULL(X.Nome, '') = ISNULL(T.Nome,'')
			--and ISNULL(X.DataAtualizacaoCargo,'0001-01-01') = ISNULL(T.DataAtualizacaoCargo,'0001-01-01')
			and ISNULL(X.Cargo, '') = ISNULL(T.Cargo, '') 
			and ISNULL(X.LotacaoCidade, '') = ISNULL(T.LotacaoCidade, '')
			and ISNULL(X.LotacaoDataInicio,'1900-01-01') = ISNULL(T.LotacaoDataInicio,'1900-01-01') 
			and ISNULL(X.LotacaoSigla, '') = ISNULL(T.LotacaoSigla, '')
			and ISNULL(X.ParticipanteLotacaoTelefone, '') = ISNULL(T.ParticipanteLotacaoTelefone, '')
			and ISNULL(X.FuncaoDataInicio, '1900-01-01') = ISNULL(T.FuncaoDataInicio, '1900-01-01')	
			and ISNULL(X.ParticipanteEmail, '') = ISNULL(T.ParticipanteEmail, '') 
			and ISNULL(X.IndicadorArea, 0) = ISNULL(T.IDIndicadorArea,0)
			AND ISNULL(X.DataArquivo, '1900-01-01') =  ISNULL(T.DataArquivo, '1900-01-01')
			AND ISNULL(X.VIP, 0) =  ISNULL(T.VIP, 0)

		--WHEN MATCHED AND X.DataArquivo < T.DataArquivo 
		--THEN    
		--   UPDATE SET DataArquivo =  X.DataArquivo
		WHEN NOT MATCHED AND [ROW] = 1 
		THEN INSERT ([IDFuncionario]
			   ,[IDFuncao]
			   ,[IDUnidade]
			   ,[IDSituacaoFuncionario]
			   ,IDIndicadorArea
			   ,[Nome]
			   ,[DataAdmissao]
			   ,[DataAtualizacaoCargo]
			   ,[DataAtualizacaoVolta]
			   ,[Salario]
			   ,[Cargo]
			   ,[LotacaoUF]
			   ,[LotacaoCidade]
			   ,[LotacaoDataInicio]
			   ,[LotacaoSigla]
			   ,[LotacaoEmail]
			   ,[ParticipanteEmail]
			   ,[ParticipanteLotacaoDDD]
			   ,[ParticipanteLotacaoTelefone]
			   ,[FuncaoDataInicio]
			   ,[NomeArquivo]
			   ,[DataArquivo]
			   ,[LastValue]
			   ,[VIP])
		 VALUES (X.[IDFuncionario],X.IDFuncao,X.IDUnidade,X.[IDSituacaoFuncionario], X.IndicadorArea, X.[Nome],X.[DataAdmissao],
				X.[DataAtualizacaoCargo],X.[DataAtualizacaoVolta],X.[Salario],X.[Cargo],X.[LotacaoUF],X.[LotacaoCidade],
				X.[LotacaoDataInicio],X.[LotacaoSigla],X.[LotacaoEmail], X.ParticipanteEmail, X.[ParticipanteLotacaoDDD],
				X.[ParticipanteLotacaoTelefone],X.[FuncaoDataInicio],X.[NomeArquivo],X.DataArquivo, 0,X.VIP
		       )
		WHEN MATCHED AND [ROW] = 0 AND X.[Persisted] = 1
		THEN
		  DELETE
		; 




--;MERGE INTO Dados.FuncionarioHistorico AS T
--		USING (
--				select A.[IDFuncionario]
--					  ,A.[IDFuncao]
--					  ,A.[IDUnidade]
--					  ,A.[IDSituacaoFuncionario]
--					  ,A.[Nome]
--					  ,A.[DataAdmissao]
--					  ,A.[DataAtualizacaoCargo]
--					  ,A.[DataAtualizacaoVolta]
--					  ,A.[Salario]
--					  ,A.[Cargo]
--					  ,A.[LotacaoUF]
--					  ,A.[LotacaoCidade]
--					  ,A.[LotacaoDataInicio]
--					  ,A.[LotacaoSigla]
--					  ,A.[LotacaoEmail]
--					  ,A.ParticipanteEmail
--					  ,A.LotacaoDDD as [ParticipanteLotacaoDDD]
--					  ,A.LotacaoTelefone as [ParticipanteLotacaoTelefone]
--					  ,A.[FuncaoDataInicio]
--					  ,A.[IndicadorArea]
--					  ,A.[NomeArquivo]
--					  ,A.[DataArquivo]
--					  /*,(CASE WHEN  ROW_NUMBER() OVER (PARTITION BY A.IDFuncionario
--													  ORDER BY A.DataArquivo DESC, A.[DataAtualizacaoCargo] DESC, A.[FuncaoDataInicio] DESC ) = 1 /*OR PE.Endereco IS NOT NULL*/ THEN 1
--																	ELSE 0 END) LastValue
--					  */
--					  ,0 LastValue
--				  ,ROW_NUMBER() OVER (PARTITION BY
--					                         A.IDFuncionario, A.[IDFuncao], A.IDUnidade 
--											,A.[IDSituacaoFuncionario],A.[Nome], A.[DataAtualizacaoCargo], A.[Cargo], A.[LotacaoCidade]
--											,A.[LotacaoDataInicio], A.[LotacaoSigla], A.LotacaoTelefone
--											,A.[FuncaoDataInicio], A.ParticipanteEmail, A.IndicadorArea
--										ORDER BY A.DataArquivo ASC) NUMERADOR
--				from 
--						(select  distinct
--							temp.Matricula,
--							F.ID as IDFuncionario,
--							FC.ID as IDFuncao,
--							U.ID as IDUnidade,
--							SF.ID as IDSituacaoFuncionario,
--							temp.Nome,
--							null as DataAdmissao,
--							temp.DataMovimentacao as DataAtualizacaoCargo,
--							null as DataAtualizacaoVolta,
--							null as Salario,
--							temp.FuncaoDescricao as Cargo,
--							temp.LotacaoUF,
--							temp.LotacaoCidade,
--							temp.LotacaoDataInicio,
--							temp.LotacaoSigla,
--							temp.LotacaoEmail,
--							temp.ParticipanteEmail,
--							RIGHT('000' + temp.LotacaoDDD,3) as LotacaoDDD,
--							temp.LotacaoTelefone,
--							temp.FuncaoDataInicio,
--							'SRH' as NomeArquivo,
--							temp.[IndicadorArea],
--							temp.DataArquivo --select *
--						from [dbo].FuncionarioSRH_TEMP temp --WHERE temp.MATRICULA like '%833662%'
--							INNER JOIN Dados.Funcionario F
--								on F.Matricula = temp.Matricula
--								AND F.IDEmpresa = 1
--                        LEFT JOIN Dados.Funcao FC
--				            on temp.FuncaoCodigo = FC.Codigo
--				            left join Dados.SituacaoFuncionario SF
--				            on SF.Codigo = temp.FuncionarioSituacaoCodigo
--				            left join Dados.Unidade U
--				            on U.Codigo = temp.UnidadeCodigo
--						--SELECT * 
--						--from [dbo].FuncionarioSRH_TEMP temp
--						--WHERE temp.MATRICULA like '%3091'								   
--						--WHERE F.ID = 5001
--						) as A

--			) as X
--			on      ISNULL(X.IDFuncionario, -1) = ISNULL(T.IDFuncionario,-1) 
--			    and ISNULL(X.IDfuncao,-1) = ISNULL(T.IDFuncao,-1)
--				and ISNULL(X.IDUnidade,-1) = ISNULL(T.IDUnidade,-1) 
--				and ISNULL(X.IDSituacaoFuncionario,-1) = ISNULL(T.IDSituacaoFuncionario,-1)
--				and ISNULL(X.Nome, '') = ISNULL(T.Nome,'')
--				--and ISNULL(X.DataAtualizacaoCargo,'0001-01-01') = ISNULL(T.DataAtualizacaoCargo,'0001-01-01')
--				and ISNULL(X.Cargo, '') = ISNULL(T.Cargo, '') 
--				and ISNULL(X.LotacaoCidade, '') = ISNULL(T.LotacaoCidade, '')
--				and ISNULL(X.LotacaoDataInicio,'0001-01-01') = ISNULL(T.LotacaoDataInicio,'0001-01-01') 
--				and ISNULL(X.LotacaoSigla, '') = ISNULL(T.LotacaoSigla, '')
--				and ISNULL(X.ParticipanteLotacaoTelefone, '') = ISNULL(T.ParticipanteLotacaoTelefone, '')
--				and ISNULL(X.FuncaoDataInicio, '0001-01-01') = ISNULL(T.FuncaoDataInicio, '0001-01-01')	
--				and ISNULL(X.ParticipanteEmail, '') = ISNULL(T.ParticipanteEmail, '') 
--				and ISNULL(X.IndicadorArea, 0) = ISNULL(T.IDIndicadorArea,0)
--				and X.DataArquivo >= T.DataArquivo
--	--WHEN MATCHED AND X.[DataArquivo] >= T.[DataArquivo] THEN  
--	--	 UPDATE
--	--			SET 
--	--			 [IDFuncao] =  COALESCE(X.IDFuncao, T.IDFuncao)
--	--			,[IDUnidade] =  COALESCE(X.IDUnidade, T.IDUnidade)
--	--			,[IDSituacaoFuncionario] =  COALESCE(X.[IDSituacaoFuncionario], T.[IDSituacaoFuncionario])
--	--			,[Nome] =  COALESCE(X.[Nome], T.[Nome])
--	--			,[DataAdmissao] =  COALESCE(X.[DataAdmissao], T.[DataAdmissao])
--	--			,[DataAtualizacaoCargo] =  COALESCE(X.[DataAtualizacaoCargo], T.[DataAtualizacaoCargo])
--	--			,[DataAtualizacaoVolta] =  COALESCE(X.[DataAtualizacaoVolta], T.[DataAtualizacaoVolta])
--	--			,[Salario] =  COALESCE(X.[Salario], T.[Salario])
--	--			,[Cargo] = COALESCE(X.[Cargo], T.[Cargo])
--	--			,[LotacaoUF] = COALESCE(X.[LotacaoUF], T.[LotacaoUF])
--	--			,[LotacaoCidade] = COALESCE(X.[LotacaoCidade], T.[LotacaoCidade])
--	--			,[LotacaoDataInicio] = COALESCE(X.[LotacaoDataInicio], T.[LotacaoDataInicio])
--	--			,[LotacaoSigla] = COALESCE(X.[LotacaoSigla], T.[LotacaoSigla])
--	--			,[LotacaoEmail] = COALESCE(X.[LotacaoEmail], T.[LotacaoEmail])
--	--			,[ParticipanteEmail] = COALESCE(X.ParticipanteEmail, T.ParticipanteEmail)
--	--			,[ParticipanteLotacaoDDD] = COALESCE(X.[ParticipanteLotacaoDDD], T.[ParticipanteLotacaoDDD])
--	--			,[ParticipanteLotacaoTelefone] = COALESCE(X.[ParticipanteLotacaoTelefone], T.[ParticipanteLotacaoTelefone])
--	--			,[FuncaoDataInicio] = COALESCE(X.[FuncaoDataInicio], T.[FuncaoDataInicio])
--	--			,[NomeArquivo] = COALESCE(X.[NomeArquivo], T.[NomeArquivo])
--	--			,[DataArquivo] = X.DataArquivo
--	--			,[LastValue] = X.LastValue
--		WHEN NOT MATCHED
--		THEN INSERT ([IDFuncionario]
--           ,[IDFuncao]
--           ,[IDUnidade]
--           ,[IDSituacaoFuncionario]
--		   ,IDIndicadorArea
--           ,[Nome]
--           ,[DataAdmissao]
--           ,[DataAtualizacaoCargo]
--           ,[DataAtualizacaoVolta]
--           ,[Salario]
--           ,[Cargo]
--           ,[LotacaoUF]
--           ,[LotacaoCidade]
--           ,[LotacaoDataInicio]
--           ,[LotacaoSigla]
--           ,[LotacaoEmail]
--		   ,[ParticipanteEmail]
--           ,[ParticipanteLotacaoDDD]
--           ,[ParticipanteLotacaoTelefone]
--           ,[FuncaoDataInicio]
--           ,[NomeArquivo]
--           ,[DataArquivo]
--           ,[LastValue])
--     VALUES (X.[IDFuncionario],X.IDFuncao,X.IDUnidade,X.[IDSituacaoFuncionario], X.IndicadorArea, X.[Nome],X.[DataAdmissao],
--			X.[DataAtualizacaoCargo],X.[DataAtualizacaoVolta],X.[Salario],X.[Cargo],X.[LotacaoUF],X.[LotacaoCidade],
--			X.[LotacaoDataInicio],X.[LotacaoSigla],X.[LotacaoEmail], X.ParticipanteEmail, X.[ParticipanteLotacaoDDD],
--			X.[ParticipanteLotacaoTelefone],X.[FuncaoDataInicio],X.[NomeArquivo],X.DataArquivo,X.LastValue
--	); 

	/*Atualiza a marcação LastValue das propostas recebidas para atualizar a última posição*/
	/*Egler - Data: 18/10/2013 */		 
    UPDATE Dados.FuncionarioHistorico SET LastValue = 1
  FROM Dados.FuncionarioHistorico PE
	INNER JOIN (
				SELECT ID,   ROW_NUMBER() OVER (PARTITION BY  FH.IDFuncionario
											    ORDER BY FH.DataArquivo DESC, FH.[DataAtualizacaoCargo] DESC, FH.[FuncaoDataInicio] DESC ) [ORDEM]
				FROM  Dados.FuncionarioHistorico FH
				WHERE FH.IDFuncionario in (SELECT F.ID
										   FROM [dbo].FuncionarioSRH_TEMP A
											inner join Dados.Funcionario F
												on F.Matricula = A.Matricula
												AND F.IDEmpresa = 1
											) 
											--AND IDFUNCIONARIO = 5007
											--ORDER BY FH.DataArquivo DESC, FH.[DataAtualizacaoCargo] DESC, FH.[FuncaoDataInicio] DESC
				) A
	 ON A.ID = PE.ID 
	 AND A.ORDEM = 1		

--1 RETIRAR DO MERGE DA TABELA FUNCIONARIO TODOS OS CAMPOS QUE SÃO CARREGADOS NA TABELA FUNCIONARIO HISTORICO
--2 CRIAR AQUI UM UPDATE ATUALIZANDO A TABELA DADOS.FUNCIONARIO ESSES CAMPOS COM OS DADOS DA TABELA DADOS.FUNCIONARIOHISTORICO, MARCADOS COMO LASTVALUE = 1

UPDATE [Corporativo].[Dados].Funcionario
SET 
--SELECT 
        IDUltimaFuncao = fh.IDFuncao, 
		IDUltimaUnidade = fh.IDUnidade, 
		IDUltimaSituacaoFuncionario = fh.IDSituacaoFuncionario, 
		Nome = fh.Nome, 
		DataAdmissao = fh.DataAdmissao, 
		DataAtualizacaoVolta = fh.DataAtualizacaoVolta,
		Salario = fh.Salario, 
		UltimoCargo = fh.Cargo, 
		UltimoLotacaoEmail = fh.LotacaoEmail,
		DDD = fh.ParticipanteLotacaoDDD, 
		Telefone = fh.ParticipanteLotacaoTelefone,
		UltimoParticipanteEmail = fh.ParticipanteEmail,
		IDIndicadorArea = fh.IDIndicadorArea
		
FROM [Corporativo].[Dados].[FuncionarioHistorico] FH
	inner join [Corporativo].[Dados].Funcionario f
on (fh.IDFuncionario = f.ID)		
AND F.IDEmpresa = 1
where fh.LASTVALUE = 1 
AND EXISTS( SELECT *
            FROM [dbo].FuncionarioSRH_TEMP temp
	        WHERE F.Matricula = temp.Matricula)


 /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Funcionario_SRH'

   /*************************************************************************************/
  
 /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[FuncionarioSRH_TEMP] 
    
  /*********************************************************************************************************************/               
  /*Recupeara maior Código do retorno*/
  /*********************************************************************************************************************/
  SET @COMANDO = 'INSERT INTO [dbo].[FuncionarioSRH_TEMP] ( 
                        [Codigo]
					   ,[ControleVersao]
					   ,[NomeArquivo]
					   ,[DataArquivo]
					   ,[DataMovimentacao]
					   ,[Nome]
					   ,[CPF]
					   ,[DataNascimento]
					   ,[EstadoCivil]
					   ,[SexoCodigo]
					   ,[Sexo]
					   ,[Profissao]
					   ,[RendaIndividual]
					   ,[RendaFamiliar]
					   ,[Matricula]
					   ,[FuncionarioEmail]
					   ,[ParticipanteEmail]
					   ,[FuncaoCodigo]
					   ,[FuncaoDescricao]
					   ,[FuncaoDataInicio]
					   ,[FuncaoIndicadorFaixa]
					   ,[FuncionarioSituacaoCodigo]
					   ,[FuncionarioSituacao]
					   ,[IndicadorArea]
					   ,[UnidadeCodigo]
					   ,[UnidadeNome]
					   ,[LotacaoUF]
					   ,[LotacaoCidade]
					   ,[LotacaoSigla]
					   ,[LotacaoEmail]
					   ,[LotacaoDataInicio]
					   ,[LotacaoDDD]
					   ,[LotacaoTelefone]
					   ,[Endereco]
					   ,[Cidade]
					   ,[UF]
					   ,[CEP]
					   ,[Agencia]
					   ,[Operacao]
					   ,[Conta]
					   )
                SELECT 
                      [Codigo]
					   ,[ControleVersao]
					   ,[NomeArquivo]
					   ,[DataArquivo]
					   ,[DataMovimentacao]
					   ,[Nome]
					   ,[CPF]
					   ,[DataNascimento]
					   ,[EstadoCivil]
					   ,[SexoCodigo]
					   ,[Sexo]
					   ,[Profissao]
					   ,[RendaIndividual]
					   ,[RendaFamiliar]
					   ,[Matricula]
					   ,[FuncionarioEmail]
					   ,[ParticipanteEmail]
					   ,[FuncaoCodigo]
					   ,[FuncaoDescricao]
					   ,[FuncaoDataInicio]
					   ,[FuncaoIndicadorFaixa]
					   ,[FuncionarioSituacaoCodigo]
					   ,[FuncionarioSituacao]
					   ,[IndicadorArea]
					   ,[UnidadeCodigo]
					   ,[UnidadeNome]
					   ,[LotacaoUF]
					   ,[LotacaoCidade]
					   ,[LotacaoSigla]
					   ,[LotacaoEmail]
					   ,[LotacaoDataInicio]
					   ,[LotacaoDDD]
					   ,[LotacaoTelefone]
					   ,[Endereco]
					   ,[Cidade]
					   ,[UF]
					   ,[CEP]
					   ,[Agencia]
					   ,[Operacao]
					   ,[Conta] 
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaFuncionario_SRH] ''''' + @PontoDeParada + ''''''') PRP'

	EXEC (@COMANDO)     

                
	SELECT @MaiorCodigo= MAX(Codigo)
	FROM [dbo].[FuncionarioSRH_TEMP]

END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FuncionarioSRH_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].FuncionarioSRH_TEMP;				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH


--SELECT *
--FROM Dados.Funcionario f
--inner join dados.FuncionarioHistorico fh
--on f.id = fh.IDFuncionario
--where F.Matricula LIKE '%00033689%'        --f.Nome like 'GILMAR MARCULAN'--	F.Matricula LIKE '%3990' --





