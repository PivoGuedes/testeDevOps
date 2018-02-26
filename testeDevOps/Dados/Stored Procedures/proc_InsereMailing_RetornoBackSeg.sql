/*
	Autor: Andre Anselmo
	Data Criação: 28/05/2015

	Descrição: 
	
	Última alteração : 

*/
--[Corporativo].[proc_InsereMailing_RetornoBackseg]
/*******************************************************************************
	Nome: Corporativo.Dados.proc_InsereMailing_RetornoBackseg
	Descrição: 
		
	Parâmetros de entrada:
					
	Retorno:

*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereMailing_RetornoBackSeg] 
AS
    
BEGIN TRY		
	    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 

 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RETORNO_MAILINGBACKSEG_TEMP]') AND type in (N'U'))
	DROP TABLE [dbo].[RETORNO_MAILINGBACKSEG_TEMP];


CREATE TABLE [dbo].[RETORNO_MAILINGBACKSEG_TEMP](
	Cod_cliente VARCHAR(100)         
	,Num_titulo VARCHAR(100)            
	,Data_vigencia DATE         
	,Data_acao DATE
	,Num_cpf VARCHAR(100)         
	,Nom_devedor  VARCHAR(100)                                                                                                                                                                                                       
	,End_Com_Cargo  VARCHAR(100)                          
	,End_res_UF  VARCHAR(100)          
	,Tipo_fone  VARCHAR(100)                     
	,Cod_acao  VARCHAR(100)                      
	,Hora_ACAO VARCHAR(100)                      
	,Fone_1  VARCHAR(100)                        
	,Fone_2  VARCHAR(100)                        
	,Fone_3  VARCHAR(100)                        
	,Fone_4  VARCHAR(100)                        
	,Fone_5  VARCHAR(100)                        
	,Dcr_sub_acao  VARCHAR(100)                                                                                                                                                                                                      
	,Email_1  VARCHAR(100)                                                                                                                                                                                                           
	,Email_2  VARCHAR(100)                                                                                                                                                                                                           
	,Num_Fone  VARCHAR(100)                      
	,APPL  VARCHAR(100)                          
	,Cod_fase  VARCHAR(100)           
	,Codigo INT           
) 
;

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'RETORNO_MAILINGBACKSEG'

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[RETORNO_MAILINGBACKSEG_TEMP]
                SELECT 
					Cod_cliente          
					,Num_titulo   
					,Data_vigencia
					,Data_acao
					,Num_cpf              
					,Nom_devedor                                                                                                                                                                                              
					,End_Com_Cargo                                      
					,End_res_UF 
					,Tipo_fone            
					,Cod_acao             
					,Hora_ACAO            
					,Fone_1               
					,Fone_2               
					,Fone_3               
					,Fone_4               
					,Fone_5               
					,Dcr_sub_acao                                                                                                                                                                                             
					,Email_1                                                                                                                                                                                                  
					,Email_2                                                                                                                                                                                                  
					,Num_Fone             
					,APPL          
					,Cod_fase             
					,Codigo
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaMailing_RetornoBackSeg] ''''' + @PontoDeParada + ''''''') PRP'
EXEC (@COMANDO)     

                
SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM [dbo].[RETORNO_MAILINGBACKSEG_TEMP] PRP
                  
/*********************************************************************************************************************/


WHILE @MaiorCodigo IS NOT NULL
BEGIN 
 --   PRINT @MaiorCodigo

	INSERT INTO Mailing.Atendimento_BackSeg
	(
					Cod_cliente          
					,Num_titulo   
					,Data_vigencia
					,Data_acao
					,Num_cpf              
					,Nom_devedor                                                                                                                                                                                              
					,End_Com_Cargo                                      
					,End_res_UF 
					,Tipo_fone            
					,Cod_acao             
					,Hora_ACAO            
					,Fone_1               
					,Fone_2               
					,Fone_3               
					,Fone_4               
					,Fone_5               
					,Dcr_sub_acao                                                                                                                                                                                             
					,Email_1                                                                                                                                                                                                  
					,Email_2                                                                                                                                                                                                  
					,Num_Fone             
					,APPL                 
					,Cod_fase             
	)
	SELECT 
					Cod_cliente          
					,Num_titulo   
					,Data_vigencia
					,Data_acao
					,Num_cpf              
					,Nom_devedor                                                                                                                                                                                              
					,End_Com_Cargo                                      
					,End_res_UF 
					,Tipo_fone            
					,Cod_acao             
					,Hora_ACAO            
					,Fone_1               
					,Fone_2               
					,Fone_3               
					,Fone_4               
					,Fone_5               
					,Dcr_sub_acao                                                                                                                                                                                             
					,Email_1                                                                                                                                                                                                  
					,Email_2                                                                                                                                                                                                  
					,Num_Fone             
					,APPL                 
					,Cod_fase             
	FROM dbo.RETORNO_MAILINGBACKSEG_TEMP
  
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'RETORNO_MAILINGBACKSEG'
  /*************************************************************************************/
  
  
 /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[RETORNO_MAILINGBACKSEG_TEMP] 
  
  /*********************************************************************************************************************/
SET @COMANDO = 'INSERT INTO [dbo].[RETORNO_MAILINGBACKSEG_TEMP]
                SELECT 
					Cod_cliente          
					,Num_titulo   
					,Data_vigencia
					,Data_acao
					,Num_cpf              
					,Nom_devedor                                                                                                                                                                                              
					,End_Com_Cargo                                      
					,End_res_UF 
					,Tipo_fone            
					,Cod_acao             
					,Hora_ACAO            
					,Fone_1               
					,Fone_2               
					,Fone_3               
					,Fone_4               
					,Fone_5               
					,Dcr_sub_acao                                                                                                                                                                                             
					,Email_1                                                                                                                                                                                                  
					,Email_2                                                                                                                                                                                                  
					,Num_Fone             
					,APPL                 
					,Cod_fase  
					,Codigo           
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaMailing_RetornoBackSeg] ''''' + @PontoDeParada + ''''''') PRP'
EXEC (@COMANDO)     
                  
SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM [dbo].[RETORNO_MAILINGBACKSEG_TEMP] PRP
                    
  /*********************************************************************************************************************/
  
END

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     	      	

 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RETORNO_MAILINGBACKSEG_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[RETORNO_MAILINGBACKSEG_TEMP];





