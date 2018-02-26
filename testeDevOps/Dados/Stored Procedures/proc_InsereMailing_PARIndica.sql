

/*
	Autor: Andre Anselmo
	Data Criação: 15/05/2015

	Descrição: 
	
	Última alteração : 

*/
--[Corporativo].[proc_RecuperaMailing_PARIndica]
/*******************************************************************************
	Nome: Corporativo.Dados.proc_InsereMailing_PARIndica
	Descrição: 
		
	Parâmetros de entrada:
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereMailing_PARIndica] 
AS
    
BEGIN TRY		
	    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 

 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MAILINGPARINDICA_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[MAILINGPARINDICA_TEMP];


CREATE TABLE [dbo].[MAILINGPARINDICA_TEMP](
	Codigo	int	
	,CodCampanha	varchar(50)
	,NomeCampanha	varchar(50)
	,Produto	varchar(100)
	,Objetivo	varchar(100)
	,CPF	varchar(20)
	,Nome	varchar(100)
	,DDDTelefone	varchar(30)
	,TipoTelefone	varchar(50)
	,DDD2Telefone2	varchar(50)
	,TipoTelefone2	varchar(50)
	,DDD3Telefone3	varchar(50)
	,TipoTelefone3	varchar(50)
	,Email	varchar(100)
	,Data_de_Nascimento	varchar(50)
	,ProdutoOferta	varchar(100)
	,Posse_Produto_GCS	varchar(100)
	,Tipo_Cliente	varchar(100)
	,Agencia_Vinculo	varchar(20)
	,Agencia_Indicacao	varchar(20)
	,Indicador	varchar(100)
	,AsVens_Indicador	varchar(100)
	,Regional_PAR	varchar(200)
	,Superintendencia_Regional	varchar(200)
	,Termino_Vigencia_Atual	varchar(200)
	,Campo_X1	varchar(200)
	,Campo_X2	varchar(200)
	,Campo_X3	varchar(200)
	,Campo_X4	varchar(200)
	,Campo_X5	varchar(200)
	,Campo_X6	varchar(200)
	,Campo_X7	varchar(200)
	,Campo_X8	varchar(200)
	,Campo_X9	varchar(200)
	,Campo_X10	varchar(200)
	,Campo_X11	varchar(200)
	,Campo_X12	varchar(200)
	,Campo_X13	varchar(200)
	,Campo_X14	varchar(200)
	,Campo_X15	varchar(200)
	,Campo_X16	varchar(200)
	,Campo_X17	varchar(200)
	,Campo_X18	varchar(200)
	,Campo_X19	varchar(200)
	,Campo_X20	varchar(200)
	,Campo_X21	varchar(200)
	,Campo_X22	varchar(200)
	,Campo_X23	varchar(200)
	,Campo_X24	varchar(200)
	,Campo_X25	varchar(200)
	,Campo_X26	varchar(200)
	,Campo_X27	varchar(200)
	,Campo_X28	varchar(200)
	,Campo_X29	varchar(200)
	,Campo_X30	varchar(200)
	,Campo_X31	varchar(200)
	,Campo_X32	varchar(200)
	,Campo_X33	varchar(200)
	,Campo_X34	varchar(200)
	,Campo_X35	varchar(200)
	,Campo_X36	varchar(200)
	,Campo_X37	varchar(200)
	,Campo_X38	varchar(200)
	,Campo_X39	varchar(200)
	,Campo_X40	varchar(200)
	,Campo_X41	varchar(200)
	,Campo_X42	varchar(200)
	,NomeArquivo	varchar(200)
	,DataHoraImportacao	datetime2	
) 
;


--UPDATE ControleDados.PontoParada SET PontoParada=0 WHERE NomeEntidade = 'MAILINGPARINDICA'

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'MAILINGPARINDICA'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[MAILINGPARINDICA_TEMP]
                SELECT 
					Codigo      
					,CodCampanha                                        
					,NomeCampanha                                       
					,Produto                                                                                              
					,Objetivo                                                                                             
					,CPF                  
					,Nome                                                                                                 
					,DDDTelefone                    
					,TipoTelefone                                       
					,DDD2Telefone2                                      
					,TipoTelefone2                                      
					,DDD3Telefone3                                      
					,TipoTelefone3                                      
					,Email                                                                                                
					,Data_de_Nascimento                                 
					,ProdutoOferta                                                                                        
					,Posse_Produto_GCS                                                                                    
					,Tipo_Cliente                                                                                         
					,Agencia_Vinculo      
					,Agencia_Indicacao    
					,Indicador                                                                                            
					,AsVens_Indicador                                                                                     
					,Regional_PAR                                                                                                                                                                                             
					,Superintendencia_Regional                                                                                                                                                                                
					,Termino_Vigencia_Atual                                                                                                                                                                                   
					,Campo_X1                                                                                                                                                                                                 
					,Campo_X2                                                                                                                                                                                                 
					,Campo_X3                                                                                                                                                                                                 
					,Campo_X4                                                                                                                                                                                                 
					,Campo_X5                         
					,Campo_X6                                                                                                                                                                                                 
					,Campo_X7                                                                                                                                                                                                 
					,Campo_X8                                                                                                                                                                                                 
					,Campo_X9                                                                                                                                                                                                 
					,Campo_X10                                                                                                                                                                                                
					,Campo_X11                                                                                                                                                                                                
					,Campo_X12                                                                                                                                                                                                
					,Campo_X13                                                                                                                                                                                                
					,Campo_X14                                                                                                                                                                                                
					,Campo_X15                                                                                                                                                                                                
					,Campo_X16                                                                                                                                                                                                
					,Campo_X17                                                                                                                                                                                                
					,Campo_X18                                                                                                                                                                                                
					,Campo_X19                                                                                                                                                                                                
					,Campo_X20                                                                                                                                                                                                
					,Campo_X21                                                                                                                                                                                                
					,Campo_X22                                                                                                                                                                                                
					,Campo_X23                                                                                                                                                                                                
					,Campo_X24                                                                                                                                                                                                
					,Campo_X25                                                                                                                             
					,Campo_X26                                                                                                                                                                                                
					,Campo_X27                                                                                                                                                                                                
					,Campo_X28                                                                                                                                                                                                
					,Campo_X29                                                                                                                                                                                                
					,Campo_X30                                                                                                                                                                                                
					,Campo_X31                                                                                                                                                                                                
					,Campo_X32                                                                                                                                                                                                
					,Campo_X33                                                                                                                                                                                                
					,Campo_X34                                                                                                                                                                                                
					,Campo_X35                                                                                                                                                                                                
					,Campo_X36                                                                                                                                                                                                
					,Campo_X37                                                                                                                                                                                                
					,Campo_X38                                                                                                                                                                                                
					,Campo_X39                                                                                                                                                                                                
					,Campo_X40                                                                                                                                                                                                
					,Campo_X41                                                                                                                                                                                                
					,Campo_X42                                                                                                                                                                                                
					,NomeArquivo                                                                                                                                                                                              
					,DataHoraImportacao
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaMailing_PARIndica] ''''' + @PontoDeParada + ''''''') PRP'
EXEC (@COMANDO)     

                
SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM [dbo].[MAILINGPARINDICA_TEMP] PRP
                  
/*********************************************************************************************************************/


