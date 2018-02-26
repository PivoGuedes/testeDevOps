


/*******************************************************************************
	Nome: CORPORATIVO.dbo.fn_TrataNumeroPropostaZeroExtra
	Descrição: Função auxiliar para caso onde número proposta é gerado com um zero a mais, sendo
		na verdade o número da apólice com esse zero extra. Como isso pode aparecer tanto na proposta
		como no status, optamos por colocar em um procedimento para encapsular a lógica.
			As definições das regras foram validadas pela área de negócio junto com Egler Vieira em e-mail
		encaminhado no dia 28/05/2012 12:13h.

		
	Parâmetros de entrada:
		@NumeroProposta VARCHAR(20): número da proposta que será validada contra a regra definida pelo grupo PAR.
				
	Retorno:
		VARCHAR(20): Número da proposta tratada com a regra de negócio
	
	Exemplo de utilização:
		Vide fim deste arquivo para alguns exemplos simples de utilização.

*******************************************************************************/
CREATE FUNCTION [dbo].[fn_TrataNumeroPropostaZeroExtra] (@NumeroProposta VARCHAR(20))
RETURNS VARCHAR(20)
WITH SCHEMABINDING
AS
BEGIN
    --DECLARE @NumeroProposta VARCHAR(20) = ' 4482300390305 '
	DECLARE @Retorno VARCHAR(20)
	IF LEFT(@NumeroProposta,2) = 'SN'
    BEGIN
         SET @Retorno =  'SN' + RIGHT('000000000000000' + REPLACE(@NumeroProposta, 'SN',''), 15)
    END
    ELSE
    BEGIN
        SELECT @Retorno = 
		    CAST (
			    CAST      
				    (CASE WHEN
						    LEFT(@NumeroProposta, 5) IN ('12014', '12018')			
						    AND SUBSTRING(CAST(@NumeroProposta AS VARCHAR), 6, 2) NOT IN ('71', '72', '77')
						    AND LEFT(RIGHT(@NumeroProposta, 9),2) NOT IN ('07', '13')
						    AND LEN(CAST(@NumeroProposta AS VARCHAR)) = 14                                 						
						    AND RIGHT(CAST(@NumeroProposta AS VARCHAR), 1) = '0'
					    THEN CAST(@NumeroProposta AS NUMERIC(38,0)) / 10.0
				         WHEN 
				          LEFT(@NumeroProposta,5) = '10022' 
				          AND RIGHT(@NumeroProposta,1) = '0'
				          AND len(CAST(@NumeroProposta AS VARCHAR))=12
					    THEN CAST(@NumeroProposta AS NUMERIC(38,0)) / 10.0				      
					     WHEN 
				          LEFT(@NumeroProposta,4) = '9543' 
				          AND RIGHT(@NumeroProposta,1) = '0'
				          AND len(CAST(@NumeroProposta AS VARCHAR))=12
					    THEN CAST(@NumeroProposta AS NUMERIC(38,0)) / 10.0				      
							    ELSE @NumeroProposta
						    END
			    AS BIGINT)              
		    AS VARCHAR(20))
  
    SET @Retorno = RIGHT('000000000000000' + @Retorno, 15)
   END

   IF (@Retorno =  '000000000000000' OR @Retorno = 'SN000000000000000')
    SET @Retorno = NULL
 -- PRINT @Retorno 
   RETURN @Retorno
END
/*
	SELECT Fenae.fn_TrataNumeroPropostaZeroExtra('12014013227540')
	SELECT Fenae.fn_TrataNumeroPropostaZeroExtra('12014013243520')

	SELECT Fenae.fn_TrataNumeroPropostaZeroExtra(12014013243520)
	SELECT Fenae.fn_TrataNumeroPropostaZeroExtra(NULL)
	SELECT Fenae.fn_TrataNumeroPropostaZeroExtra(84681761694)
*/
