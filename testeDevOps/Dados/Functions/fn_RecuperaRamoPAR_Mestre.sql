
CREATE FUNCTION Dados.fn_RecuperaRamoPAR_Mestre (@IDRamo int)
returns table
as
return
WITH RM
AS
(
   SELECT RP.ID, RP.Codigo, RP.Nome, RP.IDRamoMestre, 1 [Nivel]
   FROM Dados.RamoPAR RP WITH (NOLOCK)
   WHERE
    RP.ID = @IDRamo
   UNION ALL
   SELECT RP.ID, RP.Codigo, RP.Nome, RP.IDRamoMestre, Nivel + 1 [Nivel]
   FROM RM
   INNER JOIN Dados.RamoPAR RP
   ON RM.IDRamoMestre = RP.ID
 )
 SELECT A.*--A.Codigo,A.Nome, A.IDRamoFolha
 FROM RM
 CROSS APPLY (SELECT *, (SELECT ID FROM RM WHERE Nivel = 1) [IDRamoFolha]
              FROM RM RM1
			  WHERE IDRamoMestre IS NULL
			  AND RM.ID = RM1.ID
			   ) A