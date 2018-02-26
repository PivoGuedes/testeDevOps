


--select Corporativo.[Dados].[fn_TrataNumeroCelular] (31, 31346798)


CREATE FUNCTION [Dados].[fn_TrataNumeroCelular] (@NumeroDDD Int, @NumeroTelefone bigint)
RETURNS VARCHAR(20)
AS
BEGIN
   DECLARE @Retorno varchar(20)

   IF @NumeroDDD IS NULL OR @NumeroDDD = 0 OR @NumeroTelefone IS NULL OR @NumeroTelefone = 0
     SET @Retorno = NULL
   ELSE
     IF LEN(@NumeroDDD) <> 2 
	    SET @Retorno = NULL
     ELSE
		BEGIN
		    IF LEN(@NumeroTelefone) <> 9
		      BEGIN
			   IF LEN(@NumeroTelefone) = 8 
			     BEGIN
				   IF LEFT(@NumeroTelefone,1) in ('1','2','3','4','5','6')
					 BEGIN
					   SET @Retorno = NULL--Cast(@NumeroDDD as varchar(2)) + Cast(@NumeroTelefone as varchar(10))
				     END
				   ELSE 
				     BEGIN
					   IF LEFT(@NumeroTelefone,1) in ('7','8','9')
					      SET @Retorno = Cast(@NumeroDDD as varchar(2)) + '9' + Cast(@NumeroTelefone as varchar(10))  
					 END
		         END
				ELSE
				BEGIN
			       SET @Retorno = NULL
				END
		      END
			ELSE
		      BEGIN
			    SET @Retorno = Cast(@NumeroDDD as varchar(2)) + Cast(@NumeroTelefone as varchar(10))
			  END
		  END
 -- PRINT @Retorno 

   RETURN @Retorno
END
