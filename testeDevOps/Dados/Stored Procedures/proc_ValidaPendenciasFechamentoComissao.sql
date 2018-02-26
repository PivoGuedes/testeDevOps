
/*
	Autor: Egler Vieira
	Data Criação: 23/04/2013

	Descrição: 
	
	Última alteração : 

*/

/*******************************************************************************
	Nome: CORPORATIVO.Dados.proc_ValidaPendenciasFechamentoComissao
	Descrição: Procedimento que valida as 
		
	Parâmetros de entrada: @DataCompetencia - Data do recibo

					
	Retorno:
	
*******************************************************************************/
CREATE PROCEDURE [Dados].[proc_ValidaPendenciasFechamentoComissao] @DataCompetencia DATE, @IDEmpresa SMALLINT, @ExtraRede bit = 0
AS
--DECLARE @DataCompetencia DATE = '2012-01-31'
SELECT DISTINCT 
FF.Codigo [CodigoFilialFaturamento], 
FF.Nome [NomeFilialFaturamento],
FP.Codigo [CodigoFilialParCorretora],
FP.Nome [NomeFilialParCorretora],
PRD.CodigoComercializado [CodigoProduto], 
PRD.Descricao [NomeProduto],  CVP.Nome [CanalVenda],
C.NumeroProposta,
--PRP.NumeroProposta,
--CNT.NumeroContrato,
C.NumeroRecibo,
C.NumeroEndosso

FROM Dados.Comissao_Partitioned C                             
INNER JOIN Dados.Produto PRD 
ON PRD.ID = C.IDProduto
--LEFT JOIN Dados.Contrato CNT
--ON CNT.ID = C.IDContrato
--LEFT JOIN Dados.Proposta PRP 
--ON PRP.ID = C.IDProposta
LEFT JOIN Dados.FilialFaturamento FF 
ON C.IDFilialFaturamento = FF.ID
LEFT JOIN Dados.CanalVendaPAR CVP 
ON CVP.ID = C.IDCanalVendaPAR


  OUTER APPLY Dados.fn_RecuperaUnidade_PointInTime(C.IDUnidadeVenda, C.DataCompetencia) EN
  OUTER APPLY Dados.fn_RecuperaUnidade_PointInTime(EN.IDUnidadeEscritorioNegocio, C.DataCompetencia) EN1 
LEFT JOIN DADOS.FilialPARCorretora FP
ON FP.ID = COALESCE(EN.IDFilialPARCorretora, EN1.IDFilialPARCorretora)
  


WHERE C.DataCompetencia = @DataCompetencia 
   AND (C.IDFilialFaturamento IS NULL 
       OR C.IDCanalVendaPAR IS NULL 
       OR PRD.Descricao IS NULL
       OR (EN.IDFilialPARCorretora IS NULL AND EN1.IDFilialPARCorretora IS NULL AND C.LancamentoManual = 0)
       ) 
AND C.IDOperacao <> 8
AND C.IDEmpresa = @IDEmpresa
AND  1 = CASE WHEN @ExtraRede = 1 AND C.Arquivo = 'COMI EXTRA REDE'  THEN 1
               WHEN @ExtraRede = 0 AND (C.Arquivo != 'COMI EXTRA REDE' OR C.Arquivo IS NULL) THEN 1 
		  ELSE 0 END
OPTION (MAXDOP 2, OPTIMIZE FOR (@DataCompetencia UNKNOWN, @IDEmpresa UNKNOWN, @ExtraRede UNKNOWN))






--EXEC [Dados].[proc_ValidaPendenciasFechamentoComissao] @DataCompetencia = '2016-04-05', @IDEmpresa=3
