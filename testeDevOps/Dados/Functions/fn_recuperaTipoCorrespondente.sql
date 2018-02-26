CREATE FUNCTION [Dados].[fn_recuperaTipoCorrespondente](@IDCorrespondente INT)
RETURNS TINYINT
WITH SCHEMABINDING
AS
BEGIN
DECLARE @ID Smallint

--DECLARE @NumeroProposta varchar(20) = '00008464327676' , @CodigoProduto varchar(5) = '9329', @CodigoMatricula varchar(20) = NULL
  SET @ID = (
            SELECT TOP 1 IDTipoCorrespondente FROM Dados.Correspondente C WHERE C.ID = @IDCorrespondente  ORDER BY ID
            )
            
  RETURN @ID
END
