
/*
	Autor: Egler Vieira
	Data Criação: 03/05/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereW714AMET
	Descrição: Procedimento que realiza a carga do AVGESTAO (W714) no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereW714AMET] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[W714AMET_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
BEGIN
	DROP TABLE [dbo].[W714AMET_TEMP];
	/*
		RAISERROR   (N'A tabela temporária [W714AMET_TEMP] foi encontrada. Verifique se há um processo paralelo executando a função.',
    16, -- Severity.
    1 -- State.
    );
    */
END

CREATE TABLE [dbo].[W714AMET_TEMP](
	[Codigo] [int]  NOT NULL,
	[ControleVersao] [decimal](16, 8) NULL,
	[NomeArquivo] [nvarchar](100) NULL,
	[DataArquivo] [datetime] NULL,
	[DataProcessamento] [date] NULL,
	[CodigoUnidade] [smallint] NULL,
	[Bloco] [varchar](6) NULL,
	[Segmento] [char](5) NULL,
	[MesPeriodo] [smallint] NULL,
	[AnoPeriodo] [smallint] NULL,
	[ValorNegociado] [numeric](15, 2) NULL,
	[ValorRealizadoAcumulado] [numeric](15, 2) NULL,
	[ValorRealizadoMensal] [numeric](15, 2) NULL,
	[PercentualEsperado] [numeric](10, 3) NULL,
	[PercentualRealizado] [numeric](10, 3) NULL,
	[Mensuracao] [char](8) NULL
)                       


 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_W714AMET_TEMP_Codigo ON [dbo].[W714AMET_TEMP]
( 
  Codigo ASC
)   

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'W714AMET'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
                
    SET @COMANDO =
    '  INSERT INTO dbo.W714AMET_TEMP
        ( 	[Codigo],                 
	          [ControleVersao],         
	          [NomeArquivo],            
	          [DataArquivo],            
	          [DataProcessamento],      
	          [CodigoUnidade],          
	          [Bloco],                  
	          [Segmento],               
	          [MesPeriodo],             
	          [AnoPeriodo],             
	          [ValorNegociado],         
	          [ValorRealizadoAcumulado],
	          [ValorRealizadoMensal],   
	          [PercentualEsperado],     
	          [PercentualRealizado],    
	          [Mensuracao]  )
     SELECT 
            [Codigo],                 
	          [ControleVersao],         
	          [NomeArquivo],            
	          [DataArquivo],            
	          [DataProcessamento],      
	          [CodigoUnidade],          
	          [Bloco],                  
	          [Segmento],               
	          [MesPeriodo],             
	          [AnoPeriodo],             
	          [ValorNegociado],         
	          [ValorRealizadoAcumulado],
	          [ValorRealizadoMensal],   
	          [PercentualEsperado],     
	          [PercentualRealizado],    
	          [Mensuracao]  
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaW714AMET] ''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.W714AMET_TEMP PRP                    

