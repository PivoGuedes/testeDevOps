CREATE PROCEDURE [Dados].[proc_InsereUnidade] 
AS
    
BEGIN TRY		
 
	    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 

 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UNIDADES_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[UNIDADES_TEMP];


CREATE TABLE [dbo].[UNIDADES_TEMP](
	[Codigo] [bigint] NOT NULL,
	[Arquivo] [varchar](8) NOT NULL,
	[TipoDado] [varchar](7) NOT NULL,
	[ControleVersao] [numeric](16, 8) NULL,
	[NomeCompletoArquivo] [nvarchar](100) NOT NULL,
	[DataArquivo] [date] NOT NULL,
	[TipoUnidade] [varchar](8000) NULL,
	[CodigoUnidade] [smallint] NULL,
	[NomeUnidade] [varchar](8000) NULL,
	[CodigoUnidadeEscritorioNegociosCEF] [smallint] NULL,
	[Endereco] [varchar](8000) NULL,
	[Bairro] [varchar](8000) NULL,
	[DDD] [varchar](8000) NULL,
	[CEP] [varchar](8000) NULL,
	[DataCriacao] [date] NULL,
	[DataAutomacao] [date] NULL,
	[DataExtincao] [date] NULL,
	[DataFimOperacao] [date] NULL,
	[Praca] [numeric](2, 0) NULL,
	[TipoPV] [varchar](8000) NULL,
	[Retaguarda] [numeric](4, 0) NULL,
	[AutenticarPV] [numeric](1, 0) NULL,
	[Porte] [numeric](1, 0) NULL,
	[Rota] [numeric](2, 0) NULL,
	[Impressa] [numeric](4, 0) NULL,
	[Responsavel] [varchar](8000) NULL,
	[CodigoEnderecamento] [varchar](8000) NULL,
	[SiglaUnidade] [varchar](8000) NULL,
	[CanalVoz] [numeric](4, 0) NULL,
	[JusticaFederal] [varchar](8000) NULL,
	[ClassePV] [varchar](8000) NULL,
	[NomeMunicipio] [varchar](8000) NULL,
	[UFMunicipio] [varchar](8000) NULL,
	[Telefone1] [varchar](8000) NULL,
	[TipoTelefone1] [varchar](8000) NULL,
	[Telefone2] [varchar](8000) NULL,
	[TipoTelefone2] [varchar](8000) NULL,
	[Telefone3] [varchar](8000) NULL,
	[TipoTelefone3] [varchar](8000) NULL,
	[Telefone4] [varchar](8000) NULL,
	[TipoTelefone4] [varchar](8000) NULL,
	[Telefone5] [varchar](8000) NULL,
	[TipoTelefone5] [varchar](8000) NULL
) ON [Dados]
;


 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_EMISSAO_ENDOSSO_TEMP ON [dbo].[UNIDADES_TEMP]
( 
  Codigo ASC
);         


SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'UNIDADE'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[UNIDADES_TEMP]
                SELECT [Codigo]
                      ,[Arquivo]
                      ,[TipoDado]
                      ,[ControleVersao]
                      ,[NomeCompletoArquivo]
                      ,[DataArquivo]
                      ,[TipoUnidade]
                      ,[CodigoUnidade]
                      ,[NomeUnidade]
                      ,CASE WHEN [CodigoUnidadeEscritorioNegociosCEF] = 0 THEN NULL ELSE [CodigoUnidadeEscritorioNegociosCEF] END [CodigoUnidadeEscritorioNegociosCEF]
                      ,[Endereco]
                      ,[Bairro]
                      ,[DDD]
                      ,[CEP]
                      ,[DataCriacao]
                      ,[DataAutomacao]
                      ,[DataExtincao]
                      ,[DataFimOperacao]
                      ,[Praca]
                      ,[TipoPV]
                      ,CASE WHEN [Retaguarda] = 0 THEN NULL ELSE [Retaguarda] END [Retaguarda]
                      ,[AutenticarPV]
                      ,[Porte]
                      ,[Rota]
                      ,[Impressa]
                      ,[Responsavel]
                      ,[CodigoEnderecamento]
                      ,[SiglaUnidade]
                      ,[CanalVoz]
                      ,[JusticaFederal]
                      ,[ClassePV]
                      ,[NomeMunicipio]
                      ,[UFMunicipio]
                      ,[Telefone1]
                      ,[TipoTelefone1]
                      ,[Telefone2]
                      ,[TipoTelefone2]
                      ,[Telefone3]
                      ,[TipoTelefone3]
                      ,[Telefone4]
                      ,[TipoTelefone4]
                      ,[Telefone5]
                      ,[TipoTelefone5]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaUnidade] ''''' + @PontoDeParada + ''''', 200'') PRP'