WHILE @MaiorCodigo IS NOT NULL
BEGIN 
 --   PRINT @MaiorCodigo

	INSERT INTO Mailing.MailingPARIndica 
	(
		CodCampanha                                        
		,NomeCampanha                                       
		,Produto                                                                                              
		,Objetivo                                                                                             
		,CPF                  
		,Nome                                                                                                 
		,DDDTelefone                    
		,TipoTelefone                                       
		,DDD2Telefone2                                      
		,TipoTelefone2                                      
		,DDD3Telefone3                                      
		,TipoTelefone3                                      
		,Email                                                                                                
		,Data_de_Nascimento                                 
		,ProdutoOferta                                                                                        
		,Posse_Produto_GCS                                                                                    
		,Tipo_Cliente                                                                                         
		,Agencia_Vinculo      
		,Agencia_Indicacao    
		,Indicador                                                                                            
		,AsVens_Indicador                                                                                     
		,Regional_PAR                                                                                                                                                                                             
		,Superintendencia_Regional                                                                                                                                                                                
		,Termino_Vigencia_Atual                                                                                                                                                                                   
		,Campo_X1                                                                                                                                                                                                 
		,Campo_X2                                                                                                                                                                                                 
		,Campo_X3                                                                                                                                                                                                 
		,Campo_X4                                                                                                                                                                                                 
		,Campo_X5                         
		,Campo_X6                                                                                                                                                                                                 
		,Campo_X7                                                                                                                                                                                                 
		,Campo_X8                                                                                                                                                                                                 
		,Campo_X9                                                                                                                                                                                                 
		,Campo_X10                                                                                                                                                                                                
		,Campo_X11                                                                                                                                                                                                
		,Campo_X12                                                                                                                                                                                                
		,Campo_X13                                                                                                                                                                                                
		,Campo_X14                                                                                                                                                                                                
		,Campo_X15                                                                                                                                                                                                
		,Campo_X16                                                                                                                                                                                                
		,Campo_X17                                                                                                                                                                                                
		,Campo_X18                                                                                                                                                                                                
		,Campo_X19                                                                                                                                                                                                
		,Campo_X20                                                                                                                                                                                                
		,Campo_X21                                                                                                                                                                                                
		,Campo_X22                                                                                                                                                                                                
		,Campo_X23                                                                                                                                                                                                
		,Campo_X24                                                                                                                                                                                                
		,Campo_X25                                                                                                                             
		,Campo_X26                                                                                                                                                                                                
		,Campo_X27                                                                                                                                                                                                
		,Campo_X28                                                                                                                                                                                                
		,Campo_X29                                                                                                                                                                                                
		,Campo_X30                                                                                                                                                                                                
		,Campo_X31                                                                                                                                                                                                
		,Campo_X32                                                                                                                                                                                                
		,Campo_X33                                                                                                                                                                                                
		,Campo_X34                                                                                                                                                                                                
		,Campo_X35                                                                                                                                                                                                
		,Campo_X36                                                                                                                                                                                                
		,Campo_X37                                                                                                                                                                                                
		,Campo_X38                                                                                                                                                                                                
		,Campo_X39                                                                                                                                                                                                
		,Campo_X40                                                                                                                                                                                                
		,Campo_X41                                                                                                                                                                                                
		,Campo_X42                                                                                                                                                                                                
		,NomeArquivo	
	)
	SELECT 
		CodCampanha                                        
		,NomeCampanha                                       
		,Produto                                                                                              
		,Objetivo                                                                                             
		,CPF                  
		,Nome                                                                                                 
		,DDDTelefone                    
		,TipoTelefone                                       
		,DDD2Telefone2                                      
		,TipoTelefone2                                      
		,DDD3Telefone3                                      
		,TipoTelefone3                                      
		,Email                                                                                                
		,Data_de_Nascimento                                 
		,ProdutoOferta                                                                                        
		,Posse_Produto_GCS                                                                                    
		,Tipo_Cliente                                                                                         
		,Agencia_Vinculo      
		,Agencia_Indicacao    
		,Indicador                                                                                            
		,AsVens_Indicador                                                                                     
		,Regional_PAR                                                                                                                                                                                             
		,Superintendencia_Regional                                                                                                                                                                                
		,Termino_Vigencia_Atual                                                                                                                                                                                   
		,Campo_X1                                                                                                                                                                                                 
		,Campo_X2                                                                                                                                                                                                 
		,Campo_X3                                                                                                                                                                                                 
		,Campo_X4                                                                                                                                                                                                 
		,Campo_X5                         
		,Campo_X6                                                                                                                                                                                                 
		,Campo_X7                                                                                                                                                                                                 
		,Campo_X8                                                                                                                                                                                                 
		,Campo_X9                                                                                                                                                                                                 
		,Campo_X10                                                                                                                                                                                                
		,Campo_X11                                                                                                                                                                                                
		,Campo_X12                                                                                                                                                                                                
		,Campo_X13                                                                                                                                                                                                
		,Campo_X14                                                                                                                                                                                                
		,Campo_X15                                                                                                                                                                                                
		,Campo_X16                                                                                                                                                                                                
		,Campo_X17                                                                                                                                                                                                
		,Campo_X18                                                                                                                                                                                                
		,Campo_X19                                                                                                                                                                                                
		,Campo_X20                                                                                                                                                                                                
		,Campo_X21                                                                                                                                                                                                
		,Campo_X22                                                                                                                                                                                                
		,Campo_X23                                                                                                                                                                                                
		,Campo_X24                                                                                                                                                                                                
		,Campo_X25                                                                                                                             
		,Campo_X26                                                                                                                                                                                                
		,Campo_X27                                                                                                                                                                                                
		,Campo_X28                                                                                                                                                                                                
		,Campo_X29                                                                                                                                                                                                
		,Campo_X30                                                                                                                                                                                                
		,Campo_X31                                                                                                                                                                                                
		,Campo_X32                                                                                                                                                                                                
		,Campo_X33                                                                                                                                                                                                
		,Campo_X34                                                                                                                                                                                                
		,Campo_X35                                                                                                                                                                                                
		,Campo_X36                                                                                                                                                                                                
		,Campo_X37                                                                                                                                                                                                
		,Campo_X38                                                                                                                                                                                                
		,Campo_X39                                                                                                                                                                                                
		,Campo_X40                                                                                                                                                                                                
		,Campo_X41                                                                                                                                                                                                
		,Campo_X42                                                                                                                                                                                                
		,NomeArquivo
	FROM dbo.MAILINGPARINDICA_TEMP
  
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'MAILINGPARINDICA'
  /*************************************************************************************/
  
  
 /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[MAILINGPARINDICA_TEMP] 
  
  /*********************************************************************************************************************/
