
/*
	Autor: Egler Vieira
	Data Criação: 14/03/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_AtualizaCodigoHierarquicoCanaisVendaPAR_Ativos
	Descrição: Procedimento que atualiza a hierarquia (árvore codificada) dos canais de vendas PAR ativos
		
	Parâmetros de entrada: 
					
	Retorno:
	
*******************************************************************************/
CREATE PROCEDURE Dados.proc_AtualizaCodigoHierarquicoCanaisVendaPAR_Ativos
AS
  UPDATE Dados.CanalVendaPAR SET [CodigoHierarquico] = HCVP.CodigoHierarquico
  FROM Dados.CanalVendaPAR CVP
  INNER JOIN Dados.vw_RetornaHierarquiaCanaisAtivos HCVP
  ON CVP.ID = HCVP.ID

