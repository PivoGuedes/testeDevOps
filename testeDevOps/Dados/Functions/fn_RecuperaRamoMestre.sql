
create FUNCTION [Dados].[fn_RecuperaRamoMestre](@IDRamo SMALLINT)
RETURNS TABLE
WITH SCHEMABINDING
AS
	RETURN (
		WITH BuscaRamoMestre AS (
			SELECT	ID, Codigo, Nome, IDRamoMestre, 0 AS Nivel
			FROM	Dados.RamoPAR
			WHERE	ID=@IDRamo

			UNION ALL

			SELECT	R.ID, R.Codigo, R.Nome, R.IDRamoMestre, (Nivel + 1)
			FROM	Dados.RamoPAR AS R
			INNER JOIN BuscaRamoMestre AS RM
			ON R.ID=RM.IDRamoMestre AND R.ID<>ISNULL(R.IDRamoMestre,0)
		)
		SELECT ID, Codigo, Nome, IDRamoMestre, Nivel FROM BuscaRamoMestre WHERE IDRamoMestre IS NULL
	)
