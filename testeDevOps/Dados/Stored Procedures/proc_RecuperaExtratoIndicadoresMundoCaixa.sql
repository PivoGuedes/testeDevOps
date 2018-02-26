
/*
	Autor: Egler Vieira
	Data Criação: 19/08/2014

	Descrição: 
	
	Última alteração :  Windson e Pedro Luiz
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_RecuperaExtratoIndicadoresMundoCaixa
	Descrição: Procedimento que realiza a recuperação do extrato de pontos de um indicador, 
	           chamando a função que recupera e calcula os valores líquidos.
			   
	Parâmetros de entrada:
	
					
	Retorno:

*******************************************************************************/	

CREATE PROCEDURE [Dados].[proc_RecuperaExtratoIndicadoresMundoCaixa](@IDIndicador INT, @AnoCompetencia INT, @MesCompetencia int, @Gerente bit = 0, @Pago bit = 1)
AS
  SELECT * 
  FROM Dados.fn_RecuperaExtratoIndicadoresMundoCaixa(@IDIndicador, @AnoCompetencia, @MesCompetencia, @Gerente, @Pago) REI




  --   [Dados].[proc_RecuperaExtratoIndicadoresMundoCaixa] @IDIndicador=47106, @AnoCompetencia=2016, @MesCompetencia=10
