
/*
	Autor: Egler Vieira
	Data Criação:17/07/2014

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereProdutor
	Descrição: Procedimento que realiza a inserção dos Produtores no banco de dados.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_InsereProdutor] as
BEGIN TRY		
 
	    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 
   	    

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Produtor_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Produtor_TEMP];

CREATE TABLE [dbo].[Produtor_TEMP](
          COD_PRODUTOR INT
        , NOM_PRODUTOR VARCHAR(100)
        , COD_CGCCPF_PRODUTOR VARCHAR(20)
        , COD_TIPO_PRODUTOR CHAR(1)
        , DES_TIPO_PRODUTOR VARCHAR(100)
        , NUM_MATRICULA BIGINT
        , COD_FILIAL SMALLINT
        , NOM_FILIAL VARCHAR(100)
)  


 /*Cria alguns índices para facilitar a busca*/  
CREATE CLUSTERED INDEX idx_Produtor_TEMP ON [dbo].[Produtor_TEMP]
( 
  Cod_Produtor ASC
)         


--SELECT @PontoDeParada = PontoParada
--FROM ControleDados.PontoParada
--WHERE NomeEntidade = 'Produtor'


--select @PontoDeParada = 20007037


/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[Produtor_TEMP] 
                       (
                        COD_PRODUTOR
                      , NOM_PRODUTOR
                      , COD_CGCCPF_PRODUTOR
                      , COD_TIPO_PRODUTOR
                      , DES_TIPO_PRODUTOR
                      , NUM_MATRICULA
                      , COD_FILIAL
                      , NOM_FILIAL
                       )
                SELECT DISTINCT
                      	  COD_PRODUTOR
                        , NOM_PRODUTOR
                        , COD_CGCCPF_PRODUTOR
                        , COD_TIPO_PRODUTOR
                        , DES_TIPO_PRODUTOR
                        , NUM_MATRICULA
                        , COD_FILIAL
                        , NOM_FILIAL
                FROM OPENQUERY ([ANTARES], 
                ''EXEC [Corporativo].[SSD].[proc_RecuperaProdutor] '') PRP'

EXEC (@COMANDO)     

                
--SELECT @MaiorCodigo= MAX(PRP.Codigo)
--FROM [dbo].[Produtor_TEMP] PRP
                  
/*********************************************************************************************************************/

--WHILE @MaiorCodigo IS NOT NULL
BEGIN 
--    PRINT @MaiorCodigo
   
      /***********************************************************************
      Carregar os TIPOS dos Produtors
      ***********************************************************************/
      ;MERGE INTO Dados.TipoProdutor AS T
      USING (SELECT DISTINCT CASE WHEN ST.COD_TIPO_PRODUTOR = '-' THEN 255 ELSE ST.COD_TIPO_PRODUTOR END COD_TIPO_PRODUTOR, (SELECT TOP 1 DES_TIPO_PRODUTOR FROM [Produtor_TEMP] B WHERE ST.Cod_TIPO_PRODUTOR = B.cod_TIPO_PRODUTOR) DES_TIPO_PRODUTOR
             FROM [Produtor_TEMP] ST
             
            ) X
       ON T.ID = X.COD_TIPO_PRODUTOR 
      WHEN NOT MATCHED
            THEN INSERT (ID, Descricao)
                 VALUES (X.COD_TIPO_PRODUTOR, X.DES_TIPO_PRODUTOR);
     /***********************************************************************/   
                                                      
   
      /***********************************************************************
      Carregar as FILIAIS DE FATURAMENTO dos Produtors
      ***********************************************************************/
      ;MERGE INTO Dados.FilialFaturamento AS T
      USING (SELECT DISTINCT  ST.COD_FILIAL, ST.NOM_FILIAL
             FROM [Produtor_TEMP] ST
             WHERE ST.COD_FILIAL IS NOT NULL AND ST.COD_FILIAL >= 0
            ) X
       ON T.Codigo = X.COD_FILIAL 
      WHEN NOT MATCHED
            THEN INSERT (Codigo, Nome)
                 VALUES (X.COD_FILIAL, X.NOM_FILIAL); 
     /***********************************************************************/


    -----------------------------------------------------------------------------------------------------------------------
    --Comando para inserir os Produtors recebidos no arquivo Produtor
    -----------------------------------------------------------------------------------------------------------------------		               
   	MERGE INTO Dados.Produtor AS T
		USING (

		  SELECT DISTINCT
             'SSD.PRODUTOR' [Arquivo],
	          Cast(getdate() as date) [DataArquivo],
      	          
             ST.COD_PRODUTOR,
             ST.NOM_PRODUTOR,
             ST.COD_CGCCPF_PRODUTOR,
             ST.NUM_MATRICULA,
          --   FF.ID [IDFilialFaturamento],
             TP.ID [IDTipoProdutor]

          FROM [Produtor_TEMP] ST
              LEFT JOIN Dados.FilialFaturamento FF
              ON ST.COD_FILIAL = FF.Codigo
              LEFT JOIN Dados.TipoProdutor TP
              ON TP.ID = ST.COD_TIPO_PRODUTOR
          WHERE COD_PRODUTOR >= 0
          ) S
   ON   T.Codigo = S.COD_PRODUTOR
		WHEN MATCHED
			THEN UPDATE 
				SET T.Nome = COALESCE(S.NOM_PRODUTOR, T.Nome)
				   ,T.CPFCNPJ = COALESCE(S.COD_CGCCPF_PRODUTOR, T.CPFCNPJ)
				   ,T.Matricula = COALESCE(S.NUM_MATRICULA, T.Matricula)
				   ,T.IDTipoProdutor = COALESCE(S.[IDTipoProdutor], T.IDTipoProdutor)
                  -- ,T.IDFilialFaturamento = COALESCE(S.IDFilialFaturamento, T.IDFilialFaturamento)
                   ,T.DataArquivo = COALESCE(S.DataArquivo, T.DataArquivo)
				   ,T.NomeArquivo = COALESCE(S.Arquivo, T.NomeArquivo)
		WHEN NOT MATCHED
			THEN INSERT (
			         Codigo
                    ,Nome 
                    ,CPFCNPJ 
                    ,Matricula 
                    ,IDTipoProdutor 
                    --,IDFilialFaturamento 
                    ,DataArquivo
                    ,NomeArquivo 
                     )
				    VALUES (S.COD_PRODUTOR, S.NOM_PRODUTOR, S.COD_CGCCPF_PRODUTOR, S.NUM_MATRICULA, S.[IDTipoProdutor]
                    --, S.IDFilialFaturamento
                    , S.DataArquivo, S.Arquivo);
    -----------------------------------------------------------------------------------------------------------------------				
				--SELECT * FROM Dados.Produtor
    
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  --SET @PontoDeParada = @MaiorCodigo
  
  --UPDATE ControleDados.PontoParada 
  --SET PontoParada = @MaiorCodigo
  --WHERE NomeEntidade = 'Produtor'
  /*************************************************************************************/
  
 /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[Produtor_TEMP]   
END

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Produtor_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Produtor_TEMP];				
	
END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH
