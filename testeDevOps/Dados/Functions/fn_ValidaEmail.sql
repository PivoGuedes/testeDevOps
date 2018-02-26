


CREATE FUNCTION [Dados].[fn_ValidaEmail] (@EmailAdress varchar(255))   
RETURNS varchar(255) 
AS BEGIN

DECLARE @AlphabetPlus VARCHAR(255)
      , @Max INT 
      , @Pos INT 
      , @OK BIT  
	  , @EmailAdressReturn VARCHAR(255) = @EmailAdress

IF @EmailAdress IS NULL 
   OR NOT @EmailAdress LIKE '_%@__%.__%' 
   OR CHARINDEX(' ',LTRIM(RTRIM(@EmailAdress))) > 0
       RETURN('')

SELECT @AlphabetPlus = 'abcdefghijklmnopqrstuvwxyz01234567890_-.@'
     , @Max = LEN(@EmailAdress)
     , @Pos = 0
     , @OK = 1

WHILE @Pos < @Max AND @OK = 1 BEGIN
    SET @Pos = @Pos + 1
    IF NOT @AlphabetPlus LIKE '%' + SUBSTRING(@EmailAdress, @Pos, 1) + '%' 
        --SET @OK = 0
		SET @EmailAdressReturn = NULL
END 

RETURN REPLACE(@EmailAdressReturn,' ','') 
END


