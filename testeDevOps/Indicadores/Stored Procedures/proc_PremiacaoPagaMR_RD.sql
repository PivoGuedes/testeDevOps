
/*
	Autor: Egler Vieira
	Data Criação: 15/09/2016

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Indicadores.proc_PremiacaoPagaMR_RD
	Descrição: Procedimento que recupera premiação paga de MR e RD em um determinado período.
		
	Parâmetros de entrada: @DataInicioEmissao date
	                       @DataFimEmissao dae
	
					(Produtos 7705 e 7725)
	Retorno:

*******************************************************************************/
CREATE PROCEDURE [Indicadores].[proc_PremiacaoPagaMR_RD] @Lote int, @NumeroApolice VARCHAR(40)
as

--DECLARE @Lote INT --= ''--14
--DECLARE @NumeroApolice VARCHAR(40) --= ''--'1201402501651'

DECLARE @SQLText VARCHAR(8000)

SET @SQLText = '
	WITH CT AS (
		SELECT 
			P.IDFuncionario, P.IDUnidade, P.NumeroApolice, IT.NuApolice,RM.Nome AS Ramo,
			PP.CodigoComercializado, P.ValorBruto,
			IT.Calculo_Gerente, IT.Calculo_Indicador, P.Gerente, P.NumeroParcela,  IT.NuParcela,
			P.TipoPagamento, P.DataArquivo, IT.CdLote, IT.DtEmissao, P.NumeroEndosso
		FROM Corporativo.Dados.PremiacaoIndicadores P
		INNER JOIN Corporativo.Dados.ProdutoPremiacao PP 
		ON PP.ID = P.IDProdutoPremiacao
		INNER JOIN Corporativo.Dados.Produto PRD
		ON PRD.CodigoComercializado = PP.CodigoComercializado
		INNER JOIN [CalculoComissao].[INDICADOR].[ITEM_LOTE_PREMIACAO] AS IT
		ON IT.[NuApolice2] = P.NumeroApolice and IT.NuParcela = P.NumeroParcela
		CROSS APPLY DADOS.fn_RecuperaRamoPAR_Mestre(PRD.IDRamoPAR) RM 
		WHERE PRD.IDRamoPar IN (21, 51, 53, 54, 80, 81, 82)
	)
	SELECT 
		IDFuncionario, IDUnidade, NumeroApolice, NuApolice,
		CodigoComercializado, ValorBruto,
		Calculo_Gerente, Calculo_Indicador, Gerente, NumeroParcela,  NuParcela,
		TipoPagamento, DataArquivo, CdLote, DtEmissao, NumeroEndosso
	FROM CT 
	WHERE Ramo=''Patrimonial'''


IF ISNULL(@NumeroApolice,'') <> ''
BEGIN
	SET @SQLText = @SQLText + ' AND NumeroApolice=''' + @NumeroApolice + ''''
END

IF ISNULL(@Lote,'') <> ''
BEGIN
	SET @SQLText = @SQLText + ' AND CdLote=''' + CAST(@Lote AS VARCHAR(4)) + ''''
END

SET @SQLText = @SQLText + ' group by IDFuncionario, IDUnidade, NumeroApolice,
							 CodigoComercializado, ValorBruto, NumeroParcela, 
							 TipoPagamento, DataArquivo, Gerente, CdLote,  NuApolice,  NuParcela,
							  DtEmissao, Calculo_Gerente, Calculo_Indicador, NumeroEndosso
							ORDER BY NumeroApolice, NumeroParcela'

exec (@SQLText)



/*

SELECT P.IDFuncionario, P.IDUnidade, P.NumeroApolice, PP.CodigoComercializado, P.ValorBruto, P.NumeroParcela, P.TipoPagamento, P.DataArquivo, P.Gerente
FROM Dados.PremiacaoIndicadores P
INNER JOIN Dados.ProdutoPremiacao PP
ON PP.ID = P.IDProdutoPremiacao
INNER JOIN Dados.Produto PRD
ON PRD.CodigoComercializado = PP.CodigoComercializado
WHERE P.DataArquivo BETWEEN @DataInicioPremiacao AND @DataFimPremiacao
AND  PRD.IDRamoPar IN (21, 51, 53, 54, 80, 81, 82)
ORDER BY P.IDFuncionario, P.NumeroApolice, P.NumeroParcela
OPTION(OPTIMIZE FOR UNKNOWN)
--exec Indicadores.proc_PremiacaoPagaMR_RD '20160801', '20160831'



*/
-- @DataInicioPremiacao date, @DataFimPremiacao date
--as
--SELECT P.IDFuncionario, P.IDUnidade, P.NumeroApolice, PP.CodigoComercializado, P.ValorBruto, P.NumeroParcela, P.TipoPagamento, P.DataArquivo, P.Gerente
--FROM Dados.PremiacaoIndicadores P
--INNER JOIN Dados.ProdutoPremiacao PP
--ON PP.ID = P.IDProdutoPremiacao
--INNER JOIN Dados.Produto PRD
--ON PRD.CodigoComercializado = PP.CodigoComercializado
--WHERE P.DataArquivo BETWEEN @DataInicioPremiacao AND @DataFimPremiacao
--AND  PRD.IDRamoPar IN (21, 51, 53, 54, 80, 81, 82)
--ORDER BY P.IDFuncionario, P.NumeroApolice, P.NumeroParcela
--OPTION(OPTIMIZE FOR UNKNOWN)
----exec Indicadores.proc_PremiacaoPagaMR_RD '20160801', '20160831'
