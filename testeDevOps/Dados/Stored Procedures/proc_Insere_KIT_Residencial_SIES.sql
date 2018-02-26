/*
	Autor: Andre Anselmo
	Data Criação: 28/05/2015

	Descrição: 
	
	Última alteração : 

*/
--[Corporativo].[proc_Insere_KIT_Residencial_SIES]
/*******************************************************************************
	Nome: Corporativo.Dados.proc_Insere_KIT_Residencial_SIES
	Descrição: 
		
	Parâmetros de entrada:
					
	Retorno:

*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_Insere_KIT_Residencial_SIES] 
AS
    
BEGIN TRY		
	    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 

 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KIT_Residencial_SIES_TEMP]') AND type in (N'U'))
	DROP TABLE [dbo].[KIT_Residencial_SIES_TEMP];

CREATE TABLE [dbo].[KIT_Residencial_SIES_TEMP](
	 Codigo INT,
	 DataArquivo DATE,
	 NomeArquivo VARCHAR(200),
     ControleVersao VARCHAR(200),
	 Processo_SUSEP VARCHAR(200),
	 Numero_Apolice VARCHAR(50),
	 Nome_Produto VARCHAR(200),
	 Codigo_Produto VARCHAR(50),
	 Codigo_Ramo VARCHAR(50),
	 Data_Emissao VARCHAR(200),
	 Apolice_Renovada VARCHAR(200),
	 Numero_Proposta VARCHAR(200),
	 Data_Proposta VARCHAR(200),
	 Inicio_Vigencia VARCHAR(200),
	 Fim_Vigencia VARCHAR(200),
	 Razao_Social VARCHAR(200),
	 CNPJ VARCHAR(200)        
) ;

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'KIT_Residencial_SIES'


/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[KIT_Residencial_SIES_TEMP]
                SELECT 
					 Codigo,
					 DataArquivo,
					 NomeArquivo,
					 ControleVersao,
					 Processo_SUSEP,
					 Numero_Apolice,
					 Nome_Produto,
					 Codigo_Produto,
					 Codigo_Ramo,
					 Data_Emissao,
					 Apolice_Renovada,
					 Numero_Proposta,
					 Data_Proposta,
					 Inicio_Vigencia,
					 Fim_Vigencia,
					 Razao_Social,
					 CNPJ 
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_Recupera_KIT_RESIDENCIAL_SIES] ''''' + @PontoDeParada + ''''''') PRP'
EXEC (@COMANDO)     

                
SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM [dbo].[KIT_Residencial_SIES_TEMP] PRP
                  
/*********************************************************************************************************************/


