﻿
/*
	Autor: Andre Anselmo
	Data Criação: 2015-04-13

	Descrição: 
	
	
	Última alteração : 
                                                                                      
*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.[proc_RecuperaEmissaoAuto_COL]
	Descrição: 
		
	Parâmetros de entrada: 
						   
					
	Retorno:
	
*******************************************************************************/ 
CREATE FUNCTION [Dados].[fn_RecuperaEmissaoAuto_COL](@PontoParada VARCHAR(400))

RETURNS TABLE
AS
RETURN


	SELECT T4.SEGURADORA AS "CODIGOSEGURADORA",
		T4.PRODUTO AS "CODIGOPRODUTO",
		T6.NOME AS "NOMEPRODUTO",
		T4.APOLICE AS "NUMEROAPOLICE",
		T4.PROPOSTA AS "NUMEROPROPOSTA",
		T4.ENDOSSO AS "NUMEROENDOSSO",
		T7.APOLICE_RENOVADA AS "APOLICEANTERIOR",
		T8.SITUACAO AS "SITUACAOENDOSSO",
		T8.INICIO_VIGENCIA AS "DATAINICIOVIGENCIAENDOSSO",
		T8.TERMINO_VIGENCIA AS "DATAFIMVIGENCIAENDOSSO",
		T4.DATA_EMISSAO AS "DATAEMISSAO",
		T4.DATA_PROPOSTA AS "DATAPROPOSTA",
		T4.DATA_ALTERACAO AS "DATASITUACAO",
		day(t4.termino_vigencia) as "DIAVENCIMENTO",
		NULL AS "CODIGOCOBERTURA",
		NULL AS "NOMECOBERTURA",
		T4.PREMIO_LIQUIDO AS "VALORPREMIOLIQUIDO",
		T4.PREMIO_TOTAL AS "VALORPREMIOBRUTO",
		T4.IOF AS "VALORIOF",
		NULL AS "PERIDICIDADEPAGAMENTO",
		NULL AS "SITUACAOPAGAMENTO",
		T4.SITUACAO AS "SITUACAOPROPOSTA",
		NULL AS "SITUACAOCOBRANCA",
		T9.Descricao AS "MOTIVODASITUACAO",
		T4.TIPO_NEGOCIO AS "TIPOSEGURO",
		T4.QTDE_PARC_PREMIO AS QUANTIDADEPARCELAS,
		ISNULL(ROUND((T4.PREMIO_TOTAL / case when t4.Qtde_parc_premio <= 0 then 1 else t4.Qtde_parc_premio end), 2),0) AS "VALORPRIMEIRAPARCELA",
		ISNULL(ROUND((T4.PREMIO_TOTAL / case when t4.Qtde_parc_premio <= 0 then 1 else t4.Qtde_parc_premio end), 2),0) AS "VALORDEMAISPARCELAS"
	FROM OBERON.COL_MULTISEGURADORA.dbo.TABELA_DOCUMENTOS T4
	JOIN OBERON.COL_MULTISEGURADORA.dbo.TABELA_CLIENTES T5 ON (T4.CLIENTE = T5.CLIENTE)
	JOIN OBERON.COL_MULTISEGURADORA.dbo.TABELA_PRODUTOS T6 ON (T4.PRODUTO = T6.PRODUTO)
	LEFT JOIN OBERON.COL_MULTISEGURADORA.dbo.TABELA_DOCSRENOVADOS T7 ON (T4.DOCUMENTO = T7.Documento)
	LEFT JOIN OBERON.COL_MULTISEGURADORA.dbo.TABELA_DOCUMENTOS T8 ON (T4.DOCUMENTO = T8.DOCUMENTO AND T4.ALTERACAO > 0 AND T4.ALTERACAO = T8.ALTERACAO)
	LEFT JOIN OBERON.COL_MULTISEGURADORA.dbo.TABELA_MOTIVOSORC T9 ON (T4.MOTIVO_ORC = T9.MOTIVO_ORC)
	WHERE T4.PROPOSTA >  CAST( @PontoParada AS INT)
	
	

	--declare @PontoParada varchar(20)
	--set @PontoParada =250
	--SELECT * FROM [Dados].[fn_RecuperaEmissaoAuto_COL](@PontoParada) ORDER BY NumeroProposta
