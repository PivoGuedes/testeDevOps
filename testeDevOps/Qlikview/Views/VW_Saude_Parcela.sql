






CREATE VIEW [Qlikview].[VW_Saude_Parcela] AS 
WITH PROPOSTAS AS (
SELECT p.ID as IDProposta,
		pr.ID as IDParcela,
		pr.NumeroParcela,
		pr.DataVencimento,
		pr.ValorPremioLiquido
FROM DADOS.PROPOSTA p
inner join Dados.ParcelaSaude prcs on prcs.IDProposta = p.ID
inner join Dados.Parcela pr on prcs.IDParcela = pr.ID
)
SELECT *
FROM PROPOSTAS