WHILE @MaiorCodigo IS NOT NULL
BEGIN 
 --   PRINT @MaiorCodigo

 ; MERGE INTO dados.RenovacaoPatrimonial AS T
      USING (
		SELECT 
					 DataArquivo,
					 NomeArquivo,
					 ControleVersao,
					 Processo_SUSEP,
					 Numero_Apolice,
					 Nome_Produto,
					 Codigo_Produto,
					 Codigo_Ramo,
					 Data_Emissao,
					 Apolice_Renovada,
					 Numero_Proposta,
					 Data_Proposta,
					 Inicio_Vigencia,    
					 Fim_Vigencia,
					 Razao_Social,
					 CNPJ            
		FROM dbo.KIT_Residencial_SIES_TEMP
            ) X
       ON  T.DataArquivo = X.DataArquivo
	   AND T.Numero_Apolice = X.Numero_Apolice
     WHEN NOT MATCHED
	          THEN INSERT (DataArquivo,
					 NomeArquivo,
					 ControleVersao,
					 Processo_SUSEP,
					 Numero_Apolice,
					 Nome_Produto,
					 Codigo_Produto,
					 Codigo_Ramo,
					 Data_Emissao,
					 Apolice_Renovada,
					 Numero_Proposta,
					 Data_Proposta,
					 Inicio_Vigencia,    
					 Fim_Vigencia,
					 Razao_Social,
					 CNPJ )
	               VALUES (X.DataArquivo,
					 X.NomeArquivo,
					 X.ControleVersao,
					 X.Processo_SUSEP,
					 X.Numero_Apolice,
					 X.Nome_Produto,
					 X.Codigo_Produto,
					 X.Codigo_Ramo,
					 X.Data_Emissao,
					 X.Apolice_Renovada,
					 X.Numero_Proposta,
					 X.Data_Proposta,
					 X.Inicio_Vigencia,    
					 X.Fim_Vigencia,
					 X.Razao_Social,
					 CNPJ );



	--INSERT INTO Dados.RenovacaoPatrimonial 
	--(
	--				 DataArquivo,
	--				 NomeArquivo,
	--				 ControleVersao,
	--				 Processo_SUSEP,
	--				 Numero_Apolice,
	--				 Nome_Produto,
	--				 Codigo_Produto,
	--				 Codigo_Ramo,
	--				 Data_Emissao,
	--				 Apolice_Renovada,
	--				 Numero_Proposta,
	--				 Data_Proposta,
	--				 Inicio_Vigencia,
	--				 Fim_Vigencia,
	--				 Razao_Social,
	--				 CNPJ           
	--)
	--SELECT 
	--				 DataArquivo,
	--				 NomeArquivo,
	--				 ControleVersao,
	--				 Processo_SUSEP,
	--				 Numero_Apolice,
	--				 Nome_Produto,
	--				 Codigo_Produto,
	--				 Codigo_Ramo,
	--				 Data_Emissao,
	--				 Apolice_Renovada,
	--				 Numero_Proposta,
	--				 Data_Proposta,
	--				 Inicio_Vigencia,    
	--				 Fim_Vigencia,
	--				 Razao_Social,
	--				 CNPJ            
	--FROM dbo.KIT_Residencial_SIES_TEMP
  
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'KIT_Residencial_SIES'
  /*************************************************************************************/
  
  
 /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[KIT_Residencial_SIES_TEMP] 
  
  /*********************************************************************************************************************/
SET @COMANDO = 'INSERT INTO [dbo].[KIT_Residencial_SIES_TEMP]
                SELECT 
					 Codigo,
					 DataArquivo,
					 NomeArquivo,
					 ControleVersao,
					 Processo_SUSEP,
					 Numero_Apolice,
					 Nome_Produto,
					 Codigo_Produto,
					 Codigo_Ramo,
					 Data_Emissao,
					 Apolice_Renovada,
					 Numero_Proposta,
					 Data_Proposta,
					 Inicio_Vigencia,
					 Fim_Vigencia,
					 Razao_Social,
					 CNPJ 
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_Recupera_KIT_RESIDENCIAL_SIES] ''''' + @PontoDeParada + ''''''') PRP'
EXEC (@COMANDO)     
 
                  
SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM [dbo].[KIT_Residencial_SIES_TEMP] PRP
                    
  /*********************************************************************************************************************/
  
END

--Atualiza o IDContratoAnterior da apolice
;WITH CT AS (
	SELECT  C.NumeroContrato, k.Apolice_Renovada AS ApoliceRenovada_SIES , C1.ID AS IDNovoContratoAnterior, C1.NumeroContrato AS ApoliceRenovada_ODS-- A.IDContratoAnterior, C.ID AS IDContrato
	FROM Dados.RenovacaoPatrimonial AS K
	INNER JOIN Dados.Contrato AS C 
	ON K.Numero_Apolice=C.NumeroContrato
	INNER JOIN Dados.Contrato AS C1
	ON C1.NumeroContrato=Apolice_Renovada
	--OUTER APPLY (SELECT ID AS IDContratoAnterior FROM Dados.Contrato AS CTI WHERE CTI.NumeroContrato=K.Apolice_Renovada) AS A
	WHERE --C.IDContratoAnterior is not null
	Apolice_Renovada IS NOT NULL
)
--SELECT DISTINCT CT.ApoliceRenovada_ODS, CT.ApoliceRenovada_SIES, CT.NumeroContrato, C.NumeroContrato FROM CT INNER JOIN Dados.Contrato AS C
UPDATE Dados.Contrato SET IDContratoAnterior=CT.IDNovoContratoAnterior FROM Dados.Contrato AS C INNER JOIN CT
ON CT.NumeroContrato=C.NumeroContrato
--WHERE CT.ApoliceRenovada_ODS<>CT.ApoliceRenovada_SIES


END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     	      	

 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KIT_Residencial_SIES_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[KIT_Residencial_SIES_TEMP];