EXEC (@COMANDO)     

                
SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM [dbo].[UNIDADES_TEMP] PRP
                  
/*********************************************************************************************************************/
  

WHILE @MaiorCodigo IS NOT NULL
BEGIN 
    PRINT @MaiorCodigo
 
 
 
-----------------------------------------------------------------------------------------------------------------------
--Comando para inserir EVENTUAIS Agências (Escritório de Negócio) que não existirem na tabela de Unidades e estiverem 
--lançados como Escritório de negócios  
-----------------------------------------------------------------------------------------------------------------------
                      
    
  INSERT INTO Dados.Unidade(Codigo)
  SELECT UT.CodigoUnidadeEscritorioNegociosCEF
  FROM [dbo].[UNIDADES_TEMP] UT
  WHERE 
      not exists (
                  SELECT     *
                  FROM         Dados.Unidade U
                  WHERE U.Codigo = UT.CodigoUnidadeEscritorioNegociosCEF)
  AND UT.CodigoUnidadeEscritorioNegociosCEF IS NOT NULL
  GROUP BY UT.CodigoUnidadeEscritorioNegociosCEF   

  
  INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)
  SELECT DISTINCT U.ID, 'UNIDADE COM DADOS INCOMPLETOS' [Unidade], MAX(UT.Codigo) [CodigoNaFonte], 'UNIDADE' [TipoDado], MAX(UT.DataArquivo) [DataArquivo], MAX(Arquivo) [Arquivo]
  FROM [dbo].[UNIDADES_TEMP] UT
  INNER JOIN Dados.Unidade U
  ON UT.CodigoUnidadeEscritorioNegociosCEF = U.Codigo
  WHERE 
      not exists (
                  SELECT     *
                  FROM         Dados.UnidadeHistorico UH
                  WHERE UH.IDUnidade = U.ID)
  GROUP BY U.ID 
   
-----------------------------------------------------------------------------------------------------------------------     

-----------------------------------------------------------------------------------------------------------------------
--Comando para inserir EVENTUAIS Agências (Retaguarda) que não existirem na tabela de Unidades e estiverem 
--lançados como Retaguarda  
-----------------------------------------------------------------------------------------------------------------------
                      
    
  INSERT INTO Dados.Unidade(Codigo)
  SELECT UT.Retaguarda
  FROM [dbo].[UNIDADES_TEMP] UT
  WHERE 
      not exists (
                  SELECT     *
                  FROM         Dados.Unidade U
                  WHERE U.Codigo = UT.Retaguarda)
  AND UT.Retaguarda IS NOT NULL
  GROUP BY UT.Retaguarda   

  
  INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)
  SELECT DISTINCT U.ID, 'UNIDADE COM DADOS INCOMPLETOS' [Unidade], MAX(UT.Codigo) [CodigoNaFonte], 'UNIDADE' [TipoDado], MAX(UT.DataArquivo) [DataArquivo], MAX(Arquivo) [Arquivo]
  FROM [dbo].[UNIDADES_TEMP] UT
  INNER JOIN Dados.Unidade U
  ON UT.Retaguarda = U.Codigo
  WHERE 
      not exists (
                  SELECT     *
                  FROM         Dados.UnidadeHistorico UH
                  WHERE UH.IDUnidade = U.ID)
  GROUP BY U.ID 
   
