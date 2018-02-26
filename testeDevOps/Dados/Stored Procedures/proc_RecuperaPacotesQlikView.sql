
/*
	Autor: Windson Santos
	Data Criação: 16/04/2014

	Descrição: 
	
	Última alteração :

*/

/*******************************************************************************
	Nome:  [Dados].[proc_RecuperaPacotesQlikView]
	Descrição: Procedimento busca todos os pacotes no protheus para a vinculação 
			   com usuário para controle de acesso no QlikView.
		
	Parâmetros de entrada:
	
					
	Retorno: Todos os pacotes do protheus para realização do vinculo com o usuário para controlar o acesso dos usuários no QlikView

*******************************************************************************/ 
CREATE PROCEDURE [Dados].[proc_RecuperaPacotesQlikView]
AS
SELECT
       CTS.CTS_CONTAG AS Codigo, 
       CTS.CTS_DESCCG AS Descricao
FROM SCASE.[RBDF27].[dbo].[CTS010] CTS
WHERE CTS.D_E_L_E_T_ = ''  
AND CTS.CTS_CODPLA = '003'  
GROUP BY CTS.CTS_CONTAG, CTS.CTS_DESCCG 
ORDER BY CTS_CONTAG; 
