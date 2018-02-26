CREATE PROCEDURE [Dados].[proc_InsereFuncionario_PROPAY] as
BEGIN TRY	

--DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
--DECLARE @COMANDO AS NVARCHAR(max)

 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FuncionarioPROPAY_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].FuncionarioPROPAY_TEMP;

CREATE TABLE [dbo].FuncionarioPROPAY_TEMP(
	[CodigoEmpresaPropay] VARCHAR(10) NULL,
	[NomeEmpresaPropay] VARCHAR(150) NULL,
	[NomeFantasiaEmpresaPropay] VARCHAR(150) NULL,
	[NomeFuncionario] VARCHAR(150) NULL,
	[CPFTratado] CHAR(14) NULL,
	[CPF] varCHAR(14) NULL,
	[Email] VARCHAR(60) NULL,
	[MatriculaTratada] VARCHAR(20) NULL,
	[Matricula] VARCHAR(20) NULL,
	[PIS] VARCHAR(30) NULL,
	[Telefone] varchar(20) NULL,
	[CodigoCentroCusto]  varchar(30) NULL,
	[CodigoCargo]  varchar(30) NULL,
	[DataAdmissaoTratada] DATE NULL,
	[DataAdmissao]  VARCHAR(20)  NULL,
	[SexoCodigo] tinyint NULL,
	[Sexo] VARCHAR(20) NULL,
	[DataNascimentoTratada] DATE NULL,
	[DataNascimento]  VARCHAR(20)  NULL,
	[EstadoCivilCodigo] VARCHAR(10) NULL,
	[EstadoCivil] VARCHAR(40) NULL,
	[Endereco] VARCHAR(100) NULL,
	[ComplementoEndereco] VARCHAR(80) NULL,
	[Bairro] VARCHAR(80) NULL,
	[DDD] VARCHAR(5) NULL,
	[CEP] VARCHAR(9) NULL,
	[Celular] VARCHAR(20)NULL,
	[Municipio] VARCHAR(80) NULL,
	[UF] CHAR(2) NULL,
	Hierarquia VARCHAR(50) NULL,
	[DataArquivo] DATE NULL,
	[NomeArquivo] VARCHAR(100) NOT NULL

) 

 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idxMatricula_FuncionarioPROPAY_TEMP ON [dbo].FuncionarioPROPAY_TEMP
( 
  [MatriculaTratada] ASC
)       

							
--SELECT @PontoDeParada = PontoParada
--FROM ControleDados.PontoParada
--WHERE NomeEntidade = 'Funcionario_PROPAY'


/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/

INSERT INTO [dbo].[FuncionarioPROPAY_TEMP] ( 
                        [CodigoEmpresaPropay]
						  ,[NomeEmpresaPropay]
						  ,[NomeFantasiaEmpresaPropay]
						  ,[NomeFuncionario]
						  ,[CPFTratado]
						  ,[CPF]
						  ,[Email]
						  ,[MatriculaTratada]
						  ,[Matricula]
						  ,[PIS]
						  ,[Telefone]
						  ,[CodigoCentroCusto]
						  ,[CodigoCargo]
						  ,[DataAdmissaoTratada]
						  ,[DataAdmissao]
						  ,[SexoCodigo]
						  ,[Sexo]
						  ,[DataNascimentoTratada]
						  ,[DataNascimento]
						  ,[EstadoCivilCodigo]
						  ,[EstadoCivil] 
						  ,[Endereco] 
						  ,[ComplementoEndereco] 
						  ,[Bairro] 
						  ,[DDD] 
						  ,[CEP] 
						  ,[Celular] 
						  ,[Municipio] 
						  ,[UF] 
						  ,Hierarquia
						  ,[DataArquivo]
						  ,[NomeArquivo])
						  
			EXEC [Corporativo].[Dados].[proc_RecuperaFuncionario_PROPAY] 
          
--SELECT @MaiorCodigo= MAX(Codigo)
--FROM [dbo].[FuncionarioSRH_TEMP]

