
CREATE FUNCTION [Dados].[fn_RecuperaSR](@CodigoUnidade SMALLINT)
RETURNS TABLE
WITH SCHEMABINDING
AS
	RETURN (
		WITH BuscaSR AS (
			SELECT U.ID, U.Codigo, U.Nome AS Nome, U.IDUnidadeEscritorioNegocio, U.TipoUnidade AS TipoUnidade, IDFilialParCorretora ,0 AS Nivel
			FROM Dados.vw_Unidade AS U
			WHERE U.Codigo = @CodigoUnidade
		
			UNION ALL
			
			SELECT U.ID, U.Codigo, U.Nome AS Nome, U.IDUnidadeEscritorioNegocio, U.TipoUnidade, U.IDFilialParCorretora, (Nivel + 1)
			FROM Dados.vw_Unidade AS U

			INNER JOIN BuscaSR AS SR
			ON U.IDUnidade = SR.IDUnidadeEscritorioNegocio AND U.IDUnidade <> U.IDUnidadeEscritorioNegocio
		)
		SELECT R.Codigo, R.ID, R.IDFilialParCorretora, R.IDUnidadeEscritorioNegocio, R.Nivel
			, R.Nome, R.TipoUnidade
		FROM BuscaSR AS R
		WHERE R.TipoUnidade = 'SR'
		--OPTION (MAXRECURSION 32767);
	)