SET @COMANDO = 'INSERT INTO [dbo].[MAILINGPARINDICA_TEMP]
                SELECT 
					Codigo      
					,CodCampanha                                        
					,NomeCampanha                                       
					,Produto                                                                                              
					,Objetivo                                                                                             
					,CPF                  
					,Nome                                                                                                 
					,DDDTelefone                    
					,TipoTelefone                                       
					,DDD2Telefone2                                      
					,TipoTelefone2                                      
					,DDD3Telefone3                                      
					,TipoTelefone3                                      
					,Email                                                                                                
					,Data_de_Nascimento                                 
					,ProdutoOferta                                                                                        
					,Posse_Produto_GCS                                                                                    
					,Tipo_Cliente                                                                                         
					,Agencia_Vinculo      
					,Agencia_Indicacao    
					,Indicador                                                                                            
					,AsVens_Indicador                                                                                     
					,Regional_PAR                                                                                                                                                                                             
					,Superintendencia_Regional                                                                                                                                                                                
					,Termino_Vigencia_Atual                                                                                                                                                                                   
					,Campo_X1                                                                                                                                                                                                 
					,Campo_X2                                                                                                                                                                                                 
					,Campo_X3                                                                                                                                                                                                 
					,Campo_X4                                                                                                                                                                                                 
					,Campo_X5                         
					,Campo_X6                                                                                                                                                                                                 
					,Campo_X7                                                                                                                                                                                                 
					,Campo_X8                                                                                                                                                                                                 
					,Campo_X9                                                                                                                                                                                                 
					,Campo_X10                                                                                                                                                                                                
					,Campo_X11                                                                                                                                                                                                
					,Campo_X12                                                                                                                                                                                                
					,Campo_X13                                                                                                                                                                                                
					,Campo_X14                                                                                                                                                                                                
					,Campo_X15                                                                                                                                                                                                
					,Campo_X16                                                                                                                                                                                                
					,Campo_X17                                                                                                                                                                                                
					,Campo_X18                                                                                                                                                                                                
					,Campo_X19                                                                                                                                                                                                
					,Campo_X20                                                                                                                                                                                                
					,Campo_X21                                                                                                                                                                                                
					,Campo_X22                                                                                                                                                                                                
					,Campo_X23                                                                                                                                                                                                
					,Campo_X24                                                                                                                                                                                                
					,Campo_X25                                                                                                                             
					,Campo_X26                                                                                                                                                                                                
					,Campo_X27                                                                                                                                                                                                
					,Campo_X28                                                                                                                                                                                                
					,Campo_X29                                                                                                                                                                                                
					,Campo_X30                                                                                                                                                                                                
					,Campo_X31                                                                                                                                                                                                
					,Campo_X32                                                                                                                                                                                                
					,Campo_X33                                                                                                                                                                                                
					,Campo_X34                                                                                                                                                                                                
					,Campo_X35                                                                                                                                                                                                
					,Campo_X36                                                                                                                                                                                                
					,Campo_X37                                                                                                                                                                                                
					,Campo_X38                                                                                                                                                                                                
					,Campo_X39                                                                                                                                                                                                
					,Campo_X40                                                                                                                                                                                                
					,Campo_X41                                                                                                                                                                                                
					,Campo_X42                                                                                                                                                                                                
					,NomeArquivo                                                                                                                                                                                              
					,DataHoraImportacao
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaMailing_PARIndica] ''''' + @PontoDeParada + ''''''') PRP'
EXEC (@COMANDO)     


                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM [dbo].[MAILINGPARINDICA_TEMP] PRP
                    
  /*********************************************************************************************************************/
  
END

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     	      	

 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MAILINGPARINDICA_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[MAILINGPARINDICA_TEMP];



