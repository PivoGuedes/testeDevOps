
/*
	Autor: Luan Moreno M. Maciel
	Data Criação: 16/10/2013

	Descrição: 
	Última Alteração: 

*/

/*******************************************************************************
	Nome: 
	Parâmetros de Entrada:		
	Retorno:
*******************************************************************************/

CREATE PROCEDURE [Dados].proc_AtualizaProposta_SaldoPago 
AS

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

IF OBJECT_ID('dbo.DadosPropostaValorPagoAcumulado_temp') IS NOT NULL
	DROP TABLE dbo.DadosPropostaValorPagoAcumulado_temp;

CREATE TABLE dbo.DadosPropostaValorPagoAcumulado_temp
( IDProposta INT )

BEGIN TRY
BEGIN TRANSACTION 

MERGE INTO Dados.Proposta AS t
USING 
(
SELECT P.IDProposta, SUM(P.Valor) Soma
FROM Dados.Pagamento P 
WHERE P.SaldoProcessado = 0
GROUP BY P.IDProposta
) AS s
ON t.ID = s.IDProposta
WHEN MATCHED THEN 
	UPDATE 
		SET ValorPagoAcumulado = ISNULL(ValorPagoAcumulado,0) + Soma
OUTPUT inserted.ID INTO dbo.DadosPropostaValorPagoAcumulado_temp;

UPDATE Dados.Pagamento
	SET SaldoProcessado = 1 
FROM Dados.Pagamento AS PG
INNER JOIN dbo.DadosPropostaValorPagoAcumulado_temp AS P
ON PG.IDProposta = P.IDProposta
WHERE SaldoProcessado = 0

IF @@TRANCOUNT >= 1
	COMMIT TRANSACTION
END TRY
BEGIN CATCH	
	ROLLBACK TRANSACTION
END CATCH;





