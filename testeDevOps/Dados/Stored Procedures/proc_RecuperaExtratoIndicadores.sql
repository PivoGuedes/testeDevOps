/*
	Autor: Egler Vieira
	Data Criação: 19/08/2014

	Descrição: 
	
	Última alteração :  
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_RecuperaExtratoIndicadores
	Descrição: Procedimento que realiza a recuperação do extrato de pontos de um indicador, 
	           chamando a função que recupera e calcula os valores líquidos.
			   
	Parâmetros de entrada:
	
					
	Retorno:

*******************************************************************************/	

CREATE PROCEDURE [Dados].[proc_RecuperaExtratoIndicadores](@IDIndicador INT, @AnoCompetencia INT, @MesCompetencia int, @Gerente bit =0 )
AS
  SELECT * 
  FROM Dados.fn_RecuperaExtratoIndicadores(@IDIndicador, @AnoCompetencia, @MesCompetencia,@Gerente) REI
