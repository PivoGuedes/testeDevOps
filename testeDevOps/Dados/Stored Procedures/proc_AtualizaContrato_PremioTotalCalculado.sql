
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

CREATE PROCEDURE Dados.proc_AtualizaContrato_PremioTotalCalculado 
AS

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

--SELECT TOP 10 *
--INTO tempdb.dbo.DadosContrato
--FROM Dados.Contrato
--WHERE ID IN (787, 788, 789)

IF OBJECT_ID('dbo.DadosContratoPremioCalculado_temp') IS NOT NULL
	DROP TABLE dbo.DadosContratoPremioCalculado_temp;

CREATE TABLE dbo.DadosContratoPremioCalculado_temp
( IDContrato INT )

BEGIN TRY
BEGIN TRANSACTION 

MERGE INTO Dados.Contrato AS t
USING 
(
	SELECT IDContrato,
		   SUM(ValorPremioTotal) AS ValorPremioBrutoCalculado, 
           SUM(ValorPremioLiquido) AS ValorPremioLiquidoCalculado
	FROM Dados.Endosso AS E
	--WHERE IDContrato IN (787, 788, 789)
	GROUP BY IDContrato
) AS s
ON t.ID = s.IDContrato
WHEN MATCHED THEN 
	UPDATE 
		SET t.ValorPremioBrutoCalculado = ISNULL(s.ValorPremioBrutoCalculado,0),
		    t.ValorPremioLiquidoCalculado = ISNULL(s.ValorPremioLiquidoCalculado,0)
OUTPUT inserted.ID INTO dbo.DadosContratoPremioCalculado_temp;

UPDATE E
	SET E.PremioCalculado = 1
FROM DadosContratoPremioCalculado_temp AS DCSP
INNER JOIN Dados.Endosso AS E
ON DCSP.IDContrato = E.IDContrato

IF @@TRANCOUNT >= 1
	COMMIT TRANSACTION
END TRY
BEGIN CATCH	
	ROLLBACK TRANSACTION
END CATCH;

--SELECT SaldoProcessado, *
--FROM Dados.Endosso AS E
--WHERE IDContrato IN (787, 788, 789)
