


CREATE VIEW [Dados].[vw_CadastroCCA_2016]
AS

SELECT DISTINCT 
	T.CODIGO
	, C.Nome
	, C.CPFCNPJ
	, T.SITUACAO
	, COALESCE(C.Cidade, T.Cidade) AS Cidade
	, T.ENDERECO
	, T.BAIRRO
	, T.CEP
	, T.DDD
	, T.TELEFONE
	, T.EMAIL
	, C.ICSituacao
	, T.UF
	, C.TipoCorrespondente
	, U.Codigo AS CodigoAgencia
FROM [dbo].[LT3179B_Produção_Final] AS T 
INNER JOIN Dados.Correspondente AS C
ON C.Matricula=RIGHT(T.CODIGO,8)
LEFT OUTER JOIN Dados.Unidade AS U
ON C.IDUnidade=U.ID



