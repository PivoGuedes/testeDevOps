CREATE function [Dados].[fn_trataTelefoneSF] (@DDD VARCHAR(5) = '', @Telefone VARCHAR(25))
RETURNS VARCHAR(25)
AS
BEGIN

IF @Telefone = '' 
RETURN @Telefone


Declare @Pais varchar (6) = '55'
--Declare @DDD VARCHAR(5) = '061'
--Declare @Telefone VARCHAR(20) = '92533388'

IF @DDD IS NULL 
	SET @DDD = ''

SET @DDD = RIGHT(REPLACE(REPLACE(@DDD,')',''),'(',''),2)


SET @Telefone = REPLACE(REPLACE(REPLACE(REPLACE(@Telefone,'-',''), ' ',''),')',''),'(','')

IF LEFT(@Telefone,1) = '0'
	SET @Telefone = RIGHT( @Telefone, LEN(@Telefone) - 1)

IF LEN(@Telefone) >= 11 
BEGIN
--PRINT 0
	SET @DDD = LEFT(@TELEFONE,2)
	SET @Telefone = RIGHT(@TELEFONE, 9)
END 

IF LEN(@Telefone) = 10
BEGIN
--PRINT 1
	SET @DDD = LEFT(@TELEFONE,2)
	SET @Telefone = RIGHT(@TELEFONE, 8)
END		
--SET @Telefone =  @Pais + @DDD + @Telefone
SET @Telefone = @DDD + @Telefone
--SET @Telefone =  @Pais + ' ' + @DDD + ' ' + @Telefone


RETURN @Telefone
END
