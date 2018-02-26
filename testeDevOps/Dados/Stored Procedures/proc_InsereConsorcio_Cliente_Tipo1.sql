
/*******************************************************************************
	Nome: CORPORATIVO.Dados.[proc_InsereConsorcio_Cliente_Tipo1]
	Descrição: 
		
	Parâmetros de entrada:
	
					
	Retorno:

OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
 
CREATE PROCEDURE [Dados].[proc_InsereConsorcio_Cliente_Tipo1] 
AS

BEGIN TRY		
    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(MAX) 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cliente_Cliente_Tipo1_Temp]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Cliente_Cliente_Tipo1_Temp];

CREATE TABLE [dbo].[Cliente_Cliente_Tipo1_Temp](
	NUMERO_GRUPO	int	
	,NUMERO_COTA	int	
	,NUMERO_VERSAO	int	
	,BRANCOS	varchar(20)
	,CPFCNPJ varchar(20)
	,DataNascimento	date	
	,NOME	varchar(50)
	,TipoPessoa	char(2)
	,IDENTIDADE	varchar(20)
	,ORGAO_EXPEDIDOR	varchar(10)
	,UF_ORGAO_EXPEDIDOR	varchar(2)
	,ESTADO_CIVIL	tinyint
	,SEXO	tinyint	
	,PROFISSAO	int	
	,DDD_RESIDENCIA	char(3)
	,TELEFONE_RESIDENCIA	varchar(10)
	,DDD_COMERCIAL	char(3)
	,TELEFONE_COMERCIAL	varchar(10)
	,DDD_FAX	char(3)
	,TELEFONE_FAX	varchar(10)
	,DATA_EXPEDICAO_RG	date
	,CODIGO_SEGMENTO	char(4)
	,NOME_CONJUGE	varchar(50)
	,DATA_NASCIMENTO_CONJUGE	date
	,PROFISSAO_CONJUGE	int	
	,EMAIL	varchar(100)
	,DESCRICAO_DE_PROFISSAO	varchar(50)
	,RENDA_INDIVIDUAL	tinyint	
	,RENDA_FAMILIAR	tinyint	
	,BRANCOS_B	varchar(50)
	,Codigo	int
	,NomeArquivo	varchar(200)
	,Chave	varchar(90)
	,DataArquivo	date
	,NumeroProposta	varchar(24)
);


/* SELECIONA O ÚLTIMO PONTO DE PARADA */
--SELECT *
SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'Consorcio_Cliente_Tipo1'

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/
--    DECLARE @COMANDO AS NVARCHAR(MAX) 
--	 DECLARE @PontoDeParada AS VARCHAR(400) SET @PONTODEPARADA = 0           
    SET @COMANDO = 'INSERT INTO [dbo].[Cliente_Cliente_Tipo1_Temp]
           (CPFCNPJ,DATANASCIMENTO,NOME,TIPOPESSOA,DDD_RESIDENCIA,TELEFONE_RESIDENCIA, Codigo,NomeArquivo,DataArquivo,NumeroProposta )
		   SELECT  CPFCNPJ,DATANASCIMENTO,NOME,TIPOPESSOA,DDD_RESIDENCIA,TELEFONE_RESIDENCIA, Codigo,NomeArquivo,DataArquivo,NumeroProposta 
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaConsorcio_Cliente_Tipo1] ''''' + @PontoDeParada + ''''''') PRP '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.Cliente_Cliente_Tipo1_Temp PRP                    

/*********************************************************************************************************************/
                           
SET @COMANDO = '' 

WHILE @MaiorCodigo IS NOT NULL
BEGIN

/**********************************************************************
       inclui e atualiza os Clientes de consórcio.
***********************************************************************/
;MERGE INTO Dados.ContratoCliente AS T
	USING (

		select * from (	SELECT DISTINCT 
				C.ID AS IDContrato, (CASE TipoPessoa WHEN 1 THEN 'Pessoa Física' ELSE 'Pessoa Jurídica' END) AS TipoPessoa, CPFCNPJ, Nome AS NomeCliente, 
				COALESCE(DDD_RESIDENCIA, DDD_Comercial) AS DDD, COALESCE(Telefone_residencia, Telefone_comercial) AS Telefone, 
				TMP.DataArquivo, TMP.NomeArquivo AS Arquivo,ROW_NUMBER() OVER (PARTITION BY c.ID order by TMP.DataArquivo desc) linha
			FROM DBO.Cliente_Cliente_Tipo1_Temp AS TMP
			INNER JOIN Dados.Contrato AS C
			ON TMP.NumeroProposta=C.NumeroContrato
			--where c.ID = 22670062
				) z where linha = 1
          ) X
        ON T.IDContrato = X.IDContrato
		WHEN NOT MATCHED
		          THEN INSERT (IDContrato, TipoPessoa, CPFCNPJ, NomeCliente, DDD, Telefone, DataArquivo, Arquivo)
		               VALUES (X.IDContrato, X.TipoPessoa, X.CPFCNPJ, X.NomeCliente, X.DDD, X.Telefone, X.DataArquivo, X.Arquivo); 
/*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/

  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'Consorcio_Cliente_Tipo1'

 /****************************************************************************************/
  
  TRUNCATE TABLE [dbo].[Cliente_Cliente_Tipo1_Temp]
  
  /**************************************************************************************/
   
    SET @COMANDO = 'INSERT INTO [dbo].[Cliente_Cliente_Tipo1_Temp]
           (CPFCNPJ,DATANASCIMENTO,NOME,TIPOPESSOA,DDD_RESIDENCIA,TELEFONE_RESIDENCIA, Codigo,NomeArquivo,DataArquivo,NumeroProposta )
		   SELECT  CPFCNPJ,DATANASCIMENTO,NOME,TIPOPESSOA,DDD_RESIDENCIA,TELEFONE_RESIDENCIA, Codigo,NomeArquivo,DataArquivo,NumeroProposta 
       FROM OPENQUERY ([OBERON], 
       ''EXEC [Fenae].[Corporativo].[proc_RecuperaConsorcio_Cliente_Tipo1] ''''' + @PontoDeParada + ''''''') PRP '
exec (@COMANDO)    

SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM dbo.Cliente_Cliente_Tipo1_Temp PRP 

  /*********************************************************************************************************************/
                    
  /*********************************************************************************************************************/
  
END
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cliente_Cliente_Tipo1]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[Cliente_Cliente_Tipo1_Temp];

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     

			    
			                    