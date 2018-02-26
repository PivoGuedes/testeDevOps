
CREATE FUNCTION [Dados].[fn_RecuperaUnidade_PointInTime_Deletar](@IDUnidade smallint, @DataReferencia DATE)
RETURNS TABLE
WITH SCHEMABINDING
AS   
 RETURN SELECT TOP 1 UH.IDFilialPARCorretora, UH.ASVEN, UH.IDUnidadeEscritorioNegocio, UH.Nome, UH.Codigo, UH.DataArquivo [DataReferenciaUnidade]
        FROM Dados.vw_UnidadeGeral_Deletar UH
        WHERE UH.IDUnidade = @IDUnidade
         AND UH.DataArquivo <= @DataReferencia
        ORDER BY UH.IDUnidade ASC, UH.DataArquivo DESC, UH.ID DESC  