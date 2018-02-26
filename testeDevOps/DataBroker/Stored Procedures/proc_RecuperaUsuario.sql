
CREATE PROCEDURE [DataBroker].[proc_RecuperaUsuario]
   @Matricula VARCHAR(50)
AS 

SELECT 
	F.Nome
	, F.Matricula
	, E.Nome AS Empresa
	, COALESCE(IA.Descricao, '') AS Area
	, COALESCE(FU.Descricao, '') AS Funcao
FROM Dados.Funcionario AS F
INNER JOIN Dados.Empresa AS E
ON F.IDEmpresa=E.ID
LEFT OUTER JOIN Dados.IndicadorArea AS IA
ON F.IDIndicadorArea=IA.ID
LEFT OUTER JOIN Dados.Funcao AS FU
ON F.IDUltimaFuncao=FU.ID
WHERE F.Matricula=@Matricula


