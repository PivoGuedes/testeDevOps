

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
CREATE PROCEDURE [Dados].[proc_InsereRetornoMailing_BackSeg] 
AS
    
BEGIN TRY		
	    
DECLARE @PontoDeParada AS VARCHAR(400)
DECLARE @MaiorCodigo AS BIGINT
DECLARE @ParmDefinition NVARCHAR(500)
DECLARE @COMANDO AS NVARCHAR(max) 

 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RETORNOMAILINGBACKSEG_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[RETORNOMAILINGBACKSEG_TEMP];


CREATE TABLE [dbo].[RETORNOMAILINGBACKSEG_TEMP](
Data_Vigencia DATE,
Data_Acao DATE,
Cod_Cliente VARCHAR(200),
Num_Titulo VARCHAR(200),
Num_CPF VARCHAR(200),
Nom_Devedor VARCHAR(200),
End_Com_Cargo VARCHAR(200),
End_Res_UF VARCHAR(200),
Tipo_Fone VARCHAR(200),
Cod_Acao VARCHAR(200),
Hora_Acao VARCHAR(200),
Fone_1 VARCHAR(200),
Fone_2 VARCHAR(200),
Fone_3 VARCHAR(200),
Fone_4 VARCHAR(200),
Fone_5 VARCHAR(200),
Dcr_Sub_Acao VARCHAR(200),
Email_1 VARCHAR(200),
Email_2 VARCHAR(200),
Num_Fone VARCHAR(200),
APPL VARCHAR(200),
Cod_Fase VARCHAR(200),
Codigo VARCHAR(200)
) 
;

--SELECT * FROM ControleDados.PontoParada
--INSERT INTO ControleDados.PontoParada ( NomeEntidade, PontoParada) values ('RETORNOMAILINGBACKSEG_TEMP',0)

--UPDATE ControleDados.PontoParada SET PontoParada=0 WHERE NomeEntidade = 'MAILINGPARINDICA'

SELECT @PontoDeParada = PontoParada
FROM ControleDados.PontoParada
WHERE NomeEntidade = 'RETORNO_MAILINGBACKSEG'
               --select @PontoDeParada = 20007037

/*********************************************************************************************************************/               
/*Recupeara maior Código do retorno*/
/*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[RETORNOMAILINGBACKSEG_TEMP]
                SELECT 
					Data_Vigencia, 
					Data_Acao, 
					Cod_Cliente,
					Num_Titulo,
					Num_CPF,
					Nom_Devedor,
					End_Com_Cargo,
					End_Res_UF,
					Tipo_Fone,
					Cod_Acao,
					Hora_Acao,
					Fone_1,
					Fone_2,
					Fone_3,
					Fone_4,
					Fone_5,
					Dcr_Sub_Acao,
					Email_1,
					Email_2,
					Num_Fone,
					APPL,
					Cod_Fase,
					Codigo
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaRetornoMailing_BackSeg] ''''' + @PontoDeParada + ''''''') PRP'
EXEC (@COMANDO)     

                
SELECT @MaiorCodigo= MAX(PRP.Codigo)
FROM [dbo].[RETORNOMAILINGBACKSEG_TEMP] PRP
                  
/*********************************************************************************************************************/


WHILE @MaiorCodigo IS NOT NULL
BEGIN 
 --   PRINT @MaiorCodigo

	INSERT INTO Mailing.Atendimento_BackSeg
	(
		Data_Vigencia, 
		Data_Acao, 
		Cod_Cliente,
		Num_Titulo,
		Num_CPF,
		Nom_Devedor,
		End_Com_Cargo,
		End_Res_UF,
		Tipo_Fone,
		Cod_Acao,
		Hora_Acao,
		Fone_1,
		Fone_2,
		Fone_3,
		Fone_4,
		Fone_5,
		Dcr_Sub_Acao,
		Email_1,
		Email_2,
		Num_Fone,
		APPL,
		Cod_Fase
	)
	SELECT 
		Data_Vigencia, 
		Data_Acao, 
		Cod_Cliente,
		Num_Titulo,
		Num_CPF,
		Nom_Devedor,
		End_Com_Cargo,
		End_Res_UF,
		Tipo_Fone,
		Cod_Acao,
		Hora_Acao,
		Fone_1,
		Fone_2,
		Fone_3,
		Fone_4,
		Fone_5,
		Dcr_Sub_Acao,
		Email_1,
		Email_2,
		Num_Fone,
		APPL,
		Cod_Fase
	FROM dbo.RETORNOMAILINGBACKSEG_TEMP
  
  /*************************************************************************************/
  /*Atualiza o ponto de parada, igualando-o ao maior código trabalhado no comando acima*/
  /*************************************************************************************/
  SET @PontoDeParada = @MaiorCodigo
  
  UPDATE ControleDados.PontoParada 
  SET PontoParada = @MaiorCodigo
  WHERE NomeEntidade = 'RETORNO_MAILINGBACKSEG'
  /*************************************************************************************/
  
  
 /*********************************************************************************************************************/
  TRUNCATE TABLE [dbo].[RETORNOMAILINGBACKSEG_TEMP] 
  
  /*********************************************************************************************************************/

SET @COMANDO = 'INSERT INTO [dbo].[RETORNOMAILINGBACKSEG_TEMP]
                SELECT 
					Data_Vigencia, 
					Data_Acao, 
					Cod_Cliente,
					Num_Titulo,
					Num_CPF,
					Nom_Devedor,
					End_Com_Cargo,
					End_Res_UF,
					Tipo_Fone,
					Cod_Acao,
					Hora_Acao,
					Fone_1,
					Fone_2,
					Fone_3,
					Fone_4,
					Fone_5,
					Dcr_Sub_Acao,
					Email_1,
					Email_2,
					Num_Fone,
					APPL,
					Cod_Fase,
					Codigo
                FROM OPENQUERY ([OBERON], 
                ''EXEC [Fenae].[Corporativo].[proc_RecuperaRetornoMailing_BackSeg] ''''' + @PontoDeParada + ''''''') PRP'
EXEC (@COMANDO)     


                  
  SELECT @MaiorCodigo= MAX(PRP.Codigo)
  FROM [dbo].[RETORNOMAILINGBACKSEG_TEMP] PRP
                    
  /*********************************************************************************************************************/
  
END

END TRY                
BEGIN CATCH
	
  EXEC CleansingKit.dbo.proc_RethrowError	
 -- RETURN @@ERROR	
END CATCH     	      	

 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RETORNOMAILINGBACKSEG_TEMP]') AND type in (N'U') /*ORDER BY NAME*/)
	DROP TABLE [dbo].[RETORNOMAILINGBACKSEG_TEMP];






