
/*
	Autor: Diego Lima
	Data Criação: 14/02/2014

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereFuncionarioSituacao_PROPAY
	Descrição: Procedimento que realiza a inserção de funcionários no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InsereFuncionarioSituacao_PROPAY] as
BEGIN TRY

DECLARE @PontoDeParada AS DATE
DECLARE @MaiorCodigo AS DATE
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 
--select * from FuncionarioSituacaoPROPAY_TEMP where Nome like 'egler%'
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FuncionarioSituacaoPROPAY_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[FuncionarioSituacaoPROPAY_TEMP];

	CREATE TABLE [dbo].FuncionarioSituacaoPROPAY_TEMP(
							[CodigoEmpresaPropay] VARCHAR(10) NULL,
							[MatriculaTratada] VARCHAR(20) NULL,
							[Matricula] VARCHAR(20) NULL,
							[DataNascimentoTratada] DATE NULL,
							[DataNascimento]  VARCHAR(20)  NULL,
							[SexoCodigo] tinyint NULL,
							[Sexo] VARCHAR(20) NULL,
							[Nome] VARCHAR(150) NULL,
							[PIS] VARCHAR(30) NULL,
							[Situacao] VARCHAR(100) NULL,
							[DataSituacaoTratada] DATE NULL,
							[DataSituacao]  VARCHAR(20)  NULL,
							[DataAdmissaoTratada] DATE NULL,
							[DataAdmissao]  VARCHAR(20)  NULL,
							[BancoAgenciaCCorrente] varchar(100) NULL,
							[GrupoHierarquico] varchar(100) NULL,
							[CodigoCargo]  varchar(30) NULL,
							[DescricaoCargo]  varchar(130) NULL,
							[CodigoCentroCusto]  varchar(30) NULL,
							[DescricaoCentroCusto]  varchar(130) NULL,
							[SalarioTratado] decimal(13,2) NULL,
							[DataArquivo] DATE NULL,
							CodigoOcupacao varchar(7),
							[NomeArquivo] VARCHAR(100) NOT NULL,
							[ORDEM] VARCHAR(10) NULL

						) 

 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idxMatricula_FuncionarioSituacaoPROPAY_TEMP ON [dbo].FuncionarioSituacaoPROPAY_TEMP
( 
  [MatriculaTratada] ASC
) 

/* SELECIONA O ÚLTIMO PONTO DE PARADA */

--SELECT @PontoDeParada = PontoParada
--FROM ControleDados.PontoParada
--WHERE NomeEntidade = 'FuncionarioSituacao_PROPAY'


/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/

--SET @ParmDefinition = N'@MaiorCodigo DATE OUTPUT';     

