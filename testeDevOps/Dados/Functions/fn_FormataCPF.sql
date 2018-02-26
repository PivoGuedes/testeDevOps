﻿
CREATE function [Dados].[fn_FormataCPF] (@CPF VARCHAR(20))
RETURNS VARCHAR(25)
AS
BEGIN


IF @CPF = '' 
RETURN @CPF

DECLARE @CPFFormated VARCHAR(20) = RIGHT('000000000' + CAST(REPLACE(REPLACE(LTRIM(RTRIM(@CPF)),'-',''),'.','') AS varchar(15)),11)

RETURN SUBSTRING(@CPFFormated,1,3) + '.' + SUBSTRING(@CPFFormated,4,3) + '.' + SUBSTRING(@CPFFormated,7,3) + '-' + SUBSTRING(@CPFFormated,10,2) 
END