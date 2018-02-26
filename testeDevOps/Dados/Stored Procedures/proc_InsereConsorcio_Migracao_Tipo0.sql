
/*******************************************************************************
	Nome: CORPORATIVO.Dados.[proc_InsereConsorcio_Migracao_Tipo0]
	Descrição: 
		
	Parâmetros de entrada:
	
					
	Retorno:

OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
 
CREATE PROCEDURE [Dados].[proc_InsereConsorcio_Migracao_Tipo0] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cliente_Migracao_Tipo0_Temp]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Cliente_Migracao_Tipo0_Temp];

CREATE TABLE [dbo].[Cliente_Migracao_Tipo0_Temp](
	NUMERO_GRUPO	int	
	,NUMERO_COTA	int	
	,NUMERO_VERSAO	int	
	,NUMERO_GRUPO_ATUAL	int	
	,NUMERO_COTA_ATUAL	int	
	,NUMERO_VERSAO_ATUAL	int	
	,BRANCOS	varchar(300)
	,Codigo	int	
	,NomeArquivo	varchar(200)
	,DataArquivo	date	
	,NumeroProposta	varchar(24)
);

/* SELECIONA O ÚLTIMO PONTO DE PARADA */
--SELECT *
SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Cliente_Migracao_Tipo0'

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
--   DECLARE @COMANDO AS NVARCHAR(MAX) 
--	 DECLARE @PontoDeParada AS VARCHAR(400) SET @PONTODEPARADA = 0           
    SET @COMANDO = 'INSERT INTO [dbo].[Cliente_Migracao_Tipo0_Temp]
           (NUMERO_GRUPO, NUMERO_COTA, NUMERO_VERSAO, NUMERO_GRUPO_ATUAL, NUMERO_COTA_ATUAL, NUMERO_VERSAO_ATUAL, BRANCOS, NomeArquivo, DataArquivo, NumeroProposta, Codigo)
		   SELECT  NUMERO_GRUPO, NUMERO_COTA, NUMERO_VERSAO, NUMERO_GRUPO_ATUAL, NUMERO_COTA_ATUAL, NUMERO_VERSAO_ATUAL, BRANCOS, NomeArquivo, DataArquivo, NumeroProposta, Codigo
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaConsorcio_Tipo0]''''' + @PontoDeParada + ''''''') PRP '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.Cliente_Migracao_Tipo0_Temp PRP                    

/*********************************************************************************************************************/
                           
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN
/**********************************************************************
       grava informações de migração, transferência dos contratos de consórcio.
***********************************************************************/

;MERGE INTO Dados.MigracaoConsorcio AS T
	USING (
			SELECT DISTINCT 
				C.ID AS IDContrato, TMP.Numero_grupo, TMP.Numero_Cota, TMP.Numero_versao, 
				TMP.Numero_grupo_atual, TMP.Numero_cota_atual, TMP.Numero_versao_atual, 
				TMP.Brancos, TMP.NomeArquivo, TMP.DataArquivo
			FROM DBO.Cliente_Migracao_Tipo0_Temp AS TMP
			INNER JOIN Dados.Contrato AS C
			ON TMP.NumeroProposta=C.NumeroContrato
          ) X
        ON T.IDContrato = X.IDContrato
		AND T.DataArquivo=X.DataArquivo
		WHEN NOT MATCHED
		          THEN INSERT (Numero_grupo, Numero_Cota, Numero_versao, Numero_grupo_atual, Numero_cota_atual, Numero_versao_atual, Brancos, NomeArquivo, DataArquivo, IDContrato)
		               VALUES (X.Numero_grupo, X.Numero_Cota, X.Numero_versao, X.Numero_grupo_atual, X.Numero_cota_atual, X.Numero_versao_atual, X.Brancos, X.NomeArquivo, X.DataArquivo, X.IDContrato ); 

/*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/

  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Cliente_Migracao_Tipo0'

 /****************************************************************************************/
  
  TRUNCATE TABLE [dbo].Cliente_Migracao_Tipo0_Temp
  
  /**************************************************************************************/
   
    SET @COMANDO = 'INSERT INTO [dbo].[Cliente_Migracao_Tipo0_Temp]
           (NUMERO_GRUPO, NUMERO_COTA, NUMERO_VERSAO, NUMERO_GRUPO_ATUAL, NUMERO_COTA_ATUAL, NUMERO_VERSAO_ATUAL, BRANCOS, NomeArquivo, DataArquivo, NumeroProposta)
		   SELECT  NUMERO_GRUPO, NUMERO_COTA, NUMERO_VERSAO, NUMERO_GRUPO_ATUAL, NUMERO_COTA_ATUAL, NUMERO_VERSAO_ATUAL, BRANCOS, NomeArquivo, DataArquivo, NumeroProposta
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaConsorcio_Tipo0]''''' + @PontoDeParada + ''''''') PRP '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.Cliente_Migracao_Tipo0_Temp PRP 

  /*********************************************************************************************************************/
                    
  /*********************************************************************************************************************/
  
END
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cliente_Migracao_Tipo0_Temp]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Cliente_Migracao_Tipo0_Temp];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     

			    
			                    