-----------------------------------------------------------------------------------------------------------------------     

-----------------------------------------------------------------------------------------------------------------------
--Comando para inserir EVENTUAIS Agências que não existirem na tabela de Unidades e estiverem 
--lançados como Retaguarda  
-----------------------------------------------------------------------------------------------------------------------
                      
    
  INSERT INTO Dados.Unidade(Codigo)
  SELECT UT.CodigoUnidade
  FROM [dbo].[UNIDADES_TEMP] UT
  WHERE 
      not exists (
                  SELECT     *
                  FROM         Dados.Unidade U
                  WHERE U.Codigo = UT.CodigoUnidade)
  AND UT.CodigoUnidade IS NOT NULL
  GROUP BY UT.CodigoUnidade   

  
  INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)
  SELECT DISTINCT U.ID, 'UNIDADE COM DADOS INCOMPLETOS' [Unidade], MAX(UT.Codigo) [CodigoNaFonte], 'UNIDADE' [TipoDado], MAX(UT.DataArquivo) [DataArquivo], MAX(Arquivo) [Arquivo]
  FROM [dbo].[UNIDADES_TEMP] UT
  INNER JOIN Dados.Unidade U
  ON UT.CodigoUnidade = U.Codigo
  WHERE 
      not exists (
                  SELECT     *
                  FROM         Dados.UnidadeHistorico UH
                  WHERE UH.IDUnidade = U.ID)
				
  GROUP BY U.ID 
   
-----------------------------------------------------------------------------------------------------------------------    


-----------------------------------------------------------------------------------------------------------------------
--Comando para inserir EVENTUAIS Tipos de Unidade que não existirem na tabela de TipoUnidade e estiverem em registros de UNIDADE
-----------------------------------------------------------------------------------------------------------------------

  INSERT INTO Dados.TipoUnidade (Descricao)
  SELECT DISTINCT CleansingKit.dbo.fn_NTrimNull(UT.TipoUnidade) 
  FROM [dbo].[UNIDADES_TEMP] UT
  WHERE 
      not exists (
    SELECT     *
    FROM         Dados.TipoUnidade TU
    WHERE TU.Descricao = CleansingKit.dbo.fn_NTrimNull(UT.TipoUnidade))                      
  AND UT.TipoUnidade IS NOT NULL
----------------------------------------------------------------------------------------------------------------------- 
  
-----------------------------------------------------------------------------------------------------------------------
--Comando para inserir EVENTUAIS Tipos de PV que não existirem na tabela de TipoPV e estiverem em registros de UNIDADE
-----------------------------------------------------------------------------------------------------------------------

  INSERT INTO Dados.TipoPV (Descricao)
  SELECT DISTINCT CleansingKit.dbo.fn_NTrimNull(UT.TipoPV) 
  FROM [dbo].[UNIDADES_TEMP] UT
  WHERE 
      not exists (
    SELECT     *
    FROM         Dados.TipoPV TPV
    WHERE TPV.Descricao = CleansingKit.dbo.fn_NTrimNull(UT.TipoPV))  
  AND UT.TipoPV IS NOT NULL                    

-----------------------------------------------------------------------------------------------------------------------     

    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir as Unidades recebidos no arquivo UNIDADE
    -----------------------------------------------------------------------------------------------------------------------		                
             
 ;
 MERGE INTO Dados.UnidadeHistorico T
 USING
(           
SELECT  U.ID [IDUnidade]
       ,UT.NomeUnidade
       ,TU.ID [IDTipoUnidade]
       ,UH.[IDFilialPARCorretora]
       ,UH.[IDFilialFaturamento] 
       ,UEN.ID [IDUnidadeEscritorioNegocio]
       ,UT.[Endereco]
       ,UT.[Bairro]
       ,UT.[CEP]
       ,UT.[DDD]
       ,UT.[DataCriacao]
       ,UT.[DataExtincao]
       ,UT.[DataAutomacao]
       ,UT.[Praca]
       ,TPV.ID [IDTipoPV]
       ,URT.ID [IDRetaguarda]
       ,UT.[AutenticarPV]
       ,UT.[Porte]
       ,UT.[Rota]
       ,UT.[Impressa]
       ,UT.[Responsavel]
       ,UT.[CodigoEnderecamento]
       ,UT.[SiglaUnidade]
       ,UT.[CanalVoz]
       ,UT.[JusticaFederal]
       ,UT.[DataFimOperacao]
       ,UT.[ClassePV]
       ,UT.[NomeMunicipio]
       ,UT.[UFMunicipio]
       ,UT.[Telefone1]
       ,UT.[TipoTelefone1]
       ,UT.[Telefone2]
       ,UT.[TipoTelefone2]
       ,UT.[Telefone3]
       ,UT.[TipoTelefone3]
       ,UT.[Telefone4]
       ,UT.[TipoTelefone4]
       ,UT.[Telefone5]
       ,UT.[TipoTelefone5]
       ,UH.[ASVEN]
       ,UH.[IBGE]
       ,UH.[MatriculaGestor]
       ,UT.Codigo [CodigoNaFonte]
       ,UT.[TipoDado]
       ,UT.[Arquivo]
       ,UT.[DataArquivo]
  FROM [dbo].[UNIDADES_TEMP] UT
  INNER JOIN Dados.TipoPV TPV
  ON UT.TipoPV = TPV.Descricao
  INNER JOIN Dados.TipoUnidade TU
  ON UT.TipoUnidade = TU.Descricao
  INNER JOIN Dados.Unidade U
  ON U.Codigo = UT.CodigoUnidade
  LEFT JOIN Dados.Unidade UEN
  ON UEN.Codigo = UT.CodigoUnidadeEscritorioNegociosCEF
  LEFT JOIN Dados.Unidade URT
  ON URT.Codigo = UT.Retaguarda
  OUTER APPLY (SELECT TOP 1 * 
               FROM Dados.UnidadeHistorico UH 
               WHERE UH.IDUnidade = U.ID
			   AND UH.DataArquivo <= UT.[DataArquivo]
               ORDER BY UH.IDUnidade, UH.DataArquivo DESC, ID DESC) UH
			    --where  U.ID = 1161
) S
ON  T.IDUnidade   = S.IDUnidade
AND T.DataArquivo = S.DataArquivo
WHEN NOT MATCHED THEN
	INSERT  
        (
		   [IDUnidade]
           ,[Nome]
           ,[IDTipoUnidade]
           ,[IDFilialPARCorretora]
           ,[IDFilialFaturamento]
           ,[IDUnidadeEscritorioNegocio]
           ,[Endereco]
           ,[Bairro]
           ,[CEP]
           ,[DDD]
           ,[DataCriacao]
           ,[DataExtincao]
           ,[DataAutomacao]
           ,[Praca]
           ,[IDTipoPV]
           ,[IDRetaguarda]
           ,[AutenticarPV]
           ,[Porte]
           ,[Rota]
           ,[Impressa]
           ,[Responsavel]
           ,[CodigoEnderecamento]
           ,[SiglaUnidade]
           ,[CanalVoz]
           ,[JusticaFederal]
           ,[DataFimOperacao]
           ,[ClassePV]
           ,[NomeMunicipio]
           ,[UFMunicipio]
           ,[Telefone1]
           ,[TipoTelefone1]
           ,[Telefone2]
           ,[TipoTelefone2]
           ,[Telefone3]
           ,[TipoTelefone3]
           ,[Telefone4]
           ,[TipoTelefone4]
           ,[Telefone5]
           ,[TipoTelefone5]
           ,[ASVEN]
           ,[IBGE]
           ,[MatriculaGestor]
           ,[CodigoNaFonte]
           ,[TipoDado]
           ,[Arquivo]
           ,[DataArquivo]
		)
	VALUES 
		(
			 S.[IDUnidade]
			,S.NomeUnidade
			,S.[IDTipoUnidade]
			,S.[IDFilialPARCorretora]
			,S.[IDFilialFaturamento]
			,S.[IDUnidadeEscritorioNegocio]
			,S.[Endereco]
			,S.[Bairro]
			,S.[CEP]
			,S.[DDD]
			,S.[DataCriacao]
			,S.[DataExtincao]
			,S.[DataAutomacao]
			,S.[Praca]
			,S.[IDTipoPV]
			,S.[IDRetaguarda]
			,S.[AutenticarPV]
			,S.[Porte]
			,S.[Rota]
			,S.[Impressa]
			,S.[Responsavel]
			,S.[CodigoEnderecamento]
			,S.[SiglaUnidade]
			,S.[CanalVoz]
			,S.[JusticaFederal]
			,S.[DataFimOperacao]
			,S.[ClassePV]
			,S.[NomeMunicipio]
			,S.[UFMunicipio]
			,S.[Telefone1]
			,S.[TipoTelefone1]
			,S.[Telefone2]
			,S.[TipoTelefone2]
			,S.[Telefone3]
			,S.[TipoTelefone3]
			,S.[Telefone4]
			,S.[TipoTelefone4]
			,S.[Telefone5]
			,S.[TipoTelefone5]
			,S.[ASVEN]
			,S.[IBGE]
			,S.[MatriculaGestor]
			,S.[CodigoNaFonte]
			,S.[TipoDado]
			,S.[Arquivo]
			,S.[DataArquivo]
		)	      			
