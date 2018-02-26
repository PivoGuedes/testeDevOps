					  

/*
	Autor: Egler Vieira
	Data Criação: 14/11/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InserePremiacaoINSS_INDICADORES
	Descrição: Procedimento que realiza a inserção da premiação sintética dos indicadores
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
						   
CREATE PROCEDURE [Dados].[proc_InserePremiacaoINSS_INDICADORES] @PontoDeParada AS DATE as
BEGIN TRY		
	    

DECLARE @MaiorCodigo AS DATE
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(4000) 
   	    

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PremiacaoINSS_INDICADORES_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PremiacaoINSS_INDICADORES_TEMP];

CREATE TABLE [dbo].[PremiacaoINSS_INDICADORES_TEMP](
--	[Codigo] [int] NOT NULL,
--	[ControleVersao] [decimal](16, 8) NULL,
	[NomeArquivo] [varchar](60) NULL,
	[MatriculaIndicador] [varchar](8) NULL,
	[NumOcorrencia] [tinyint] NOT NULL,
	[CPF] [varchar](20) NULL,
	[PIS] [varchar](20) NULL,
	[CBO] [varchar](7) NULL,
	[ValorRubrica] [decimal](19, 2) NULL,
--	[DataProcessamento] [date] NOT NULL,
	--[DataReferencia] AS Cast(Cast(YEAR(DataArquivo) as varchar(4)) + '-' + Cast(MONTH(DataArquivo) as varchar(2)) + '-01' as date),
	[DataReferencia] [date] NOT NULL,
	[TipoDado] [varchar](60) DEFAULT('FuncefINSS')
) 
 


 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_PremiacaoINSS_INDICADORES_TEMP ON [dbo].[PremiacaoINSS_INDICADORES_TEMP]
( 
  [MatriculaIndicador] 
)	

---- CREATE NONCLUSTERED INDEX idx_PremiacaoINSS_Apolice_INDICADORES_TEMP ON [dbo].[PremiacaoINSS_INDICADORES_TEMP]
----( 
----  [NumeroApolice],
----  [NumeroEndosso],
----  [CodigoSubGrupo]
----)
---- INCLUDE ([Ocorrencia], [NumeroParcela], [NumeroTitulo], [TipoPagamento], [MatriculaIndicador], [CodigoProduto], CodigoPV, CodigoEN)

---- CREATE NONCLUSTERED INDEX idx_PremiacaoINSS_Titulo_INDICADORES_TEMP ON [dbo].[PremiacaoINSS_INDICADORES_TEMP]
----( 
----  [NumeroTitulo]
----)
---- INCLUDE ([Ocorrencia], [NumeroParcela], [NumeroApolice], [CodigoSubGrupo], [TipoPagamento], [MatriculaIndicador], [CodigoProduto], CodigoPV, CodigoEN)

  
  
   
    
		   --SELECT EM.MaiorData
     --           FROM OPENQUERY ([OBERON], 
     --           ' SELECT MAX(MesReferencia) [MaiorData]
     --               FROM FENAE.dbo.INSSIndicadores
     --               WHERE MesReferencia >= ''2010-01-01''') EM
    
  
--select @PontoDeParada = 20007037

----SELECT @PontoDeParada = PontoParada
----FROM ControleDados.PontoParada
----WHERE NomeEntidade = 'PremiacaoINSS_INDICADORES'


----/*********************************************************************************************************************/               
----/*Recupeara maior Código do retorno*/
----/*********************************************************************************************************************/
                
----SET @ParmDefinition = N'@MaiorCodigo DATE OUTPUT';     

