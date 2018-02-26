
/*
	Autor: Egler Vieira
	Data Criação: 20/01/2014

	Descrição: 
	
	Última alteração :

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_AtualizaContratoAnterior_PropostasAUTO
	Descrição: Procedimento que realiza a atualização.
		
	Parâmetros de entrada: 	
					
	Retorno:

OBS: 
	  	
*/
CREATE PROCEDURE [Dados].[proc_AtualizaContratoAnterior_PropostasAUTO] 
AS
UPDATE Dados.Contrato SET IDContratoAnterior = CNAT.IDContrato
FROM Dados.Proposta PRP
INNER JOIN Dados.PropostaAutomovel PA
ON PA.IDProposta = PRP.ID
INNER JOIN Dados.Contrato CNT
ON CNT.ID = PRP.IDContrato
--OUTER APPLY (SELECT IDContrato, NumeroContrato NumeroContratoAnterior FROM Dados.Contrato CNTA WHERE CNTA.NumeroContrato = PA.NumeroApoliceAnterior) CNAT
OUTER APPLY (SELECT CNTA.ID AS IDContrato, NumeroContrato NumeroContratoAnterior FROM Dados.Contrato CNTA WHERE CNTA.NumeroContrato = PA.NumeroApoliceAnterior) CNAT
WHERE CNT.IDContratoAnterior IS NULL
AND PA.NumeroApoliceAnterior IS NOT NULL
AND LEN(PA.NumeroApoliceAnterior) > 5
AND CNAT.IDContrato IS NOT NULL