/*********************************************************************************************************************/

--WHILE @MaiorCodigo IS NOT NULL
BEGIN 

 /***********************************************************************
     Carregar os ESTADO CIVIL dos Funcionarios PROPAY
 ***********************************************************************/

 --; MERGE INTO [Dados].[EstadoCivil] AS T

	--USING (
	--		SELECT DISTINCT [EstadoCivilCodigo]
	--					   ,[EstadoCivil]  
	--					  -- ,(select max(id)+1 from [Dados].[EstadoCivil])
	--		FROM [dbo].[FuncionarioPROPAY_TEMP] 
	--		WHERE [EstadoCivilCodigo] IS NOT NULL
	--	)X

	--ON  isnull(T.[CodigoEstadoCivilPROPAY],'-1') = isnull(X.[EstadoCivilCodigo],'-1')
 --    WHEN NOT MATCHED
	--          THEN INSERT ([CodigoEstadoCivilPROPAY], Descricao)
	--               VALUES (X.[EstadoCivilCodigo], X.[EstadoCivil]);

 /***********************************************************************
     Atualiza Municipio e UF de acordo com CEP
 ***********************************************************************/
 UPDATE [dbo].[FuncionarioPROPAY_TEMP]
 SET Municipio = a.localidade,
	 UF = a.siglauf
 
 --SELECT 
 --     ,temp.[Bairro]
 --     ,[DDD]
 --     ,temp.[CEP]
 --     ,[Celular]
 --     ,[Municipio]
	--  ,a.localidade
 --     ,[UF]
	--  ,a.siglauf
 --     ,[DataArquivo]
 --     ,[NomeArquivo]
  FROM OPENQUERY ([OBERON], 
                'SELECT *
					FROM [Enderecador].[dbo].[vwBuscaCEP]
					') A 
	RIGHT JOIN [dbo].[FuncionarioPROPAY_TEMP] temp
	ON temp.cep = a.cep  COLLATE Latin1_General_CI_AS
 
 /***********************************************************************
     Carregar os CENTRO CUSTOS dos Funcionarios
 ***********************************************************************/

 ; MERGE INTO [Dados].[CentroCusto] AS T

	USING (
			SELECT DISTINCT CodigoCentroCusto 
			FROM [dbo].[FuncionarioPROPAY_TEMP] 
			WHERE CodigoCentroCusto IS NOT NULL
		)X

	ON  T.Codigo = X.CodigoCentroCusto
     WHEN NOT MATCHED
	          THEN INSERT (Codigo, Descricao)
	               VALUES (X.CodigoCentroCusto, '');

/***********************************************************************
     Carregar as CARGO dos Funcionarios
***********************************************************************/

 --; MERGE INTO [Dados].[CargoPROPAY] AS T
 --   USING (
	  
	--		SELECT DISTINCT CodigoCargo 
	--		FROM [dbo].[FuncionarioPROPAY_TEMP] 
	--		WHERE CodigoCargo IS NOT NULL
 --         ) X
 --   ON  T.Codigo = X.CodigoCargo
 --    WHEN NOT MATCHED
	--          THEN INSERT (Codigo, Descricao)
	--               VALUES (X.CodigoCargo,'');

; MERGE INTO [Dados].[CargoPROPAY] AS T
    USING (
	  
			SELECT DISTINCT temp.CodigoCargo ,temp.[CodigoEmpresaPropay], e.ID AS IDEmpresa
			--,c.codigo
			FROM [dbo].[FuncionarioPROPAY_TEMP] temp
			
			--inner join [Dados].[CargoPROPAY] c
			--on c.Codigo = temp.CodigoCargo

			inner join dados.Empresa e
			on temp.CodigoEmpresaPropay = e.CodigoEmpresaPROPAY

			WHERE CodigoCargo IS NOT NULL --and [CodigoEmpresaPropay] = 1
		

          ) X
    ON  T.Codigo = X.CodigoCargo
	and isnull(T.IDEmpresa,-1) = isnull(X.IDEmpresa,-1)
     WHEN NOT MATCHED
	          THEN INSERT (Codigo, Descricao, IDEmpresa)
	               VALUES (X.CodigoCargo,'', X.IDEmpresa);

/***********************************************************************
     Carregar as EMPRESAS 
***********************************************************************/

 ; MERGE INTO [Dados].[Empresa] AS T
    USING (
			SELECT DISTINCT CodigoEmpresaPropay ,
							(CASE
									WHEN CodigoEmpresaPropay = 1 THEN 'PAR Corretora'
									WHEN CodigoEmpresaPropay = 2 THEN 'PAR Saúde'
									WHEN CodigoEmpresaPropay = 3 THEN 'PAR Riscos Especiais'
									WHEN CodigoEmpresaPropay = 4 THEN 'PAR Saúde Corporate'
									WHEN CodigoEmpresaPropay = 5 THEN 'PAR SAUDE ADMINISTRADORA DE BENEFICIOS'
									WHEN CodigoEmpresaPropay = 6 THEN 'HABSEG ADMINISTRACAO E CORRETAGEM DE SEGUROS'
									WHEN CodigoEmpresaPropay = 100 THEN 'Administrador Portal'
									WHEN CodigoEmpresaPropay = 501 THEN 'PAR Corretora Autonomos'
									WHEN CodigoEmpresaPropay = 504 THEN 'PAR Saúde Corporate Autonomos'
									ELSE [NomeEmpresaPropay]
							 END) AS Nome , 
							 NomeEmpresaPropay, 
							 NomeFantasiaEmpresaPropay
							  
			FROM [dbo].[FuncionarioPROPAY_TEMP] 
			WHERE CodigoEmpresaPropay IS NOT NULL
		)X
	ON  isnull(T.CodigoEmpresaPropay,'') = isnull(X.CodigoEmpresaPropay,'')
     WHEN NOT MATCHED
	          THEN INSERT ([Nome],Descricao, CodigoEmpresaPROPAY)
	               VALUES (X.Nome,'',CodigoEmpresaPROPAY);

/***********************************************************************
    Carregar os Funcionarios recebidos no arquivo PROPAY
***********************************************************************/

 ;MERGE INTO Dados.Funcionario AS T
		USING (
				SELECT TEMP.[CodigoEmpresaPropay]
						,E.ID AS IDEmpresa
						,[NomeEmpresaPropay]
						,[NomeFantasiaEmpresaPropay]
						,[NomeFuncionario]
						,[CPFTratado]
						--,[CPF]
						,[Email]
						,[MatriculaTratada]
						--,[Matricula]
						,[PIS]
						,[Telefone]
						,CC.ID AS IDCentroCusto
						,[CodigoCentroCusto]
						,C.ID AS IDCargoPROPAY
						,[CodigoCargo]
						,[DataAdmissaoTratada]
						,[DataAdmissao]
						,[SexoCodigo] AS IDSexo
						,[Sexo]
						,[DataNascimentoTratada]
						,[DataNascimento]
						,EC.ID as IDEstadoCivil
						,[Endereco]
						,[ComplementoEndereco]
						,[Bairro]
						,[DDD]
						,temp.[CEP]
						,[Celular]
						,[Municipio]
	  					,[UF]
						,Hierarquia
	  					,[DataArquivo]
						,[NomeArquivo] 
				FROM [dbo].[FuncionarioPROPAY_TEMP] TEMP
				LEFT JOIN [Dados].[Empresa] E
				ON E.CodigoEmpresaPROPAY = TEMP.CodigoEmpresaPROPAY

				LEFT JOIN [Dados].[CargoPROPAY] C
				ON C.CODIGO = TEMP.CodigoCargo
				and c.IDempresa = e.ID

				--LEFT JOIN ##testeCArgoPropay C
				--ON C.CODIGO = TEMP.CodigoCargo
				--and c.IDempresa = e.ID

				LEFT JOIN [Dados].[CentroCusto] CC
				ON CC.Codigo = TEMP.CodigoCentroCusto

				LEFT JOIN [Dados].[EstadoCivil] EC
				ON EC.[CodigoEstadoCivilPROPAY] = TEMP.EstadoCivilCodigo
				 
		  ) X
ON  X.MatriculaTratada = T.Matricula
and X.IDEmpresa = T.IDEmpresa

WHEN MATCHED  AND X.DataArquivo >= ISNULL(T.DataArquivo, '0001-01-01')
	THEN UPDATE
		   SET T.Nome = COALESCE(X.NomeFuncionario, T.Nome)
			  ,t.[CPF] = COALESCE(X.CPFTratado, T.CPF)
			  ,t.[Email] = COALESCE(X.Email, T.Email)
			  ,t.[PIS] = COALESCE(X.PIS, T.PIS)
			  ,t.[Telefone] = COALESCE(X.Telefone, T.Telefone)
			  ,t.IDCentroCusto = COALESCE(X.IDCentroCusto, T.IDCentroCusto) 
			  ,t.[DataAdmissao] = COALESCE(X.[DataAdmissaoTratada], T.[DataAdmissao])
			  ,t.DataSistema = (getdate())
			  ,t.[IDSexo]  = COALESCE(X.IDSexo, T.IDSexo)
			  ,t.[DataNascimento] = COALESCE(X.DataNascimentoTratada, T.DataNascimento)
			  ,t.[NomeArquivo]  = COALESCE(X.NomeArquivo, T.NomeArquivo)
			  ,t.[DataArquivo]  = COALESCE(X.DataArquivo, T.DataArquivo)
			  ,t.IDCargoPROPAY = COALESCE(X.IDCargoPROPAY, T.IDCargoPROPAY)
			  ,T.IDEstadoCivil = COALESCE(X.IDEstadoCivil, T.IDEstadoCivil) 
			  ,T.[Endereco]= COALESCE(X.[Endereco], T.[Endereco]) 
			  ,t.[ComplementoEndereco] = COALESCE(X.[ComplementoEndereco], T.[ComplementoEndereco]) 
			  ,T.[Bairro] = COALESCE(X.[Bairro], T.[Bairro]) 
			  ,t.[DDD] = COALESCE(X.[DDD], T.[DDD]) 
			  ,t.[CEP] = COALESCE(X.[CEP], T.[CEP]) 
			  ,t.[Celular] = COALESCE(X.[Celular], T.[Celular]) 
			  ,t.[Municipio]= COALESCE(X.[Municipio], T.[Municipio]) 
	  		  ,t.[UF] = COALESCE(X.[UF], T.[UF]) 
			  ,t.Hierarquia =  COALESCE(X.[Hierarquia], T.[Hierarquia]) 
	  WHEN NOT MATCHED
			THEN INSERT ([Nome],[CPF],[Email],[Matricula],[PIS],[IDEmpresa],[DDD],[Telefone],IDCentroCusto
						,[DataAdmissao],DataSistema,[IDSexo],[DataNascimento],[NomeArquivo],[DataArquivo]
						,IDCargoPROPAY, IDEstadoCivil,[Celular],[Endereco],[ComplementoEndereco],[CEP],
						[Municipio],[Bairro],[UF], [Hierarquia]
						)

				  VALUES (X.NomeFuncionario,X.CPFTratado,X.Email,X.MatriculaTratada,X.PIS,X.IDEmpresa
				  ,x.[DDD],X.Telefone, X.IDCentroCusto,X.[DataAdmissaoTratada],(getdate()),X.IDSexo,
				  X.DataNascimento,X.NomeArquivo, X.DataArquivo,x.IDCargoPROPAY, X.IDEstadoCivil, 
				  x.[Celular], X.[Endereco], x.[ComplementoEndereco],x.[CEP],x.[Municipio], x.[Bairro],
				  x.[UF], X.[Hierarquia]);
	
     /***********************************************************************

/*Apaga a marcação LastValue do historico funcionario recebidos para atualizar a última posição
-> logo depois da inserção de funcionarios*/

/*Diego Lima - Data: 10/10/2013 */

     ***********************************************************************/	  

--UPDATE Dados.FuncionarioHistorico SET LastValue = 0
----select * 
--FROM Dados.FuncionarioHistorico FH 
--	INNER JOIN Dados.Funcionario F
--	ON FH.IDFuncionario = F.ID	
--    INNER JOIN [dbo].[FuncionarioPROPAY_TEMP] Temp
--	ON    F.Matricula = Temp.MatriculaTratada
--	LEFT JOIN [Dados].[Empresa] E
--	ON E.CodigoEmpresaPROPAY = TEMP.CodigoEmpresaPROPAY
--WHERE FH.LastValue = 1												
   --AND T.DataArquivo >= FH.DataArquivo

     /***********************************************************************
       Carrega os dados na Funcionario historico
     ***********************************************************************/  
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
--					  ,A.[NomeArquivo]
--					  ,A.[DataArquivo]
--					  /*,(CASE WHEN  ROW_NUMBER() OVER (PARTITION BY A.IDFuncionario
--													  ORDER BY A.DataArquivo DESC, A.[DataAtualizacaoCargo] DESC, A.[FuncaoDataInicio] DESC ) = 1 /*OR PE.Endereco IS NOT NULL*/ THEN 1
--																	ELSE 0 END) LastValue
--					  */
--					  ,0 LastValue
--					  ,ROW_NUMBER() OVER (PARTITION BY
--					                         A.IDFuncionario, A.[IDFuncao], A.IDUnidade 
--											,A.[IDSituacaoFuncionario],A.[Nome],A.[DataAtualizacaoCargo],A.[Cargo], A.[LotacaoCidade], A.ParticipanteEmail
--											,A.[LotacaoDataInicio],A.[LotacaoSigla], A.[LotacaoEmail], A.LotacaoTelefone,A.[FuncaoDataInicio]
--										ORDER BY A.DataArquivo DESC) NUMERADOR
--				from 
--						(SELECT TEMP.[CodigoEmpresaPropay]
--								,E.ID AS IDEmpresa
--								,[NomeEmpresaPropay]
--								,[NomeFantasiaEmpresaPropay]
--								,[NomeFuncionario] AS Nome
--								,[CPFTratado]
--								--,[CPF]
--								,[Email]
--								,[MatriculaTratada]
--								--,[Matricula]
--								,[PIS]
--								,[Telefone]
--								,CC.ID AS IDCentroCusto
--								,[CodigoCentroCusto]
--								,C.ID AS IDCargoPROPAY
--								,[CodigoCargo]
--								,[DataAdmissaoTratada]
--								,[DataAdmissao]
--								,[SexoCodigo] AS IDSexo
--								,[Sexo]
--								,[DataNascimentoTratada]
--								,[DataNascimento]
--								,[DataArquivo]
--								,[NomeArquivo] 
--						FROM [dbo].[FuncionarioPROPAY_TEMP] TEMP
--						LEFT JOIN [Dados].[Empresa] E
--						ON E.CodigoEmpresaPROPAY = TEMP.CodigoEmpresaPROPAY

--						LEFT JOIN [Dados].[CargoPROPAY] C
--						ON C.CODIGO = TEMP.CodigoCargo

--						LEFT JOIN [Dados].[CentroCusto] CC
--						ON CC.Codigo = TEMP.CodigoCentroCusto
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
--	WHEN MATCHED AND X.[DataArquivo] >= T.[DataArquivo] THEN  
--		 UPDATE
--				SET 
--				 [IDFuncao] =  COALESCE(X.IDFuncao, T.IDFuncao)
--				,[IDUnidade] =  COALESCE(X.IDUnidade, T.IDUnidade)
--				,[IDSituacaoFuncionario] =  COALESCE(X.[IDSituacaoFuncionario], T.[IDSituacaoFuncionario])
--				,[Nome] =  COALESCE(X.[Nome], T.[Nome])
--				,[DataAdmissao] =  COALESCE(X.[DataAdmissao], T.[DataAdmissao])
--				,[DataAtualizacaoCargo] =  COALESCE(X.[DataAtualizacaoCargo], T.[DataAtualizacaoCargo])
--				,[DataAtualizacaoVolta] =  COALESCE(X.[DataAtualizacaoVolta], T.[DataAtualizacaoVolta])
--				,[Salario] =  COALESCE(X.[Salario], T.[Salario])
--				,[Cargo] = COALESCE(X.[Cargo], T.[Cargo])
--				,[LotacaoUF] = COALESCE(X.[LotacaoUF], T.[LotacaoUF])
--				,[LotacaoCidade] = COALESCE(X.[LotacaoCidade], T.[LotacaoCidade])
--				,[LotacaoDataInicio] = COALESCE(X.[LotacaoDataInicio], T.[LotacaoDataInicio])
--				,[LotacaoSigla] = COALESCE(X.[LotacaoSigla], T.[LotacaoSigla])
--				,[LotacaoEmail] = COALESCE(X.[LotacaoEmail], T.[LotacaoEmail])
--				,[ParticipanteEmail] = COALESCE(X.ParticipanteEmail, T.ParticipanteEmail)
--				,[ParticipanteLotacaoDDD] = COALESCE(X.[ParticipanteLotacaoDDD], T.[ParticipanteLotacaoDDD])
--				,[ParticipanteLotacaoTelefone] = COALESCE(X.[ParticipanteLotacaoTelefone], T.[ParticipanteLotacaoTelefone])
--				,[FuncaoDataInicio] = COALESCE(X.[FuncaoDataInicio], T.[FuncaoDataInicio])
--				,[NomeArquivo] = COALESCE(X.[NomeArquivo], T.[NomeArquivo])
--				,[DataArquivo] = X.DataArquivo
--				,[LastValue] = X.LastValue
--		WHEN NOT MATCHED
--		THEN INSERT ([IDFuncionario]
--           ,[IDFuncao]
--           ,[IDUnidade]
--           ,[IDSituacaoFuncionario]
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
--     VALUES (X.[IDFuncionario],X.IDFuncao,X.IDUnidade,X.[IDSituacaoFuncionario],X.[Nome],X.[DataAdmissao],
--			X.[DataAtualizacaoCargo],X.[DataAtualizacaoVolta],X.[Salario],X.[Cargo],X.[LotacaoUF],X.[LotacaoCidade],
--			X.[LotacaoDataInicio],X.[LotacaoSigla],X.[LotacaoEmail], X.ParticipanteEmail, X.[ParticipanteLotacaoDDD],
--			X.[ParticipanteLotacaoTelefone],X.[FuncaoDataInicio],X.[NomeArquivo],X.DataArquivo,X.LastValue

--); 

	/*Atualiza a marcação LastValue das propostas recebidas para atualizar a última posição*/
	/*Egler - Data: 18/10/2013 */		 
 --   UPDATE Dados.FuncionarioHistorico SET LastValue = 1
 --   FROM Dados.FuncionarioHistorico PE
	--INNER JOIN (
	--			SELECT ID,   ROW_NUMBER() OVER (PARTITION BY  FH.IDFuncionario
	--										    ORDER BY FH.DataArquivo DESC, FH.[DataAtualizacaoCargo] DESC, FH.[FuncaoDataInicio] DESC ) [ORDEM]
	--			FROM  Dados.FuncionarioHistorico FH
	--			WHERE FH.IDFuncionario in (SELECT F.ID
	--									   FROM [dbo].FuncionarioSRH_TEMP A
	--										inner join Dados.Funcionario F
	--											on F.Matricula = A.Matricula
	--											AND F.IDEmpresa = 1
	--										) 
	--										--AND IDFUNCIONARIO = 5007
	--										--ORDER BY FH.DataArquivo DESC, FH.[DataAtualizacaoCargo] DESC, FH.[FuncaoDataInicio] DESC
	--			) A
	-- ON A.ID = PE.ID 
	-- AND A.ORDEM = 1		
			  
--1 RETIRAR DO MERGE DA TABELA FUNCIONARIO TODOS OS CAMPOS QUE SÃO CARREGADOS NA TABELA FUNCIONARIO HISTORICO
--2 CRIAR AQUI UM UPDATE ATUALIZANDO A TABELA DADOS.FUNCIONARIO ESSES CAMPOS COM OS DADOS DA TABELA DADOS.FUNCIONARIOHISTORICO, MARCADOS COMO LASTVALUE = 1

--UPDATE [Dados].Funcionario
--SET 
----SELECT 
--        IDUltimaFuncao = fh.IDFuncao, 
--		IDUltimaUnidade = fh.IDUnidade, 
--		IDUltimaSituacaoFuncionario = fh.IDSituacaoFuncionario, 
--		Nome = fh.Nome, 
--		DataAdmissao = fh.DataAdmissao, 
--		DataAtualizacaoVolta = fh.DataAtualizacaoVolta,
--		Salario = fh.Salario, 
--		UltimoCargo = fh.Cargo, 
--		UltimoLotacaoEmail = fh.LotacaoEmail,
--		DDD = fh.ParticipanteLotacaoDDD, 
--		Telefone = fh.ParticipanteLotacaoTelefone,
--		UltimoParticipanteEmail = fh.ParticipanteEmail
		
--FROM [Dados].[FuncionarioHistorico] FH
--	inner join [Dados].Funcionario f
--on (fh.IDFuncionario = f.ID)		
--AND F.IDEmpresa = 1
--where fh.LASTVALUE = 1 
--AND EXISTS( SELECT *
--            FROM [dbo].[FuncionarioPROPAY_TEMP] temp
--	        WHERE F.Matricula = temp.MatriculaTratada)


 /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  --SET @PontoDeParada = @MaiorCodigo
  
  --UPDATE ControleDados.PontoParada 
  --SET PontoParada = @MaiorCodigo
  --WHERE NomeEntidade = 'Funcionario_PROPAY'

   /*************************************************************************************/
  
 /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[FuncionarioPROPAY_TEMP] 
    
  /*********************************************************************************************************************/               
  /*Recupeara maior Código do retorno*/
  /*********************************************************************************************************************/
  
INSERT INTO [dbo].[FuncionarioPROPAY_TEMP] ( 
                         
                        [CodigoEmpresaPropay]
						  ,[NomeEmpresaPropay]
						  ,[NomeFantasiaEmpresaPropay]
						  ,[NomeFuncionario]
						  ,[CPFTratado]
						  ,[CPF]
						  ,[Email]
						  ,[MatriculaTratada]
						  ,[Matricula]
						  ,[PIS]
						  ,[Telefone]
						  ,[CodigoCentroCusto]
						  ,[CodigoCargo]
						  ,[DataAdmissaoTratada]
						  ,[DataAdmissao]
						  ,[SexoCodigo]
						  ,[Sexo]
						  ,[DataNascimentoTratada]
						  ,[DataNascimento]
						  ,[EstadoCivilCodigo]
						  ,[EstadoCivil] 
						  ,[Endereco] 
						  ,[ComplementoEndereco] 
						  ,[Bairro] 
						  ,[DDD] 
						  ,[CEP] 
						  ,[Celular] 
						  ,[Municipio] 
						  ,[UF] 
						  ,Hierarquia
						  ,[DataArquivo]
						  ,[NomeArquivo])
						  
			EXEC [Corporativo].[Dados].[proc_RecuperaFuncionario_PROPAY] 
          

                
	--SELECT @MaiorCodigo= MAX(Codigo)
	--FROM [dbo].[FuncionarioSRH_TEMP]

END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FuncionarioPROPAY_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[FuncionarioPROPAY_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH

