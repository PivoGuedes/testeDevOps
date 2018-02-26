CREATE FUNCTION [dbo].[remove_acento](@Texto varchar(8000))
returns varchar(50)  
AS  
 
BEGIN
         declare @SemAcento varchar(50)   
 
         select @SemAcento  = replace(@Texto COLLATE SQL_Latin1_General_CP1_CI_AS ,'á','_')   
         select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'à','_')   
         select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'ã','_')   
         select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'â','_')   
         select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'é','_')   
         select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'è','_')   
         select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'ê','_')   
         select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'í','_')   
         select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'ì','_')   
         select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'î','_')   
         select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'ó','_')   
         select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'ò','_')   
         select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'ô','_')   
         select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'õ','_')   
         select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'ú','_')   
         select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'ù','_')   
         select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'û','_')   
         select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'ü','_')   
         select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'ç','_') 
		 select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'ª','_')
		 select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'º','_') 
		 select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'''','_')  
		 select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'´','_')
		 select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'Ý','_')
		 select @SemAcento = replace(@SemAcento collate SQL_Latin1_General_CP1_CI_AS,'Ø','_')
 
         return (UPPER(@SemAcento))  
END

--=====================================================================

--( @TEXTO VARCHAR(MAX) ) 
--RETURNS VARCHAR(MAX) AS 
--BEGIN 
--DECLARE @TEXTO_FORMATADO VARCHAR(MAX) 
---- O trecho abaixo possibilita que caracteres como "º" ou "ª" 
---- sejam convertidos para "o" ou "a", respectivamente 
--SET @TEXTO_FORMATADO = UPPER(@TEXTO) COLLATE SQL_Latin1_General_CP1_CI_As 


---- O trecho abaixo remove acentos e outros caracteres especiais, 
---- substituindo os mesmos por letras normais 

--SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO COLLATE SQL_Latin1_General_CP1_CI_AS ,'á','_')
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO COLLATE sql_latin1_general_cp1250_ci_as,'à','_')   
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO collate sql_latin1_general_cp1250_ci_as,'ã','_')   
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO collate sql_latin1_general_cp1250_ci_as,'â','_')   
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO collate sql_latin1_general_cp1250_ci_as,'é','_')   
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO collate sql_latin1_general_cp1250_ci_as,'è','_')   
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO collate sql_latin1_general_cp1250_ci_as,'ê','_')   
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO collate sql_latin1_general_cp1250_ci_as,'í','_')   
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO collate sql_latin1_general_cp1250_ci_as,'ì','_')   
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO collate sql_latin1_general_cp1250_ci_as,'î','_')   
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO collate sql_latin1_general_cp1250_ci_as,'ó','_')   
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO collate sql_latin1_general_cp1250_ci_as,'ò','_')   
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO collate sql_latin1_general_cp1250_ci_as,'ô','_')   
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO collate sql_latin1_general_cp1250_ci_as,'õ','_')   
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO collate sql_latin1_general_cp1250_ci_as,'ú','_')   
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO collate sql_latin1_general_cp1250_ci_as,'ù','_')   
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO collate sql_latin1_general_cp1250_ci_as,'û','_')   
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO collate sql_latin1_general_cp1250_ci_as,'ü','_')   
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO collate sql_latin1_general_cp1250_ci_as,'ç','_') 
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO collate sql_latin1_general_cp1250_ci_as,'ª','_')
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO collate sql_latin1_general_cp1250_ci_as,'º','_') 
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO collate sql_latin1_general_cp1250_ci_as,'''','_')  
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO collate sql_latin1_general_cp1250_ci_as,'´','_')
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO collate sql_latin1_general_cp1250_ci_as,'Ý','_')
----SET @TEXTO_FORMATADO = replace(@TEXTO_FORMATADO collate sql_latin1_general_cp1250_ci_as,'Ø','_')

--RETURN @TEXTO_FORMATADO 
--END 
--GO

--------------------------------------------------------------------------
