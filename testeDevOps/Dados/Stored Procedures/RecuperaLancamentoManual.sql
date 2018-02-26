
CREATE PROCEDURE [Dados].[RecuperaLancamentoManual]  @IDEmpresa smallint, @IDOperacao tinyint, @DataCompetenciaInicio DATE, @DataCompetenciaFim DATE
AS

select						C.ID
						  , C.ValorCorretagem
						  , C.ValorBase 
                          , C.ValorComissaoPAR , C.ValorRepasse, C.DataRecibo
						  , C.DataCompetencia , C.NumeroRecibo, C.NumeroEndosso
						  , C.NumeroParcela, C.DataCalculo, C.DataQuitacaoParcela
						  , C.TipoCorretagem, C.CodigoSubgrupoRamoVida, C.IDProposta
						  , C.NumeroProposta, C.CodigoProduto, C.LancamentoManual	
						  , C.Repasse, C.Arquivo, C.DataArquivo, C.PercentualCorretagem
						  , C.IDEmpresa , C.IDSeguradora, C.NumeroReciboOriginal, C.IDOperacao 
						  , C.IDProdutor, C.IDFilialFaturamento, C.IDUnidadeVenda , C.IDCanalVendaPAR
						  , C.IDProduto
						  , CO.Descricao AS ComissaoOperacaoDescricao
						  , EF.processado
						  , P.Descricao AS ProdutoDescricao
from Dados.Comissao C --WITH(NOEXPAND)
INNER JOIN Dados.ComissaoOperacao CO on CO.ID = c.IDOperacao
INNER JOIN [ControleDados].[ExportacaoFaturamento] EF ON EF.DataCompetencia = C.DataCompetencia AND C.NumeroRecibo = EF.NumeroRecibo AND C.DataRecibo = EF.DataRecibo AND C.IDEmpresa = EF.IDEmpresa
INNER JOIN Dados.Produto P ON P.ID = C.IDProduto
where  C.IDEmpresa=@IDEmpresa and C.IDOperacao=@IDOperacao and C.DataCompetencia BETWEEN @DataCompetenciaInicio and @DataCompetenciaFim
   AND C.LancamentoManual = 1
--AND ISNULL(C.LancamentoManual,0) = @LancamentoManual
--AND CASE WHEN @LancamentoManual IS NULL THEN 1 ELSE ISNULL(C.LancamentoManual,1) END = ISNULL(@LancamentoManual,1)
OPTION (OPTIMIZE FOR( @DataCompetenciaInicio UNKNOWN, @DataCompetenciaFim UNKNOWN, @IDEmpresa UNKNOWN, @IDOperacao UNKNOWN))

