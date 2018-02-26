CREATE FUNCTION [Dados].[fn_TrataNumeroTelefone] (@NumeroDDD Int, @NumeroTelefone bigint)
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
--	   IF (LEFT(@NumeroDDD, 1) = '1') --or @NumeroDDD in (11,12,13,14,15,16,17,18,19,21,22,24,27,28,31,32,33,34,35,36,37,38,39,61,62,63,64,65,66,67,68,69,71,72,73,74,75,76,77,78,79,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99))
	      BEGIN
		    IF LEN(@NumeroTelefone) <> 9
		      BEGIN
			   IF LEN(@NumeroTelefone) = 8 
			     BEGIN
				   IF LEFT(@NumeroTelefone,1) in ('1','2','3','4','5','6')
					 BEGIN
					   SET @Retorno = Cast(@NumeroDDD as varchar(2)) + Cast(@NumeroTelefone as varchar(10))
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
	  --ELSE
	  --   BEGIN
		 --  IF LEN(@NumeroTelefone) <> 8
		 --     BEGIN
			--   SET @Retorno = NULL
		 --     END 
		 --  ELSE
		 --     BEGIN
			--    SET @Retorno = Cast(@NumeroDDD as varchar(2)) + Cast(@NumeroTelefone as varchar(10))
			--  END
		 --END
 -- PRINT @Retorno 
   RETURN @Retorno
END