--SET @COMANDO = 'SELECT @MaiorCodigo= EM.MaiorData
--                FROM  
--                '' SELECT MAX(convert(date,df.data_situacao,104)) [MaiorData]
--                    FROM propay.[DBGPCS].[dbo].[DADOS_FUNCIONARIO] DF
--                    WHERE  convert(date,df.data_situacao,104) is not null 
--							AND convert(date,df.data_situacao,104) >= ''''' + Cast(@PontoDeParada as varchar(10)) + ''''''') EM';

                
--exec sp_executesql @COMANDO
--                ,@ParmDefinition
--                ,@MaiorCodigo = @MaiorCodigo OUTPUT;

/*********************************************************************************************************************/

--WHILE @PontoDeParada <= @MaiorCodigo
BEGIN 

INSERT INTO [dbo].[FuncionarioSituacaoPROPAY_TEMP] ( 
                        [CodigoEmpresaPropay]
						  ,[MatriculaTratada]
						  ,[Matricula]
						  ,[DataNascimentoTratada]
						  ,[DataNascimento]
						  ,[SexoCodigo]
						  ,[Sexo]
						  ,[Nome]
						  ,[PIS]
						  ,[Situacao]
						  ,[DataSituacaoTratada]
						  ,[DataSituacao]
						  ,[DataAdmissaoTratada]
						  ,[DataAdmissao]
						  ,[BancoAgenciaCCorrente]
						  ,[GrupoHierarquico]
						  ,[CodigoCargo]
						  ,[DescricaoCargo]
						  ,[CodigoCentroCusto]
						  ,[DescricaoCentroCusto]
						  ,[SalarioTratado]						  
						  ,[DataArquivo]
						  ,CodigoOcupacao
						  ,[NomeArquivo]
						  ,[ORDEM]
						  )
						  
			EXEC [Corporativo].[Dados].[proc_RecuperaFuncionarioSituacao_PROPAY] --Cast(@PontoDeParada as varchar(10)) 


 /***********************************************************************
     Carregar os CENTRO CUSTOS dos Funcionarios
 ***********************************************************************/

 ; MERGE INTO [Dados].[CentroCusto] AS T

	USING (
			SELECT DISTINCT CodigoCentroCusto,[DescricaoCentroCusto]
			FROM [dbo].[FuncionarioSituacaoPROPAY_TEMP] 
			WHERE CodigoCentroCusto IS NOT NULL
		)X

	ON  T.Codigo = X.CodigoCentroCusto
     WHEN NOT MATCHED
	          THEN INSERT (Codigo, Descricao)
	               VALUES (X.CodigoCentroCusto, '');

	 ; MERGE INTO [Dados].[Ocupacao] AS T

	USING (
			SELECT DISTINCT CodigoOcupacao
			FROM [dbo].[FuncionarioSituacaoPROPAY_TEMP] 
			WHERE CodigoOcupacao IS NOT NULL
		)X

	ON  T.Codigo = X.CodigoOcupacao
     WHEN NOT MATCHED
	          THEN INSERT (Codigo, Descricao)
	               VALUES (X.CodigoOcupacao, '');

	; MERGE INTO [Dados].[CentroCusto] AS T

	USING (
			SELECT DISTINCT CodigoCentroCusto,[DescricaoCentroCusto]
			FROM [dbo].[FuncionarioSituacaoPROPAY_TEMP] 
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
	  
	--		SELECT DISTINCT CodigoCargo ,DescricaoCargo
	--		FROM [dbo].[FuncionarioSituacaoPROPAY_TEMP] 
	--		WHERE CodigoCargo IS NOT NULL
 --         ) X
 --   ON  T.Codigo = X.CodigoCargo
 --    WHEN NOT MATCHED
	--          THEN INSERT (Codigo, Descricao)
	--               VALUES (X.CodigoCargo,'');

; MERGE INTO [Dados].[CargoPROPAY] AS T
    USING (
	  
			SELECT DISTINCT temp.CodigoCargo ,temp.DescricaoCargo,temp.[CodigoEmpresaPropay], e.id AS IDEmpresa,
				c.codigo
			FROM [dbo].[FuncionarioSituacaoPROPAY_TEMP] temp
			
			inner join [Dados].[CargoPROPAY] c
			on c.Codigo = temp.CodigoCargo

			inner join dados.Empresa e
			on temp.CodigoEmpresaPropay = e.CodigoEmpresaPROPAY

			WHERE CodigoCargo IS NOT NULL --and [CodigoEmpresaPropay] = 1

          ) X
    ON  T.Codigo = X.CodigoCargo
	and isnull(T.IDEmpresa,-1) = isnull(X.IDEmpresa,-1)

	WHEN MATCHED 
	THEN UPDATE
		   SET Descricao = x.DescricaoCargo

     WHEN NOT MATCHED
	          THEN INSERT (Codigo, Descricao,IDEmpresa)
	               VALUES (X.CodigoCargo,x.DescricaoCargo,x.IDEmpresa);

/***********************************************************************
     Carregar as SITUACAO dos Funcionarios
***********************************************************************/

 ; MERGE INTO [Dados].[SituacaoFuncionario] AS T
    USING (
	  
			SELECT DISTINCT Situacao 
			FROM [dbo].[FuncionarioSituacaoPROPAY_TEMP] 
			WHERE Situacao IS NOT NULL
          ) X
    ON  T.Descricao = X.Situacao
     WHEN NOT MATCHED
	          THEN INSERT (Codigo, Descricao)
	               VALUES ('',X.Situacao);


/***********************************************************************

/*Apaga a marcação LastValue do historico funcionario recebidos para atualizar a última posição
-> logo depois da inserção de funcionarios*/

/*Diego Lima - Data: 27/03/2014 */

     ***********************************************************************/	  

UPDATE Dados.FuncionarioHistorico 
SET LastValue = 0
--select * 
FROM Dados.FuncionarioHistorico PS
    WHERE PS.IDFuncionario IN (
	                        SELECT f.ID
                            FROM [dbo].[FuncionarioSituacaoPROPAY_TEMP] TEMP
								LEFT JOIN [Dados].[Empresa] E
								ON E.CodigoEmpresaPROPAY = TEMP.CodigoEmpresaPROPAY

								LEFT JOIN Dados.Funcionario f
								ON TEMP.MatriculaTratada = f.Matricula
								AND f.idempresa = e.ID

								--order by 1

								--368720
							-- AND PRP_T.[DataArquivo] >= PS.[DataArquivo]
                           )
           AND PS.LastValue = 1											
   --AND T.DataArquivo >= FH.DataArquivo
   --DELETE FROM DADOS.FuncionarioHistorico WHERE NomeArquivo = 'PROPAY' 

 /***********************************************************************
      Carrega os dados na Funcionario historico
 ***********************************************************************/  
;MERGE INTO Dados.FuncionarioHistorico
 AS T
		USING (
				SELECT 
						a.IDFuncionario,
						A.IDCargoPROPAY,
						a.IDSituacao AS IDSituacaoFuncionario,
						a.Nome,
						a.DataAdmissaoTratada AS DataAdmissao,
						a.DataSituacaoTratada AS DataSituacaoTratada, --Deixa comentado até verificar se a data situacao pode ser a data atualização volta
						a.SalarioTratado AS Salario,
						a.DescricaoCargo AS Cargo,
						a.DescricaoCentroCusto AS Lotacao,
						a.IDCentroCusto,
						a.NomeArquivo,
						a.DataArquivo,
						[CodigoOcupacao],
						0 LastValue



						FROM (
				
								SELECT  f.id AS IDFuncionario,
										TEMP.[CodigoEmpresaPropay]
										,E.ID as IDEmpresa
										,[MatriculaTratada]
										,temp.[Matricula]
										,[DataNascimentoTratada]
										,temp.[DataNascimento]
										,[SexoCodigo] as IDSexo
										,[Sexo]
										,TEMP.[Nome]
										,temp.[PIS]
										,SF.ID AS IDSituacao
										,TEMP.[Situacao]
										,[DataSituacaoTratada]
										,[DataAdmissaoTratada]
										,temp.[DataAdmissao]
										,[BancoAgenciaCCorrente]
										,[GrupoHierarquico]
										,C.ID AS IDCargoPROPAY
										,TEMP.[CodigoCargo]
										,TEMP.[DescricaoCargo]
										,CC.ID AS IDCentroCusto
										,TEMP.[CodigoCentroCusto]
										,TEMP.[DescricaoCentroCusto]
										,[SalarioTratado]
										,temp.[DataArquivo]
										,temp.[NomeArquivo]
										,o.Codigo [CodigoOcupacao]
										,ROW_NUMBER() OVER(PARTITION BY ISNULL(F.ID, -1),
													 ISNULL(SF.ID,-1),
													 ISNULL(F.Nome, ''),
													 ISNULL(DescricaoCargo, '') ,
							
													 temp.[DataArquivo],
													 ISNULL([CodigoOcupacao],'') ,
													 ISNULL([Salario],0),
													 ISNULL(TEMP.[DataAdmissao], '1900-01-01'),
													 isnull(IDCentroCusto, -1),
													 TEMP.DataSituacaotratada
													 ORDER BY TEMP.DataArquivo
													) [ORDEM]

								FROM [dbo].[FuncionarioSituacaoPROPAY_TEMP] TEMP
								LEFT JOIN [Dados].[Empresa] E
								ON E.CodigoEmpresaPROPAY = TEMP.CodigoEmpresaPROPAY

								LEFT JOIN [Dados].[CargoPROPAY] C
								ON C.CODIGO = TEMP.CodigoCargo
								and c.IDempresa = e.ID


								LEFT JOIN Dados.Ocupacao O
								ON O.Codigo = TEMP.CodigoOcupacao

				--			   LEFT JOIN ##testeCArgoPropay C
								--ON C.CODIGO = TEMP.CodigoCargo
								--and c.IDempresa = e.ID

								LEFT JOIN [Dados].[CentroCusto] CC
								ON CC.Codigo = TEMP.CodigoCentroCusto

								LEFT JOIN [Dados].[SituacaoFuncionario] SF
								ON SF.Descricao = TEMP.Situacao
								
								LEFT JOIN Dados.Funcionario f
								ON TEMP.MatriculaTratada = f.Matricula
									AND f.idempresa = e.ID 
							) AS A

					where IDFuncionario is not null and DataArquivo is not null and ordem = 1 --and nome like 'egler%'
				) AS X

				ON      ISNULL(X.IDFuncionario, -1) = ISNULL(T.IDFuncionario,-1) 
						and ISNULL(X.IDSituacaoFuncionario,-1) = ISNULL(T.IDSituacaoFuncionario,-1)
						and ISNULL(X.Nome, '') = ISNULL(T.Nome,'')
						--and ISNULL(X.DataAtualizacaoCargo,'0001-01-01') = ISNULL(T.DataAtualizacaoCargo,'0001-01-01')
						and ISNULL(X.Cargo, '') = ISNULL(T.Cargo, '') 
						--and ISNULL(X.DataAtualizacaoVolta,'0001-01-01') = ISNULL(T.DataAtualizacaoVolta,'0001-01-01') 
						
						--and X.[DataArquivo] = T.[DataArquivo]
						and ISNULL(T.[CodigoOcupacao],'') = ISNULL(X.[CodigoOcupacao],'')
						and ISNULL(T.[Salario],0) = ISNULL(X.Salario,0)
						AND ISNULL(T.[DataAdmissao], '1900-01-01') = ISNULL(X.[DataAdmissao], '1900-01-01')
						AND ISNULL(T.[DataSituacao], '1900-01-01') = ISNULL(X.[DataSituacaotratada], '1900-01-01')
						and isnull(T.IDCentroCusto, -1) = isnull(X.IDCentroCusto, -1)
--WHEN MATCHED THEN  
		-- UPDATE
		--		SET 
				--[IDSituacaoFuncionario] =  COALESCE(X.[IDSituacaoFuncionario], T.[IDSituacaoFuncionario])
				--,[Nome] =  COALESCE(X.[Nome], T.[Nome])
				 --[CodigoOcupacao] = X.[CodigoOcupacao]
				-- [DataAdmissao] =  COALESCE(X.[DataAdmissao], T.[DataAdmissao])
				--,[DataAtualizacaoVolta] =  COALESCE(X.[DataAtualizacaoVolta], T.[DataAtualizacaoVolta])
				--,[Salario] =  COALESCE(X.[Salario], T.[Salario])
				--,[Cargo] = COALESCE(X.[Cargo], T.[Cargo])
				--,[NomeArquivo] = COALESCE(X.[NomeArquivo], T.[NomeArquivo])
				--,[DataArquivo] = X.DataArquivo
				--,[LastValue] = X.LastValue
			   -- ,[Lotacao] = COALESCE(X.Lotacao, T.Lotacao)
WHEN NOT MATCHED
		THEN INSERT ([IDFuncionario]
					 ,[IDSituacaoFuncionario]
					 ,[Nome]
					 ,[DataAdmissao]
					 ,[CodigoOcupacao]
					 ,[DataSituacao]
					-- ,[DataAtualizacaoVolta]
					 ,[Salario]
					 ,[Cargo]
					 ,[NomeArquivo]
					 ,[DataArquivo]
					 ,[LastValue]
					 ,[Lotacao],
					 IDCentroCusto)
     VALUES (X.[IDFuncionario],X.[IDSituacaoFuncionario],X.[Nome],X.[DataAdmissao], X.[CodigoOcupacao], X.[DataSituacaoTratada],
				/*X.[DataAtualizacaoVolta],*/X.[Salario],X.[Cargo],X.[NomeArquivo],X.DataArquivo,X.LastValue, X.Lotacao, X.IDCentroCusto

); 

--========================================================

	/*Atualiza a marcação LastValue das historico funcionarios recebidos para atualizar a última posição*/
	/*Diego Lima - Data: 27/03/2014 */

--==========================================================
			 
 UPDATE Dados.FuncionarioHistorico 
 
 SET LastValue = 1
 --select a.*
    FROM Dados.FuncionarioHistorico PE
	INNER JOIN (
				SELECT ID,   ROW_NUMBER() OVER (PARTITION BY  FH.IDFuncionario
											    ORDER BY  DataSituacao desc, DataArquivo desc) [ORDEM]
				FROM Dados.FuncionarioHistorico FH
				WHERE FH.IDFuncionario in (SELECT F.ID
										   FROM [dbo].[FuncionarioSituacaoPROPAY_TEMP] TEMP

												LEFT JOIN [Dados].[Empresa] E
													ON E.CodigoEmpresaPROPAY = TEMP.CodigoEmpresaPROPAY

												LEFT JOIN Dados.Funcionario f
													ON TEMP.MatriculaTratada = f.Matricula
														AND f.idempresa = e.ID
											) 
											--AND IDFUNCIONARIO = 5007
											--ORDER BY FH.DataArquivo DESC, FH.[DataAtualizacaoCargo] DESC, FH.[FuncaoDataInicio] DESC
				) A
	 ON A.ID = PE.ID 
	 AND A.ORDEM = 1	
	-- and pe.IDFuncionario = 367874

	-- select * from Dados.FuncionarioHistorico where id = 1744778
	UPDATE Dados.Funcionario SET IDUltimaSituacaoFuncionario = FH.IDSituacaoFuncionario, DataUltimaSituacaoFuncionario = FH.DataSituacao
	FROM Dados.Funcionario F
	INNER JOIN Dados.FuncionarioHistorico FH
	ON FH.IDFuncionario = F.ID
	WHERE FH.LastValue = 1 --AND F.NOMEARQUIVO = 'PROPAY'
	  AND FH.IDFuncionario in (SELECT F.ID
								FROM [dbo].[FuncionarioSituacaoPROPAY_TEMP] TEMP

									LEFT JOIN [Dados].[Empresa] E
										ON E.CodigoEmpresaPROPAY = TEMP.CodigoEmpresaPROPAY

									LEFT JOIN Dados.Funcionario f
										ON TEMP.MatriculaTratada = f.Matricula
											AND f.idempresa = e.ID
								) 
								
--WITH CTE
--AS
--(
--SELECT *, ROW_NUMBER() OVER(PARTITION BY FF.Nome, F.FUCPF ORDER BY FF.DATA_SITUACAO DESC) [ORDEM]
--FROM propay.[DBGPCS].[dbo].DADOS_FUNCIONARIO FF
--INNER JOIN propay.[DBGPCS].[dbo].FUNCIONA F
--ON FF.MATRICULA = F.FUMATFUNC
--AND FF.NOME = F.FUNOMFUNC
--INNER JOIN propay.[DBGPCS].[dbo].EMPRESAS E
--ON E.EMCODEMP = F.FUCODEMP
--WHERE CODIGO_CENTRO_CUSTO IN('131211114',
--'131211212',
--'1340402',
--'131111413',
--'131111311',
--'131111301',
--'131111112',
--'131111101',
--'13708',
--'131111312',
--'131211512',
--'131111411',
--'131111201',
--'16101',
--'131211513',
--'16102',
--'131111414',
--'131211411',
--'131211201',
--'131211514',
--'131211115',
--'131111421',
--'131111115',
--'131211311',
--'131211101',
--'1312101',
--'131211501',
--'14103',
--'131211112',
--'131111211',
--'131211214',
--'131111113',
--'131111415',
--'131211113',
--'131211401',
--'131111121',
--'131211301',
--'131111221',
--'131211121',
--'131111111',
--'131111212',
--'131211111',
--'131211511',
--'131211413',
--'14102',
--'19112',
--'131211313',
--'131211211',
--'1.6.1.01',
--'131211312',
--'131111401',
--'131111314',
--'131211412',
--'131211213',
--'14107',
--'131111412',
--'1311101',
--'131211221',
--'131111313',
--'131111114',
--'13401',
--'13601',
--'1340101')     
--)
----SELECT DISTINCT 99 [CORP], c.CODIGO_CARGO [CODIGOCARGO], c.DESC_CARGO [DESCRICAO],cp.Descricao, cp.Codigo
--update cp
--set cp.Descricao = c.DESC_CARGO 
--FROM CTE C
--inner join [Dados].[CargoPROPAY] cp
--on c.CODIGO_CARGO = cp.Codigo COLLATE Latin1_General_CI_AS
--WHERE ORDEM = 1


   /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/

  --SET @PontoDeParada = DATEADD(DD, 1, @PontoDeParada)
  
  --UPDATE ControleDados.PontoParada 
  --SET PontoParada = Cast(@PontoDeParada as varchar(10))
  --WHERE NomeEntidade = 'FuncionarioSituacao_PROPAY'

 /*********************************************************************************************************************/
  --LIMPA A TABELA TEMPORARIA 

  TRUNCATE TABLE [dbo].[FuncionarioSituacaoPROPAY_TEMP] 

/*********************************************************************************************************************/
  --depois comentar isso aqui
  
  INSERT INTO [dbo].[FuncionarioSituacaoPROPAY_TEMP] ( 
                        [CodigoEmpresaPropay]
						  ,[MatriculaTratada]
						  ,[Matricula]
						  ,[DataNascimentoTratada]
						  ,[DataNascimento]
						  ,[SexoCodigo]
						  ,[Sexo]
						  ,[Nome]
						  ,[PIS]
						  ,[Situacao]
						  ,[DataSituacaoTratada]
						  ,[DataSituacao]
						  ,[DataAdmissaoTratada]
						  ,[DataAdmissao]
						  ,[BancoAgenciaCCorrente]
						  ,[GrupoHierarquico]
						  ,[CodigoCargo]
						  ,[DescricaoCargo]
						  ,[CodigoCentroCusto]
						  ,[DescricaoCentroCusto]
						  ,[SalarioTratado]
						  ,[DataArquivo]
						  ,CodigoOcupacao
						  ,[NomeArquivo]
						  ,[ORDEM]
						  )
						  
			EXEC [Corporativo].[Dados].[proc_RecuperaFuncionarioSituacao_PROPAY] --@PontoDeParada 


END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FuncionarioSituacaoPROPAY_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[FuncionarioSituacaoPROPAY_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH

