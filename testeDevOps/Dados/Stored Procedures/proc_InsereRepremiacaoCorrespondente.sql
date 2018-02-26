
/*
	Autor: Egler Vieira
	Data Criação: 06/03/2014

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_InsereRepremiacaoCorrespondente
	Descrição: Procedimento que realiza a inserção dos lançamentos CONSOLIDADOS dos Correspondentes.
		
	Parâmetros de entrada:
	
					
	Retorno:


OBS: Rodar os comandos abaixo para que a proc possa funcionar
	  	
EXEC sp_serveroption 'GEINF-32', 'DATA ACCESS', TRUE;
SELECT * FROM SYS.SERVERS
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_InsereRepremiacaoCorrespondente] (@Ano smallint, @Mes tinyint, @IDTipoCorrespondente tinyint, @IDTipoProduto tinyint)
AS
--INSERT INTO Dados.RePremiacaoCorrespondente	 (IDProdutor, IDCorrespondente, IDFilialFaturamento, Cidade, UF, ValorCorretagem, DataCompetencia)
MERGE INTO Dados.RePremiacaoCorrespondente AS T
USING 
	(
		SELECT PC.[IDProdutor], [IDCorrespondente], @IDTipoProduto [IDTipoProduto], [IDFilialFaturamento], C.Cidade, C.UF, SUM(PC.ValorCorretagem) [ValorCorretagem], Cast(@Ano as varchar(4)) + '-' + RIGHT('0' + Cast(@Mes as varchar(2)),2) + '-' + '01' [DataCompetencia]
		FROM Dados.PremiacaoCorrespondente PC
		LEFT JOIN Dados.Correspondente C
		ON C.ID = PC.IDCorrespondente
		LEFT JOIN Dados.Unidade U
		ON U.ID = C.IDUnidade
		WHERE C.IDTipoCorrespondente =  @IDTipoCorrespondente --1 = lotérica, 2 = atendente
		AND PC.IDTipoProduto =  @IDTipoProduto --1 = SAF, 2 = consórcio     
		AND YEAR(PC.DataArquivo) = @Ano
		AND MONTH(PC.DataArquivo) = @Mes
		AND PC.IDOperacao = 1 --Corretagem -> 1001
		--------------------------------------------------------------------------------------
		--Garante que o ATENDENTE e O LOTÉRICO fiquem registrados onde é devido
		--AND CASE WHEN @IDtipoCorrespondente = 1 AND (PC.Arquivo LIKE '%SAFAT%' OR PC.Arquivo LIKE '%DC0701_CBN_EMPRESARIO%') THEN 0
		--         WHEN @IDtipoCorrespondente = 2 AND (PC.Arquivo LIKE '%SACBN%'OR  PC.Arquivo LIKE '%CONSCBN%' OR PC.Arquivo LIKE '%DC0701_CBN_ATENDENTE%') THEN 0
		--		 ELSE 1
		--	END = 1	 
		--------------------------------------------------------------------------------------
		GROUP BY PC.[IDProdutor], [IDCorrespondente],[IDFilialFaturamento], C.Cidade, C.UF
	 ) X
ON  X.IDProdutor = T.IDProdutor 
AND X.[IDCorrespondente] = T.[IDCorrespondente]
AND X.[IDTipoProduto] = T.[IDTipoProduto]
AND X.[IDFilialFaturamento] = T.[IDFilialFaturamento]
AND X.[DataCompetencia] = T.[DataCompetencia]
WHEN NOT MATCHED THEN
		INSERT (IDProdutor, IDCorrespondente, [IDTipoProduto], IDFilialFaturamento, Cidade, UF, ValorCorretagem, DataCompetencia)
		VALUES (X.IDProdutor, X.IDCorrespondente, X.IDTipoProduto, X.IDFilialFaturamento, X.Cidade, X.UF, X.ValorCorretagem, X.DataCompetencia)
WHEN MATCHED THEN
    UPDATE SET ValorCorretagem = COALESCE(X.ValorCorretagem, T.ValorCorretagem),
	           Cidade = COALESCE(X.Cidade, T.Cidade),
			   UF = COALESCE(X.UF, T.UF);

--EXEC Dados.proc_InsereRepremiacaoCorrespondente 2013, 12, 1
--EXEC Dados.proc_InsereRepremiacaoCorrespondente 2014, 01, 1
--EXEC Dados.proc_InsereRepremiacaoCorrespondente 2014, 03, 1, 2

--EXEC Dados.proc_InsereRepremiacaoCorrespondente 2013, 12, 2
--EXEC Dados.proc_InsereRepremiacaoCorrespondente 2014, 01, 2
--EXEC Dados.proc_InsereRepremiacaoCorrespondente 2014, 02, 2