WHEN MATCHED THEN
UPDATE SET
			 [IDUnidade] = COALESCE(S.[IDUnidade], T.[IDUnidade])
			,[Nome] = COALESCE (S.NomeUnidade, T.[Nome])
			,[IDTipoUnidade] = COALESCE (S.[IDTipoUnidade], T.[IDTipoUnidade])
			,[IDFilialPARCorretora] = COALESCE (S.[IDFilialPARCorretora], T.[IDFilialPARCorretora])
			,[IDFilialFaturamento] = COALESCE (S.[IDFilialFaturamento], T.[IDFilialFaturamento])
			,[IDUnidadeEscritorioNegocio] = COALESCE (S.[IDUnidadeEscritorioNegocio], T.[IDUnidadeEscritorioNegocio])
			,[Endereco] = COALESCE (S.[Endereco], T.[Endereco])
			,[Bairro] = COALESCE (S.[Bairro], T.[Bairro])
			,[CEP] = COALESCE (S.[CEP], T.[CEP])
			,[DDD] = COALESCE (S.[DDD], T.[DDD])
			,[DataCriacao] = COALESCE (S.[DataCriacao], T.[DataCriacao])
			,[DataExtincao] = COALESCE (S.[DataExtincao], T.[DataExtincao])
			,[DataAutomacao] = COALESCE (S.[DataAutomacao], T.[DataAutomacao])
			,[Praca] = COALESCE (S.[Praca], T.[Praca])
			,[IDTipoPV] = COALESCE (S.[IDTipoPV], T.[IDTipoPV])
			,[IDRetaguarda] = COALESCE (S.[IDRetaguarda], T.[IDRetaguarda])
			,[AutenticarPV] = COALESCE (S.[AutenticarPV], T.[AutenticarPV])
			,[Porte] = COALESCE (S.[Porte], T.[Porte])
			,[Rota] = COALESCE (S.[Rota], T.[Rota])
			,[Impressa] = COALESCE (S.[Impressa], T.[Impressa])
			,[Responsavel] = COALESCE (S.[Responsavel], T.[Responsavel])
			,[CodigoEnderecamento] = COALESCE (S.[CodigoEnderecamento], T.[CodigoEnderecamento])
			,[SiglaUnidade] = COALESCE (S.[SiglaUnidade], T.[SiglaUnidade])
			,[CanalVoz] = COALESCE (S.[CanalVoz], T.[CanalVoz])
			,[JusticaFederal] = COALESCE (S.[JusticaFederal], T.[JusticaFederal])
			,[DataFimOperacao] = COALESCE (S.[DataFimOperacao], T.[DataFimOperacao])
			,[ClassePV] = COALESCE (S.[ClassePV], T.[ClassePV])
			,[NomeMunicipio] = COALESCE (S.[NomeMunicipio], T.[NomeMunicipio])
			,[UFMunicipio] = COALESCE (S.[UFMunicipio], T.[UFMunicipio])
			,[Telefone1] = COALESCE (S.[Telefone1], T.[Telefone1])
			,[TipoTelefone1] = COALESCE (S.[TipoTelefone1], T.[TipoTelefone1])
			,[Telefone2] = COALESCE (S.[Telefone2], T.[Telefone2])
			,[TipoTelefone2] = COALESCE (S.[TipoTelefone2], T.[TipoTelefone2])
			,[Telefone3] = COALESCE (S.[Telefone3], T.[Telefone3])
			,[TipoTelefone3] = COALESCE (S.[TipoTelefone3], T.[TipoTelefone3])
			,[Telefone4] = COALESCE (S.[Telefone4], T.[Telefone4])
			,[TipoTelefone4] = COALESCE (S.[TipoTelefone4], T.[TipoTelefone4])
			,[Telefone5] = COALESCE (S.[Telefone5], T.[Telefone5])
			,[TipoTelefone5] = COALESCE (S.[TipoTelefone5], T.[TipoTelefone5])
			--[ASVEN] = T.ASVEN
			,[IBGE] = COALESCE (S.[IBGE], T.[IBGE])
			,[MatriculaGestor] = COALESCE (S.[MatriculaGestor], T.[MatriculaGestor])
			,[CodigoNaFonte] = COALESCE (S.[CodigoNaFonte], T.[CodigoNaFonte])
			,[TipoDado] = COALESCE (S.[TipoDado], T.[TipoDado])
			,[Arquivo] = COALESCE (S.[Arquivo], T.[Arquivo])
			,[DataArquivo] = COALESCE (S.[DataArquivo], T.[DataArquivo])
