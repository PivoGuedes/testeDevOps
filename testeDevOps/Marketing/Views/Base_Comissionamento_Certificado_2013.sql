                
/*
	Autor: Gustavo Moreira
	Data Criação: 30/09/2013

	Descrição: 
	
	Última alteração :  
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Marketing.Base_Comissionamento_Certificado_2013
	Descrição: Consulta da tabela Base_Comissionamento_Certificado_2013.
		
	
					
	Retorno:

*******************************************************************************/ 
create VIEW [Marketing].[Base_Comissionamento_Certificado_2013]
AS


SELECT [PERIODO]
      ,[COD_PRODUTO]
      ,[NUM_APOLICE]
      ,[COD_SUBGRUPO]
      ,[NUM_CERTIFICADO]
      ,[AGENCIA]
      ,[COD_CLIENTE]
      ,[CGCCPF]
      ,[NOME_RAZAO]
      ,[TIPO_PESSOA]
      ,[RAMO_COBERTURA]
      ,[NUM_PARCELA]
      ,[PREMIO]
      ,[NUM_ENDOSSO]
      ,[NUM_RECIBO]
      ,[COD_PRODUTOR]
      ,[NOME_PRODUTOR]
      ,[PCT_COM_CORRETOR]
      ,[PREMIO_LIQUIDO]
      ,[PRM_TOTAL_ENDOSSO]
      ,[PRM_DEVOLVIDO]
      ,[PREMIO_REC]
      ,[VAL_BASICO]
      ,[VAL_COMISSAO]
      ,[DT_EMISSAO]
      ,[DATA_CALCULO]
      ,[DATA_QUITACAO]
      ,[DT_COMISSAO]
      ,[TIPO_COMISSAO]
      ,[COD_OPERACAO_ENDOSSO]
      ,[COD_OPERACAO_COMISSAO]
      ,[TIPO_PAGTO]
	  ,[VENDANOVA]
  FROM [VALIDACOES].[dbo].[Base_Comissionamento_Certificado_2013]