/*********************************************************************************************************************/
                  
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN
--print @MaiorCodigo

  
  /*INSERE BLOCOS NÃO ENCONTRADOS*/
  ;MERGE INTO Dados.Bloco AS T
  USING	
  (
  SELECT DISTINCT
        W.[Bloco] [Codigo],
        'BLOCO SEM NOME' [Nome]
  FROM [dbo].[W714AMET_TEMP] W
  WHERE W.[Bloco] IS NOT NULL
  ) X
  ON T.[Codigo] = X.[Codigo]
  WHEN NOT MATCHED
          THEN INSERT ([Codigo], [Nome])
               VALUES (X.[Codigo], X.[Nome]);  
               
  
  /*INSERE SEGMENTOS NÃO ENCONTRADOS*/
  ;MERGE INTO Dados.Segmento AS T
  USING	
  (
  SELECT DISTINCT
        W.[Segmento] [Codigo],
        'SEGMENTO SEM NOME' [Nome]
  FROM [dbo].[W714AMET_TEMP] W
  WHERE W.[Segmento] IS NOT NULL
  ) X
  ON T.[Codigo] = X.[Codigo]
  WHEN NOT MATCHED
          THEN INSERT ([Codigo], [Nome])
               VALUES (X.[Codigo], X.[Nome]);        
   
   
  /*INSERE PVs NÃO LOCALIZADOS*/
  /*#################################################################*/
  ;INSERT INTO Dados.Unidade(Codigo)
  SELECT DISTINCT W.CodigoUnidade
  FROM [dbo].[W714AMET_TEMP] W
  WHERE  W.CodigoUnidade IS NOT NULL 
    AND not exists (
                    SELECT     *
                    FROM         Dados.Unidade U
                    WHERE U.Codigo = W.CodigoUnidade);                  
                                                          

  INSERT INTO Dados.UnidadeHistorico(IDUnidade, Nome, CodigoNaFonte, TipoDado, DataArquivo, Arquivo)
  SELECT DISTINCT U.ID, 'UNIDADE COM DADOS INCOMPLETOS' [Unidade], -1 [CodigoNaFonte], 'W714' [TipoDado], MAX(W.DataArquivo) [DataArquivo], 'W714' [Arquivo]
  FROM [dbo].[W714AMET_TEMP] W
  INNER JOIN Dados.Unidade U
  ON W.CodigoUnidade = U.Codigo
  WHERE 
      not exists (
                  SELECT     *
                  FROM         Dados.UnidadeHistorico UH
                  WHERE UH.IDUnidade = U.ID)    
  GROUP BY U.ID; 
  /*#################################################################*/
   
   
  /*************************************************************************************/
  /*Chama a PROC que roda a importação registro a registro dos detalhes do RESIDENTIAL TP6 (PRPSASSE)*/
  /*************************************************************************************/ 
    MERGE INTO Dados.AVGestaoBloco AS S
		USING ( SELECT *
            FROM
            (
               SELECT
				          U.ID IDUnidade
				        , B.ID IDBloco
				        , DataArquivo
				        , DataProcessamento
				        , AnoPeriodo
				        , MesPeriodo
				        , ValorRealizadoMensal
				        , ValorRealizadoAcumulado
				        , ValorNegociado
				        , PercentualRealizado
				        , PercentualEsperado
				        , S.ID IDSegmento
				        , Mensuracao
				        , NomeArquivo [Arquivo]--Reprocessamento
                , W.CODIGO
		            , ROW_NUMBER() OVER(PARTITION BY U.ID, B.ID, S.ID, W.DataArquivo, W.DataProcessamento, W.AnoPeriodo, W.MesPeriodo ORDER BY U.ID, B.ID, S.ID, W.DataArquivo, W.DataProcessamento, W.AnoPeriodo, W.MesPeriodo, W.Codigo DESC) [ORDER]				        
				         FROM [dbo].[W714AMET_TEMP] W
				         INNER JOIN Dados.Unidade U
				         ON W.CodigoUnidade = U.Codigo
				         INNER JOIN Dados.Segmento S
				         ON S.Codigo = W.Segmento
				         INNER JOIN Dados.Bloco B
				         ON B.Codigo = W.Bloco
				       
			      ) S
            WHERE S.[ORDER] = 1
				) AS O 
	   ON   S.IDUnidade         = O.IDUnidade
			AND S.IDBloco           = O.IDBloco
			AND S.IDSegmento        = O.IDSegmento
			AND S.DataArquivo       = O.DataArquivo
			AND S.DataProcessamento = O.DataProcessamento
			AND S.AnoPeriodo        = O.AnoPeriodo
			AND S.MesPeriodo        = O.MesPeriodo
		WHEN MATCHED
			THEN UPDATE
				 SET  
					ValorRealizadoMensal = COALESCE(O.ValorRealizadoMensal, S.ValorRealizadoMensal) 
						,						
					ValorRealizadoAcumulado = COALESCE(O.ValorRealizadoAcumulado, S.ValorRealizadoAcumulado) 
						,	
					ValorNegociado = COALESCE(O.ValorNegociado, S.ValorNegociado)							
						,	
					PercentualRealizado = COALESCE(O.PercentualRealizado, S.PercentualRealizado)							
						,	
					PercentualEsperado =  COALESCE(O.PercentualEsperado, S.PercentualEsperado)							
						,
					Mensuracao = COALESCE(O.Mensuracao, S.Mensuracao)							
					  ,
					Arquivo =  COALESCE(O.Arquivo, S.Arquivo)							
		WHEN NOT MATCHED
			THEN INSERT (IDUnidade, IDBloco, DataArquivo, DataProcessamento, AnoPeriodo, MesPeriodo, 
				ValorRealizadoMensal, ValorRealizadoAcumulado, ValorNegociado, PercentualRealizado
				, PercentualEsperado, IDSegmento, Mensuracao, Arquivo) 
			VALUES (O.IDUnidade, O.IDBloco, O.DataArquivo, O.DataProcessamento, O.AnoPeriodo, O.MesPeriodo, 
				O.ValorRealizadoMensal, O.ValorRealizadoAcumulado, O.ValorNegociado, O.PercentualRealizado
				, O.PercentualEsperado, O.IDSegmento, O.Mensuracao, O.Arquivo); 
  /*************************************************************************************/ 


  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'W714AMET'
  /*************************************************************************************/
  
                  
  /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[W714AMET_TEMP]        
  /*********************************************************************************************************************/
                
         SET @COMANDO =
    '  INSERT INTO dbo.W714AMET_TEMP
        ( 	[Codigo],                 
	          [ControleVersao],         
	          [NomeArquivo],            
	          [DataArquivo],            
	          [DataProcessamento],      
	          [CodigoUnidade],          
	          [Bloco],                  
	          [Segmento],               
	          [MesPeriodo],             
	          [AnoPeriodo],             
	          [ValorNegociado],         
	          [ValorRealizadoAcumulado],
	          [ValorRealizadoMensal],   
	          [PercentualEsperado],     
	          [PercentualRealizado],    
	          [Mensuracao]  )
     SELECT 
            [Codigo],                 
	          [ControleVersao],         
	          [NomeArquivo],            
	          [DataArquivo],            
	          [DataProcessamento],      
	          [CodigoUnidade],          
	          [Bloco],                  
	          [Segmento],               
	          [MesPeriodo],             
	          [AnoPeriodo],             
	          [ValorNegociado],         
	          [ValorRealizadoAcumulado],
	          [ValorRealizadoMensal],   
	          [PercentualEsperado],     
	          [PercentualRealizado],    
	          [Mensuracao]  
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaW714AMET] ''''' + @PontoDeParada + ''''''') PRP
         '
exec (@COMANDO) 

                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM dbo.W714AMET_TEMP PRP    

  
                    
  /*********************************************************************************************************************/

                    
  /*********************************************************************************************************************/
  
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[W714AMET_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[W714AMET_TEMP];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH                                      

--EXEC [Dados].[proc_InsereW714AMET] 

