
/*
	Autor: Windson Santos
	Data Criação: 16/04/2014

	Descrição: 
	
	Última alteração :

*/

/*******************************************************************************
	Nome:  [Dados].[proc_RecuperaCentroCustoQlikView]
	Descrição: Procedimento busca todos os centros de custo do PROTHEUS usados no QlikView
	para controlar o acesso dos usuários.
		
	Parâmetros de entrada:
	
					
	Retorno: Todos os centros de custo válidos para o QlikView

*******************************************************************************/ 
CREATE PROCEDURE [Dados].[proc_RecuperaCentroCustoQlikView]
AS
SELECT [ID]
      ,[IDCentroCustoMestre]
      ,[Codigo]
      ,[Descricao]
      ,[IDClasse]
      ,[Classe]
      ,[FL_Bloqueio]
FROM [Corporativo].[Dados].[CentroCusto] CC,
	(SELECT
		LTRIM(RTRIM(CTT.CTT_CUSTO)) AS CD_CENTRO_CUSTO
	FROM SCASE.[RBDF27].[dbo].[CTT010] CTT
	WHERE CTT.D_E_L_E_T_ = '' AND CTT.CTT_CUSTO <> '90000'
	) AS A
WHERE CC.[Codigo] = A.CD_CENTRO_CUSTO COLLATE SQL_Latin1_General_CP1_CI_AS
ORDER BY CC.Codigo
