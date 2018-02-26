---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



/*
	Autor: Egler Vieira
	Data Criação: 2014/03/12

	Descrição: 
	
	Última alteração :  
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Premiacao.vw_PremiacaoCorrespondenteCBN_Analitico
	Descrição: Procedimento que realiza a recuperação da premiação analítica dos correspondentes bancários.
		
	Parâmetros de entrada: DataApuracao -> Data de referência para apuração
	
					
	Retorno:

*******************************************************************************/ 
CREATE VIEW [Premiacao].[vw_PremiacaoCorrespondenteCBN_Analitico]
AS
SELECT
	PC.ID, 
	C.Matricula, 
	C.CPFCNPJ, 
	C.Nome, 
	C.Cidade, 
	C.UF,
    CDB.Banco, 
    CDB.Agencia [AgenciaConta], 
    CDB.ContaCorrente, 
    CDB.Operacao,
	PC.IDTipoProduto,
	PRP.NumeroProposta, 
	CNT.NumeroContrato, 
	CNT.NumeroBilhete, 
	PC.NumeroEndosso, 
	PC.NumeroRecibo, 
	PC.NumeroParcela, 
	CO.Codigo [CodigoOperacao],  
	PC.DataArquivo, 
	PC.ValorCorretagem [ValoCorretagem]
FROM Dados.PremiacaoCorrespondente PC
INNER JOIN Dados.Correspondente C
ON C.ID = PC.IDCorrespondente
LEFT JOIN Dados.CorrespondenteDadosBancarios CDB
ON CDB.IDCorrespondente = PC.IDCorrespondente
AND CDB.IDTipoProduto = PC.IDTipoProduto
LEFT JOIN Dados.TipoProduto TP
ON TP.ID = PC.IDTipoProduto
LEFT JOIN Dados.Unidade U
ON U.ID = C.IDUnidade
LEFT JOIN Dados.Proposta PRP
ON PC.IDProposta = PRP.ID
LEFT JOIN Dados.Contrato CNT
ON CNT.ID = PC.IDContrato
LEFT JOIN Dados.ComissaoOperacao CO
ON CO.ID = PC.IDOperacao
WHERE C.IDTipoCorrespondente =  1
--AND CDB.IDTipoProduto = 1
--and c.NomeArquivo NOT LIKE 'SAFAT'





