
/*******************************************************************************
	Nome: Fenae.Corporativoproc_RecuperaPlanos_Protheus
	
	Descrição: Essa procedure vai consultar os dados de Propostas Saúde
		
	Parâmetros de entrada:

	Retorno:
	ResultSet com informações que preencherão a tabela temporária que fará o merge com a Dados.Proposta
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_RecuperaPlanos_Protheus] 
--	@PontoParada VARCHAR(400)
AS

 SELECT *  FROM  OPENQUERY ([SCASE],'

;WITH CTE AS (

SELECT BI3_CODINT,BI3_CODIGO,BI3_VERSAO,BI3_DESCRI,BI3_SUSEP, BJ3_CODFOR, ''03'' as EMPRESA 
FROM BI3030
INNER JOIN BJ3030 ON BJ3_FILIAL = BI3_FILIAL AND BJ3_CODIGO = BI3_CODINT + BI3_CODIGO AND BJ3030.D_E_L_E_T_=''''
INNER JOIN BJ1030 ON BJ1_FILIAL = BI3_FILIAL AND BJ1_CODIGO = BJ3_CODFOR AND BJ1030.D_E_L_E_T_ = ''''
WHERE BI3030.D_E_L_E_T_='''' AND BI3_CODINT <> ''0005''

UNION

SELECT BI3_CODINT,BI3_CODIGO,BI3_VERSAO,BI3_DESCRI,BI3_SUSEP, BJ3_CODFOR , ''04'' as EMPRESA 
FROM BI3040
INNER JOIN BJ3040 ON BJ3_FILIAL = BI3_FILIAL AND BJ3_CODIGO = BI3_CODINT + BI3_CODIGO AND BJ3040.D_E_L_E_T_=''''
INNER JOIN BJ1040 ON BJ1_FILIAL = BI3_FILIAL AND BJ1_CODIGO = BJ3_CODFOR AND BJ1040.D_E_L_E_T_ = ''''
WHERE BI3040.D_E_L_E_T_='''')
SELECT * FROM
(
SELECT case when Cast(BI3_CODINT AS iNT) = 1 then 18
								when Cast(BI3_CODINT AS iNT) = 2 then 42
								when Cast(BI3_CODINT AS iNT) = 3 then 43
								when Cast(BI3_CODINT AS iNT) = 4 then 44 
								ELSE 286 End as IDSeguradora,
				BI3_CODIGO AS CodigoPlano,
				BJ3_CODFOR AS FormaDeCobranca,
				BI3_VERSAO AS VersaoPlano,
				BI3_DESCRI AS NomePlano,
				Case When Len(rTrim(BI3_SUSEP)) = 0 then Null 
				Else BI3_SUSEP End  AS NumANS,
				null	   AS PlanoANS,
				EMPRESA
				FROM CTE)
				AS A')

--WHERE CTE.NumeroProposta = '001201400671965'


