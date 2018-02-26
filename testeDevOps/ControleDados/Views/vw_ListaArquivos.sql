CREATE VIEW [ControleDados].[vw_ListaArquivos]
AS
SELECT DISTINCT
C.Arquivo as Arquivo, c.DataArquivo
FROM [Dados].[Contrato] C

UNION

SELECT DISTINCT
P.TipoDado as Arquivo, p.DataArquivo
FROM [Dados].[Proposta] P

UNION

SELECT DISTINCT
A.Arquivo as Arquivo, a.DataArquivo
FROM [Dados].[Atendimento] A


