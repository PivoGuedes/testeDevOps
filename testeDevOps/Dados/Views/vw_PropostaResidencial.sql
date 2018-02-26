

/*
	Autor: Egler Vieira
	Data Criação: 12/10/2013

	Descrição: 
	
	Última alteração :
*/

/*******************************************************************************
	Nome: Corporativo.[Dados].[vw_PropostaResidencial]
	Descrição: View que rastreia as Propostas do ramo residencial e Calcula alguns valores que não são entregues nos arquivos.
		
	Parâmetros de entrada:
	
					
	Retorno:
*******************************************************************************/
CREATE VIEW [Dados].[vw_PropostaResidencial]
AS
WITH CTE
as
(
/*
SELECT PR.IDProposta, PR.DescontoFidelidade, PR.DescontoAgrupCobertura, PR.DescontoExperiencia, PR.DescontoFuncionarioPublico
     , (PR.ValorPremioLiquido - ISNULL(LEAD(PR.ValorPremioLiquido,1)OVER(ORDER BY DataEmissao DESC),0.00)) ValorPremioTarifario
	 , (PR.ValorPremioTotal - PR.ValorCustoApolice - PR.ValorIOF) ValorPremioLiquido
	 , ValorCustoApolice
	 , PR.ValorIOF
	 , (PE.ValorPremioLiquido + PE.ValorIOF) ValorPremioTotal	
	 , PR.ValorPrimeiraParcela
	 , PR.ValorDemaisParcelas
	 , PE.ValorPremioLiquido [ValorPremioLiquidoEndosso]
	 , PR.ValorPremioLiquido ValorPremioTarifarioFinal 
	 , PE.NumeroEndosso
	 , PE.DataInicioVigencia
	 , PE.DataFimVigencia
*/
SELECT PR.IDProposta, PR.DescontoFidelidade, PR.DescontoAgrupCobertura, PR.DescontoExperiencia, PR.DescontoFuncionarioPublico
     , (PR.ValorPremioLiquido - ISNULL(LEAD(PR.ValorPremioLiquido,1)OVER(ORDER BY PR.IDProposta, PE.NumeroEndosso DESC),0.00)) ValorPremioTarifario
	 --, (CASE WHEN PE.ValorDiferencaEndosso < 0 THEN PR.ValorPremioTotal * -1 else PR.ValorPremioTotal END - PR.ValorCustoApolice - PR.ValorIOF)  ValorPremioLiquido
	 , (PR.ValorPremioTotal - PR.ValorCustoApolice - PR.ValorIOF) ValorPremioLiquido
	 , ValorCustoApolice
	 , PR.ValorIOF
	 , (CASE WHEN PE.ValorDiferencaEndosso < 0 THEN PE.ValorPremioLiquido * -1 else PE.ValorPremioLiquido end + PE.ValorIOF) ValorPremioTotal	
	 , PR.ValorPrimeiraParcela
	 , PR.ValorDemaisParcelas
	 , (CASE WHEN PE.ValorDiferencaEndosso < 0 THEN PE.ValorPremioLiquido * -1 else PE.ValorPremioLiquido end)  [ValorPremioLiquidoEndosso]
	 , PR.ValorPremioLiquido ValorPremioTarifarioFinal 
	 , PE.NumeroEndosso
	 , PE.DataInicioVigencia
	 , PE.DataFimVigencia
	 , PR.DataArquivo
FROM Dados.PropostaResidencial PR
INNER JOIN Dados.PropostaEndosso PE
ON PR.IDProposta = PE.IDProposta
AND PR.DataArquivo = PE.DataEmissao 
WHERE  PE.ValorPremioLiquido <> 0.00
  --AND PE.IDProposta = 8578177	 
) 
SELECT IDProposta
     , NumeroEndosso
     , DescontoFidelidade
	 , DescontoAgrupCobertura
	 , DescontoExperiencia
	 , DescontoFuncionarioPublico
	 , ValorPremioTarifario
	 , (ValorPremioTarifario * DescontoAgrupCobertura)  ValorDescAgrupCobertura
	 , ValorPremioLiquido
	 , ValorCustoApolice
	 , ValorIOF
	 , ValorPremioTotal	  	
	 , ValorPrimeiraParcela
	 , ValorDemaisParcelas
	 , [ValorPremioLiquidoEndosso]
	 , ValorPremioTarifarioFinal
	 , DataInicioVigencia
	 , DataFimVigencia
	 , DataArquivo
FROM CTE
--ORDER BY CTE.IDProposta

--SELECT * FROM Dados.vw_PropostaResidencial WHERE IDProposta = 8578177 ORDER BY IDProposta, NumeroEndosso

