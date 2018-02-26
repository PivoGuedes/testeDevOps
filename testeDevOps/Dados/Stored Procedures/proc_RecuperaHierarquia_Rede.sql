
/*
	Autor: Egler Vieira
	Data Criação: 27/07/2016

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: Corporativo.[Dados].[proc_RecuperaHierarquia_Rede]
	Descrição: Proc que retorna a última posição da hierarquia da rede
		
	Parâmetros de entrada:
	
					
	Retorno:
*******************************************************************************/

CREATE PROCEDURE [Dados].[proc_RecuperaHierarquia_Rede]
AS
SELECT *
FROM Dados.fn_RecuperaFuncionariosRede() FR
ORDER BY  FR.RegiaoRede, FR.IDTipoRegiao, FR.IDTipoVaga, FR.Cargo, FR.Matricula, FR.[NomeUnidade]