;
				
    -----------------------------------------------------------------------------------------------------------------------        
          
  
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'UNIDADE'
  /*************************************************************************************/
  
  
 /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[UNIDADES_TEMP] 
  
  /*********************************************************************************************************************/
SET @COMANDO = 'INSERT INTO [dbo].[UNIDADES_TEMP]
                SELECT [Codigo]
                      ,[Arquivo]
                      ,[TipoDado]
                      ,[ControleVersao]
                      ,[NomeCompletoArquivo]
                      ,[DataArquivo]
                      ,[TipoUnidade]
                      ,[CodigoUnidade]
                      ,[NomeUnidade]
                      ,[CodigoUnidadeEscritorioNegociosCEF]
                      ,[Endereco]
                      ,[Bairro]
                      ,[DDD]
                      ,[CEP]
                      ,[DataCriacao]
                      ,[DataAutomacao]
                      ,[DataExtincao]
                      ,[DataFimOperacao]
                      ,[Praca]
                      ,[TipoPV]
                      ,[Retaguarda]
                      ,[AutenticarPV]
                      ,[Porte]
                      ,[Rota]
                      ,[Impressa]
                      ,[Responsavel]
                      ,[CodigoEnderecamento]
                      ,[SiglaUnidade]
                      ,[CanalVoz]
                      ,[JusticaFederal]
                      ,[ClassePV]
                      ,[NomeMunicipio]
                      ,[UFMunicipio]
                      ,[Telefone1]
                      ,[TipoTelefone1]
                      ,[Telefone2]
                      ,[TipoTelefone2]
                      ,[Telefone3]
                      ,[TipoTelefone3]
                      ,[Telefone4]
                      ,[TipoTelefone4]
                      ,[Telefone5]
                      ,[TipoTelefone5]
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaUnidade] ''''' + @PontoDeParada + ''''', 200'') PRP'

  EXEC (@COMANDO)     

                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM [dbo].[UNIDADES_TEMP] PRP
                    
  /*********************************************************************************************************************/
  
END

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     	      	

 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UNIDADES_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[UNIDADES_TEMP];