----SET @COMANDO = 'SELECT @MaiorCodigo= EM.MaiorData
----                FROM OPENQUERY ([OBERON], 
----                '' SELECT MAX(MesReferencia) [MaiorData]
----                    FROM FENAE.dbo.INSSIndicadores
----                    WHERE MesReferencia >= ''''' + Cast(@PontoDeParada as varchar(10)) + ''''''') EM';

                
----exec sp_executesql @COMANDO
----                ,@ParmDefinition
----                ,@MaiorCodigo = @MaiorCodigo OUTPUT;
                  
----/*********************************************************************************************************************/

----WHILE @PontoDeParada <= @MaiorCodigo
----BEGIN 


	SET @COMANDO = 'INSERT INTO [dbo].[PremiacaoINSS_INDICADORES_TEMP] (

								[NomeArquivo],
								[MatriculaIndicador],
								[NumOcorrencia],
								[CPF],
								[PIS],
								[CBO],
								[ValorRubrica],
								[DataReferencia]
							)  
					SELECT  

							[NomeArquivo],
							[MatriculaIndicador],
							[NumOcorrencia],
							[CPF],
							[PIS],
							[CBO],
							[ValorRubrica],
							[DataReferencia]
					FROM OPENQUERY ([OBERON], 
					''EXEC [Fenae].[Corporativo].[proc_RecuperaPremiacaoINSS_INDICADORES] '''''  + Cast(@PontoDeParada as varchar(10)) + ''''''') PRM'

;exec sp_executesql @COMANDO

    --InserirFuncionario (INDICADOR)

--  ##### A INFORMAÇÃO CHEGA SEM O DIGITO DA MATRICULA ####
-- CONSIDERAREMOS QUE OS ARQUIVOS SRH/CADCEF FORAM CARREGADOS E ESTÃO COMPLETOS

	--/***********************************************************************
	-- O ARQUIVO FuncefINSS não vem com o digito da matrícula do indicador. Entretanto, é possível atualizar o PIS 
	-- e o código da ocupação caso o indicador já tenha sido inserido através dos arquivos CADCEF e/ou SRH
	--*/

	UPDATE Dados.Funcionario SET PIS = PRM.PIS
	--SELECT *
	FROM Dados.Funcionario FH
	INNER JOIN ( 
		SELECT DISTINCT F.ID [IDFuncionario], PRM.PIS                                        
		FROM dbo.[PremiacaoINSS_INDICADORES_TEMP] PRM
		INNER JOIN Dados.Funcionario F
		ON LEFT(F.Matricula,7) = PRM.[MatriculaIndicador]
		AND F.IDEmpresa = 1
		AND F.CPF = PRM.CPF) PRM
    ON PRM.IDFuncionario = FH.ID

	--/***********************************************************************
	--Carregar os FUNCIONARIOS de proposta não carregados do SRH
	--***********************************************************************/
	--;MERGE INTO Dados.Funcionario AS T
	--	USING (           
	--		SELECT DISTINCT PRM.[MatriculaIndicador] [Matricula], 1 [IDEmpresa], PRM.TipoDado, PRM.PIS, PRM.DataArquivo -- Caixa Econômica                
	--		FROM dbo.[PremiacaoINSS_INDICADORES_TEMP] PRM
	--		WHERE PRM.[MatriculaIndicador] IS NOT NULL
	--		) X
	--ON  LEFT(T.Matricula,7) = RIGHT(X.[Matricula],7)
	--	 AND T.IDEmpresa = 1
	--	 AND LEN(T.Matricula) = 8
	--WHEN  MATCHED
	--      THEN
	--		--THEN INSERT ([Matricula], IDEmpresa, PIS,  NomeArquivo, DataArquivo)
	--		--	VALUES (X.[Matricula], X.IDEmpresa, X.PIS, X.TipoDado, X.DataArquivo);  
	--	  UPDATE SET PIS = X.PIS;										


	



	--SELECT  *   
	--FROM dbo.[PremiacaoINSS_INDICADORES_TEMP] PRM
	--WHERE PRM.Dat
	
	--SELECT top 100 *
	--FROM Dados.Funcionario where id = 72256
	--ORDER BY Matricula
	
--	SELECT top 100 *
--	FROM Dados.Funcionario 
--	WHERE CPF = '461.877.159-34'
--0002155
	INSERT INTO	[ControleDados].[LogPremiacaoINSS_INDICADORES]
		([NomeArquivo], [MatriculaIndicador], [CPF], [PIS], [CBO],
	     [ValorRubrica], [DataArquivo], [DataReferencia], [TipoDado])
	SELECT DISTINCT 
	 	 [NomeArquivo], [MatriculaIndicador], [CPF], [PIS], [CBO],
	     [ValorRubrica], DataReferencia [DataArquivo], [DataReferencia], [TipoDado]
	FROM dbo.[PremiacaoINSS_INDICADORES_TEMP] PRM
	WHERE NOT EXISTS (SELECT *
					  FROM Dados.Funcionario F
					  WHERE LEFT(F.Matricula,7) = PRM.[MatriculaIndicador]
						AND F.IDEmpresa = 1
						AND F.CPF = PRM.CPF
					 )

	--Garante o cadastro do Codigo Brasileiro de Ocupação na table [Ocupacao]
	INSERT INTO Dados.Ocupacao (Codigo)
	SELECT DISTINCT CBO
	FROM dbo.[PremiacaoINSS_INDICADORES_TEMP] PRM
	WHERE NOT EXISTS (
					  Select * from dados.ocupacao o
					  Where o.codigo = cbo
					 )
		
	--------------------------------------------------------------------------------------------------------
	--Atualiza o Codigo CBO do Funcionário Historico
	--------------------------------------------------------------------------------------------------------
	UPDATE Dados.FuncionarioHistorico SET CodigoOcupacao = PRM.CBO
	--SELECT *
	FROM Dados.FuncionarioHistorico FH
	INNER JOIN ( 
		SELECT DISTINCT F.ID [IDFuncionario], CBO, PRM.DataReferencia DataArquivo, PRM.[NomeArquivo], PRM.DataReferencia	                                        
		FROM dbo.[PremiacaoINSS_INDICADORES_TEMP] PRM
		INNER JOIN Dados.Funcionario F
		ON LEFT(F.Matricula,7) = PRM.[MatriculaIndicador]
		AND F.IDEmpresa = 1
		AND F.CPF = PRM.CPF) PRM
    ON PRM.IDFuncionario = FH.IDFuncionario
	WHERE
	 (    
	    (
	    PRM.DataReferencia >= FH.DataArquivo
	    AND DATEADD(MM,1,Cast(PRM.DataReferencia as Date))	< FH.DataArquivo
		)
		OR
		FH.CodigoOcupacao IS NULL
	 )
	  				
	--------------------------------------------------------------------------------------------------------
	--Insere um registro no Histórico de Funcionário quando não existir nenhum registro.
	--------------------------------------------------------------------------------------------------------
	INSERT INTO Dados.FuncionarioHistorico (IDFuncionario, CodigoOcupacao, DataArquivo, NomeArquivo)
    SELECT DISTINCT F.ID [IDFuncionario], CBO, PRM.DataReferencia DataArquivo, PRM.[NomeArquivo]--, f.*	                                        
	FROM dbo.[PremiacaoINSS_INDICADORES_TEMP] PRM
	INNER JOIN Dados.Funcionario F
	ON LEFT(F.Matricula,7) = PRM.[MatriculaIndicador]
	AND F.IDEmpresa = 1
	AND F.CPF = PRM.CPF
	WHERE NOT EXISTS (
	                  SELECT *
					  FROM Dados.FuncionarioHistorico FH
					  WHERE FH.IDFuncionario = F.ID
					 )		

  --TODO - InserirContratoCliente (OU NÃO)
  						     
  	--------------------------------------------------------------------------------------------------------
	--Insere INSS recolhido do indicador (Funcionário) registro.
	--------------------------------------------------------------------------------------------------------
	MERGE INTO Dados.PremiacaoIndicadoresINSS AS T
	USING (           
			SELECT DISTINCT F.ID [IDFuncionario], PRM.ValorRubrica, PRM.NumOcorrencia, PRM.DataReferencia, PRM.DataReferencia DataArquivo, PRM.NomeArquivo -- Caixa Econômica                
			FROM dbo.[PremiacaoINSS_INDICADORES_TEMP] PRM
			INNER JOIN Dados.Funcionario F
				ON LEFT(F.Matricula,7) = PRM.[MatriculaIndicador]
			AND F.IDEmpresa = 1
			AND F.CPF = PRM.CPF
		  ) X
	ON  T.IDFuncionario = X.IDFuncionario
	AND	T.DataReferencia = X.DataReferencia
	AND T.NumOcorrencia = X.NumOcorrencia
	WHEN  NOT MATCHED 	      
		THEN INSERT ([IDFuncionario], ValorRubrica, NumOcorrencia, DataReferencia, NomeArquivo, DataArquivo)
			 VALUES (X.[IDFuncionario], X.ValorRubrica, X.NumOcorrencia, X.DataReferencia, X.NomeArquivo, X.DataArquivo)
	WHEN MATCHED THEN  
		  UPDATE SET ValorRubrica  = X.ValorRubrica;
	--------------------------------------------------------------------------------------------------------
  
  UPDATE Dados.RePremiacaoIndicadores SET ValorINSSRecolhidoCEF = X.[ValorRubrica]
  --SELECT *
  FROM Dados.RePremiacaoIndicadores  R
  CROSS APPLY (SELECT SUM(ValorRubrica) [ValorRubrica], PINSS.DataReferencia
               FROM Dados.PremiacaoIndicadoresINSS PINSS
			   WHERE PINSS.IDFuncionario = R.IDFuncionario
			   AND PINSS.DataReferencia = R.DataReferencia --Cast(YEAR(R.DataArquivo) as varchar(4)) + '-' + Cast(MONTH(R.DataArquivo)as varchar(2)) + '-' + '01'
			   GROUP BY PINSS.IDFuncionario, PINSS.DataReferencia) X
  WHERE EXISTS (SELECT 	*
                FROM   dbo.[PremiacaoINSS_INDICADORES_TEMP] PRM 
				INNER JOIN Dados.Funcionario F
				ON LEFT(F.Matricula,7) = PRM.[MatriculaIndicador]
					AND F.IDEmpresa = 1
					AND F.CPF = PRM.CPF
				WHERE F.ID = R.IDFuncionario 
				AND PRM.DataReferencia = X.DataReferencia
			   )											  

  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
    /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = DATEADD(DD, 1, @PontoDeParada)
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = Cast(@PontoDeParada as varchar(10))
  WHERE NomeEntidade = 'PremiacaoINSS_INDICADORES'
  /*************************************************************************************/
  
 /*********************************************************************************************************************/
  --LIMPA A TABELA TEMPORARIA 
  TRUNCATE TABLE [dbo].[PremiacaoINSS_INDICADORES_TEMP] 
  /*********************************************************************************************************************/
  
--END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PremiacaoINSS_INDICADORES_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[PremiacaoINSS_INDICADORES_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH

--EXEC [Dados].[proc_InserePremiacaoINSS_INDICADORES]
