﻿CREATE FUNCTION Transacao.fn_GenerateSlug
(   
    @str VARCHAR(100)
)
RETURNS VARCHAR(100)
AS
BEGIN
DECLARE @TEXTO_FORMATADO VARCHAR(MAX)
	SET @TEXTO_FORMATADO = UPPER(@str)
	    COLLATE sql_latin1_general_cp1250_ci_as

	SET @TEXTO_FORMATADO = @TEXTO_FORMATADO
	    COLLATE sql_latin1_general_cp1251_ci_as
	SET @TEXTO_FORMATADO = LOWER(REPLACE(@TEXTO_FORMATADO,' ','-'))
	RETURN @TEXTO_FORMATADO
END
