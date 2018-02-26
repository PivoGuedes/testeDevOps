
/*
	Autor: Egler Vieira
	Data Criação: 14/07/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: Corporativo.[Dados].[vw_RetornaHierarquiaCanaisAtivos]
	Descrição: View que, com recursividade, calcula a árvore hierarquica dos canais de vendas ativos
		
	Parâmetros de entrada:
	
					
	Retorno:
*******************************************************************************/
CREATE VIEW Dados.vw_RetornaHierarquiaCanaisAtivos
AS
WITH C
AS
(
SELECT CVP.Codigo, Cast(RIGHT('00'  + Cast(ROW_NUMBER() OVER (ORDER BY CVP.ID) as varchar(2)),2) as varchar(40)) /*CVP.*/CodigoHierarquico /*cvp.CodigoHierarquico*/, CVP.Nome [Canal], /*CVP.CodigoHierarquico*/ Cast('' as varchar(40)) [CodigoHierarquicoCanalMestre], CVP.ID, CVP.IDCanalMestre, 0 [Nivel], cvp.DataInicio, cvp.DataFim--, Cast('' as varchar(40)) [Sequencial]
FROM Dados.CanalVendaPAR CVP
WHERE CVP.IDCanalMestre IS NULL
UNION ALL
SELECT CVP.Codigo, Cast(C.CodigoHierarquico + RIGHT('00'  + Cast(ROW_NUMBER() OVER (PARTITION BY C.IDCanalMestre ORDER BY C.ID) as varchar(2)),2) as varchar(40)) /*CVP.*/CodigoHierarquico, CVP.Nome [Canal], c.CodigoHierarquico [CodigoHierarquicoCanalMestre], CVP.ID, CVP.IDCanalMestre, Nivel + 1 [Nivel], cvp.DataInicio, cvp.DataFim--, Cast(C.CodigoHierarquicoCanalMestre + RIGHT('00'  + Cast(ROW_NUMBER() OVER (PARTITION BY C.IDCanalMestre ORDER BY C.ID) as varchar(2)),2) as varchar(40)) [Sequencial]
FROM Dados.CanalVendaPAR CVP
INNER JOIN C 
ON CVP.IDCanalMestre = C.ID
WHERE CVP.DataFim IS NULL

)
SELECT *--, C.CodigoHierarquicoCanalMestre + RIGHT('00'  + Cast(ROW_NUMBER() OVER (PARTITION BY C.IDCanalMestre ORDER BY C.ID) as varchar(2)),2) [Sequencial]
FROM C



