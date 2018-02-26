Create Function Transacao.UDF_Split
(           
      @String VARCHAR(MAX), 
      @delimiter VARCHAR(50)
)
RETURNS @Table TABLE(  
	Splitcolumn VARCHAR(MAX)
) 
BEGIN
    Declare @Xml AS XML  
    SET @Xml = cast(('<A>'+replace(@String,@delimiter,'</A><A>')+'</A>') AS XML)  
    INSERT INTO @Table SELECT A.value('.', 'varchar(max)') as [Column] FROM @Xml.nodes('A') AS FN(A)  
	RETURN
END
