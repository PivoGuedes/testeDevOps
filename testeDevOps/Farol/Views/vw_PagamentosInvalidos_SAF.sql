

CREATE VIEW [Farol].[vw_PagamentosInvalidos_SAF]
AS

SELECT 
CAST(PC.NumeroContrato as bigint) as Contrato, 
	   PC.ID,
	   PC.IDProdutor,
	   PC.IDOperacao,
	   PC.IDCorrespondente,
	   PC.IDFilialFaturamento,
	   PC.NumeroRecibo,
	   PC.IDContrato,
	   PC.IDProposta,
CAST(PC.NumeroEndosso as bigint) as Endosso,
	   PC.NumeroParcela,
CAST(PC.NumeroBilhete as numeric) as Bilhete, 
	   PC.ValorCorretagem,
	   --PC.Grupo,
	   --PC.Cota,
	   PC.DataProcessamento, 
	   --PC.NumeroContrato,
CAST(PC.NumeroProposta as bigint) as Proposta, 
	   PC.Arquivo, 
	   PC.DataArquivo
	   --PC.IDTipoProduto
--C.NumeroContrato as NC,* 
FROM Dados.PremiacaoCorrespondente AS PC
INNER JOIN  Dados.Correspondente AS C2 ON C2.ID = PC.IDCorrespondente
INNER JOIN Dados.TipoProduto AS TP
ON TP.ID=PC.IDTipoProduto
INNER JOIN Dados.Contrato AS C
ON C.ID=PC.IDContrato
WHERE EXISTS 
(
       SELECT *-- ID, IDProdutor, IDOperacao, IDCORRESPONDENTE, IDProposta, IDContrato, NumeroParcela, 
	   --NumeroEndosso, Arquivo, DataArquivo  
       FROM Dados.PremiacaoCorrespondente AS PC2
		WHERE PC2.IDCorrespondente = PC.IDCorrespondente
			AND PC2.IDProposta = PC.IDProposta	   
			AND PC2.IDContrato = PC.IDContrato
			AND PC2.NumeroParcela = PC.NumeroParcela
			AND PC2.NumeroEndosso = PC.NumeroEndosso
			and PC2.Arquivo <> PC.Arquivo
)
--AND C.NumeroContrato like '%103701587372%' 
--AND C.NumeroContrato = '25532601'
and PC.Arquivo = 'D170419.DC0701_CBN_EMPRESARIO_42278473000103.170419.txt' --and PC.IDContrato = 25532601


--110205170
--210209925


